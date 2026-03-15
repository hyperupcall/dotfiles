// ==UserScript==
// @name         Kattis – Create Files Button
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Adds a "Create Files" button above Sample Input 1 on Kattis problem pages. Clicking it copies a bash script to your clipboard that sets up a local project directory.
// @match        https://open.kattis.com/problems/*
// @grant        GM_setClipboard
// ==/UserScript==

(function () {
	"use strict";

	// Extract problem slug from URL
	const slug = location.pathname.split("/problems/")[1]?.split("/")[0];
	if (!slug) return;

	// Collect all sample input/output pairs from the page
	function getSamples() {
		const samples = [];
		const tables = document.querySelectorAll("table.sample");

		tables.forEach((table) => {
			const cells = table.querySelectorAll("td");
			if (cells.length >= 2) {
				const inputPre = cells[0].querySelector("pre");
				const outputPre = cells[1].querySelector("pre");
				samples.push({
					input: inputPre ? inputPre.innerText : "",
					output: outputPre ? outputPre.innerText : "",
				});
			}
		});

		// Fallback: look for .sampleinput / .sampledata pre elements
		if (samples.length === 0) {
			const inputEls = document.querySelectorAll(
				".sampleinput pre, .sampledata pre",
			);
			const inputTexts = [];
			const outputTexts = [];
			inputEls.forEach((pre, i) => {
				if (i % 2 === 0) inputTexts.push(pre.innerText);
				else outputTexts.push(pre.innerText);
			});
			for (let i = 0; i < inputTexts.length; i++) {
				samples.push({
					input: inputTexts[i],
					output: outputTexts[i] || "",
				});
			}
		}

		return samples;
	}

	function buildBashScript(samples) {
		const cppTemplate = `#include <bits/stdc++.h>
using namespace std;
int main() {

}`;

		let bash = `#!/bin/bash

# Check we are in the right place
CURRENT=$(basename "$PWD")
PARENT=$(basename "$(dirname "$PWD")")

if echo "$CURRENT" | grep -qi "kattis"; then
  : # already in a kattis folder, nothing to do
elif echo "$PARENT" | grep -qi "kattis"; then
  cd ..
else
  echo "Error: neither the current folder ('$CURRENT') nor its parent ('$PARENT') contains 'kattis'. Aborting."
  exit 1
fi

`;

		bash +=
			`mkdir -p ${slug}\ncat > ${slug}/${slug}.cpp << 'CPPEOF'\n${cppTemplate}\nCPPEOF\n`;

		samples.forEach((s, i) => {
			const n = i + 1;
			const inputContent = s.input.replace(/\n$/, "");
			const outputContent = s.output.replace(/\n$/, "");
			bash +=
				`\ncat > ${slug}/~input${n}.txt << 'EOF${n}IN'\n${inputContent}\nEOF${n}IN\n`;
			bash +=
				`\ncat > ${slug}/~output${n}.txt << 'EOF${n}OUT'\n${outputContent}\nEOF${n}OUT\n`;
		});

		bash += `\necho "Created ${slug}/ with ${samples.length} test case(s)"`;
		bash += `\ncd ${slug}`;
		return bash;
	}

	function createButton() {
		const btn = document.createElement("button");
		btn.textContent = "Create Files";
		btn.style.cssText = `
      display: inline-block;
      margin-bottom: 10px;
      padding: 8px 18px;
      background: #1b6ec2;
      color: white;
      border: none;
      border-radius: 5px;
      font-size: 14px;
      font-weight: bold;
      cursor: pointer;
      font-family: sans-serif;
    `;

		btn.addEventListener(
			"mouseenter",
			() => btn.style.background = "#145ea8",
		);
		btn.addEventListener(
			"mouseleave",
			() => btn.style.background = "#1b6ec2",
		);

		btn.addEventListener("click", () => {
			const samples = getSamples();
			const bashScript = buildBashScript(samples);
			GM_setClipboard(bashScript, "text");

			btn.textContent = "✓ Copied!";
			btn.style.background = "#2e7d32";
			setTimeout(() => {
				btn.textContent = "Create Files";
				btn.style.background = "#1b6ec2";
			}, 2000);
		});

		// Find the first sample table and insert the button before it
		const firstTable = document.querySelector("table.sample");
		if (firstTable) {
			const wrapper = document.createElement("div");
			wrapper.appendChild(btn);
			firstTable.before(wrapper);
			return;
		}

		// Fallback: find any element whose text is "Sample Input 1"
		const walker = document.createTreeWalker(
			document.body,
			NodeFilter.SHOW_TEXT,
		);
		let node;
		while ((node = walker.nextNode())) {
			if (/sample input 1/i.test(node.textContent.trim())) {
				const target = node.parentElement;
				const wrapper = document.createElement("div");
				wrapper.appendChild(btn);
				target.before(wrapper);
				return;
			}
		}

		// Last resort: append to main content area
		const main = document.querySelector(
			"#problem-text, main, .problem-statement, article",
		);
		if (main) main.prepend(btn);
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", createButton);
	} else {
		createButton();
	}
})();
