<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Évaluer le rapport"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard">
  <%@ include file="include/navbar.jsp" %>
  <main class="main-content">
    <div class="container">
      <div class="form-card" style="max-width:800px;">
        <h2>Évaluer le rapport de stage</h2>
        <c:if test="${not empty offre}">
          <p class="text-secondary mb-3">
            <c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/>
            – <c:out value="${offre.entreprise.nom}"/>
          </p>
        </c:if>

        <c:if test="${not empty offre}">
          <div style="background:var(--color-surface-alt);border:1px solid var(--color-border);border-radius:var(--radius-md);padding:1rem;margin-bottom:1.5rem;display:grid;grid-template-columns:1fr 1fr;gap:0.5rem;">
            <div class="detail-field">
              <div class="detail-field-label">Étudiant</div>
              <div class="detail-field-value"><c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/></div>
            </div>
            <div class="detail-field">
              <div class="detail-field-label">Matricule</div>
              <div class="detail-field-value"><c:out value="${offre.etudiant.matricule}"/></div>
            </div>
            <div class="detail-field">
              <div class="detail-field-label">Entreprise</div>
              <div class="detail-field-value"><c:out value="${offre.entreprise.nom}"/></div>
            </div>
            <div class="detail-field">
              <div class="detail-field-label">Poste</div>
              <div class="detail-field-value"><c:out value="${offre.intitulePoste}"/></div>
            </div>
            <c:if test="${not empty rapport}">
              <div class="detail-field">
                <div class="detail-field-label">Titre du rapport</div>
                <div class="detail-field-value"><c:out value="${rapport.titre}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Nom du fichier PDF</div>
                <div class="detail-field-value">
                  <code class="filename"><c:out value="${rapport.nomFichierPdf}"/></code>
                </div>
              </div>
              <c:if test="${not empty rapport.nomFichierAnnexe}">
                <div class="detail-field">
                  <div class="detail-field-label">Annexes</div>
                  <div class="detail-field-value">
                    <code class="filename"><c:out value="${rapport.nomFichierAnnexe}"/></code>
                  </div>
                </div>
              </c:if>
            </c:if>
          </div>

          <!-- NOTICE : fichier à récupérer -->
          <c:if test="${not empty rapport}">
            <div class="notice-box notice-warning">
              <span class="notice-icon">⚠️</span>
              <div class="notice-content">
                <strong>Fichier à récupérer</strong>
                <p>Si vous n'avez pas encore reçu ce fichier, contactez l'étudiant
                <strong><c:out value="${offre.etudiant.utilisateur.prenom}"/>
                <c:out value="${offre.etudiant.utilisateur.nom}"/></strong>
                à l'adresse :
                <strong><c:out value="${offre.etudiant.utilisateur.email}"/></strong></p>
              </div>
            </div>
          </c:if>

        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/notes?action=attribuer" novalidate>
          <input type="hidden" name="rapportId" value="${rapport.id}">
          <input type="hidden" name="offreId" value="${offre.id}">

          <div class="note-grid">
            <div class="form-group">
              <label class="form-label required" for="noteStage">Note de stage pratique /20</label>
              <input type="number" id="noteStage" name="noteStage" class="form-control"
                     min="0" max="20" step="0.5" required placeholder="0">
              <p class="text-sm text-muted mt-1">Qualité du travail en entreprise (coeff. 40%)</p>
            </div>
            <div class="form-group">
              <label class="form-label required" for="noteRapport">Note du rapport écrit /20</label>
              <input type="number" id="noteRapport" name="noteRapport" class="form-control"
                     min="0" max="20" step="0.5" required placeholder="0">
              <p class="text-sm text-muted mt-1">Qualité de rédaction et profondeur technique (coeff. 40%)</p>
            </div>
            <div class="form-group">
              <label class="form-label required" for="notePresentation">Note de présentation /20</label>
              <input type="number" id="notePresentation" name="notePresentation" class="form-control"
                     min="0" max="20" step="0.5" required placeholder="0">
              <p class="text-sm text-muted mt-1">Soutenance orale (coeff. 20%)</p>
            </div>
          </div>

          <div class="note-result" id="noteResult" style="display:none;">
            <div class="text-sm" style="opacity:0.75;margin-bottom:0.25rem;">Note finale calculée</div>
            <div class="note-value" id="noteFinaleDisplay">–</div>
            <div class="note-mention" id="mentionDisplay">–</div>
          </div>

          <div class="form-group mt-3">
            <label class="form-label required" for="appreciation">Appréciation générale</label>
            <textarea id="appreciation" name="appreciation" class="form-control" rows="5"
                      placeholder="Évaluez le travail de l'étudiant, ses points forts, ses axes d'amélioration..."
                      required maxlength="2000"></textarea>
          </div>

          <div class="flex-between mt-4">
            <a href="${pageContext.request.contextPath}/offres?action=detail&id=${offre.id}" class="btn btn-secondary">Annuler</a>
            <button type="submit" class="btn btn-primary">✅ Valider et attribuer la note</button>
          </div>
        </form>
      </div>
    </div>
  </main>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
  <script>
    (function() {
      var inputs = ['noteStage','noteRapport','notePresentation'];
      var mentions = [
        {min:18, label:'Très Bien', color:'#065F46'},
        {min:16, label:'Bien', color:'#166534'},
        {min:14, label:'Assez Bien', color:'#1D4ED8'},
        {min:12, label:'Passable', color:'#D97706'},
        {min:0,  label:'Insuffisant', color:'#DC2626'}
      ];
      function calc() {
        var s = parseFloat(document.getElementById('noteStage').value) || 0;
        var r = parseFloat(document.getElementById('noteRapport').value) || 0;
        var p = parseFloat(document.getElementById('notePresentation').value) || 0;
        var finale = (s * 0.40) + (r * 0.40) + (p * 0.20);
        var mention = mentions.find(function(m){ return finale >= m.min; }) || mentions[4];
        var result = document.getElementById('noteResult');
        result.style.display = 'block';
        document.getElementById('noteFinaleDisplay').textContent = finale.toFixed(2) + ' / 20';
        var md = document.getElementById('mentionDisplay');
        md.textContent = mention.label;
        md.style.color = '#fff';
      }
      inputs.forEach(function(id) {
        document.getElementById(id).addEventListener('input', calc);
      });
    })();
  </script>
</body>
</html>
