<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Rapport de stage — Étape 2"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Déposer mon rapport de stage</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content page-content-sm">
        <div class="steps-indicator">
          <div class="step-item done">
            <div class="step-num">✓</div><span class="step-label">Contenu</span>
          </div>
          <div class="step-sep"></div>
          <div class="step-item active">
            <div class="step-num">2</div><span class="step-label">Dépôt</span>
          </div>
        </div>

        <c:if test="${not empty erreurs}">
          <div class="alert alert-error">
            <c:forEach items="${erreurs}" var="err"><p class="mb-1"><c:out value="${err}"/></p></c:forEach>
          </div>
        </c:if>
        <c:if test="${not empty erreur}">
          <div class="alert alert-error"><c:out value="${erreur}"/></div>
        </c:if>

        <div class="card">
          <div class="card-header"><h3 class="card-title">📤 Dépôt du rapport</h3></div>
          <div class="card-body">
            <div class="alert alert-info mb-3">
              ℹ️ Déposez le fichier PDF dans la salle dédiée, puis indiquez son nom ci-dessous.
            </div>
            <form method="post" action="${pageContext.request.contextPath}/rapports?action=soumettre-etape2">
              <div class="form-group">
                <label class="form-label">Fichier PDF du rapport <span class="required">*</span></label>
                <input class="form-control" type="text" name="nomFichierPdf" required
                       value="<c:out value="${nomFichierPdf}"/>"
                       placeholder="rapport_prenom_nom_2026.pdf"/>
                <p class="form-hint">PDF uniquement.</p>
              </div>
              <div class="form-group">
                <label class="form-label">Fichier annexe (optionnel)</label>
                <input class="form-control" type="text" name="nomFichierAnnexe"
                       value="<c:out value="${nomFichierAnnexe}"/>"
                       placeholder="annexes_prenom_nom_2026.pdf"/>
              </div>

              <div class="divider"></div>

              <div class="form-check">
                <input type="checkbox" name="confirmation" id="confirmation" required/>
                <label for="confirmation">
                  Je <strong>certifie</strong> que ce rapport est mon travail personnel et
                  que le fichier PDF a bien été déposé.
                </label>
              </div>

              <button type="submit" class="btn btn-success btn-lg">📤 Soumettre mon rapport</button>
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