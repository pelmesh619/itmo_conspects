window.addEventListener('load', () => {
    if (window.location.hash) {
        const target = document.querySelector(window.location.hash);
        if (target) {
            // Small timeout ensures the browser has finished layout calculations
            setTimeout(() => {
                target.scrollIntoView({ behavior: 'smooth' });
            }, 50);
        }
    }
});