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

    const julianMonthIndex = monthJul - 1; // JS: 0..11
    const msPerDay = 24 * 60 * 60 * 1000;
    const julianUtc = Date.UTC(year, julianMonthIndex, dayJul);
    const gregorianUtcMs = julianUtc + shift * msPerDay;

    return new Date(gregorianUtcMs);
}

document.addEventListener('DOMContentLoaded', function () {
    const now = new Date();
    const month = now.getMonth() + 1; // 1–12
    const day = now.getDate();
    const year = now.getFullYear();

    if (month === 4 && day === 1) {
        const headings = document.querySelectorAll('h1, h2, h3, h4, h5, h6');
        headings.forEach((heading, index) => {
            const originalText = heading.textContent.trim();
            if (originalText) {
                heading.textContent = reverseString(originalText);
            }
        });

        const firstH1 = document.querySelector('h1');
        if (firstH1) {
            let text = firstH1.textContent.trim();
            text = text.replace(/^[\u{1F000}-\u{1FFFF}]|[\u{1F000}-\u{1FFFF}]$/gu, '').trim();
            firstH1.textContent = `🤪 ${text} 🤪`;
        }

        return;
    }

    const h1 = document.querySelector('h1');
    if (!h1) return;

    let emoji = '';

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
        emoji = '🎄';
    }
    else {
        const easter = getEasterDate(year);
        const diffDays = Math.floor((now - easter) / (1000 * 60 * 60 * 24));
        if (-3 <= diffDays <= 0) {
            emoji = '🥚';
        }
    }

    if (emoji) {
        let text = h1.textContent.trim();
        text = text.replace(/^[\u{1F000}-\u{1FFFF}]|[\u{1F000}-\u{1FFFF}]$/gu, '').trim();
        h1.textContent = `${emoji} ${text} ${emoji}`;
    }
});

