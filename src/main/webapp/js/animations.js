/* ============================================================
   STAGETRACK – animations.js
   Animations au scroll, ripple, compteurs (vanilla JS)
   ============================================================ */

(function () {
  'use strict';

  // 1. Scroll reveal avec IntersectionObserver
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry, i) => {
      if (entry.isIntersecting) {
        const delay = entry.target.dataset.delay || (i * 80);
        setTimeout(() => entry.target.classList.add('animate-in'), delay);
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });

  document.querySelectorAll('.scroll-reveal, .card, .stat-card').forEach((el, i) => {
    el.classList.add('scroll-reveal');
    el.dataset.delay = i * 80;
    observer.observe(el);
  });

  // 2. Effet ripple sur les boutons
  document.querySelectorAll('.btn-primary, .btn-secondary, .btn-danger, .btn-success').forEach(btn => {
    btn.style.position = 'relative';
    btn.style.overflow = 'hidden';
    btn.addEventListener('click', function (e) {
      const rect   = this.getBoundingClientRect();
      const size   = Math.max(rect.width, rect.height);
      const x      = e.clientX - rect.left - size / 2;
      const y      = e.clientY - rect.top  - size / 2;
      const ripple = document.createElement('span');
      ripple.className = 'ripple-effect';
      Object.assign(ripple.style, {
        width: size + 'px', height: size + 'px',
        left: x + 'px', top: y + 'px',
        position: 'absolute', borderRadius: '50%',
        pointerEvents: 'none'
      });
      this.appendChild(ripple);
      setTimeout(() => ripple.remove(), 700);
    });
  });

  // 3. Compteur animé pour les stat-cards
  function animateCounter(el) {
    const target = parseInt(el.textContent, 10);
    if (isNaN(target) || target === 0) return;
    const duration = 1200;
    const start    = performance.now();
    const update   = (now) => {
      const progress = Math.min((now - start) / duration, 1);
      const ease     = 1 - Math.pow(1 - progress, 3);
      el.textContent = Math.round(ease * target);
      if (progress < 1) requestAnimationFrame(update);
    };
    el.textContent = '0';
    requestAnimationFrame(update);
  }

  const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCounter(entry.target);
        counterObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });

  document.querySelectorAll('.stat-number').forEach(el => counterObserver.observe(el));

  // 4. Progress bar animée
  document.querySelectorAll('[data-progress]').forEach(el => {
    const pct = el.dataset.progress;
    el.style.setProperty('--progress-width', pct + '%');
    el.style.animation = 'progressFill 1s cubic-bezier(0.4,0,0.2,1) both';
  });

})();
