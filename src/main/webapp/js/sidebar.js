/* ============================================================
   STAGETRACK – sidebar.js
   Sidebar toggle, active links, dropdown, logout confirm
   ============================================================ */

(function () {
  'use strict';

  const sidebar     = document.querySelector('.sidebar');
  const toggleBtn   = document.querySelector('.sidebar-toggle');
  const navLinks    = document.querySelectorAll('.nav-link');
  const STORAGE_KEY = 'stagetrack-sidebar-collapsed';

  if (!sidebar) return;

  function restoreState() {
    if (localStorage.getItem(STORAGE_KEY) === 'true') {
      sidebar.classList.add('collapsed');
      document.body.classList.add('sidebar-collapsed');
    }
  }

  if (toggleBtn) {
    toggleBtn.addEventListener('click', function (e) {
      e.preventDefault();
      e.stopPropagation();
      const collapsed = sidebar.classList.toggle('collapsed');
      document.body.classList.toggle('sidebar-collapsed', collapsed);
      localStorage.setItem(STORAGE_KEY, collapsed ? 'true' : 'false');
      window.dispatchEvent(new CustomEvent('sidebar:toggled', { detail: { collapsed } }));
    });
  }

  function markActive() {
    const path = window.location.pathname;
    navLinks.forEach(function (link) {
      link.classList.remove('active');
      const href = link.getAttribute('href');
      if (href && href !== '#') {
        const linkPath = href.split('?')[0];
        if (path.includes(linkPath) || path.endsWith(linkPath)) {
          link.classList.add('active');
        }
      }
    });
  }

  document.querySelectorAll('.has-dropdown').forEach(function (item) {
    const trigger = item.querySelector('.nav-link-dropdown');
    const menu    = item.querySelector('.dropdown-menu');
    const arrow   = item.querySelector('.nav-arrow');
    if (!trigger || !menu) return;

    trigger.addEventListener('click', function (e) {
      e.preventDefault();
      const isOpen = item.classList.toggle('is-open');
      trigger.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
      if (arrow) arrow.style.transform = isOpen ? 'rotate(-180deg)' : 'rotate(0deg)';
    });

    menu.querySelectorAll('.dropdown-item').forEach(function (di) {
      const dHref = di.getAttribute('href');
      if (dHref && window.location.pathname.includes(dHref.split('?')[0])) {
        di.classList.add('active');
        item.classList.add('is-open');
        trigger.classList.add('active');
      }
      di.addEventListener('click', function () {
        sidebar.classList.remove('is-open');
      });
    });
  });

  navLinks.forEach(function (link) {
    link.addEventListener('mouseenter', function () {
      if (!sidebar.classList.contains('collapsed')) return;
      const label = this.querySelector('.nav-label');
      if (!label) return;
      const tip = document.createElement('div');
      tip.className = 'nav-tooltip';
      tip.textContent = label.textContent.trim();
      this.style.position = 'relative';
      this.appendChild(tip);
    });
    link.addEventListener('mouseleave', function () {
      const tip = this.querySelector('.nav-tooltip');
      if (tip) tip.remove();
    });
  });

  navLinks.forEach(function (link) {
    link.addEventListener('click', function () {
      if (window.innerWidth <= 900) {
        sidebar.classList.remove('is-open');
        const overlay = document.querySelector('.sidebar-overlay');
        if (overlay) overlay.classList.remove('active');
      }
    });
  });

  /* ── Logout confirmation ──────────────────────────────────── */
  const logoutBtn = document.querySelector('.logout-btn, [data-logout="true"]');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', function (e) {
      e.preventDefault();
      const logoutUrl = document.body.getAttribute('data-logout-url')
                     || this.getAttribute('href')
                     || '/login?action=logout';
      showLogoutModal(logoutUrl);
    });
  }

  function showLogoutModal(logoutUrl) {
    const old = document.getElementById('logout-modal-backdrop');
    if (old) old.remove();

    const backdrop = document.createElement('div');
    backdrop.id = 'logout-modal-backdrop';
    backdrop.className = 'modal-backdrop';
    backdrop.setAttribute('role', 'dialog');
    backdrop.setAttribute('aria-modal', 'true');
    backdrop.setAttribute('aria-labelledby', 'logout-modal-title');

    backdrop.innerHTML =
      '<div class="modal animate-scale-in" role="document">' +
        '<div class="modal-header">' +
          '<div class="modal-icon warning">🚪</div>' +
          '<div><div class="modal-title" id="logout-modal-title">Déconnexion</div></div>' +
        '</div>' +
        '<div class="modal-body">Êtes-vous sûr de vouloir vous déconnecter&nbsp;? Votre session sera fermée.</div>' +
        '<div class="modal-actions">' +
          '<button class="btn btn-secondary" id="logout-cancel">Annuler</button>' +
          '<a href="' + logoutUrl + '" class="btn btn-danger" id="logout-confirm">Se déconnecter</a>' +
        '</div>' +
      '</div>';

    document.body.appendChild(backdrop);

    const cancel = backdrop.querySelector('#logout-cancel');
    cancel.addEventListener('click', function () { backdrop.remove(); });
    backdrop.addEventListener('click', function (e) { if (e.target === backdrop) backdrop.remove(); });
    document.addEventListener('keydown', function onKey(e) {
      if (e.key === 'Escape') { backdrop.remove(); document.removeEventListener('keydown', onKey); }
    });
    cancel.focus();
  }

  /* ── Mobile hamburger ──────────────────────────────────────── */
  const hamburger = document.querySelector('.hamburger');
  if (hamburger) {
    hamburger.addEventListener('click', function () {
      this.classList.toggle('open');
      sidebar.classList.toggle('is-open');
      let overlay = document.querySelector('.sidebar-overlay');
      if (!overlay) {
        overlay = document.createElement('div');
        overlay.className = 'sidebar-overlay';
        document.body.appendChild(overlay);
        overlay.addEventListener('click', function () {
          sidebar.classList.remove('is-open');
          hamburger.classList.remove('open');
          overlay.classList.remove('active');
        });
      }
      overlay.classList.toggle('active');
    });
  }

  function init() { restoreState(); markActive(); }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();

})();
