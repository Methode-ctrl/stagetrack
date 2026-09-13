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

  /* ---------- 3. Confirmation avant suppression ---------- */
  function confirmerSuppression(message) {
    return confirm(message || 'Confirmer la suppression ?');
  }

  document.querySelectorAll('form[data-confirm]').forEach(function (form) {
    form.addEventListener('submit', function (event) {
      if (!confirmerSuppression(form.getAttribute('data-confirm'))) {
        event.preventDefault();
      }
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

  window.StageTrack = window.StageTrack || {};
  window.StageTrack.calculerNote = calculerNote;
  window.StageTrack.confirmerSuppression = confirmerSuppression;
})();