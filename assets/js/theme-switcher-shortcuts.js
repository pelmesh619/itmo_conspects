document.addEventListener('keydown', (e) => {
  // Alt + N for light/dark toggle
  if (e.altKey && e.key === 'N') {
    e.preventDefault();
    if (window.themeSwitcher) {
      window.themeSwitcher.toggle();
    }
  }
});