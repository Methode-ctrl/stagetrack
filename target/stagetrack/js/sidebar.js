/* ============================================================
   STAGETRACK – sidebar.js
   Gestion du sidebar collapsible (toggle, persistance, etc)
   ============================================================ */

(function () {
  'use strict';

  const sidebar = document.querySelector('.sidebar');
  const toggleBtn = document.querySelector('.sidebar-toggle');
  const navLinks = document.querySelectorAll('.nav-link');
  const SIDEBAR_STATE_KEY = 'stagetrack-sidebar-collapsed';

  if (!sidebar) return;

  // ── 1. Restaurer l'état du sidebar depuis localStorage ────────
  function restoreSidebarState() {
    const isCollapsed = localStorage.getItem(SIDEBAR_STATE_KEY) === 'true';
    if (isCollapsed) {
      sidebar.classList.add('collapsed');
    }
  }

  // ── 2. Sauvegarder l'état du sidebar ────────────────────────
  function saveSidebarState(isCollapsed) {
    localStorage.setItem(SIDEBAR_STATE_KEY, isCollapsed ? 'true' : 'false');
  }

  // ── 3. Toggle du sidebar ────────────────────────────────────
  if (toggleBtn) {
    toggleBtn.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      
      const isCollapsed = sidebar.classList.toggle('collapsed');
      
      // Ajouter/retirer la classe au body pour animer le padding
      document.body.classList.toggle('sidebar-collapsed', isCollapsed);
      
      saveSidebarState(isCollapsed);

      // Dispatch custom event pour d'autres composants
      window.dispatchEvent(new CustomEvent('sidebar:toggled', {
        detail: { isCollapsed }
      }));
    });
  }

  // ── 4. Marquer le lien actif selon l'URL courante ────────────
  function setActiveLinkByUrl() {
    const currentPath = window.location.pathname;
    
    navLinks.forEach(link => {
      link.classList.remove('active');
      
      const href = link.getAttribute('href');
      if (href && href !== '#') {
        // Extraire le chemin sans les paramètres
        const linkPath = href.split('?')[0];
        
        // Vérifier si le chemin courant inclut le chemin du lien
        if (currentPath.includes(linkPath) || currentPath.endsWith(linkPath)) {
          link.classList.add('active');
        }
      }
    });
  }

  // ── 5. Gérer les dropdowns pour ADMIN/SUPERVISEUR ────────────
  document.querySelectorAll('.has-dropdown').forEach(item => {
    const link = item.querySelector('.nav-link-dropdown');
    const menu = item.querySelector('.dropdown-menu');
    
    if (!link || !menu) return;

    // Click pour mobile
    link.addEventListener('click', (e) => {
      if (window.innerWidth <= 768) {
        e.preventDefault();
        item.classList.toggle('is-open');
        menu.classList.toggle('is-visible');
      }
    });

    // Hover pour desktop
    if (window.innerWidth > 768) {
      item.addEventListener('mouseenter', () => {
        menu.classList.add('is-visible');
      });
      item.addEventListener('mouseleave', () => {
        menu.classList.remove('is-visible');
      });
    }
  });

  // ── 6. Dropdown : marquer l'item actif ──────────────────────
  document.querySelectorAll('.dropdown-item').forEach(item => {
    const href = item.getAttribute('href');
    const currentPath = window.location.pathname;
    
    if (href && currentPath.includes(href.split('?')[0])) {
      item.classList.add('active');
      item.closest('.has-dropdown').querySelector('.nav-link-dropdown').classList.add('active');
    }
  });

  // ── 7. Tooltips au hover pour collapsed state ────────────────
  navLinks.forEach(link => {
    link.addEventListener('mouseenter', function () {
      if (sidebar.classList.contains('collapsed')) {
        const label = this.querySelector('.nav-label');
        if (label) {
          const tooltip = document.createElement('div');
          tooltip.className = 'nav-tooltip';
          tooltip.textContent = label.textContent;
          tooltip.style.cssText = `
            position: absolute;
            left: calc(100% + 0.75rem);
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.9);
            color: #64c8ff;
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            font-size: 0.8rem;
            white-space: nowrap;
            z-index: 1000;
            border: 1px solid rgba(100, 200, 255, 0.3);
            pointer-events: none;
            animation: tooltipSlideIn 0.2s ease-out;
          `;
          
          const style = document.createElement('style');
          if (!document.getElementById('tooltip-animation')) {
            style.id = 'tooltip-animation';
            style.textContent = `
              @keyframes tooltipSlideIn {
                from {
                  opacity: 0;
                  transform: translateY(-50%) translateX(-8px);
                }
                to {
                  opacity: 1;
                  transform: translateY(-50%) translateX(0);
                }
              }
            `;
            document.head.appendChild(style);
          }
          
          this.appendChild(tooltip);
        }
      }
    });

    link.addEventListener('mouseleave', function () {
      const tooltip = this.querySelector('.nav-tooltip');
      if (tooltip) {
        tooltip.remove();
      }
    });
  });

  // ── 8. Fermer le sidebar mobile au clic sur un lien ──────────
  if (window.innerWidth <= 768) {
    navLinks.forEach(link => {
      link.addEventListener('click', () => {
        sidebar.classList.remove('is-open');
      });
    });
  }

  // ── 9. Gestion du logout ────────────────────────────────────
  const logoutBtn = document.querySelector('.logout-btn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', (e) => {
      e.preventDefault();
      // Redirection vers logout via JSP ou API
      window.location.href = document.querySelector('body').getAttribute('data-logout-url') || '/logout';
    });
  }

  // ── 10. Initialisation ──────────────────────────────────────
  function init() {
    restoreSidebarState();
    setActiveLinkByUrl();
    
    // Appliquer la classe au body si le sidebar est collapsed
    if (sidebar.classList.contains('collapsed')) {
      document.body.classList.add('sidebar-collapsed');
    }
  }

  document.addEventListener('DOMContentLoaded', init);

  // Fallback si DOM déjà chargé
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

})();
