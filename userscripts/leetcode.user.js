// ==UserScript==
// @name        Improved LeetCode Styles
// @namespace   Violentmonkey Scripts
// @match       https://leetcode.com/*
// @grant       none
// @version     0.1.0
// @author      Edwin Kofler
// @description 7/17/2025, 5:12:51 PM
// ==/UserScript==
document.querySelector("head").append(
	document.createRange().createContextualFragment(`
<style>
  .flex.flex-col.gap-1.overflow-x-hidden.p-4.pt-6.transition-all.px-4 {
	 width: 325px !important;
  }
</style>
`),
);
