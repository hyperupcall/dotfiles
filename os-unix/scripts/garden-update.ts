#!/usr/bin/env -S deno run --allow-env --allow-read --allow-write
import * as YAML from "npm:yaml";
import { join } from "jsr:@std/path";
import { expandGlob } from "jsr:@std/fs";

const homeDir = Deno.env.get("HOME");
if (!homeDir) {
	console.error("❌ HOME environment variable not set");
	Deno.exit(1);
}

const gardenConfigDir = join(homeDir, ".config", "garden");
const gardenYamlPath = join(gardenConfigDir, "garden.yaml");

interface TreesConfig {
	trees?: Record<string, unknown>;
}

async function main() {
	console.log(`📂 Reading graft files from: ${gardenConfigDir}\n`);

	const graftData: Array<{ name: string; trees: string[] }> = [];

	for await (const file of expandGlob(join(gardenConfigDir, "graft-*.yaml"))) {
		if (!file.isFile) continue;

		const filename = file.name;
		const match = filename.match(/^graft-(.+)\.yaml$/);
		if (!match) continue;

		const graftName = match[1];

		try {
			const content = await Deno.readTextFile(file.path);
			const parsed = YAML.parse(content) as TreesConfig;

			const treeNames = parsed.trees ? Object.keys(parsed.trees) : [];

			if (treeNames.length === 0) {
				console.warn(`  ⚠️  No trees found in ${filename}`);
				continue;
			}

			graftData.push({
				name: graftName,
				trees: treeNames,
			});

			console.log(
				`  ✓ Found '${graftName}' with ${treeNames.length} tree(s): ${
					treeNames.join(", ")
				}`,
			);
		} catch (error) {
			console.error(`  ❌ Error reading ${filename}:`, error.message);
		}
	}

	if (graftData.length === 0) {
		console.error("\n❌ No valid graft files found!");
		Deno.exit(1);
	}

	console.log(`\n📝 Processing ${graftData.length} graft file(s)`);

	const gardenContent = await Deno.readTextFile(gardenYamlPath);
	const gardenDoc = YAML.parseDocument(gardenContent);

	const newGroups: Record<string, string[]> = {};

	for (const graft of graftData) {
		const groupEntries = graft.trees.map(
			(treeName) => `graft-${graft.name}::${treeName}`,
		);

		newGroups[graft.name] = groupEntries;
		console.log(
			`  ✓ Updated group '${graft.name}' with ${groupEntries.length} entries`,
		);
	}

	gardenDoc.set("groups", newGroups);

	const newContent = gardenDoc.toString({
		lineWidth: 0,
		blockQuote: "literal",
		defaultStringType: "QUOTE_SINGLE",
		defaultKeyType: "PLAIN",
	});

	const lines = newContent.split("\n");
	const outputLines: string[] = [];
	for (let i = 0; i < lines.length; i++) {
		outputLines.push(lines[i]);
		if (
			i < lines.length - 1 &&
			lines[i].match(/^\s+\w[\w-]*:\s*$/) &&
			lines[i + 1].match(/^\s+- /)
		) {
			let j = i + 1;
			while (j < lines.length && lines[j].match(/^\s+- /)) {
				outputLines.push(lines[j]);
				j++;
			}
			outputLines.push("");
			i = j - 1;
		}
	}
	const finalContent = outputLines.join("\n");

	await Deno.writeTextFile(gardenYamlPath, finalContent);

	console.log(`\n✅ Successfully updated ${gardenYamlPath}`);
}

if (import.meta.main) {
	await main();
}
