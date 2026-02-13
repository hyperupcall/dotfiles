// ==UserScript==
// @name        Improved GitHub Styles
// @namespace   Violentmonkey Scripts
// @match       https://github.com/*
// @grant       none
// @version     0.1.0
// @author      Edwin Kofler
// @description 6/27/2025, 6:41:56 PM
// @icon        https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png
// ==/UserScript==
document.querySelector("head").append(
	document.createRange().createContextualFragment(`
<style>
:root {
	--contribution-default-borderColor-0: #adb5bd !important;
}

.ContributionCalendar-day, .ContributionCalendar-day[data-level="0"], .ContributionCalendar-day[data-level="0"] {
	border-width: 1px !important;
}
</style>
`),
);
