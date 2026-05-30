// ==UserScript==
// @name         Improved Pexels
// @namespace    com.edwinkofler
// @version      0.3.1
// @description  Adds download button for better named images.
// @author       Edwin Kofler
// @match        https://www.pexels.com/photo/*
// @grant        GM_xmlhttpRequest
// @connect      images.pexels.com
// @connect      www.pexels.com
// @run-at       document-idle
// @icon         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAMAAABHPGVmAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAADxQTFRFB6CB////AAAAEqSG1u/quOTbW8CrB6CBe8287fj2CaKCoNvPB6CBB6CBB6CBB6CBLK6UB6CBSLmiB6CBeYEgJgAAABR0Uk5T//8A/////+r//wf/0j+2ZP8i/4lFWtBaAAABqklEQVR4nO3a23KEIAwG4KiIgAdKef93LVZRO+MKBZLxgv92Z/YbgmjcDbRblF4GKJpp0Wr/ctgIW1jYMlh1IjMKsWYyHsEz3GLmDcE0nGJWRKEarmLKIRbXANAtYC/EFUyBxjYAZljwEQvo1XJbj08AxTpqampqrukeUgxhzedI1osvbOQ3TOSvKIi4BQkCxK0ms2hRSCO/CZCm4RRIk7OWHWH8JqK/VixjX3akv/+04+dKGRbiGHEo6VdyCAHgR8GST2UYOZXkpUQgMObuSgzSyV1JvcBiEBCZ9YpCuh0ZMZHjyKIi/uijIv76SjwpL0JIykWx8SSXsD+MqY/H19xWKG6Qx60+uZl4xUOr87XK6YoCjYSQhxE4Sv9HuFgz4rZE12/fU6C5CyJZzXAcUqbhfkb6Mq8OT4jM6uijEMaLvc7dI3LkJV9M75GMRr4iFTmbHfEnmS3QB+Q+FanI+5GnHzoL/tRZU1NT874MFP9jTzR/+pOML5AMYpCMlLQKeeuXdTimNQRjPsgDS8aPXhm0ii3mMkSmcYbI9GWIbGVmOxWFhsnOfhzuBzi7D0LdRPLlAAAAAElFTkSuQmCC
// ==/UserScript==

(function () {
  'use strict';

  function getPhotoId() {
    const segment = location.pathname.replace(/\/$/, '').split('/').pop();
    return segment.split('-').pop();
  }

  function getAuthorName() {
    const selectors = [
      '[class*="AuthorGroup_desktopAuthorGroup"] h5',
      '[class*="AuthorGroup"] h5',
      'a[href^="/@"]',
    ];
    for (const sel of selectors) {
      const el = document.querySelector(sel);
      if (!el) continue;
      const text = el.textContent.trim();
      if (text) return text;
    }
    return 'unknown-author';
  }

  function buildStem() {
    const id = getPhotoId();
    const author = getAuthorName().replace(/[/\\:*?"<>|]+/g, ' ').trim();

    const img = document.querySelector('img[alt][src*="images.pexels.com"]')
              || document.querySelector('img[alt][src*="pexels.com"]');
    const h1  = document.querySelector('h1');
    let description = (img?.alt || h1?.textContent || '').trim();
    description = description.replace(/\s*[-|–—]\s*(pexels|free\s+stock).*$/i, '').trim();
    if (description.length > 60) description = description.slice(0, 60).trimEnd();
    description = description.replace(/[/\\:*?"<>|]+/g, ' ').trim() || 'image';

    return `image - ${author} - pexels_${id}`;
  }

  function smartDownload(anchorEl, btn) {
    const href = anchorEl?.href;
    if (!href) return;

    const stem = buildStem();
    setButtonState(btn, 'loading');

    GM_xmlhttpRequest({
      method: 'GET',
      url: href,
      onload(resp) {
        const finalUrl = resp.finalUrl || href;
        fetchAndSave(finalUrl, stem, btn);
      },
      onerror() {
        console.error('[Pexels Smart DL] Failed to resolve redirect for', href);
        setButtonState(btn, 'idle');
      },
    });
  }

  function fetchAndSave(url, stem, btn) {
    const extMatch = url.split('?')[0].match(/\.(\w+)$/);
    const ext = extMatch ? extMatch[1].toLowerCase() : 'jpg';
    const filename = `${stem}.${ext}`;

    GM_xmlhttpRequest({
      method: 'GET',
      url,
      responseType: 'blob',
      onload(resp) {
        const objectUrl = URL.createObjectURL(resp.response);
        const a = document.createElement('a');
        a.href = objectUrl;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        setTimeout(() => { URL.revokeObjectURL(objectUrl); a.remove(); }, 1500);
        setButtonState(btn, 'idle');
      },
      onerror() {
        console.error('[Pexels Smart DL] Failed to fetch blob for', url);
        setButtonState(btn, 'idle');
      },
    });
  }

  const BTN_CLASS = 'pxl-smart-dl-btn';

  function setButtonState(btn, state) {
    if (!btn) return;
    if (state === 'loading') {
      btn.textContent = '⏳';
      btn.disabled = true;
    } else {
      btn.textContent = '📋';
      btn.title = 'Smart download';
      btn.disabled = false;
    }
  }

  function createSmartButton(anchorEl) {
    const btn = document.createElement('button');
    btn.className = BTN_CLASS;
    btn.textContent = '📋';
    btn.title = 'Smart download';
    btn.style.cssText = `
      display: inline-flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      margin-left: 6px;
      border: 2px solid #333;
      border-radius: 6px;
      padding: 12px 10px;
      margin: 0 4px;
      background: #fff;
      color: #333;
      font-size: 15px;
      cursor: pointer;
      vertical-align: middle;
      transition: background 0.15s, color 0.15s, border-color 0.15s;
      line-height: 1;
    `;
    btn.addEventListener('mouseenter', () => {
      btn.style.background = '#333';
      btn.style.color = '#fff';
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.background = '#fff';
      btn.style.color = '#333';
    });
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      smartDownload(anchorEl, btn);
    });
    return btn;
  }

  function injectIntoDropdown(root) {
    const anchors = Array.from(
      root.querySelectorAll('a[download], a[href*="/download"]')
    ).filter(a => {
      if (!a.closest('[role="listbox"], [role="menu"]')) return false;
      const sib = a.nextElementSibling;
      return !sib || !sib.classList.contains(BTN_CLASS);
    });

    if (!anchors.length) return;

    anchors.forEach((anchor) => {
      const btn = createSmartButton(anchor);
      const parent = anchor.parentElement;
      const originalDisplay = getComputedStyle(parent).display;
      if (!originalDisplay.includes('flex') && !originalDisplay.includes('grid')) {
        parent.style.display = 'flex';
        parent.style.alignItems = 'center';
        parent.style.gap = '4px';
      }
      anchor.after(btn);
    });
  }

  const observer = new MutationObserver((mutations) => {
    for (const { addedNodes } of mutations) {
      for (const node of addedNodes) {
        if (node.nodeType !== Node.ELEMENT_NODE) continue;

        const candidates = [
          node,
          ...node.querySelectorAll(
            '[role="menu"], [role="listbox"], [role="list"], ' +
            '[data-testid*="download"], [class*="download-menu"], [class*="DownloadMenu"]'
          ),
        ];

        for (const candidate of candidates) {
          if (
            candidate.querySelector('a[download]') ||
            candidate.querySelector('a[href*="/download"]')
          ) {
            injectIntoDropdown(candidate);
          }
        }
      }
    }
  });

  observer.observe(document.body, { childList: true, subtree: true });

  document.querySelectorAll('[role="menu"], [role="listbox"]').forEach((el) => {
    if (el.querySelector('a[download]') || el.querySelector('a[href*="/download"]')) {
      injectIntoDropdown(el);
    }
  });
})();
