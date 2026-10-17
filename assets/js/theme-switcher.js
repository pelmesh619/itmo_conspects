/**
 * Theme Switcher
 * Handles light/dark mode toggling with localStorage persistence
 */

class ThemeSwitcher {
  constructor() {
    this.htmlElement = document.documentElement;
    this.toggleButton = null;
    this.prefersDark = window.matchMedia('(prefers-color-scheme: dark)');

    this.init();
  }

  init() {
    // Restore saved theme or use system preference
    this.loadTheme();

    // Set up toggle button
    this.setupToggleButton();

    // Listen for system preference changes
    this.prefersDark.addEventListener('change', (e) => this.handleSystemPreferenceChange(e));
  }

  /**
   * Load theme from localStorage or system preference
   */
  loadTheme() {
    const savedTheme = localStorage.getItem('theme');

    if (savedTheme) {
      this.setTheme(savedTheme);
    } else if (this.prefersDark.matches) {
      this.setTheme('dark');
    } else {
      this.setTheme('light');
    }
  }

  /**
   * Set theme and update UI
   */
  setTheme(theme) {
    if (theme === 'auto') {
      this.htmlElement.removeAttribute('data-theme');
      localStorage.removeItem('theme');
      return;
    }

    this.htmlElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
    this.updateToggleButton();
  }

  /**
   * Toggle between light and dark themes
   */
  toggle() {
    const currentTheme = this.htmlElement.getAttribute('data-theme') || 'light';
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    this.setTheme(newTheme);
  }

  /**
   * Set up the toggle button in the DOM
   */
  setupToggleButton() {
    this.toggleButton = document.getElementById('theme-toggle');

    if (this.toggleButton) {
      this.toggleButton.addEventListener('click', () => this.toggle());
      this.updateToggleButton();
    }
  }

  /**
   * Update toggle button appearance and text
   */
  updateToggleButton() {
    if (!this.toggleButton) return;

    const currentTheme = this.htmlElement.getAttribute('data-theme') || 'light';

    if (currentTheme === 'dark') {
      this.toggleButton.innerHTML = '☀️ Светлая тема <code class="theme-switch-shortcut-hint">Shift+D</code>';
      this.toggleButton.setAttribute('aria-label', 'Переключиться на светлую тему');
      this.toggleButton.setAttribute('title', 'Переключиться на светлую тему (Shift+D)');
      this.toggleButton.classList.add('dark-mode');
    } else {
      this.toggleButton.innerHTML = '🌙 Тёмная тема <code class="theme-switch-shortcut-hint">Shift+D</code>';
      this.toggleButton.setAttribute('aria-label', 'Переключиться на тёмную тему');
      this.toggleButton.setAttribute('title', 'Переключиться на тёмную тему (Shift+D)');
      this.toggleButton.classList.remove('dark-mode');
    }
  }

  /**
   * Handle system preference changes
   */
  handleSystemPreferenceChange(e) {
    const savedTheme = localStorage.getItem('theme');

    // Only auto-switch if user hasn't explicitly set a theme
    if (!savedTheme) {
      if (e.matches) {
        this.setTheme('dark');
      } else {
        this.setTheme('light');
      }
    }
  }

  /**
   * Get current theme
   */
  getCurrentTheme() {
    return this.htmlElement.getAttribute('data-theme') || 'light';
  }
}


const button = document.createElement("button");
button.id = "theme-toggle";
button.classList.add("theme-toggle-btn");
button.setAttribute("aria-keyshortcuts", "Shift+D");
button.setAttribute('aria-label', 'Включить тёмную тему');
button.setAttribute('title', 'Включить тёмную тему (Shift+D)');
button.innerText = '🌙 Тёмная тема <code class="theme-switch-shortcut-hint">Shift+D</code>';

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => {
    document.documentElement.appendChild(button);
    window.themeSwitcher = new ThemeSwitcher();
  });
} else {
  document.documentElement.appendChild(button);
  window.themeSwitcher = new ThemeSwitcher();
}