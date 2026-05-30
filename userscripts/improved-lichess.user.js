// ==UserScript==
// @name         Improved Lichess
// @namespace    com.edwinkofler
// @version      0.1.0
// @description  Removes navigation menu delay.
// @author       Edwin Kofler
// @match        https://lichess.org/*
// @run-at       document-end
// @icon         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkAgMAAAANjH3HAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAxQTFRF/v7+AgICSUlJoKCgjCjwRAAAAr5JREFUeJx1VjFuHDEM1K6whYDIrvYJQto0KgwEiZ/gwtwzkhT3gAD2EwzkDYu8IIXhwn6Ai/3EPsFFOrdpfKG0okRRd2xO2pHE0ZAiT6nWPh35Fuz8781xQM9wAnkF+HEUsHAKwS1w1Xw9vD++IwB7yekPJBPI2Zy+38KdJLvZTsNl4znaXQ/31VkE7FRXI2vxbmGRWx4Ph4dpUaZCHAIvYfBZqQE4MQR+0sTzPQbge56MnAH6f2Ynl5tqvgX9FEVReSaIZVHwMDE6PVwzNzy+uqzTUKs75wuhm4UjhfaAMnLz+QgnUsLkoK5pTb9I2uTGLkT7hgaJpSEe5NfSkoysQA6vBOIS7UzS0DV8yh5aocyloL2SApYu2CXaMwnYUVx04pRF77Pi825bQDfWWb512i6ag5sld3HUlUexEoUh0rYl9R2da+MVTUmvgRxtHoYS0JzrG21f0ljnYEbanmXUTDcaw0fHksDR/pj1HDFZ9kBrLBlZ4hxpjzw/52lJS/YCyS8kiLlyxNBx67VAesqwQHutEnRN+gbaNeJTrgXaNYKF4T78dkilRvDxxLnGU9e6ntLLxAUCOUsFAD+Pogan41BOiSR2GByuaLD0as2knEDwuC09qvhE257tMFXRjmYgJYEHgWyquolnFXeExEyDuJCHmEa2LsJqC194IZ0o6VsZsKho37QOdLSEx6vbduPgFwTGbYvCUhwzZZbyxI4WXIxShFjYF8XSnFOIHobmQlRWjOheaH4j1bUXOl+SvxPdmGrJMRsbtbO/lkIye6KFs9eZ7UOmIB19pIGTjn7TwAhHfZ72oplc7PNwFq26zHx1XM8CZmFi7HxVVZjeet4zxLNNF5XTvnR0LaR/zZ37VQQSn/T0Fgb/QEoV/js8vX19aP875X81k9hS/r08S0CpLxF4agHMpQf49lKm/wG4t/MktswRKgAAAABJRU5ErkJggg==
// ==/UserScript==

(function () {
'use strict';

const sheet = new CSSStyleSheet();
sheet.replaceSync(`
  #top,
  #top #topnav,
  #top .dropdown {
    transition-duration: 0ms !important;
    transition-delay:    0s  !important;
  }

  #top.hide #topnav,
  #top.hide .dropdown {
    transition: none !important;
  }

  #topnav div[role="group"] {
    transition: none !important;
  }

  #topnav.hover section:hover > div[role="group"],
  #topnav section:active     > div[role="group"],
  #topnav section.active     > div[role="group"] {
    visibility: visible !important;
    max-height: none    !important;
    opacity:    1       !important;
    transition: none    !important;
  }
`);
document.adoptedStyleSheets.push(sheet);

const top    = document.getElementById('top');
const topnav = document.getElementById('topnav');

for (const section of topnav?.querySelectorAll('section') ?? []) {
  const link     = section.querySelector(':scope > a');
  const dropdown = section.querySelector('div[role="group"]');

  section.addEventListener('mouseenter', () => {
    top?.classList.remove('hide');

    if (link instanceof HTMLElement) {
      link.style.background   = 'var(--c-bg-header-dropdown)';
      link.style.color        = 'var(--c-header-dropdown)';
      link.style.borderColor  = 'var(--c-primary)';
    }

    if (dropdown instanceof HTMLElement) {
      dropdown.style.visibility = 'visible';
      dropdown.style.maxHeight  = 'none';
    }
  });

  section.addEventListener('mouseleave', () => {
    if (link instanceof HTMLElement) {
      link.style.background  = '';
      link.style.color       = '';
      link.style.borderColor = '';
    }

    if (dropdown instanceof HTMLElement) {
      dropdown.style.visibility = '';
      dropdown.style.maxHeight  = '';
    }
  });
}
})();
