// ==UserScript==
// @name        Improved CSUMB Dashboard Styles
// @namespace   Violentmonkey Scripts
// @match       https://my.csumb.edu/dashboard*
// @grant       none
// @version     0.1.0
// @author      Edwin Kofler
// @description 8/21/2025, 9:40:32 PM
// ==/UserScript==
document.querySelector("head").append(
	document.createRange().createContextualFragment(`
<style>
  .dashboard-node .node-leaf {
	 max-width: 1400px !important;
  }

  widget-container.dashboard-widgets .card.widget {
	 margin: 4px !important;
  }
</style>
`),
);
