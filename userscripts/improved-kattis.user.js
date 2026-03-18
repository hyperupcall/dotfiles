// ==UserScript==
// @name         Improved Kattis
// @namespace    Violentmonkey Scripts
// @version      0.4
// @match        https://open.kattis.com/problems/*
// @grant        GM_setClipboard
// @grant        GM_registerMenuCommand
// @grant        GM_unregisterMenuCommand
// @grant        GM_getValue
// @grant        GM_setValue
// ==/UserScript==

const slug = location.pathname.split("/problems/")[1]?.split("/")[0];
if (!slug) return;

const LANGUAGES = {
	"C++": {
		ext: "cpp",
		template: `#include <bits/stdc++.h>
using namespace std;

int main() {

}`,
	},
	Java: {
		ext: "java",
		template: `import java.util.*;

public class ${slug} {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

    }
}`,
	},
	Python: {
		ext: "py",
		template: `import sys
`,
	},
};

const SHELLS = ["Bash or Zsh", "PowerShell Core"];

let currentLanguage = GM_getValue("kattis_language", "C++");
let currentShell = GM_getValue("kattis_shell", "Bash or Zsh");

let menuCommandIds = [];

function setLanguage(/** @type {string} */ language) {
	currentLanguage = language;
	GM_setValue("kattis_language", language);
	alert(`Language set to: ${language}`);
	updateMenuCommands();
}

function setShell(/** @type {string} */ shell) {
	currentShell = shell;
	GM_setValue("kattis_shell", shell);
	alert(`Shell set to: "${shell}"`);
	updateMenuCommands();
}

function updateMenuCommands() {
	for (let i = 0; i < menuCommandIds.length; i++) {
		GM_unregisterMenuCommand(menuCommandIds[i]);
	}
	menuCommandIds = [];

	for (let i = 0; i < Object.keys(LANGUAGES).length; i++) {
		const lang = Object.keys(LANGUAGES)[i];
		const prefix = lang === currentLanguage ? "✓ " : "  ";
		const id = GM_registerMenuCommand(
			`${prefix}Language: ${lang}`,
			() => setLanguage(lang),
		);
		menuCommandIds.push(id);
	}

	for (let i = 0; i < SHELLS.length; i++) {
		const shell = SHELLS[i];
		const prefix = shell === currentShell ? "✓ " : "  ";
		const id = GM_registerMenuCommand(
			`${prefix}Shell: ${shell}`,
			() => setShell(shell),
		);
		menuCommandIds.push(id);
	}
}

updateMenuCommands();

function getSamples() {
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

function buildScript(
	/** @type {Array<{input: string, output: string}>} */ samples,
) {
	const langConfig = LANGUAGES[currentLanguage];
	/** @type {string} */
	const ext = langConfig.ext;
	/** @type {string} */
	const template = langConfig.template;

	if (currentShell === "PowerShell Core") {
		const templateEscaped = template.replace(/\n/g, "\\n").replace(
			/'/g,
			"''",
		);

		let script =
			` & { $cur = Split-Path -Leaf (Get-Location); $par = Split-Path -Leaf (Split-Path -Parent (Get-Location)); if ($cur -match 'kattis') { } elseif ($par -match 'kattis') { cd .. } else { [Console]::Error.WriteLine("Not in kattis dir"); exit 1 }; if (Test-Path ${slug}) { [Console]::Error.WriteLine("Dir exists: ${slug}"); exit 1 }; `;

		script +=
			`New-Item -ItemType Directory -Path ${slug} | Out-Null; '${templateEscaped}' -replace '\\n', "\`n" | Out-File -FilePath ${slug}/${slug}.${ext} -Encoding utf8; `;

		for (let i = 0; i < samples.length; i++) {
			/** @type {{input: string, output: string}} */
			const s = samples[i];
			const n = i + 1;
			const inputContent = s.input.replace(/\n$/, "").replace(/\n/g, "\\n")
				.replace(/'/g, "''");
			const outputContent = s.output.replace(/\n$/, "").replace(/\n/g, "\\n")
				.replace(/'/g, "''");
			script +=
				`'${inputContent}' -replace '\\n', "\`n" | Out-File -FilePath ${slug}/~input${n}.txt -Encoding utf8; `;
			script +=
				`'${outputContent}' -replace '\\n', "\`n" | Out-File -FilePath ${slug}/~output${n}.txt -Encoding utf8; `;
		}
		script += `cd ${slug}; }`;

		return script;
	} else {
		let script =
			` { d=\$PWD; cur=\${d##*/}; par=\${d%/*}; par=\${par##*/}; if [[ \$cur == *kattis* ]]; then :; elif [[ \$par == *kattis* ]]; then cd ..; else echo "Not in kattis dir" >&2; fi; [[ -d ${slug} ]] && { echo "Directory already exists: ${slug}" >&2; }; `;

		const templateEscaped = template.replace(/\n/g, "\\n").replace(
			/'/g,
			"\\'",
		);
		script +=
			`mkdir -p ${slug}; cat > ${slug}/${slug}.${ext} <<< $'${templateEscaped}'; `;

		for (let i = 0; i < samples.length; i++) {
			/** @type {{input: string, output: string}} */
			const s = samples[i];
			const n = i + 1;
			const inputContent = s.input.replace(/\n$/, "").replace(/\n/g, "\\n")
				.replace(/'/g, "\\'");
			const outputContent = s.output.replace(/\n$/, "").replace(/\n/g, "\\n")
				.replace(/'/g, "\\'");
			script += `cat > ${slug}/~input${n}.txt <<< $'${inputContent}'; `;
			script += `cat > ${slug}/~output${n}.txt <<< $'${outputContent}'; `;
		}
		script += `cd ${slug}; }`;

		return script;
	}
}

function createButton() {
	const wrapper = document.createElement("div");
	wrapper.style.cssText = `
      position: absolute;
      top: 44px;
      left: 21px;
      cursor: pointer;
      white-space: nowrap;
      font-size: var(--font-xlarge);
      color: var(--background-gradient-start);
    `;

	const btn = document.createElement("i");
	btn.className = "fa fa-copy";
	btn.title = "Create Files";

	btn.addEventListener("click", () => {
		const samples = getSamples();
		const script = buildScript(samples);
		GM_setClipboard(script, "text");

		const originalClass = btn.className;
		btn.className = "fa fa-check";
		btn.style.color = "#2e7d32";
		setTimeout(() => {
			btn.className = originalClass;
			btn.style.color = "unset";
		}, 2000);
	});

	wrapper.appendChild(btn);

	const favouriteBtn = document.querySelector("#favourite-btn");
	if (favouriteBtn) {
		favouriteBtn.after(wrapper);
		return;
	}

	const firstTable = document.querySelector("table.sample");
	if (firstTable) {
		firstTable.before(wrapper);
		return;
	}

	const walker = document.createTreeWalker(
		document.body,
		NodeFilter.SHOW_TEXT,
	);
	/** @type {Text} */
	let node;
	while ((node = walker.nextNode())) {
		if (/sample input 1/i.test(node.textContent.trim())) {
			/** @type {HTMLElement} */
			const target = node.parentElement;
			target.before(wrapper);
			return;
		}
	}

	const problemBody = document.querySelector(".problembody");
	if (problemBody) {
		problemBody.after(wrapper);
		return;
	}

	const main = document.querySelector(
		"#problem-text, main, .problem-statement, article",
	);
	if (main) main.prepend(wrapper);
}

if (document.readyState === "loading") {
	document.addEventListener("DOMContentLoaded", createButton);
} else {
	createButton();
}
