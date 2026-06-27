// ==UserScript==
// @name         Improved Unsplash
// @namespace    com.edwinkofler
// @version      0.7.1
// @description  Adds download button for better named images.
// @author       Edwin Kofler
// @match        https://unsplash.com/photos/*
// @grant        GM_xmlhttpRequest
// @grant        GM_getValue
// @grant        GM_setValue
// @grant        GM_registerMenuCommand
// @connect      unsplash.com
// @connect      api.unsplash.com
// @connect      images.unsplash.com
// @connect      plus.unsplash.com
// @connect      dl.unsplash.com
// @run-at       document-idle
// @require      https://raw.githubusercontent.com/hyperupcall-projects/GM_config/v0.1.0/gm_config.js
// @icon         data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAAXNSR0IB2cksfwAAAAlwSFlzAAALEwAACxMBAJqcGAAAAA9QTFRFAAAAAAAAAgAAAAACAAIA+cdlAgAAAAV0Uk5T/wD///8IsecvAAAAbElEQVR4nK2PyxHAIAgFd9AG0gElpAT7ryqDnyjReEk4MLLA48lhgShQnjlb6UCu5QnchIBOKx/BEL8Abo/1FmbbAzYgWnEOIJAWK7LTeAfZnlYJrTp2LtDutlyc9D9ENPeSF2Md0rvjiM5DF3yZEfcaGOwjAAAAAElFTkSuQmCC
// ==/UserScript==

(function () {
  'use strict';

  const DIALOG_ID  = 'unsp-named-download-dialog';
  const SIZE_TIERS = [
    { size: 'small',    label: 'Small',         maxWidth: 640 },
    { size: 'medium',   label: 'Medium',        maxWidth: 1920 },
    { size: 'large',    label: 'Large',         maxWidth: 2400 },
    { size: 'original', label: 'Original size', maxWidth: Infinity },
  ];

  const cfg = new GM_config({
    id: 'ImprovedUnsplashConfig',
    title: 'Improved Unsplash Settings',
    fields: {
      apiKey: {
        label: 'Unsplash Access Key (Client-ID)',
        type: 'text',
        default: '',
      },
    },
  });

  GM_registerMenuCommand('Settings', () => cfg.open());

  function hasClassPrefix(el, prefix) {
    return [...el.classList].some(c => c.startsWith(prefix));
  }

  function getPhotoId() {
    const dlLink = document.querySelector(
      'a[data-testid="non-sponsored-photo-download-button"], ' +
      '[class*="downloadButtonContainer-"] a[href*="/download"]'
    );
    const fromHref = dlLink?.href?.match(/\/photos\/([^/?#]+)\/download/i)?.[1];
    if (fromHref) return fromHref;

    const slug = location.pathname.split('/').filter(Boolean)[1] || '';
    if (!slug) return '';
    if (/^[a-zA-Z0-9_-]{11}$/.test(slug)) return slug;

    const tail = slug.match(/-([a-zA-Z0-9_-]{11})$/);
    return tail ? tail[1] : slug;
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

  function findActionsContainer() {
    return [...document.querySelectorAll('div')].find(el =>
      hasClassPrefix(el, 'actionsContainer-')
    );
  }

  function findDownloadMenu() {
    return document.querySelector('[role="menu"]');
  }

  function findChevronButton() {
    return document.querySelector(
      '[class*="downloadButtonContainer-"] button[aria-haspopup="menu"]'
    );
  }

  function openNativeDownloadMenu() {
    return new Promise(resolve => {
      const chevron = findChevronButton();
      if (!chevron) {
        resolve(null);
        return;
      }

      if (findDownloadMenu()) {
        resolve(findDownloadMenu());
        return;
      }

      const observer = new MutationObserver(() => {
        const menu = findDownloadMenu();
        if (!menu?.querySelector('a[href*="/download"]')) return;
        observer.disconnect();
        clearTimeout(timer);
        resolve(menu);
      });

      const timer = setTimeout(() => {
        observer.disconnect();
        resolve(findDownloadMenu());
      }, 2000);

      observer.observe(document.body, { childList: true, subtree: true });
      chevron.click();
    });
  }

  function closeNativeDownloadMenu() {
    const chevron = findChevronButton();
    if (chevron?.getAttribute('aria-expanded') === 'true') {
      chevron.click();
      return;
    }
    document.dispatchEvent(
      new KeyboardEvent('keydown', { key: 'Escape', bubbles: true })
    );
  }

  function formatDimensions(width, height) {
    return `${width} × ${height}`;
  }

  function scaledDimensions(origW, origH, maxWidth) {
    const width  = Math.min(maxWidth, origW);
    const height = Math.round(origH * (width / origW));
    return { width, height };
  }

  function buildImageUrl(rawUrl, targetW, origW) {
    const url = new URL(rawUrl);
    url.searchParams.set('fm', 'jpg');
    url.searchParams.set('q', '80');
    if (targetW >= origW) {
      return url.toString();
    }
    url.searchParams.set('w', String(targetW));
    url.searchParams.set('fit', 'max');
    return url.toString();
  }

  function apiRequest(path) {
    return new Promise((resolve, reject) => {
      const key = cfg.get('apiKey')?.trim();
      if (!key) {
        reject(new Error('API key not configured'));
        return;
      }

      GM_xmlhttpRequest({
        method: 'GET',
        url: `https://api.unsplash.com${path}`,
        headers: { Authorization: `Client-ID ${key}` },
        onload(resp) {
          if (resp.status >= 200 && resp.status < 300) {
            resolve(JSON.parse(resp.responseText));
            return;
          }
          reject(new Error(`API ${resp.status}`));
        },
        onerror() {
          reject(new Error('API request failed'));
        },
      });
    });
  }

  function triggerDownloadTracking(photoId) {
    return apiRequest(`/photos/${encodeURIComponent(photoId)}/download`).catch(err => {
      console.warn('[Unsplash+] Download tracking failed:', err.message);
    });
  }

  async function fetchPhotoOptions() {
    const photoId = getPhotoId();
    if (!photoId) throw new Error('Photo ID not found');

    const photo = await apiRequest(`/photos/${encodeURIComponent(photoId)}`);

    return SIZE_TIERS.map(tier => {
      const { width, height } = scaledDimensions(
        photo.width,
        photo.height,
        tier.maxWidth
      );
      return {
        size: tier.size,
        label: tier.label,
        dimensions: formatDimensions(width, height),
        url: buildImageUrl(photo.urls.raw, width, photo.width),
      };
    });
  }

  function captureMenuStyles(menu) {
    if (!menu) return null;
    const cs = getComputedStyle(menu);
    return {
      width: cs.width, minWidth: cs.minWidth, maxWidth: cs.maxWidth,
      padding: cs.padding, margin: cs.margin, background: cs.background,
      border: cs.border, borderRadius: cs.borderRadius, boxShadow: cs.boxShadow,
      color: cs.color, fontFamily: cs.fontFamily, fontSize: cs.fontSize,
      lineHeight: cs.lineHeight, display: cs.display, flexDirection: cs.flexDirection,
      gap: cs.gap,
    };
  }

  function applyCapturedStyles(el, styles) {
    if (!styles || !el) return;
    Object.assign(el.style, styles, { boxSizing: 'border-box' });
  }

  function renderOptionButton(btn, label, dimensions) {
    btn.replaceChildren();

    const labelSpan = document.createElement('span');
    labelSpan.dataset.unsp = 'label';
    labelSpan.textContent  = label;

    const dimSpan = document.createElement('span');
    dimSpan.dataset.unsp = 'dims';
    dimSpan.textContent  = dimensions || '';
    dimSpan.style.marginLeft = 'auto';
    dimSpan.style.opacity    = '0.65';
    dimSpan.style.fontWeight = 'normal';

    btn.append(labelSpan, dimSpan);
  }

  function setOptionButtonState(btn, state) {
    if (!btn) return;
    if (state === 'loading') {
      btn.textContent = 'Downloading…';
      btn.disabled    = true;
    } else {
      renderOptionButton(btn, btn.dataset.label, btn.dataset.dimensions);
      btn.disabled = false;
    }
  }

  function createOptionButton(opt, templateLink) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.dataset.label      = opt.label;
    btn.dataset.dimensions = opt.dimensions || '';
    cloneInteractiveClasses(templateLink, btn);
    btn.style.display        = 'flex';
    btn.style.justifyContent = 'space-between';
    btn.style.alignItems     = 'center';
    btn.style.width          = '100%';
    btn.style.gap            = '12px';
    renderOptionButton(btn, opt.label, opt.dimensions);
    return btn;
  }

  function smartDownloadUrl(url, btn) {
    if (!url) return;

    const stem    = buildStem();
    const photoId = getPhotoId();
    setOptionButtonState(btn, 'loading');

    triggerDownloadTracking(photoId).finally(() => {
      fetchAndSave(url, stem, btn);
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
        setOptionButtonState(btn, 'idle');
      },
      onerror() {
        console.error('[Unsplash+] Failed to fetch blob for', url);
        setOptionButtonState(btn, 'idle');
      },
    });
  }

  function cloneInteractiveClasses(template, el) {
    if (template?.className) el.className = template.className;
  }

  function ensureDialog() {
    let dialog = document.getElementById(DIALOG_ID);
    if (dialog) return dialog;

    if (!document.getElementById('unsp-dialog-styles')) {
      const style = document.createElement('style');
      style.id = 'unsp-dialog-styles';
      style.textContent = `
        #${DIALOG_ID} {
          margin: auto;
          border: none;
          padding: 0;
          background: transparent;
          max-width: 90vw;
          max-height: 90vh;
        }
        #${DIALOG_ID}::backdrop {
          background: rgba(0, 0, 0, 0.45);
        }
      `;
      document.head.appendChild(style);
    }

    dialog = document.createElement('dialog');
    dialog.id = DIALOG_ID;
    dialog.style.zIndex = '2147483647';

    const panel = document.createElement('div');
    panel.dataset.unsp = 'dialog-panel';
    panel.style.background   = '#fff';
    panel.style.borderRadius = '8px';
    panel.style.minWidth     = '260px';
    dialog.appendChild(panel);

    dialog.addEventListener('click', (e) => {
      if (e.target === dialog) dialog.close();
    });

    dialog.addEventListener('close', closeNativeDownloadMenu);
    document.body.appendChild(dialog);
    return dialog;
  }

  async function openNamedDownloadDialog() {
    const dialog = ensureDialog();
    const panel  = dialog.querySelector('[data-unsp="dialog-panel"]');
    panel.replaceChildren();

    const loading = document.createElement('p');
    loading.textContent = 'Loading sizes…';
    panel.appendChild(loading);
    dialog.showModal();

    const menu = await openNativeDownloadMenu();

    let options;
    try {
      options = await fetchPhotoOptions();
    } catch (err) {
      closeNativeDownloadMenu();
      panel.replaceChildren();
      const msg = document.createElement('p');
      msg.style.padding = '12px 16px';
      msg.textContent = err.message === 'API key not configured'
        ? 'Set your Unsplash API key via Tampermonkey → Improved Unsplash → Settings.'
        : `Failed to load photo sizes (${err.message}).`;
      panel.appendChild(msg);
      return;
    }

    const menuStyles   = captureMenuStyles(menu);
    const templateLink = menu?.querySelector('a[href*="/download"]')
      || document.querySelector('a[data-testid="non-sponsored-photo-download-button"]');

    closeNativeDownloadMenu();
    panel.replaceChildren();
    applyCapturedStyles(panel, menuStyles);
    panel.style.background = '#fff';

    for (const opt of options) {
      const btn = createOptionButton(opt, templateLink);
      btn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        smartDownloadUrl(opt.url, btn);
      });
      panel.appendChild(btn);
    }
  }

  function injectNamedDownloadButton() {
    const actions = findActionsContainer();
    if (!actions || actions.querySelector('[data-unsp="named-download"]')) return;

    const siblingWrap = actions.querySelector('[class*="downloadButtonContainer-"]')
      || actions.lastElementChild;

    const wrap = document.createElement('button');
    if (siblingWrap instanceof HTMLElement) {
      wrap.className = siblingWrap.className;
    }
    wrap.dataset.unsp = 'named-download';

    const templateBtn = siblingWrap?.querySelector('a, button')
      || actions.querySelector('a, button');

    cloneInteractiveClasses(templateBtn, wrap);
    wrap.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      openNamedDownloadDialog();
    });

    const span = document.createElement('span');
    span.textContent = 'Named Download';
    span.className = document.querySelector('[class*="buttonText-"]').className;

    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('width', '16');
    svg.setAttribute('height', '16');
    svg.setAttribute('viewBox', '0 0 24 24');
    svg.setAttribute('fill', 'none');
    svg.setAttribute('stroke', 'currentColor');
    svg.setAttribute('stroke-width', '2');
    svg.setAttribute('stroke-linecap', 'round');
    svg.setAttribute('stroke-linejoin', 'round');
    svg.innerHTML = '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line>';

    wrap.appendChild(svg);
    wrap.appendChild(span);
    actions.prepend(wrap);
  }

  function teardown() {
    document.querySelectorAll('[data-unsp="named-download"]').forEach(el => el.remove());
    document.getElementById(DIALOG_ID)?.remove();
  }

  let lastPath = location.pathname;
  let injectTimer;

  function checkRouteChange() {
    const path = location.pathname;
    if (path === lastPath) return;
    lastPath = path;
    teardown();
    injectNamedDownloadButton();
  }

  function hookHistory() {
    const { pushState, replaceState } = history;

    history.pushState = function (...args) {
      pushState.apply(this, args);
      checkRouteChange();
    };

    history.replaceState = function (...args) {
      replaceState.apply(this, args);
      checkRouteChange();
    };

    globalThis.addEventListener('popstate', checkRouteChange);
  }

  function startInjectionObserver() {
    injectNamedDownloadButton();

    const observer = new MutationObserver(() => {
      clearTimeout(injectTimer);
      injectTimer = setTimeout(injectNamedDownloadButton, 100);
    });
    observer.observe(document.body, { childList: true, subtree: true });
  }

  hookHistory();
  startInjectionObserver();
})();
