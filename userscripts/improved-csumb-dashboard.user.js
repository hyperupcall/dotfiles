// ==UserScript==
// @name        Improved CSUMB Dashboard Styles
// @namespace   Violentmonkey Scripts
// @match       https://my.csumb.edu/dashboard*
// @grant       none
// @version     0.2
// @author      Edwin Kofler
// @description 8/21/2025, 9:40:32 PM
// ==/UserScript==
const sheet = new CSSStyleSheet();
sheet.replaceSync(`
  .dashboard-node .node-leaf {
	 max-width: 1400px !important;
  }

  widget-container.dashboard-widgets .card.widget {
	 margin: 4px !important;
  }
`);
document.adoptedStyleSheets.push(sheet);
