/* ============================================================
   STAGETRACK — UTILS.JS
   ============================================================ */

(function () {
  'use strict';

  /* ---------- 1. Calcul de la note finale en temps réel ---------- */
  function calculerNote() {
    var inputStage = document.getElementById('noteStage');
    var inputRapport = document.getElementById('noteRapport');
    var inputPresentation = document.getElementById('notePresence');
    if (!inputStage || !inputRapport || !inputPresentation) {
      return;
    }

    var ns = parseFloat(inputStage.value) || 0;
    var nr = parseFloat(inputRapport.value) || 0;
    var np = parseFloat(inputPresentation.value) || 0;

    var finale = Math.round((ns * 0.40 + nr * 0.40 + np * 0.20) * 100) / 100;

    var affichage = document.getElementById('noteFinaleAffichee');
    if (affichage) {
      affichage.textContent = finale.toFixed(2);
    }

    var mention = '';
    if (finale >= 18) mention = 'Très Bien';
    else if (finale >= 16) mention = 'Bien';
    else if (finale >= 14) mention = 'Assez Bien';
    else if (finale >= 12) mention = 'Passable';
    else mention = 'Insuffisant';

    var mentionAffichee = document.getElementById('mentionAffichee');
    if (mentionAffichee) {
      mentionAffichee.textContent = mention;
      mentionAffichee.style.color = finale >= 12 ? '#34D399' : '#F87171';
    }
  }

  ['noteStage', 'noteRapport', 'notePresence'].forEach(function (id) {
    var el = document.getElementById(id);
    if (el) {
      el.addEventListener('input', calculerNote);
    }
  });
  calculerNote();

  /* ---------- 2. Compteur de mots pour le résumé rapport ---------- */
  var champResume = document.getElementById('champResume');
  var compteur = document.getElementById('compteurMots');

  if (champResume && compteur) {
    function majCompteur() {
      var texte = champResume.value.trim();
      var mots = texte.length === 0 ? 0 : texte.split(/\s+/).length;
      compteur.textContent = mots + ' mot' + (mots > 1 ? 's' : '');
    }
    champResume.addEventListener('input', majCompteur);
    majCompteur();
  }

  /* ---------- 3. Confirmation avant suppression (modale) ---------- */
  var confirmerOverlay = null;
  var callbackConfirmation = null;

  function ouvrirConfirmation(message, callback) {
    callbackConfirmation = callback;

    if (!confirmerOverlay) {
      confirmerOverlay = document.createElement('div');
      confirmerOverlay.className = 'modal-overlay';
      confirmerOverlay.innerHTML =
        '<div class="modal" role="dialog" aria-modal="true" aria-labelledby="stConfirmTitle">' +
          '<div class="modal-header"><h3 id="stConfirmTitle">⚠️ Confirmation</h3></div>' +
          '<div class="modal-body"><p id="stConfirmMsg"></p></div>' +
          '<div class="modal-actions">' +
            '<button type="button" class="btn btn-secondary" data-confirm-action="cancel">Annuler</button>' +
            '<button type="button" class="btn btn-danger" data-confirm-action="ok">Confirmer</button>' +
          '</div>' +
        '</div>';
      document.body.appendChild(confirmerOverlay);

      confirmerOverlay.addEventListener('click', function (event) {
        var bouton = event.target.closest('[data-confirm-action]');
        if (bouton) {
          var ok = bouton.getAttribute('data-confirm-action') === 'ok';
          var cb = callbackConfirmation;
          fermerConfirmation();
          if (ok && cb) {
            cb();
          }
        }
      });

      document.addEventListener('keydown', function (event) {
        if (event.key === 'Escape' && confirmerOverlay.classList.contains('open')) {
          fermerConfirmation();
        }
      });
    }

    var msg = confirmerOverlay.querySelector('#stConfirmMsg');
    msg.textContent = message;
    confirmerOverlay.classList.add('open');
    document.body.style.overflow = 'hidden';
  }

  function fermerConfirmation() {
    if (confirmerOverlay) {
      confirmerOverlay.classList.remove('open');
    }
    document.body.style.overflow = '';
  }

  document.querySelectorAll('form[data-confirm]').forEach(function (form) {
    form.addEventListener('submit', function (event) {
      var message = form.getAttribute('data-confirm');
      if (!message) {
        return;
      }
      event.preventDefault();
      ouvrirConfirmation(message, function () {
        form.removeAttribute('data-confirm');
        form.submit();
      });
    });
  });

  /* ---------- 4. Fermeture des alertes ---------- */
  document.querySelectorAll('.alert-close').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var alertBox = btn.closest('.alert');
      if (alertBox) {
        alertBox.style.display = 'none';
      }
    });
  });

  /* ---------- 5. Retour visuel des boutons (onde de couleur) ---------- */
  document.querySelectorAll('.btn').forEach(function (btn) {
    btn.addEventListener('pointerdown', function (event) {
      if (event.button !== undefined && event.button !== 0) {
        return;
      }
      var rect = btn.getBoundingClientRect();
      var d = Math.max(rect.width, rect.height);
      var ripple = document.createElement('span');
      ripple.className = 'ripple';
      ripple.style.width = d + 'px';
      ripple.style.height = d + 'px';
      ripple.style.left = (event.clientX - rect.left - d / 2) + 'px';
      ripple.style.top = (event.clientY - rect.top - d / 2) + 'px';
      btn.appendChild(ripple);
      setTimeout(function () {
        if (ripple.parentNode) {
          ripple.parentNode.removeChild(ripple);
        }
      }, 500);
    });
  });

  window.StageTrack = window.StageTrack || {};
  window.StageTrack.calculerNote = calculerNote;
  window.StageTrack.ouvrirConfirmation = ouvrirConfirmation;
})();