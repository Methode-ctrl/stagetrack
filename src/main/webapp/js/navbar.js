/* ============================================================
   STAGETRACK — NAVBAR.JS
   ============================================================ */
(function () {
  'use strict';

  /* ---------- 1. Hamburger mobile toggle ---------- */
  var hamburger = document.querySelector('.hamburger');
  var sidebar = document.getElementById('sidebar');
  var overlay = document.getElementById('navbarOverlay');

  function openMenu() {
    if (sidebar) {
      sidebar.classList.add('open');
    }
    if (overlay) {
      overlay.style.display = 'block';
    }
    document.body.style.overflow = 'hidden';
  }

  function closeMenu() {
    if (sidebar) {
      sidebar.classList.remove('open');
    }
    if (overlay) {
      overlay.style.display = 'none';
    }
    document.body.style.overflow = '';
  }

  if (hamburger) {
    hamburger.addEventListener('click', openMenu);
  }

  if (overlay) {
    overlay.addEventListener('click', closeMenu);
  }

  window.addEventListener('resize', function () {
    if (window.innerWidth > 768) {
      closeMenu();
    }
  });

  /* ---------- 2. Effet topbar au scroll ---------- */
  var topbar = document.querySelector('.topbar');

  function onScroll() {
    if (topbar) {
      if (window.scrollY > 10) {
        topbar.classList.add('scrolled');
      } else {
        topbar.classList.remove('scrolled');
      }
    }
  }

  window.addEventListener('scroll', onScroll);
  onScroll();

  /* ---------- 3. Lien actif selon l'URL courante ---------- */
  var curPath = window.location.pathname;
  var curSearch = window.location.search;

  document.querySelectorAll('.nav-link').forEach(function (link) {
    var linkPath = link.pathname;
    var linkSearch = link.search || '';

    if (linkPath !== curPath) {
      return;
    }

    if (!linkSearch || !curSearch) {
      link.classList.add('active');
      return;
    }

    var linkBase = linkSearch.toLowerCase().split('&')[0];
    var curBase = curSearch.toLowerCase().split('&')[0];
    if (linkBase === curBase) {
      link.classList.add('active');
    }
  });

  /* ---------- 4. Fermer le menu mobile au clic sur un lien ---------- */
  document.querySelectorAll('.nav-link, .nav-logout').forEach(function (link) {
    link.addEventListener('click', closeMenu);
  });
})();