/* ============================================================
   STAGETRACK — THEME.JS
   Bascule mode sombre / clair (persisté dans localStorage)
   ============================================================ */
(function () {
  'use strict';

  var STORAGE_KEY = 'stagetrack-theme';

  var ICON_SUN = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>';
  var ICON_MOON = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8z"/></svg>';

  function readStored() {
    try {
      return localStorage.getItem(STORAGE_KEY);
    } catch (e) {
      return null;
    }
  }

  function writeStored(theme) {
    try {
      localStorage.setItem(STORAGE_KEY, theme);
    } catch (e) { /* stockage indisponible : on ignore */ }
  }

  function getInitialTheme() {
    var stored = readStored();
    if (stored === 'dark' || stored === 'light') {
      return stored;
    }
    return 'dark';
  }

  var currentTheme = getInitialTheme();

  function syncToggleIcons() {
    var isDark = currentTheme === 'dark';
    var labels = document.querySelectorAll('.theme-toggle');
    for (var i = 0; i < labels.length; i++) {
      labels[i].innerHTML = isDark ? ICON_SUN : ICON_MOON;
      labels[i].title = isDark ? 'Passer au mode clair' : 'Passer au mode sombre';
      labels[i].setAttribute('aria-label', labels[i].title);
    }
  }

  function setTheme(theme) {
    currentTheme = theme === 'light' ? 'light' : 'dark';
    document.documentElement.setAttribute('data-theme', currentTheme);
    writeStored(currentTheme);
    syncToggleIcons();
  }

  function buildToggle() {
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'theme-toggle';
    btn.setAttribute('aria-label', 'Changer de thème');
    btn.addEventListener('click', function () {
      setTheme(currentTheme === 'dark' ? 'light' : 'dark');
    });
    return btn;
  }

  function placeToggles() {
    var topbars = document.querySelectorAll('.topbar');
    if (topbars.length > 0) {
      for (var i = 0; i < topbars.length; i++) {
        topbars[i].appendChild(buildToggle());
      }
      return;
    }

    var actionBars = document.querySelectorAll('.topbar-actions');
    if (actionBars.length > 0) {
      for (var j = 0; j < actionBars.length; j++) {
        actionBars[j].insertBefore(buildToggle(), actionBars[j].firstChild);
      }
      return;
    }

    var floating = buildToggle();
    floating.classList.add('theme-toggle--floating');
    document.body.appendChild(floating);
  }

  document.documentElement.setAttribute('data-theme', currentTheme);

  function init() {
    if (document.body) {
      placeToggles();
      syncToggleIcons();
      return;
    }
    document.addEventListener('DOMContentLoaded', function () {
      placeToggles();
      syncToggleIcons();
    });
  }

  if (document.readyState === 'loading' && !document.body) {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();