<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Offre de stage — Étape 3"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Soumettre mon offre de stage</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content" style="max-width:720px; margin:0 auto;">
        <div class="steps-indicator">
          <div class="step-item done">
            <div class="step-num">✓</div><span class="step-label">Entreprise</span>
          </div>
          <div class="step-sep"></div>
          <div class="step-item done">
            <div class="step-num">✓</div><span class="step-label">Stage</span>
          </div>
          <div class="step-sep"></div>
          <div class="step-item active">
            <div class="step-num">3</div><span class="step-label">Pièces jointes</span>
          </div>
        </div>

        <c:if test="${not empty erreur}">
          <div class="alert alert-error">${erreur}</div>
        </c:if>

        <div class="card">
          <div class="card-header"><h3 class="card-title">📎 Pièces jointes</h3></div>
          <div class="card-body">
            <div class="alert alert-info mb-3">
              ℹ️ Renommez vos fichiers de la forme suggérée, puis indiquez leur nom ci-dessous.
            </div>
            <form method="post" action="${pageContext.request.contextPath}/offres?action=soumettre-etape3">
              <div class="form-group">
                <label class="form-label">Lettre d'acceptation de l'entreprise <span class="required">*</span></label>
                <input class="form-control" type="text" name="nomFichierLettre" required
                       value="<c:out value="${nomFichierLettre}"/>"
                       placeholder="lettre_acceptation_entreprise.pdf"/>
                <p class="form-hint">PDF uniquement.</p>
              </div>
              <div class="form-group">
                <label class="form-label">Curriculum Vitae <span class="required">*</span></label>
                <input class="form-control" type="text" name="nomFichierCV" required
                       value="<c:out value="${nomFichierCV}"/>"
                       placeholder="cv_prenom_nom_2026.pdf"/>
                <p class="form-hint">PDF uniquement.</p>
              </div>

              <div class="divider"></div>

              <div class="form-check">
                <input type="checkbox" name="confirmation" id="confirmation" required/>
                <label for="confirmation">
                  Je <strong>certifie</strong> que les informations fournies sont exactes et
                  que les pièces jointes sont disponibles dans la salle dédiée.
                </label>
              </div>

              <button type="submit" class="btn btn-success btn-lg">✅ Soumettre mon dossier</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
</body>
</html>