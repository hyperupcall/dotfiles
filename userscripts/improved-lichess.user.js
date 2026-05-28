// ==UserScript==
// @name         Improved lichess
// @namespace    https://lichess.org/userscripts
// @version      0.1.0
// @description  Removes navigation menu delay.
// @author       hyperupcall
// @match        https://lichess.org/*
// @grant        GM_addStyle
// @run-at       document-end
// ==/UserScript==

'use strict';

GM_addStyle(`
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
