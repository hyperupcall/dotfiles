// ==UserScript==
// @name         Improved Kattis
// @namespace    com.edwinkofler
// @author       Edwin Kofler
// @version      0.9.0
// @match        https://open.kattis.com/problems/*
// @match        https://open.kattis.com/challenge/*
// @grant        GM_setClipboard
// @grant        GM_registerMenuCommand
// @grant        GM_getValue
// @grant        GM_setValue
// @run-at       document-end
// @require      https://raw.githubusercontent.com/hyperupcall-projects/GM_config/refs/heads/main/gm_config.js
// @icon         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABOBAMAAAAk+643AAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAB5QTFRFAAAAbjscNDEs3YYRFAwJnWkm5eXmp6GcCAgKBwYGGE+FKAAAAAp0Uk5TAP////3//vxOsJIGr5kAAARwSURBVHic7de9b+M2FADwDB7kkY7YoqN49AUdFcXoGumekHikJaboeAFCzfUh0uoCHpwtKVwg/m/7HinJUkJf0KXTMQiiD/74Hqkn2jk7+9F+tP+jBYfX3W7z7vJu57vq2gSwLXdvwJ6u3p4g/yRJomfwOrz2BKnGy5f+MMGnhNoiXA4FdxevvWR6nrjb8NyPAu21wp/ZhLOiNV0aeycWrPjFS7ZaM9dFtWM+pa3QxR9e8pdG4+KEG1rZ4G+XleJaX3nn/4JEu9mulgDZ8pD2Qq98JEiJqHNaMwGFLEI+SzHoItInSU63NEvirEhEUuJPEuOKxfayej5N1EJwXZRFmMwwqThN2MdE4nzUZVEmuV2tlH9IQk4LfXl+mWg7+Tj/iKhcuccdW4K/4UckLNoSsS1KOKb2faI+xQOBAfG0/D4pz/WAnB9nc5pESXEUXcDoJMGCUV8GMRLe/i1xnVc+QjVWDucedyeXGL/c+MiW1ouWVWub3aKwR0WyOE24xjKMC11Xj274RW0eY17g+6L9r9hkrnPaL2pjTNEKYySSUiv/izzNFRFhTGNsmIVZ12aND/OKnyDBy4pelp9NxW6+Evm9qoV5oJeUl94Fw8mUlM+duTfRgz2qjKyrIg6Bh97ZY2bhF05kbURlyddG1qaIAfJTu+UZ7qXnRGYtqUAaPLqC6ERemBntdD+Ze7h5sHMxMjcW2yC7A8Dh8Domk9R2NPKzm76papr+QlMQBJnMJBzGhEokxodh6IkQMOZPbUmwB864nis9G81rSoW4uHOdmwafj2lwM4zVc7CXrCV6OSQBp91UNE1jhanw6FsSAmymqXJktdK/jkiuiqSuqDeSxmZncFeHzSRSnAh/S85wkX8zrs2btSNVUsLrFImmHe0d2adJK8x6ftEefUvwky9ijqi3ZJt3QYxpgxjzqFMW4haqZx7yBPmdObZK2j/NVUvUexLAmAj3dJqQsTDjzEe2KYOm7sX9ZxekSZGkLPKQYI+3LpqePLrsmjXmBSl3RI/IBEdjWdOYUWsaGWJxOWInJI9lvUVBYeqxWGM5CjEgcN2TFyIpNMM4eAIghCPakawvsoDyYhBSibWRqMakFSLVUdSSvM+sJQwumkELnSCSWsL1jVyOCD4DmB/FqhVjApu3BEQnRCdEpsWRyPZtDuz0IcX1wfw5RpDQizERXWb7llAP+tqWRVIcCUfC7Qf6TSa6zCxh3cDA9So7EuC4YsySDNO47UuM6u+YyiAIEiwy9xWAnmyb2ZRqCXois0EQIfls3hEawWU2BduOA4sRCblyhEZyXwxxp3I9R117Msf3xSJFxBXAvusqfUbOOZIVVb8l1/YlPt7OPCSKmOL09q/s6S2l5UtnSIRS9FxEac+RPGXdnMEXBIuMKcXUjK/CjtggGZMXZp0Jn2nzZm1pL3GBKfiF3bzujPSIYcuIbO3Atd3y8VPYMxVbTUx3RbV0ed3gDk6beLV+lxnY/l1zxMXDmWNSIMHb+pD0P4sj/6Ut/wXk+F37+daYcAAAAABJRU5ErkJggg==
// ==/UserScript==

(function () {
  'use strict';

const isChallenge = location.pathname.includes("/challenge/");
const slug = isChallenge ? "_challenge" : location.pathname.split("/problems/", 2)[1]?.split("/", 1)[0];
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

const cfg = new GM_config({
	id: "ImprovedKattisConfig",
	title: "Improved Kattis Settings",
	fields: {
		language: {
			label: "Language",
			type: "select",
			options: Object.keys(LANGUAGES),
			"default": "C++",
		},
		shell: {
			label: "Shell",
			type: "select",
			options: ["Bash or Zsh", "PowerShell Core"],
			"default": "Bash or Zsh",
		},
		inputFilename: {
			label: "Input filename pattern for test cases (use {n} for number)",
			type: "text",
			"default": "in{n}",
		},
		outputFilename: {
			label: "Output filename pattern for test cases (use {n} for number)",
			type: "text",
			"default": "out{n}",
		},
		kattisDir: {
			label: "Kattis directory name (case-insensitive)",
			type: "text",
			"default": "Kattis",
		},
	},
});

GM_registerMenuCommand("Settings/Preferences", () => cfg.open());

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
	const langConfig = LANGUAGES[cfg.get("language")];
	/** @type {string} */
	const ext = langConfig.ext;
	/** @type {string} */
	const template = langConfig.template;

	if (cfg.get("shell") === "PowerShell Core") {
		const templateEscaped = template.replace(/\n/g, "\\n").replace(
			/'/g,
			"''",
		);

		const kattisDir = cfg.get("kattisDir") || "Kattis";
		let script =
			` & { $cur = Split-Path -Leaf (Get-Location); $par = Split-Path -Leaf (Split-Path -Parent (Get-Location)); if ($cur -like '*${kattisDir}*') { } elseif ($par -like '*${kattisDir}*') { cd .. } else { [Console]::Error.WriteLine("Error: Not in Kattis directory"); exit 1 }; if (Test-Path ${slug}) { [Console]::Error.WriteLine("Dir exists: ${slug}"); exit 1 }; `;

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
			const inFile = (cfg.get("inputFilename") || "in{n}").replaceAll("{n}", n);
			const outFile = (cfg.get("outputFilename") || "out{n}").replaceAll("{n}", n);
			script +=
				`'${inputContent}' -replace '\\n', "\`n" | Out-File -FilePath ${slug}/${inFile} -Encoding utf8; `;
			script +=
				`'${outputContent}' -replace '\\n', "\`n" | Out-File -FilePath ${slug}/${outFile} -Encoding utf8; `;
		}
		script += `cd ${slug}; }`;

		return script;
	} else {
		const kattisDir = cfg.get("kattisDir") || "Kattis";
		const kattisPat = kattisDir.toLowerCase();
		let script =
			` { d=\$PWD; cur=\${d##*/}; par=\${d%/*}; par=\${par##*/}; cur=\$(tr '[:upper:]' '[:lower:]' <<< "\$cur"); par=\$(tr '[:upper:]' '[:lower:]' <<< "\$par"); if [[ \$cur == *${kattisPat}* ]]; then :; elif [[ \$par == *${kattisPat}* ]]; then cd ..; else echo "Error: Not in Kattis directory" >&2; false; fi && { [[ -d ${slug} ]] && { echo "Directory already exists: ${slug}" >&2; }; `;

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
			const inFile = (cfg.get("inputFilename") || "in{n}").replaceAll("{n}", n);
			const outFile = (cfg.get("outputFilename") || "out{n}").replaceAll("{n}", n);
			script += `cat > ${slug}/${inFile} <<< $'${inputContent}'; `;
			script += `cat > ${slug}/${outFile} <<< $'${outputContent}'; `;
		}
		script += `cd ${slug}; }; }`;

		return script;
	}
}

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
})();
