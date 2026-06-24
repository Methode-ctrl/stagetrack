/* ============================================================
   STAGETRACK – utils.js
   Fonctions utilitaires (vanilla JS)
   ============================================================ */

(function () {
  'use strict';

  // Formater une date ISO en français
  window.formatDate = function (isoStr) {
    if (!isoStr) return '–';
    return new Date(isoStr).toLocaleDateString('fr-FR', { day: '2-digit', month: 'long', year: 'numeric' });
  };

  // Afficher un overlay de chargement
  window.showLoading = function () {
    if (document.getElementById('loadingOverlay')) return;
    const overlay = document.createElement('div');
    overlay.id = 'loadingOverlay';
    overlay.className = 'loading-overlay';
    overlay.innerHTML = '<div class="spinner"></div>';
    document.body.appendChild(overlay);
  };

  window.hideLoading = function () {
    const overlay = document.getElementById('loadingOverlay');
    if (overlay) overlay.remove();
  };

  // Afficher une alerte temporaire
  window.showAlert = function (message, type = 'info', duration = 4000) {
    const alert = document.createElement('div');
    alert.className = 'alert alert-' + type;
    alert.style.cssText = 'position:fixed;top:80px;right:1rem;z-index:9998;max-width:360px;animation:fadeInRight 0.3s ease';
    alert.textContent = message;
    document.body.appendChild(alert);
    setTimeout(() => {
      alert.style.opacity = '0';
      alert.style.transition = 'opacity 0.3s ease';
      setTimeout(() => alert.remove(), 300);
    }, duration);
  };

  // Debounce
  window.debounce = function (fn, delay) {
    let timer;
    return function (...args) {
      clearTimeout(timer);
      timer = setTimeout(() => fn.apply(this, args), delay);
    };
  };

  // Throttle
  window.throttle = function (fn, limit) {
    let last = 0;
    return function (...args) {
      const now = Date.now();
      if (now - last >= limit) { last = now; fn.apply(this, args); }
    };
  };

  // Confirmation avant suppression
  document.querySelectorAll('[data-confirm]').forEach(el => {
    el.addEventListener('click', function (e) {
      if (!confirm(this.dataset.confirm || 'Confirmer cette action ?')) e.preventDefault();
    });
  });

  // Auto-dismiss des alertes après 5s
  document.querySelectorAll('.alert').forEach(alert => {
    setTimeout(() => {
      alert.style.opacity = '0';
      alert.style.transition = 'opacity 0.4s ease';
      setTimeout(() => alert.remove(), 400);
    }, 5000);
  });

})();
