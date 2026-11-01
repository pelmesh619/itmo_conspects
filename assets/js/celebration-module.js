function reverseString(str) {
    return Array.from(str).reverse().join('');
}

function getEasterDate(year) {
    const a = year % 4;
    const b = year % 7;
    const c = year % 19;
    const d = (19 * c + 15) % 30;
    const e = (2 * a + 4 * b - d + 34) % 7;
    const monthJul = Math.floor((d + e + 114) / 31);
    const dayJul = ((d + e + 114) % 31) + 1;

    const shift = Math.floor(year / 100) - Math.floor(year / 400) - 2;

    const julianMonthIndex = monthJul - 1;
    const msPerDay = 24 * 60 * 60 * 1000;
    const julianUtc = Date.UTC(year, julianMonthIndex, dayJul);
    const gregorianUtcMs = julianUtc + shift * msPerDay;

    return new Date(gregorianUtcMs);
}

function getCurrentDate() {
    return new Date();
}

function getDate() {
    return getCurrentDate();
}

function resetCelebrationSetup() {
    document.querySelectorAll('h1, h2, h3, h4, h5, h6').forEach(el => {
        el.style.direction = 'ltr';
        el.style.unicodeBidi = 'bidi-override';
    });

    if (document.stopSnowflakesAnimation)
        document.setSnowflakesAnimation(false, false);
    const snowCanvas = document.getElementById('snow-canvas');
    if (snowCanvas)
        snowCanvas.style.display = "none";

    const snowflakesAnimationToggleButton = document.getElementById('snowflakes-animation-toggle');
    if (snowflakesAnimationToggleButton)
        snowflakesAnimationToggleButton.style.display = "none";

    const style = document.getElementById('celebration-style');
    if (style)
        style.textContent = `
            h1:first-of-type::before { content: ""; }
            h1:first-of-type::after { content: ""; }
            `;
}

function reloadCelebration() {
    const now = getDate();
    const month = now.getMonth() + 1;
    const day = now.getDate();
    const year = now.getFullYear();

    resetCelebrationSetup();

    let emoji = '';

    if (month === 4 && day === 1) {
        document.querySelectorAll('h1, h2, h3, h4, h5, h6').forEach(el => {
            el.style.direction = 'rtl';
            el.style.unicodeBidi = 'bidi-override';
        });

        emoji = "🤪";
    }

    const h1 = document.querySelector('h1');
    if (!h1) return;

    if (month === 7 || month === 8) {
        emoji = '☀️';
    }
    else if (month === 10 && day >= 25 && day <= 31) {
        emoji = '🎃';
    }
    else if (month === 2 && day === 29) {
        emoji = '🍀';
    }
    else if ((month === 12 && day >= 24) || (month === 1 && day <= 7)) {
        const newYearEmojis = ["🎄", "🎅", "❄️", "⛄"];
        emoji = newYearEmojis[Math.floor(Math.random() * newYearEmojis.length)];
        showSnowCanvas();
    }
    else {
        const easter = getEasterDate(year);
        const diffDays = Math.floor((now - easter) / (1000 * 60 * 60 * 24));
        if (-3 <= diffDays && diffDays <= 0) {
            emoji = '🥚';
        }
    }

    if (emoji) {
        const style = document.getElementById('celebration-style')
            || (function () {
                let style = document.createElement('style');
                style.id = "celebration-style";
                document.head.appendChild(style);
                return style;
            })();

        style.textContent = `
            h1:first-of-type::before {
                content: "${emoji} ";
            }
            h1:first-of-type::after {
                content: " ${emoji}";
            }
            `;
    }
}

function showSnowCanvas() {
    if (document.getElementById('snow-canvas')) {  // already initialised
        document.getElementById('snow-canvas').style.display = "block";

        const snowflakesAnimationToggleButton = document.getElementById('snowflakes-animation-toggle');
        if (snowflakesAnimationToggleButton)
            snowflakesAnimationToggleButton.style.display = "block";

        document.setSnowflakesAnimation(localStorage.getItem('snowflakes-animation') === "true");
        return;
    }

    const canvas = document.createElement('canvas');
    canvas.id = 'snow-canvas';
    document.body.appendChild(canvas);

    let themeButtonsContainer = document.querySelector('.theme-buttons-container');
    if (!themeButtonsContainer) {
        themeButtonsContainer = document.createElement('div');
        themeButtonsContainer.classList.add('theme-buttons-container');
        document.body.appendChild(themeButtonsContainer);
    }

    const button = document.createElement('button');
    button.id = 'snowflakes-animation-toggle';
    button.classList.add('snowflakes-animation-toggle-btn');
    button.setAttribute('aria-pressed', 'true');
    themeButtonsContainer.appendChild(button);

    const ctx = canvas.getContext('2d');

    let width, height;
    let flakes = [];
    let flakeColor = '#ffffff';

    function readColor() {
        const c = getComputedStyle(document.documentElement)
            .getPropertyValue('--snow-color')
            .trim();
        if (c) flakeColor = c;
    }

    const FLAKES_PER_MPX = 250;
    const MIN_FLAKES = 40;
    const MAX_FLAKES = 500;

    function targetCount() {
        const areaMpx = (width * height) / 1_000_000;
        const n = Math.round(areaMpx * FLAKES_PER_MPX);
        return Math.min(MAX_FLAKES, Math.max(MIN_FLAKES, n));
    }

    function syncFlakeCount() {
        const n = targetCount();
        while (flakes.length < n) flakes.push(createFlake(true));
        if (flakes.length > n) flakes.length = n;
    }

    function resize() {
        const dpr = window.devicePixelRatio || 1;
        width = window.innerWidth;
        height = window.innerHeight * 4 / 5;

        canvas.width = width * dpr;
        canvas.height = height * dpr;
        canvas.style.height = height + 'px';

        ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        readColor();
        syncFlakeCount();
    }

    function watchTheme() {
        const opts = { attributes: true, attributeFilter: ['class', 'data-theme', 'style'] };
        new MutationObserver(readColor).observe(document.documentElement, opts);
        new MutationObserver(readColor).observe(document.body, opts);
        window.matchMedia('(prefers-color-scheme: dark)')
            .addEventListener('change', readColor);
    }

    function createFlake(randomY) {
        return {
            x: Math.random() * width,
            y: randomY ? Math.random() * height : -10 - Math.random() * 30,
            radius: 1 + Math.random() * 2.5,
            speed: 0.2 + Math.random() * 0.8,
            drift: (Math.random() - 0.5) * 0.5,
            phase: Math.random() * Math.PI * 2,
            sway: 0.01 + Math.random() * 0.02
        };
    }

    function init() {
        flakes = [];
        resize();
    }

    // --- run state ------------------------------------------------------
    let running = false;
    let rafId = null;
    let last = performance.now();

    function loop(now) {
        if (!running) return;

        const dt = Math.min((now - last) / 16.667, 3);
        last = now;

        ctx.clearRect(0, 0, width, height);
        ctx.fillStyle = flakeColor;

        for (const f of flakes) {
            f.phase += f.sway * dt;
            f.y += f.speed * dt;
            f.x += f.drift * dt + Math.sin(f.phase) * 0.4;

            if (f.y >= height || f.x < -20 || f.x > width + 20) {
                Object.assign(f, createFlake(false));
                continue;
            }

            ctx.globalAlpha = Math.max(0, 1 - f.y / height);
            ctx.beginPath();
            ctx.arc(f.x, f.y, f.radius, 0, Math.PI * 2);
            ctx.fill();
        }

        ctx.globalAlpha = 1;
        rafId = requestAnimationFrame(loop);
    }

    function start() {
        if (running) return;
        running = true;
        last = performance.now();     // avoid a dt spike after the pause
        rafId = requestAnimationFrame(loop);
    }

    function stop() {
        if (!running) return;
        running = false;
        if (rafId !== null) cancelAnimationFrame(rafId);
        rafId = null;
        ctx.clearRect(0, 0, width, height);
        ctx.globalAlpha = 1;
    }

    function setRunning(on, savePreference = true) {
        if (savePreference)
            localStorage.setItem('snowflakes-animation', on);
        on ? start() : stop();

        button.setAttribute('aria-pressed', String(on));
        const label = on
            ? 'Отключить анимацию снежинок'
            : 'Включить анимацию снежинок';
        button.setAttribute('aria-label', label);
        button.setAttribute('title', label);
        button.innerText = on ? '❄️ Отключить анимацию' : '❄️ Включить анимацию';
    }

    document.setSnowflakesAnimation = setRunning;
    // --------------------------------------------------------------------

    button.addEventListener('click', () => setRunning(!running));

    window.addEventListener('resize', resize);
    init();
    watchTheme();

    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    setRunning(!reduceMotion);
}

document.addEventListener('DOMContentLoaded', reloadCelebration);

