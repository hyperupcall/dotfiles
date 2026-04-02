#!/usr/bin/env -S deno run --allow-env --allow-read --allow-write --allow-run
import * as YAML from "npm:yaml";
import { join, dirname, basename } from "jsr:@std/path";

const homeDir = Deno.env.get("HOME");
if (!homeDir) {
	console.error("❌ HOME environment variable not set");
	Deno.exit(1);
}

interface TreesConfig {
	trees?: Record<string, unknown>;
}

interface GardenConfig {
	variables?: Record<string, string>;
	grafts?: Record<string, { config: string; root: string }>;
}

interface Workspace {
	folders: Array<{ name: string; path: string }>;
}

async function expandVariables(text: string, variables: Record<string, string>): Promise<string> {
	let result = text;
	
	for (const [varName, varValue] of Object.entries(variables)) {
		let expandedValue = varValue;
		
		if (expandedValue.startsWith("$ ")) {
			const shellCmd = expandedValue.substring(2);
			const cmd = new Deno.Command("bash", {
				args: ["-c", shellCmd],
				stdout: "piped",
			});
			const output = await cmd.output();
			expandedValue = new TextDecoder().decode(output.stdout).trim();
		}
		
		result = result.replace(new RegExp(`\\$\\{${varName}\\}`, "g"), expandedValue);
	}
	
	result = result.replace(/~/g, homeDir);
	
	return result;
}

async function main() {
	const args = Deno.args;
	
	if (args.length < 1) {
		console.error("Usage: garden-code-workspace-create.ts <graft-name>");
		Deno.exit(1);
	}
	
	const graftName = args[0];
	
	const gardenConfigDir = join(homeDir, ".config", "garden");
	const graftFile = join(gardenConfigDir, `graft-${graftName}.yaml`);
	const gardenFile = join(gardenConfigDir, "garden.yaml");
	
	try {
		await Deno.stat(graftFile);
	} catch {
		console.error(`❌ Graft file not found: ${graftFile}`);
		Deno.exit(1);
	}
	
	try {
		await Deno.stat(gardenFile);
	} catch {
		console.error(`❌ Garden file not found: ${gardenFile}`);
		Deno.exit(1);
	}
	
	const graftContent = await Deno.readTextFile(graftFile);
	const graftData = YAML.parse(graftContent) as TreesConfig;
	
	const gardenContent = await Deno.readTextFile(gardenFile);
	const gardenData = YAML.parse(gardenContent) as GardenConfig;
	
	const graftKey = `graft-${graftName}`;
	if (!gardenData.grafts || !gardenData.grafts[graftKey]) {
		console.error(`❌ Could not find ${graftKey} in garden.yaml grafts`);
		Deno.exit(1);
	}
	
	const variables = gardenData.variables || {};
	let graftRoot = gardenData.grafts[graftKey].root;
	
	graftRoot = await expandVariables(graftRoot, variables);
	
	try {
		await Deno.stat(graftRoot);
	} catch {
		console.error(`❌ Graft root directory does not exist: ${graftRoot}`);
		Deno.exit(1);
	}
	
	const trees = graftData.trees || {};
	if (Object.keys(trees).length === 0) {
		console.error(`⚠️  No trees found in ${graftFile}`);
		Deno.exit(1);
	}
	
	const graftDirName = basename(graftRoot);
	
	const folders = Object.keys(trees).map((treeName) => ({
		name: treeName,
		path: join(graftDirName, treeName),
	}));
	
	const workspace: Workspace = {
		folders: folders,
	};
	
	const parentDir = dirname(graftRoot);
	const outputFile = join(parentDir, `${graftName}.code-workspace`);
	
	await Deno.writeTextFile(
		outputFile,
		JSON.stringify(workspace, null, "\t") + "\n"
	);
	
	console.log(`✅ Created workspace file: ${outputFile}`);
}

if (import.meta.main) {
	await main();
}
