// ==UserScript==
// @name         Improved Codeforces
// @namespace    com.edwinkofler
// @version      0.2.1
// @description  Improvements for Codeforces
// @author       Edwin Kofler
// @match        https://codeforces.com/*
// @run-at       document-end
// @icon         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABPCAMAAAAqV5CTAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAJZQTFRFAAAAGY/NF4rKGpTRuhwkFYXHth0lvhwksh0lFIHF+9Zv9sVA+c9b98pO+MxU+dFh+tRo98hHG5jTFIDE+9hzwRwkwRwksR4mtx0lFYbI+tRo98pNF4nJ98lKGI/NtR0ltx0lFIHEvhwkGZHPuhwk+tJk+9dw98dFG5bSuxwk+9dw9sU/GI7Ntx0l9sVA9sZE9sZD+9Vs9xzUIQAAADJ0Uk5TAP//////////////////////u3eHOuVmUlVVU+EtkuwLDCBUySniDQ+yBdo2g4m567QkVzKVAAABaklEQVR4nO3Za2+CMBSAYTaHXAQUVOROQS5zgtP//+cGwhRGmzTxuCzLeb8WeEK/9VQQuErcKBBF8bXt5dossPbvfC9zlrgtMUaaIlDFVRQaAqokAQMJKjikUhjILIJD1kzEQgQRRBBBBJFbZRl25X0f4Eh4OpumruuGYWiatlwuV6vVxYNFwuPCnCBqMVQeRhqDhqjF5r5nDyOnBR1RixwOObIQ9b5hDyMLJrJB5KlIWmfx/NpblxRndQqKEOcgy/Mx0nTYQiJOLI8R6YpIdgqIZLJM+xNJqgkYspVZSJaCIQ4TsbdgyA6RX0eUf/MniCCCCCKIIIIIIogggshfRXimRC7HnRb7YNqcfnnmXQkT2d+eITELORCuyZ0QMRBrcM9Ys5B27uGfqYg3nKgmERUZGgKpYxpi79rF0v+cIhdvPLVN1sEUicZXmcTJpkjmkH659L/zunJhWuX27bsqypUscX6UUj70pL4AXxmrOcwVT6EAAAAASUVORK5CYII=
// ==/UserScript==
(function () {
  'use strict';

  const sheet = new CSSStyleSheet();
  sheet.replaceSync('.sidebox { margin-bottom: 1em !important; }');
  document.adoptedStyleSheets.push(sheet);

const captions = document.querySelectorAll('.roundbox.sidebox .caption.titled');
	for (const caption of captions) {
		if (!caption.textContent.includes('About Contest')) continue;
		if (caption.querySelector('.sidebar-caption-icon')) continue;

		const icon = document.createElement('i');
		icon.className = 'sidebar-caption-icon las la-angle-right';
		const topLinks = caption.querySelector('.top-links');
		if (topLinks) {
			caption.insertBefore(icon, topLinks);
		} else {
			caption.appendChild(icon);
		}

		const siblings = [];
		let sibling = caption.nextElementSibling;
		while (sibling) {
			siblings.push(sibling);
			sibling = sibling.nextElementSibling;
		}
		if (siblings.length === 0) continue;

		for (const s of siblings) s.style.display = 'none';

		icon.addEventListener('click', function (e) {
			e.preventDefault();
			icon.classList.toggle('la-angle-down');
			icon.classList.toggle('la-angle-right');
			const collapsed = icon.classList.contains('la-angle-right');
			for (const s of siblings) s.style.display = collapsed ? 'none' : '';
		});
	}
})();
