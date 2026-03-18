// ==UserScript==
// @name        Improved GitHub
// @namespace   Violentmonkey Scripts
// @match       https://github.com/*
// @grant       none
// @version     0.2
// @author      Edwin Kofler
// @description 6/27/2025, 6:41:56 PM
// @icon        https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png
// ==/UserScript==
const sheet = new CSSStyleSheet();
sheet.replaceSync(`
:root {
	--contribution-default-borderColor-0: #adb5bd !important;
}

.ContributionCalendar-day, .ContributionCalendar-day[data-level="0"], .ContributionCalendar-day[data-level="0"] {
	border-width: 1px !important;
}
`);
document.adoptedStyleSheets.push(sheet);
