(function () {
    'use strict';

    /* ============================== config ============================== */

    const STORAGE_KEY = 'notes:recently-visited:v1';
    const COLLAPSED_KEY = 'notes:recently-visited:collapsed';

    const PLACEHOLDER = 'recently-visited';
    const MAX_ITEMS = 6;
    const MAX_STORED = 30;
    const NESTED_KEYWORDS = ['Трек от'];

    const HOME_URL = "https://pelmesh619.github.io/itmo_conspects";

    const RECENTLY_VISITED_HEADER_TEXT = "Недавно посещенные конспекты";
    const HIDE_BUTTON_TEXT = "Скрыть";
    const SHOW_BUTTON_TEXT = "Показать";
    const REMOVE_BUTTON_TEXT = "Убрать";
    const REMOVE_BUTTON_CONT_TEXT = "из недавно посещенных";

    const NOTHING_HERE_YET_TEXTS = [
        "Пока недавних нет... 🏜️",
        "Здесь пока пусто... 🏜️",
        "<span id=\"cat-emoji\" style=\"display: inline\">😼</span>"
    ];
    const NOTHING_HERE_YET_CHANCES = [0.45, 0.54, 0.01];

    // "_superconspect", "_superconspect.html", "_superconspect/", "_superconspect/index.html"
    const SUPERCONSPECT_RE = /_superconspect(\.html)?\/?(index\.html)?$/i;

    /* ============================== storage ============================= */

    function readList() {
        try {
            const raw = localStorage.getItem(STORAGE_KEY);
            const parsed = raw ? JSON.parse(raw) : [];
            return Array.isArray(parsed) ? parsed.filter(p => p && p.url && p.title) : [];
        } catch (_) { return []; }
    }

    function writeList(list) {
        try { localStorage.setItem(STORAGE_KEY, JSON.stringify(list.slice(0, MAX_STORED))); } catch (_) { }
    }

    function upsert(url, entry) {
        const list = readList().filter(p => p.url !== url);
        list.unshift(Object.assign({ url, ts: Date.now() }, entry));
        writeList(list);
    }

    function forgetPage(url) {
        writeList(readList().filter(p => p.url !== url));
    }

    /* ============================== helpers ============================= */

    function normalizeUrl(href) {
        try {
            const u = new URL(href, location.href);
            u.hash = '';
            return u.href;
        } catch (_) { return String(href).split('#')[0]; }
    }

    function isSuperconspect(url) {
        try { return SUPERCONSPECT_RE.test(new URL(url, location.href).pathname); }
        catch (_) { return false; }
    }

    function isPdfUrl(url) {
        try { return /\.pdf$/i.test(new URL(url, location.href).pathname); }
        catch (_) { return /\.pdf(\?.*)?$/i.test(url); }
    }

    function isMainPage(url) {
        try {
            return new URL(url, location.href).href == new URL(HOME_URL).href;
        } catch (_) { return false; }
    }

    function isRecordableUrl(url) {
        if (isPdfUrl(url)) return true;
        if (isSuperconspect(url)) return true;
        if (isMainPage(url)) return true;
        try {
            const p = new URL(url, location.href).pathname;
            // .html/.htm files, or extensionless paths served as index pages ("/foo/")
            return /\.html?$/i.test(p) || /\/$/.test(p);
        } catch (_) {
            return false;
        }
    }

    function getH2() {
        const h2 = document.querySelector('h2');
        return h2 ? h2.textContent.replace(/\s+/g, ' ').trim() : '';
    }

    /**
     * Label of a list item = its own text, without nested lists and without links.
     *   <li>foofoofoo <a>hahaha</a> <ul>…</ul></li>  → "foofoofoo"
     *   <li><a>fafafa</a></li>                       → ""
     */
    function listItemLabel(li) {
        if (!li) return '';

        // Walk the li in document order, accumulating text, and stop as soon as
        // we hit a nested list, a link, or a non-text control. That way:
        //   <li>Physics <p><a>Full course</a></p>
        //       <p>Problems solutions: <a>Sol #1</a>, <a>Sol #2</a>…</p></li>
        //     → "Physics"
        //   <li>foofoofoo <ul>…</ul></li>  → "foofoofoo"
        //   <li><a>hahaha</a></li>          → ""      (falls through to ancestor)
        const STOP = /^(A|UL|OL|BUTTON|IMG|TABLE|PRE)$/i;
        let out = '';
        let stopped = false;

        (function walk(node) {
            if (stopped) return;
            for (const child of node.childNodes) {
                if (stopped) return;
                if (child.nodeType === Node.TEXT_NODE) {
                    out += child.textContent;
                } else if (child.nodeType === Node.ELEMENT_NODE) {
                    if (STOP.test(child.tagName)) { stopped = true; return; }
                    walk(child); // recurse into inline (em, strong, code, span, …) and <p>
                }
            }
        })(li);

        return out.replace(/\s+/g, ' ').trim();
    }

    function findPageAnchor(url) {
        const anchors = document.querySelectorAll('a[href]');
        for (const a of anchors) {
            if (a.closest('.recent-pages')) continue;
            const href = a.getAttribute('href');
            if (!href || href.startsWith('#')) continue;
            try {
                const u = new URL(a.href, location.href);
                u.hash = '';
                if (u.href === url) return a;
            } catch (_) { /* ignore */ }
        }
        return null;
    }

    /**
     * Prefix shown before " -- ".
     * For:
     *   * barbarbar
     *       * foofoofoo
     *           [hahaha](./hahaha.html)
     *           * [fafafa](./fafafa.html)
     *   both hahaha and fafafa get "foofoofoo".
     */
    function containsNestedKeyword(text) {
        if (!text) return false;
        const lower = text.toLowerCase();
        return NESTED_KEYWORDS.some(kw => kw && lower.includes(String(kw).toLowerCase()));
    }

    function getPrefix(a) {
        const li = a.closest('li');
        if (!li) return '';

        // 1) Find the nearest ancestor <li> that actually has a label.
        //    (Same behaviour as before: the `<li>` that owns the link, or the
        //    first <li> above it that carries own text.)
        let cursor = li;
        let prefix = listItemLabel(cursor);
        while (!prefix) {
            const pli = cursor.parentElement && cursor.parentElement.closest('li');
            if (!pli) return '';
            cursor = pli;
            prefix = listItemLabel(cursor);
        }

        // 2) While the accumulated prefix contains the marker, prepend the
        //    next ancestor’s label. Examples:
        //        barbarbar
        //            keyword foofoofoo
        //                [hahaha](…)         → "barbarbar -- keyword foofoofoo"
        //    Stops when the prefix no longer contains the marker or when we
        //    run out of ancestors.
        while (containsNestedKeyword(prefix)) {
            const pli = cursor.parentElement && cursor.parentElement.closest('li');
            if (!pli) break;
            const label = listItemLabel(pli);
            if (label) prefix = label + ' -- ' + prefix;
            cursor = pli; // always move up so we can’t loop
        }

        return prefix;
    }

    function resyncTitles() {
        const list = readList();
        let changed = false;

        for (const item of list) {
            const anchor = findPageAnchor(item.url);
            if (!anchor) continue;

            const prefix = getPrefix(anchor);

            // Keep the h2 / link-text tail from the stored title.
            const sep = item.title.lastIndexOf(' -- ');
            let tail = sep >= 0 ? item.title.slice(sep + 4) : item.title;

            // For PDFs and superconspect pages the tail *is* the link text,
            // so we can refresh it from the current anchor.
            if (isPdfUrl(item.url) || isSuperconspect(item.url)) {
                const lt = (anchor.textContent || '').replace(/\s+/g, ' ').trim();
                if (lt) tail = lt;
            }

            const newTitle = prefix ? prefix + ' -- ' + tail : tail;
            if (newTitle !== item.title) {
                item.title = newTitle;
                changed = true;
            }
        }

        if (changed) writeList(list);
    }

    /* ========================= page-visit recording ===================== */

    function handlePageLoad() {
        const url = normalizeUrl(location.href);
        const list = readList();
        const idx = list.findIndex(p => p.url === url);

        if (idx >= 0) {
            // Page already known (usually stored by click). Complete pending h2
            // resolution, then bump to top preserving the stored title.
            const entry = list[idx];
            if (entry.pending) {
                const h2 = getH2();
                if (h2) entry.title = entry.prefix ? entry.prefix + ' -- ' + h2 : h2;
                delete entry.pending;
                delete entry.prefix;
            }
            entry.ts = Date.now();
            list.splice(idx, 1);
            list.unshift(entry);
        } else {
            // Direct visit (bookmark, typed URL, external link) — no prefix available.
            const title = isSuperconspect(url)
                ? (document.title || '').replace(/\s+/g, ' ').trim()
                : (getH2() || (document.title || '').replace(/\s+/g, ' ').trim());
            if (title) list.unshift({ url, title, ts: Date.now() });
        }

        writeList(list);
    }

    function handleLinkClick(event) {
        if (event.button !== 0 || event.defaultPrevented) return;
        const target = event.target;
        if (!target || !target.closest) return;

        const a = target.closest('a[href]');
        if (!a) return;

        // Links inside the widget already carry a complete stored title.
        // Let them navigate normally and don't try to derive a new prefix —
        // otherwise the "×" remove button gets picked up as the list-item text.
        if (a.closest('.recent-pages')) {
            const href = a.getAttribute('href');
            if (!href || href.startsWith('#')) return;

            let url;
            try {
                const u = new URL(a.href, location.href);
                if (u.origin !== location.origin) return;
                u.hash = '';
                url = u.href;
            } catch (_) { return; }

            if (url === normalizeUrl(location.href)) return;
            if (!isRecordableUrl(url)) return;

            const pageAnchor = findPageAnchor(url);
            if (!pageAnchor) {
                const existing = readList().find(p => p.url === url);
                if (existing) upsert(url, { title: existing.title });
                return;
            }

            const prefix = getPrefix(pageAnchor);
            const linkText = (pageAnchor.textContent || '').replace(/\s+/g, ' ').trim();
            const fallback = prefix ? prefix + ' -- ' + linkText : linkText;

            if (isPdfUrl(url) || isSuperconspect(url)) {
                upsert(url, { title: fallback, prefix });
            } else {
                upsert(url, { title: fallback, prefix, pending: true });
            }
            return; // let navigation proceed
        }

        const href = a.getAttribute('href');
        if (!href || href.startsWith('#')) return;

        let url;
        try {
            const u = new URL(a.href, location.href);
            if (u.origin !== location.origin) return;
            u.hash = '';
            url = u.href;
        } catch (_) { return; }

        if (url === normalizeUrl(location.href)) return;
        if (!isRecordableUrl(url)) return;

        const prefix = getPrefix(a);
        const linkText = (a.textContent || '').replace(/\s+/g, ' ').trim();
        const fallback = prefix ? prefix + ' -- ' + linkText : linkText;

        if (isPdfUrl(url) || isSuperconspect(url)) {
            upsert(url, { title: fallback, prefix });
        } else {
            upsert(url, { title: fallback, prefix, pending: true });
        }
    }

    /* Mark .pdf links so the script is known to have handled them. */
    function markPdfLinks(root) {
        (root || document).querySelectorAll('a[href]').forEach(function (a) {
            const href = a.getAttribute('href');
            if (!href) return;
            try {
                if (/\.pdf$/i.test(new URL(href, location.href).pathname)) {
                    a.setAttribute('data-rv-pdf', '');
                }
            } catch (_) { }
        });
    }

    /* ============================ the block ============================= */

    function findPlaceholder() {
        const root = document.body || document.documentElement;
        const walker = document.createTreeWalker(root, NodeFilter.SHOW_COMMENT);
        let node;
        while ((node = walker.nextNode())) {
            if ((node.nodeValue || '').trim() === PLACEHOLDER) return node;
        }
        return null;
    }

    function weightedRandom(elements, chances) {
        if (elements.length !== chances.length) {
            throw new Error('elements and chances must have the same length');
        }
        if (elements.length === 0) {
            throw new Error('arrays must not be empty');
        }

        const total = chances.reduce((sum, c) => sum + c, 0);
        if (total <= 0) {
            throw new Error('sum of chances must be greater than 0');
        }

        let r = Math.random() * total;

        for (let i = 0; i < elements.length; i++) {
            r -= chances[i];
            if (r < 0) return elements[i];
        }

        return elements[elements.length - 1];
    }

    function mountBlock(placeholder) {
        const section = document.createElement('section');
        section.className = 'recent-pages';

        const header = document.createElement('div');
        header.className = 'recent-pages__header';

        const title = document.createElement('span');
        title.className = 'recent-pages__title';
        title.textContent = RECENTLY_VISITED_HEADER_TEXT;

        const toggle = document.createElement('button');
        toggle.type = 'button';
        toggle.className = 'recent-pages__toggle';

        header.appendChild(title);
        header.appendChild(toggle);

        const list = document.createElement('ul');
        list.className = 'recent-pages__list';

        const empty = document.createElement('p');
        empty.className = 'recent-pages__empty';
        empty.innerHTML = weightedRandom(NOTHING_HERE_YET_TEXTS, NOTHING_HERE_YET_CHANCES);

        section.appendChild(header);
        section.appendChild(list);
        section.appendChild(empty);

        placeholder.parentNode.replaceChild(section, placeholder);

        let collapsed = false;
        try { collapsed = localStorage.getItem(COLLAPSED_KEY) === '1'; } catch (_) { }

        function applyCollapsed() {
            section.classList.toggle('recent-pages--collapsed', collapsed);
            toggle.textContent = collapsed ? SHOW_BUTTON_TEXT : HIDE_BUTTON_TEXT;
            toggle.setAttribute('aria-expanded', String(!collapsed));
        }

        toggle.addEventListener('click', function () {
            collapsed = !collapsed;
            try { localStorage.setItem(COLLAPSED_KEY, collapsed ? '1' : '0'); } catch (_) { }
            applyCollapsed();
        });

        function render() {
            const items = readList().slice(0, MAX_ITEMS);
            list.textContent = '';

            items.forEach(function (item) {
                const li = document.createElement('li');
                li.className = 'recent-pages__item';

                const link = document.createElement('a');
                link.className = 'recent-pages__link';
                link.href = item.url;
                link.textContent = item.title;
                link.title = item.title;

                const remove = document.createElement('button');
                remove.type = 'button';
                remove.className = 'recent-pages__remove';
                remove.textContent = '\u00d7';
                remove.title = REMOVE_BUTTON_TEXT;
                remove.setAttribute('aria-label', REMOVE_BUTTON_TEXT + ' "' + item.title + '" ' + REMOVE_BUTTON_CONT_TEXT);
                remove.addEventListener('click', function (e) {
                    e.preventDefault();
                    e.stopPropagation();
                    forgetPage(item.url);
                    render();
                });

                li.appendChild(link);
                li.appendChild(remove);
                list.appendChild(li);
            });

            const isEmpty = items.length === 0;
            list.hidden = isEmpty;
            empty.hidden = !isEmpty;
        }

        resyncTitles();
        applyCollapsed();
        render();

        const catEl = document.getElementById("cat-emoji");

        if (catEl)
            catEl.addEventListener("click", function () {
                const span = document.createElement('span');
                span.textContent = ' -- Мяу!';
                span.style.display = 'inline';

                catEl.insertAdjacentElement('afterend', span);
            });

        window.addEventListener('pageshow', render);
    }

    /* ============================== init ================================ */

    function init() {
        const placeholder = findPlaceholder();

        if (placeholder) {
            // main page → render the widget, do not record the main page itself
            mountBlock(placeholder);
            window.addEventListener('pageshow', function () {
                resyncTitles();
                render();
            });
        } else {
            // any other page → remember it
            handlePageLoad();
        }

        markPdfLinks(document);
        document.addEventListener('click', handleLinkClick);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();