#!/usr/bin/env -S deno run --allow-all
import { spawnSync } from "node:child_process";
import os from "node:os";
import path from "node:path";
import { existsSync } from "node:fs";
import * as fs from "node:fs";
import { styleText } from "node:util";

const text = await fetch(
	"https://raw.githubusercontent.com/hyperupcall-self/vscode-hyperupcall-packs/refs/heads/main/extension-list.json",
);
const json = await text.json();

for (const manifest of json) {
	const { dirname, packageJson } = manifest;

	if (
		!dirname.startsWith("pack-ecosystem-") || dirname === "pack-ecosystem-all"
	) {
		continue;
	}

	const extnamePretty = packageJson.name.slice("vscode-".length);
	const extdir = path.join(
		os.homedir(),
		".dotfiles/.data/vscode-extensions",
		extnamePretty,
	);
	const datadir = path.join(
		os.homedir(),
		".dotfiles/.data/vscode-datadirs",
		extnamePretty,
	);

	if (!existsSync(datadir) || !existsSync(extdir)) {
		console.info(
			`${
				styleText("blue", "NOTE:")
			} Installing "${packageJson.name}" VSCode extension`,
		);
		spawnSync(
			"code",
			[
				"--user-data-dir",
				datadir,
				"--extensions-dir",
				extdir,
				"--install-extension",
				`EdwinKofler.${packageJson.name}`,
			],
			{ stdio: "inherit" },
		);
	} else {
		console.info(
			`${
				styleText("blue", "NOTE:")
			} Already installed "${packageJson.name}" VSCode extension`,
		);
	}

	const configDir = (Deno.env.get("XDG_CONFIG_HOME") ?? "").startsWith("/")
		? Deno.env.get("XDG_CONFIG_HOME")
		: path.join(os.homedir(), ".config");
	for (const filename of ["keybindings.json", "settings.json", "snippets"]) {
		const source = path.join(configDir, "Code/User", filename);
		const target = path.join(datadir, "User", filename);
		const targetStat = fs.lstatSync(target, { throwIfNoEntry: false });
		if (!targetStat) {
			fs.symlinkSync(source, target);
		} else if (targetStat.isSymbolicLink()) {
			fs.unlinkSync(target);
			fs.symlinkSync(source, target);
		} else {
			console.info(
				`${
					styleText("yellow", "WARN:")
				} Skipping symlink "${filename}" for "${packageJson.name}" VSCode extension`,
			);
		}
	}
}
const dataDir = (Deno.env.get("XDG_DATA_HOME") ?? "").startsWith("/")
	? Deno.env.get("XDG_DATA_HOME")
	: path.join(os.homedir(), ".local/share");
const inputDir =
	"/storage/vault/_Projects/By Application/GIMP/2025/vscode-hyperupcall-packs-theme-icons/out";
for (const dir of fs.readdirSync(inputDir)) {
	const name = path.parse(dir).name;
	await fs.writeFileSync(
		path.join(
			dataDir,
			"applications",
			`vscode-hyperupcall-pack-${name}.desktop`,
		),
		`[Desktop Entry]
Name=VSCode: ${name}
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=code-with-extension-path EdwinKofler vscode-hyperupcall-pack-${name} %F
Icon=${
			path.join(
				dataDir,
				`icons/hicolor/512x512/vscode-hyperupcall-pack-${name}.png`,
			)
		}
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=TextEditor;Development;IDE;
MimeType=application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window: All
Exec=code-with-extension-path EdwinKofler vscode-hyperupcall-pack-${name} --new-window %F
Icon=vscode`,
	);
	await fs.copyFileSync(
		path.join(inputDir, dir),
		path.join(
			dataDir,
			`icons/hicolor/512x512/vscode-hyperupcall-pack-${name}.png`,
		),
	);
}
