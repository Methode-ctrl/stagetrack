/* ============================================================
   STAGETRACK – navbar.js
   Logique menu navigation (vanilla JS)
   ============================================================ */

(function () {
  'use strict';

  const toggle   = document.getElementById('navbarToggle');
  const menu     = document.getElementById('navbarMenu');
  const navbar   = document.querySelector('.navbar');

  // 1. Hamburger toggle (mobile)
  if (toggle && menu) {
    toggle.addEventListener('click', () => {
      const isOpen = menu.classList.toggle('is-open');
      toggle.classList.toggle('is-active');
      toggle.setAttribute('aria-expanded', isOpen);
    });
  }

  // 2. Navbar glassmorphism au scroll
  if (navbar) {
    window.addEventListener('scroll', () => {
      navbar.classList.toggle('navbar-scrolled', window.scrollY > 20);
    }, { passive: true });
  }

  // 3. Lien actif selon l'URL courante
  document.querySelectorAll('.nav-link').forEach(link => {
    const href = link.getAttribute('href');
    if (href && href !== '#' && window.location.pathname.includes(href.split('?')[0])) {
      link.classList.add('active');
    }
  });

  // 4. Dropdown au hover (desktop)
  document.querySelectorAll('.has-dropdown').forEach(item => {
    const dd = item.querySelector('.dropdown-menu');
    if (!dd) return;
    item.addEventListener('mouseenter', () => dd.classList.add('is-visible'));
    item.addEventListener('mouseleave', () => dd.classList.remove('is-visible'));
  });

  // 4b. Dropdown au clic (mobile)
  document.querySelectorAll('.nav-link-dropdown').forEach(link => {
    link.addEventListener('click', e => {
      if (window.innerWidth <= 768) {
        e.preventDefault();
        link.closest('.has-dropdown').classList.toggle('is-open');
      }
    });
  });

  // 5. Fermer menu mobile si clic sur un lien
  document.querySelectorAll('.nav-link:not(.nav-link-dropdown)').forEach(link => {
    link.addEventListener('click', () => {
      if (menu) menu.classList.remove('is-open');
      if (toggle) { toggle.classList.remove('is-active'); toggle.setAttribute('aria-expanded', 'false'); }
    });
  });

  // 6. Fermer menu si clic en dehors
  document.addEventListener('click', e => {
    if (menu && toggle && !navbar.contains(e.target)) {
      menu.classList.remove('is-open');
      toggle.classList.remove('is-active');
      toggle.setAttribute('aria-expanded', 'false');
    }
  });

})();
