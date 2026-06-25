// ==UserScript==
// @name         Custom Image Filenames
// @namespace    com.edwinkofler
// @version      1.0.1
// @description  Adds smart download buttons with descriptive filenames on Pixabay and Pexels.
// @author       Edwin Kofler
// @match        https://pixabay.com/photos/*
// @match        https://pixabay.com/vectors/*
// @match        https://pixabay.com/illustrations/*
// @match        https://pixabay.com/images/*
// @match        https://www.pexels.com/photo/*
// @grant        GM_xmlhttpRequest
// @connect      pixabay.com
// @connect      cdn.pixabay.com
// @connect      images.pexels.com
// @connect      www.pexels.com
// @run-at       document-idle
// @icon         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAMAAABHPGVmAAAAAXNSR0IB2cksfwAAAAlwSFlzAAAewgAAHsIBbtB1PgAAAEtQTFRFGRsm////HyArtba5AAAANzlCZWZu+/v7Kiw26OjpwMHEoqOnk5SZ8/PzysvNVlhgRUZQGRsmgoOJ2NnbGRsmcXJ5GRsmGBgjGRsmLJgLpgAAABl0Uk5T/////wD////////////////u//9z/8YWlbc7/6gAAALgSURBVHic7Vppb+wgDCTZ5ibH5tjt//+lL9kCw+EAlV7yoWKkSpUJDLbHhpVgXzve6+vJLsDztb6P9dn+t17CIHjWH5Lv6ygOfB8k67UcjK1f7H1hrH7wfLPLHdldYa/rSV7s8mixOygSEhISEhL+BvJpmzmfyym3BspOYrRGJjWyxTDUW9tnAn27GTx1I0ea2py0qClFBAVXDGIS15crlf1hTHtIc2W7SKBsMgdNqX3QKbNunZV1DlLknUtxoEPMcsQFHk4V7R/J0dIc+1ywYMFWmpCppSYXjuLYFwQLQiN1hIRMQUfMWPWmADp8p/YihOSyngPCyRY+7X7XE19gQ54RneHwb1Tx684Xl1PVzhtsKN+owhgV8+xQRgZrMJJXD9LOYeRIQq7Gm3AVKkfs/Sg5aJKFjhfwRVShzF7jiFDFQ6uzyWoLWUwVMia9Lt0hmYJBs202R7gK9+1W7kL2BirdyYfJEa5Cbbek0uW29ajXRpPrw1XIkBJSIdJNI+woDzrIBISAG3pU7NosNg6OcBXqJAs9OlDJhY4jqvADkceWHm0pkgLnZ8RhGCZZiKig1CO1FSDJxZ65bjR6dkyVBEgofY+ZAU5O/A2J1JFWDIXdV2JE7CORvVPTt54QkfyIcvSRSEc617T3GvmP21l/Q6JOTHQVJKTD2dsGq+WcZFQHjTIVuJ3kWqcM1v0pyazioRxBQo7bCS6owXsETZKXWAGlgIR8OiYOsNCNSJAsJbDxh6ZT5BXtVwSwJD7ykZwCCsVBoloWXPO3ygBJhVrDNVOlQKsab/L9JD3UC8lq/Uo7Jn33CS/JglY+0sUHs+9m5CHpZwQaW7YWg4Oew+WUpDF+aCEhdtvFAueHC0nStHw05IL9LraMcqqiaJKhAGpXjtqgM1Zj8EzH/uP3PyGRJJJEkkgSyQmm8YOoH7EJCQkJfx+3PMS45UnJLY9jbnnmc8uDpXueXt3ziOz653D/AOtRHFUiG+pOAAAAAElFTkSuQmCC
// ==/UserScript==

(function () {
  'use strict';

  function getPhotoId() {
    const segment = location.pathname.replace(/\/$/, '').split('/').pop();
    const tokens  = segment.split('-');
    for (let i = tokens.length - 1; i >= 0; i--) {
      if (/^\d+$/.test(tokens[i])) return tokens[i];
    }
    return 'unknown';
  }

  function getAuthorName() {
    for (const a of document.querySelectorAll('a[class*="userName"]')) {
      const text = a.textContent.trim();
      if (text && text.length < 60) return text;
    }
    for (const a of document.querySelectorAll('a[href*="/users/"]')) {
      const text = a.textContent.trim();
      if (text && text.length < 60) return text;
    }
    return 'unknown';
  }

  function buildStem() {
    const id     = getPhotoId();
    const author = getAuthorName().replace(/[/\\:*?"<>|]+/g, ' ').trim();
    return `image - ${author} - pixabay_${id}`;
  }

  function buildDownloadUrl(width) {
    const base = location.origin + location.pathname.replace(/\/$/, '') + '/download/';
    return width ? `${base}?attachment&w=${width}` : `${base}?attachment`;
  }

  function smartDownload(width, btn) {
    const url  = buildDownloadUrl(width);
    const stem = buildStem();
    setButtonState(btn, 'loading');

    GM_xmlhttpRequest({
      method: 'GET',
      url,
      onload(resp) {
        fetchAndSave(resp.finalUrl || url, stem, btn);
      },
      onerror() {
        console.error('[Pixabay+] redirect failed:', url);
        setButtonState(btn, 'idle');
      },
    });
  }

  function fetchAndSave(url, stem, btn) {
    const extMatch = url.split('?')[0].match(/\.(\w+)$/);
    const ext      = extMatch ? extMatch[1].toLowerCase() : 'jpg';

    GM_xmlhttpRequest({
      method: 'GET',
      url,
      responseType: 'blob',
      onload(resp) {
        const objectUrl = URL.createObjectURL(resp.response);
        const a         = document.createElement('a');
        a.href          = objectUrl;
        a.download      = `${stem}.${ext}`;
        document.body.appendChild(a);
        a.click();
        setTimeout(() => { URL.revokeObjectURL(objectUrl); a.remove(); }, 1500);
        setButtonState(btn, 'idle');
      },
      onerror() {
        console.error('[Pixabay+] blob fetch failed:', url);
        setButtonState(btn, 'idle');
      },
    });
  }

  const overlay = document.createElement('div');
  overlay.id = 'cif-overlay-pixabay';
  overlay.style.cssText = `
    position: fixed;
    top: 0; left: 0;
    width: 0; height: 0;
    z-index: 2147483647;
    pointer-events: none;
  `;
  document.documentElement.appendChild(overlay);

  const pool = [];

  function setButtonState(btn, state) {
    if (!btn) return;
    if (state === 'loading') {
      btn.innerHTML = '⏳';
      btn.disabled  = true;
    } else {
      btn.innerHTML = '📋';
      btn.disabled  = false;
    }
  }

  function getPoolButton(index) {
    if (pool[index]) return pool[index];

    const btn = document.createElement('button');
    btn.type           = 'button';
    btn.innerHTML      = '📋';
    btn.title          = 'Smart download';
    btn.style.cssText  = `
      position: fixed;
      pointer-events: all;
      display: none;
      align-items: center;
      justify-content: center;
      width: 34px;
      height: 34px;
      padding: 0;
      border: 2px solid gray;
      border-radius: 6px;
      background: #fff;
      color: #2ec66e;
      font-size: 16px;
      line-height: 1;
      cursor: pointer;
      box-sizing: border-box;
      box-shadow: 0 1px 4px rgba(0,0,0,.18);
    `;
    btn.addEventListener('mouseenter', () => {
      btn.style.background = '#ccc';
      btn.style.color      = '#fff';
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.background = '#fff';
      btn.style.color      = '#ccc';
    });

    overlay.appendChild(btn);
    pool[index] = btn;
    return btn;
  }

  function parseWidth(itemEl) {
    for (const div of itemEl.querySelectorAll('div')) {
      const t = div.textContent.trim();
      if (/^\d+\s*[×x]\s*\d+$/.test(t)) {
        const m = t.match(/^(\d+)/);
        return m ? m[1] : null;
      }
    }
    return null;
  }

  let rafId = null;

  function isDownloadMenuItem(item) {
    const text = item.textContent;
    return /small|medium|large|original|vector/i.test(text) ||
           /\d+\s*[×x]\s*\d+/.test(text);
  }

  function syncOverlay() {
    const allItems = document.querySelectorAll('div[role="menu"] button[role="menuitem"]');
    const items    = Array.from(allItems).filter(isDownloadMenuItem);

    if (!items.length) {
      pool.forEach(b => { b.style.display = 'none'; });
      rafId = null;
      return;
    }

    items.forEach((item, i) => {
      const rect = item.getBoundingClientRect();
      const btn  = getPoolButton(i);

      btn.style.top     = `${rect.top + (rect.height - 34) / 2}px`;
      btn.style.left    = `${rect.right + 6}px`;
      btn.style.display = 'inline-flex';

      const width   = parseWidth(item);
      btn.onclick = (e) => {
        e.stopPropagation();
        e.preventDefault();
        smartDownload(width, btn);
      };
    });

    for (let i = items.length; i < pool.length; i++) {
      pool[i].style.display = 'none';
    }

    rafId = requestAnimationFrame(syncOverlay);
  }

  function startLoop() {
    if (!rafId) rafId = requestAnimationFrame(syncOverlay);
  }

  new MutationObserver(() => {
    const hasDownloadMenu = Array.from(
      document.querySelectorAll('div[role="menu"] button[role="menuitem"]')
    ).some(isDownloadMenuItem);
    if (hasDownloadMenu) startLoop();
  }).observe(document.body, { childList: true, subtree: true });

  startLoop();

})();

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
    const id     = getPhotoId();
    const author = getAuthorName().replace(/[/\\:*?"<>|]+/g, ' ').trim();
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
        fetchAndSave(resp.finalUrl || href, stem, btn);
      },
      onerror() {
        console.error('[Pexels+] redirect failed:', href);
        setButtonState(btn, 'idle');
      },
    });
  }

  function fetchAndSave(url, stem, btn) {
    const extMatch = url.split('?')[0].match(/\.(\w+)$/);
    const ext      = extMatch ? extMatch[1].toLowerCase() : 'jpg';

    GM_xmlhttpRequest({
      method: 'GET',
      url,
      responseType: 'blob',
      onload(resp) {
        const objectUrl = URL.createObjectURL(resp.response);
        const a         = document.createElement('a');
        a.href          = objectUrl;
        a.download      = `${stem}.${ext}`;
        document.body.appendChild(a);
        a.click();
        setTimeout(() => { URL.revokeObjectURL(objectUrl); a.remove(); }, 1500);
        setButtonState(btn, 'idle');
      },
      onerror() {
        console.error('[Pexels+] blob fetch failed:', url);
        setButtonState(btn, 'idle');
      },
    });
  }

  const overlay = document.createElement('div');
  overlay.id = 'cif-overlay-pexels';
  overlay.style.cssText = `
    position: fixed;
    top: 0; left: 0;
    width: 0; height: 0;
    z-index: 2147483647;
    pointer-events: none;
  `;
  document.documentElement.appendChild(overlay);

  const pool = [];

  function setButtonState(btn, state) {
    if (!btn) return;
    if (state === 'loading') {
      btn.innerHTML = '⏳';
      btn.disabled  = true;
    } else {
      btn.innerHTML = '📋';
      btn.disabled  = false;
    }
  }

  function getPoolButton(index) {
    if (pool[index]) return pool[index];

    const btn = document.createElement('button');
    btn.type           = 'button';
    btn.innerHTML      = '📋';
    btn.title          = 'Smart download';
    btn.style.cssText  = `
      position: fixed;
      pointer-events: all;
      display: none;
      align-items: center;
      justify-content: center;
      width: 34px;
      height: 34px;
      padding: 0;
      border: 2px solid gray;
      border-radius: 6px;
      background: #fff;
      color: #2ec66e;
      font-size: 16px;
      line-height: 1;
      cursor: pointer;
      box-sizing: border-box;
      box-shadow: 0 1px 4px rgba(0,0,0,.18);
    `;
    btn.addEventListener('mouseenter', () => {
      btn.style.background = '#ccc';
      btn.style.color      = '#fff';
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.background = '#fff';
      btn.style.color      = '#ccc';
    });

    overlay.appendChild(btn);
    pool[index] = btn;
    return btn;
  }

  function isDownloadMenuItem(item) {
    const text = item.textContent;
    return /small|medium|large|original/i.test(text) ||
           /\d+\s*[×x]\s*\d+/.test(text);
  }

  function findDownloadAnchor(el) {
    if (el.tagName === 'A' && el.href) return el;
    return el.querySelector(
      'a[download], a[href*="/download"], a[href*="images.pexels.com"]'
    );
  }

  function getDownloadMenuItems() {
    const seen = new Set();
    const items = [];

    const roots = document.querySelectorAll(
      '#medium-download-size-selector-menu, [role="listbox"], div[role="menu"]'
    );

    for (const root of roots) {
      const rows = root.querySelectorAll(
        'button[role="menuitem"], [role="option"], li, a[download], a[href*="/download"]'
      );

      for (const row of rows) {
        if (!isDownloadMenuItem(row)) continue;

        const anchor = findDownloadAnchor(row);
        if (!anchor?.href) continue;

        const positionEl = row.tagName === 'LI' ? row : (row.closest('li') || row);
        if (seen.has(anchor)) continue;
        seen.add(anchor);
        items.push({ row: positionEl, anchor });
      }
    }

    return items;
  }

  let rafId = null;

  function syncOverlay() {
    const items = getDownloadMenuItems();

    if (!items.length) {
      pool.forEach(b => { b.style.display = 'none'; });
      rafId = null;
      return;
    }

    items.forEach(({ row, anchor }, i) => {
      const rect = row.getBoundingClientRect();
      const btn  = getPoolButton(i);

      btn.style.top     = `${rect.top + (rect.height - 34) / 2}px`;
      btn.style.left    = `${rect.right + 6}px`;
      btn.style.display = 'inline-flex';

      btn.onclick = (e) => {
        e.stopPropagation();
        e.preventDefault();
        smartDownload(anchor, btn);
      };
    });

    for (let i = items.length; i < pool.length; i++) {
      pool[i].style.display = 'none';
    }

    rafId = requestAnimationFrame(syncOverlay);
  }

  function startLoop() {
    if (!rafId) rafId = requestAnimationFrame(syncOverlay);
  }

  function hasDownloadMenu() {
    return getDownloadMenuItems().length > 0;
  }

  new MutationObserver(() => {
    if (hasDownloadMenu()) startLoop();
  }).observe(document.body, { childList: true, subtree: true });

  document.addEventListener('click', () => {
    setTimeout(() => {
      if (hasDownloadMenu()) startLoop();
    }, 0);
  }, true);

  startLoop();

})();
