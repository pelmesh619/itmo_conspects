document.addEventListener('keydown', (e) => {
  // Cmd/Ctrl + Shift + L for light/dark toggle
  if ((e.metaKey || e.ctrlKey) && e.shiftKey && e.key === 'L') {
    e.preventDefault();
    if (window.themeSwitcher) {
      window.themeSwitcher.toggle();
    }
  }
});