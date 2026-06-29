<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Déposer mon rapport – Étape 2"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/login?action=logout">
  <%@ include file="include/sidebar.jsp" %>
  <main class="main-content">
    <div class="container">
      <div class="form-card">
        <div class="steps mb-4">
          <div class="step completed">
            <div class="step-circle">✓</div>
            <div class="step-label">Informations</div>
          </div>
          <div class="step active">
            <div class="step-circle">2</div>
            <div class="step-label">Fichiers</div>
          </div>
        </div>

        <h2>Déposer mon rapport de stage – Étape 2/2</h2>
        <p class="text-secondary mb-3">Dépôt du fichier rapport</p>

        <c:if test="${not empty sessionScope.rapportTemp}">
          <div style="background:var(--color-surface-alt);border:1px solid var(--color-border);border-radius:var(--radius-md);padding:1rem;margin-bottom:1.5rem;">
            <p class="font-semibold mb-1">📋 Récapitulatif étape 1</p>
            <p class="text-sm text-secondary">Titre : <strong><c:out value="${sessionScope.rapportTemp.titre}"/></strong></p>
            <p class="text-sm text-secondary">Compétences : <c:out value="${sessionScope.rapportTemp.competencesAcquises}"/></p>
          </div>
        </c:if>

        <c:if test="${not empty erreurs}">
          <c:forEach items="${erreurs}" var="erreur">
            <div class="alert alert-error"><c:out value="${erreur}"/></div>
          </c:forEach>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/rapports?action=soumettre-etape2" novalidate>

          <!-- RAPPORT PDF -->
          <div class="form-group">
            <label for="nomFichierPdf">
              📄 Nom du fichier – Rapport de stage (PDF)
              <span class="required">*</span>
            </label>
            <div class="doc-info-box">
              <p>📋 <strong>Comment faire :</strong></p>
              <ol>
                <li>Rédigez votre rapport en PDF (minimum 20 pages)</li>
                <li>Nommez-le clairement (ex: rapport_irakoze_jean_2026.pdf)</li>
                <li>Saisissez ci-dessous le nom exact de ce fichier</li>
                <li>Remettez le rapport à votre superviseur par email ou en main propre</li>
              </ol>
            </div>
            <input type="text"
                   id="nomFichierPdf"
                   name="nomFichierPdf"
                   class="form-control"
                   placeholder="rapport_stage_prenom_nom_2026.pdf"
                   value="${param.nomFichierPdf}"
                   required
                   maxlength="255"/>
            <small class="form-hint">⚠️ Minimum 20 pages recommandé. Le fichier doit se terminer par .pdf</small>
          </div>

          <!-- ANNEXES (optionnel) -->
          <div class="form-group">
            <label for="nomFichierAnnexe">
              📎 Nom du fichier – Annexes (optionnel)
            </label>
            <input type="text"
                   id="nomFichierAnnexe"
                   name="nomFichierAnnexe"
                   class="form-control"
                   placeholder="annexes_prenom_nom_2026.pdf"
                   value="${param.nomFichierAnnexe}"
                   maxlength="255"/>
            <small class="form-hint">Optionnel : schémas, captures d'écran, code source...</small>
          </div>

          <!-- NOTICE -->
          <div class="notice-box notice-info">
            <span class="notice-icon">ℹ️</span>
            <div class="notice-content">
              <strong>Dépôt physique du rapport</strong>
              <p>Après avoir soumis ce formulaire, envoyez votre rapport PDF
              par email ou remettez-le directement à votre superviseur.
              Il pourra alors l'évaluer et vous attribuer une note.</p>
            </div>
          </div>
          <input type="hidden" name="offreId" value="${sessionScope.offreId}">
          <div class="form-group" style="display:flex;align-items:flex-start;gap:0.75rem;">
            <input type="checkbox" id="confirmation" name="confirmation" required style="margin-top:3px;width:auto;">
            <label for="confirmation" class="form-label" style="margin:0;font-weight:400;color:var(--color-text-secondary);">
              Je certifie que ce rapport est mon travail personnel et original.
            </label>
          </div>
          <div class="flex-between mt-4">
            <a href="${pageContext.request.contextPath}/rapports?action=new" class="btn btn-secondary">← Précédent</a>
            <button type="submit" class="btn btn-primary">📤 Soumettre mon rapport</button>
          </div>
        </form>
      </div>
    </div>
  </main>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
