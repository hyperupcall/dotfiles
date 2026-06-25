// ==UserScript==
// @name         Competitive Paste
// @namespace    com.edwinkofler
// @author       Edwin Kofler
// @version      1.2.2
// @description  Copy sample I/O and boilerplate setup script for Kattis, CSES, and Codeforces
// @match        https://open.kattis.com/problems/*
// @match        https://open.kattis.com/challenge/*
// @match        https://cses.fi/problemset/task/*
// @match        https://codeforces.com/contest/*/problem/*
// @match        https://codeforces.com/problemset/problem/*/*
// @match        https://codeforces.com/gym/*/problem/*
// @grant        GM_setClipboard
// @grant        GM_registerMenuCommand
// @grant        GM_getValue
// @grant        GM_setValue
// @run-at       document-end
// @require      https://raw.githubusercontent.com/hyperupcall-projects/GM_config/v0.1.0/gm_config.js
// @icon         data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round' class='feather feather-clipboard'%3E%3Cpath d='M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2'%3E%3C/path%3E%3Crect x='8' y='2' width='8' height='4' rx='1' ry='1'%3E%3C/rect%3E%3C/svg%3E
// ==/UserScript==

(function () {
	"use strict";

	const SITE = location.hostname.includes("cses.fi")
		? "cses"
		: location.hostname.includes("codeforces.com")
			? "codeforces"
			: location.hostname.includes("kattis.com")
				? "kattis"
				: null;
	if (!SITE) return;

	/** @returns {{ dirName: string, sourceBase: string, javaClass: string, titleEl: HTMLElement | null } | null} */
	function getProblemInfo() {
		if (SITE === "kattis") {
			const isChallenge = location.pathname.includes("/challenge/");
			const slug = isChallenge
				? "_challenge"
				: location.pathname.split("/problems/")[1]?.split("/")[0];
			if (!slug) return null;
			return {
				dirName: slug,
				sourceBase: slug,
				javaClass: slug,
				titleEl: document.querySelector("h1.book-page-heading"),
			};
		}

		if (SITE === "cses") {
			const taskMatch = location.pathname.match(/\/problemset\/task\/(\d+)/);
			const titleEl = document.querySelector(".title-block h1");
			if (!taskMatch || !titleEl) return null;
			return {
				dirName: titleEl.textContent.trim(),
				sourceBase: "main",
				javaClass: "Main",
				titleEl,
			};
		}

		const titleEl = document.querySelector(".problem-statement .header .title");
		if (!titleEl) return null;
		const title = titleEl.textContent.trim();
		return {
			dirName: title.replace(/^[A-Za-z0-9]+\.\s*/, ""),
			sourceBase: "main",
			javaClass: "Main",
			titleEl,
		};
	}

	const problem = getProblemInfo();
	if (!problem?.titleEl) return;

	const { dirName, sourceBase, javaClass, titleEl } = problem;

	const gmcfg = new GM_config({
		id: "CompetitivePasteConfig",
		title: "Competitive Paste Settings",
		css: [
			"#CompetitivePasteConfig { font-family: system-ui, sans-serif; line-height: 1.4; }",
			"#CompetitivePasteConfig .config_header { font-size: 1.25rem; margin-bottom: 1rem; }",
			"#CompetitivePasteConfig .config_var { margin-bottom: 0.85rem; }",
			"#CompetitivePasteConfig .field_label { display: block; font-size: 0.85rem; margin-bottom: 0.25rem; }",
			"#CompetitivePasteConfig input[type=text], #CompetitivePasteConfig select { max-width: 24rem; width: 100%; padding: 0.25rem 0.4rem; }",
			"#CompetitivePasteConfig textarea { width: 100%; min-height: 5.5rem; font-family: ui-monospace, monospace; font-size: 0.8rem; padding: 0.4rem; box-sizing: border-box; }",
			"#CompetitivePasteConfig .saveclose_buttons { margin-top: 1rem; padding: 0.35rem 0.75rem; }",
		].join("\n"),
		fields: {
			language: {
				label: "Language",
				type: "select",
				options: ["C++", "Java", "Python"],
				default: "C++",
			},
			shell: {
				label: "Shell",
				type: "select",
				options: ["Bash or Zsh", "PowerShell Core"],
				default: "Bash or Zsh",
			},
			inputFilename: {
				label: "Input filename pattern for test cases (use {n} for number)",
				type: "text",
				default: "in{n}",
			},
			outputFilename: {
				label: "Output filename pattern for test cases (use {n} for number)",
				type: "text",
				default: "out{n}",
			},
			csesDir: {
				label: "CSES problem directory name (case-insensitive)",
				type: "text",
				default: "CSES",
			},
			kattisDir: {
				label: "Kattis directory name (case-insensitive)",
				type: "text",
				default: "Kattis",
			},
			codeforcesDir: {
				label: "Codeforces directory name (case-insensitive)",
				type: "text",
				default: "Codeforces",
			},
			cppTemplate: {
				label: "C++ default template",
				type: "textarea",
				default: `#include <bits/stdc++.h>
using namespace std;

int main() {

}`,
			},
			javaTemplate: {
				label: "Java default template (use {class} for the class name)",
				type: "textarea",
				default: `import java.util.*;

public class {class} {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

    }
}`,
			},
			pythonTemplate: {
				label: "Python default template",
				type: "textarea",
				default: `import sys
`,
			},
		},
	});

	GM_registerMenuCommand("Settings/Preferences", () => gmcfg.open());

	function getLanguageConfig() {
		return {
			"C++": {
				ext: "cpp",
				template: gmcfg.get("cppTemplate"),
			},
			Java: {
				ext: "java",
				template: gmcfg.get("javaTemplate").replaceAll("{class}", javaClass),
			},
			Python: {
				ext: "py",
				template: gmcfg.get("pythonTemplate"),
			},
		};
	}

	function getKattisSamples() {
		const samples = [];
		const tables = document.querySelectorAll("table.sample");

		for (let i = 0; i < tables.length; i++) {
			/** @type {HTMLTableElement} */
			const table = tables[i];
			const cells = table.querySelectorAll("td");
			if (cells.length >= 2) {
				const inputPre = cells[0].querySelector("pre");
				const outputPre = cells[1].querySelector("pre");
				samples.push({
					input: inputPre ? inputPre.innerText : "",
					output: outputPre ? outputPre.innerText : "",
				});
			}
		}

		if (samples.length === 0) {
			const inputEls = document.querySelectorAll(
				".sampleinput pre, .sampledata pre",
			);
			const inputTexts = [];
			const outputTexts = [];
			for (let i = 0; i < inputEls.length; i++) {
				/** @type {HTMLPreElement} */
				const pre = inputEls[i];
				if (i % 2 === 0) inputTexts.push(pre.innerText);
				else outputTexts.push(pre.innerText);
			}
			for (let i = 0; i < inputTexts.length; i++) {
				samples.push({
					input: inputTexts[i],
					output: outputTexts[i] || "",
				});
			}
		}

		return samples;
	}

	function getCsesSamples() {
		const samples = [];
		const headings = document.querySelectorAll(".md h1");
		/** @type {HTMLElement | null} */
		let exampleHeading = null;

		for (const heading of headings) {
			if (/^example/i.test(heading.textContent.trim())) {
				exampleHeading = heading;
				break;
			}
		}
		if (!exampleHeading) return samples;

		let el = exampleHeading.nextElementSibling;
		while (el && el.tagName !== "H1") {
			if (el.tagName === "P" && /^Input:/i.test(el.textContent.trim())) {
				const inputPre = el.nextElementSibling;
				if (inputPre?.tagName === "PRE") {
					let out = inputPre.nextElementSibling;
					while (
						out &&
						out.tagName === "P" &&
						!/^Output:/i.test(out.textContent.trim())
					) {
						out = out.nextElementSibling;
					}
					if (out?.tagName === "P" && /^Output:/i.test(out.textContent.trim())) {
						const outputPre = out.nextElementSibling;
						if (outputPre?.tagName === "PRE") {
							samples.push({
								input: inputPre.innerText,
								output: outputPre.innerText,
							});
						}
					}
				}
			}
			el = el.nextElementSibling;
		}

		return samples;
	}

	function getCodeforcesSamples() {
		const samples = [];
		for (const test of document.querySelectorAll(".sample-test")) {
			const inputPre = test.querySelector(".input pre");
			const outputPre = test.querySelector(".output pre");
			if (inputPre && outputPre) {
				samples.push({
					input: inputPre.innerText,
					output: outputPre.innerText,
				});
			}
		}
		return samples;
	}

	function getSamples() {
		if (SITE === "cses") return getCsesSamples();
		if (SITE === "codeforces") return getCodeforcesSamples();
		return getKattisSamples();
	}

	function getProblemsDir() {
		if (SITE === "cses") return gmcfg.get("csesDir");
		if (SITE === "codeforces") return gmcfg.get("codeforcesDir");
		return gmcfg.get("kattisDir");
	}

	function quoteBashSingle(/** @type {string} */ value) {
		return `'${value.replace(/'/g, "'\\''")}'`;
	}

	function quotePowerShellSingle(/** @type {string} */ value) {
		return `'${value.replace(/'/g, "''")}'`;
	}

	function buildScript(
		/** @type {Array<{input: string, output: string}>} */ samples,
	) {
		const langConfig = getLanguageConfig()[gmcfg.get("language")];
		/** @type {string} */
		const ext = langConfig.ext;
		/** @type {string} */
		const template = langConfig.template;
		const problemsDir = getProblemsDir();
		const sourceFile = `${sourceBase}.${ext}`;
		const dirQuotedBash = quoteBashSingle(dirName);
		const sourcePathBash = quoteBashSingle(`${dirName}/${sourceFile}`);
		const dirQuotedPs = quotePowerShellSingle(dirName);
		const sourcePathPs = quotePowerShellSingle(`${dirName}/${sourceFile}`);

		const dirExistsMsg = dirName.replace(/'/g, "''");
		const dirExistsMsgBash = dirName.replace(/'/g, "'\\''");

		if (gmcfg.get("shell") === "PowerShell Core") {
			const templateEscaped = template.replace(/\n/g, "\\n").replace(
				/'/g,
				"''",
			);

			let script =
				` & { $cur = Split-Path -Leaf (Get-Location); $par = Split-Path -Leaf (Split-Path -Parent (Get-Location)); if ($cur -like '*${problemsDir}*') { } elseif ($par -like '*${problemsDir}*') { cd .. } else { [Console]::Error.WriteLine("Error: Not in ${problemsDir} directory"); return }; if (Test-Path ${dirQuotedPs}) { [Console]::Error.WriteLine("Directory already exists: ${dirExistsMsg}"); return } else { `;

			script +=
				`New-Item -ItemType Directory -Path ${dirQuotedPs} | Out-Null; '${templateEscaped}' -replace '\\n', "\`n" | Out-File -FilePath ${sourcePathPs} -Encoding utf8; `;

			for (let i = 0; i < samples.length; i++) {
				/** @type {{input: string, output: string}} */
				const s = samples[i];
				const n = i + 1;
				const inputContent = s.input.replace(/\n$/, "").replace(/\n/g, "\\n")
					.replace(/'/g, "''");
				const outputContent = s.output.replace(/\n$/, "").replace(/\n/g, "\\n")
					.replace(/'/g, "''");
				const inFile = gmcfg.get("inputFilename").replaceAll("{n}", n);
				const outFile = gmcfg.get("outputFilename").replaceAll("{n}", n);
				const inPathPs = quotePowerShellSingle(`${dirName}/${inFile}`);
				const outPathPs = quotePowerShellSingle(`${dirName}/${outFile}`);
				script +=
					`'${inputContent}' -replace '\\n', "\`n" | Out-File -FilePath ${inPathPs} -Encoding utf8; `;
				script +=
					`'${outputContent}' -replace '\\n', "\`n" | Out-File -FilePath ${outPathPs} -Encoding utf8; `;
			}
			script += `cd ${dirQuotedPs}; } }`;

			return script;
		}

		const problemsPat = problemsDir.toLowerCase();
		let script =
			` { d=\$PWD; cur=\${d##*/}; par=\${d%/*}; par=\${par##*/}; cur=\$(tr '[:upper:]' '[:lower:]' <<< "\$cur"); par=\$(tr '[:upper:]' '[:lower:]' <<< "\$par"); if [[ \$cur == *${problemsPat}* ]]; then :; elif [[ \$par == *${problemsPat}* ]]; then cd ..; else echo "Error: Not in ${problemsDir} directory" >&2; false; fi && { if [[ -d ${dirQuotedBash} ]]; then echo "Directory already exists: ${dirExistsMsgBash}" >&2; else `;

		const templateEscaped = template.replace(/\n/g, "\\n").replace(
			/'/g,
			"\\'",
		);
		script +=
			`mkdir -p ${dirQuotedBash}; cat > ${sourcePathBash} <<< $'${templateEscaped}'; `;

		for (let i = 0; i < samples.length; i++) {
			/** @type {{input: string, output: string}} */
			const s = samples[i];
			const n = i + 1;
			const inputContent = s.input.replace(/\n$/, "").replace(/\n/g, "\\n")
				.replace(/'/g, "\\'");
			const outputContent = s.output.replace(/\n$/, "").replace(/\n/g, "\\n")
				.replace(/'/g, "\\'");
			const inFile = gmcfg.get("inputFilename").replaceAll("{n}", n);
			const outFile = gmcfg.get("outputFilename").replaceAll("{n}", n);
			script += `cat > ${quoteBashSingle(`${dirName}/${inFile}`)} <<< $'${inputContent}'; `;
			script += `cat > ${quoteBashSingle(`${dirName}/${outFile}`)} <<< $'${outputContent}'; `;
		}
		script += `cd ${dirQuotedBash}; fi; }; }`;

		return script;
	}

	if (titleEl.querySelector(".competitive-paste-copy")) return;

	const COPY_ICON =
		'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640" aria-hidden="true"><path d="M360 160L280 160C266.7 160 256 149.3 256 136C256 122.7 266.7 112 280 112L360 112C373.3 112 384 122.7 384 136C384 149.3 373.3 160 360 160zM360 208C397.1 208 427.6 180 431.6 144L448 144C456.8 144 464 151.2 464 160L464 512C464 520.8 456.8 528 448 528L192 528C183.2 528 176 520.8 176 512L176 160C176 151.2 183.2 144 192 144L208.4 144C212.4 180 242.9 208 280 208L360 208zM419.9 96C407 76.7 385 64 360 64L280 64C255 64 233 76.7 220.1 96L192 96C156.7 96 128 124.7 128 160L128 512C128 547.3 156.7 576 192 576L448 576C483.3 576 512 547.3 512 512L512 160C512 124.7 483.3 96 448 96L419.9 96z"/></svg>';
	const CHECK_ICON =
		'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 640" aria-hidden="true"><path d="M530.8 134.1C545.1 144.5 548.3 164.5 537.9 178.8L281.9 530.8C276.4 538.4 267.9 543.1 258.5 543.9C249.1 544.7 240 541.2 233.4 534.6L105.4 406.6C92.9 394.1 92.9 373.8 105.4 361.3C117.9 348.8 138.2 348.8 150.7 361.3L252.2 462.8L486.2 141.1C496.6 126.8 516.6 123.6 530.9 134z"/></svg>';

	function setCopyBtnIcon(/** @type {HTMLElement} */ btn, /** @type {string} */ icon) {
		btn.innerHTML = icon;
		const svg = btn.querySelector("svg");
		if (svg) {
			svg.style.cssText =
				"width: 1em; height: 1em; display: inline-block; vertical-align: -0.125em; fill: currentColor;";
		}
	}

	const copyBtn = document.createElement("span");
	copyBtn.className = "competitive-paste-copy";
	copyBtn.style.cssText =
		"margin-left: 0.2em; position: relative; bottom: 2px; cursor: pointer; font-weight: normal; white-space: nowrap; font-size: .8em; line-height: 1; vertical-align: middle;";
	copyBtn.title = "Create Files";
	setCopyBtnIcon(copyBtn, COPY_ICON);

	copyBtn.addEventListener("click", (event) => {
		event.preventDefault();
		event.stopPropagation();

		const samples = getSamples();
		const script = buildScript(samples);
		GM_setClipboard(script, "text");

		setCopyBtnIcon(copyBtn, CHECK_ICON);
		copyBtn.style.color = "#2e7d32";
		setTimeout(() => {
			setCopyBtnIcon(copyBtn, COPY_ICON);
			copyBtn.style.color = "unset";
		}, 2000);
	});

	titleEl.appendChild(copyBtn);
})();
