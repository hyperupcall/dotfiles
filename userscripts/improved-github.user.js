// ==UserScript==
// @name        Improved GitHub
// @namespace   com.edwinkofler
// @match       https://github.com/*
// @grant       none
// @version     0.2.1
// @author      Edwin Kofler
// @icon        data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABiAQMAAACcdeQKAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAZQTFRF/Pz8HBoa3jAtWwAAAVZJREFUeJy91EtuxCAMANCgLFhyBK7RRaUcDXqz9CYcIUsWFi7+ARmln1UjzWjeKMbGJtk2ulzdlgvxmgiIOJW6isF1IJg8adwaWecSNlblMERNuYvazDaXiarMOlRlWdIWVciizgRLAk3hTbimE8WhfNPJySUycPqEnKN6Vo/mvngupueh0OypGNfl8xZ6FSrdNNDXN2pU5jdCKvpRXoRDmeq4acadXTDGcfbt1SdtomuoLEpd6UXlDzpedP2r0q/6aX/3TtQnORE8aZd+3ucwZ8TKrKDzO1n8d7Cjf6jG0efgcdi7IPIyQaUHkx+Bve0azsIPPTYU7/BTFxMVuUUeKyxJRYul64BFNaqowqP6KqLq43gmSQFMXGAzSQdUTbaSRRpRRNJlbO+sS2cD2mlpD+g5lkaKsjZZZANg2StMZENNYFl5Aqys8iSdYv8FtzfoW/9w2BdRBxCtrrmd+AAAAABJRU5ErkJggg==
// ==/UserScript==
(function () {
  'use strict';

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
})();
