// ==UserScript==
// @name        Improved Canvas
// @namespace   Violentmonkey Scripts
// @match       https://*.instructure.com/*
// @grant       none
// @version     0.2
// @author      Edwin Kofler
// @description 7/20/2025, 10:14:51 AM
// ==/UserScript==
const sheet = new CSSStyleSheet();
sheet.replaceSync(`
  #announcements-link, #syllabus-link {
	 background-color: lightpink;
  }

  #modules-link, #grades-link {
	 background-color: papayawhip;
  }

  .ic-app-course-menu > #sticky-container {
	 padding-inline: 12px 6px !important;
  }

  .ic-app-course-menu > #sticky-container li > a {
	 padding-block: 7px !important;
  }
`);
document.adoptedStyleSheets.push(sheet);
