document.addEventListener('keydown', (e) => {
    const target = e.target;

    if (
        target instanceof Element &&
        target.closest('input, textarea, select, [contenteditable="true"]')
    ) {
        return;
    }

    // Shift + D
    if (
        e.shiftKey &&
        !e.ctrlKey &&
        !e.metaKey &&
        !e.altKey &&
        e.key.toLowerCase() === 'd'
    ) {
        e.preventDefault();
        if (window.themeSwitcher) {
            window.themeSwitcher.toggle();
        }
    }
});