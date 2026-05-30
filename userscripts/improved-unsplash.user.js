// ==UserScript==
// @name         Improved Unsplash
// @namespace    com.edwinkofler
// @version      0.3.0
// @description  Adds download button for better named images.
// @author       Edwin Kofler
// @match        https://unsplash.com/photos/*
// @grant        GM_xmlhttpRequest
// @connect      unsplash.com
// @connect      images.unsplash.com
// @connect      plus.unsplash.com
// @connect      dl.unsplash.com
// @run-at       document-idle
// @icon         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAA9QTFRFAAAAAAAAAgAAAAACAAIA+cdlAgAAAAV0Uk5T/wD///8IsecvAAAAbElEQVR4nK2PyxHAIAgFd9AG0gElpAT7ryqDnyjReEk4MLLA48lhgShQnjlb6UCu5QnchIBOKx/BEL8Abo/1FmbbAzYgWnEOIJAWK7LTeAfZnlYJrTp2LtDutlyc9D9ENPeSF2Md0rvjiM5DF3yZEfcaGOwjAAAAAElFTkSuQmCC
// ==/UserScript==

(function () {
  'use strict';

  function getPhotoId() {
    const slug = location.pathname.split('/').filter(Boolean)[1] || '';
    return slug.split('-').pop() || 'unknown';
  }

  function getAuthorName() {
    const nameLink = Array.from(document.querySelectorAll('a[href^="/@"]')).find(a =>
      !a.querySelector('img, svg') && a.textContent.trim().length > 0
    );
    return nameLink ? nameLink.textContent.trim() : 'unknown';
  }

  function buildStem() {
    const id     = getPhotoId();
    const author = getAuthorName().replace(/[/\\:*?"<>|]+/g, ' ').trim();
    return `image - ${author} - unsplash_${id}`;
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
        console.error('[Unsplash+] Failed to resolve redirect for', href);
        setButtonState(btn, 'idle');
      },
    });
  }

  function fetchAndSave(url, stem, btn) {
    const extMatch = url.split('?')[0].match(/\.(\w+)$/);
    const ext      = extMatch ? extMatch[1].toLowerCase() : 'jpg';
    const filename = `${stem}.${ext}`;

    GM_xmlhttpRequest({
      method: 'GET',
      url,
      responseType: 'blob',
      onload(resp) {
        const objectUrl = URL.createObjectURL(resp.response);
        const a         = document.createElement('a');
        a.href          = objectUrl;
        a.download      = filename;
        document.body.appendChild(a);
        a.click();
        setTimeout(() => { URL.revokeObjectURL(objectUrl); a.remove(); }, 1500);
        setButtonState(btn, 'idle');
      },
      onerror() {
        console.error('[Unsplash+] Failed to fetch blob for', url);
        setButtonState(btn, 'idle');
      },
    });
  }

  const BTN_CLASS = 'unsp-smart-dl-btn';

  function setButtonState(btn, state) {
    if (!btn) return;
    if (state === 'loading') {
      btn.textContent = '⏳';
      btn.disabled    = true;
    } else {
      btn.textContent = '💾';
      btn.title       = 'Smart download (better filename)';
      btn.disabled    = false;
    }
  }

  function createSmartButton(anchorEl) {
    const btn = document.createElement('button');
    btn.className   = BTN_CLASS;
    btn.textContent = '💾';
    btn.title       = 'Smart download';
    btn.style.cssText = `
      display: inline-flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      margin-left: 6px;
      padding: 0 10px;
      min-height: 34px;
      border: 2px solid #333;
      border-radius: 6px;
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
      btn.style.color      = '#fff';
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.background = '#fff';
      btn.style.color      = '#333';
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
      if (!/small|medium|large|original/i.test(a.textContent)) return false;
      const sib = a.nextElementSibling;
      return !sib || !sib.classList.contains(BTN_CLASS);
    });

    if (!anchors.length) return;

    anchors.forEach((anchor) => {
      const btn = createSmartButton(anchor);
      anchor.after(btn);
    });

    const menu = anchors[0].closest('[role="menu"]') || anchors[0].parentElement;
    menu.style.cssText = `
      display: grid;
      grid-template-columns: 1fr auto;
      align-items: center;
      gap: 2px 0;
    `;

    Array.from(menu.children).forEach(child => {
      if (!child.matches(`a, .${BTN_CLASS}`)) {
        child.style.gridColumn = '1 / -1';
      }
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
            '[data-testid*="download"], [class*="download"], [class*="Download"]'
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
})();
