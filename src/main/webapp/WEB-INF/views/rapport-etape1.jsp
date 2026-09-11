<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Rapport de stage — Étape 1"/>
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
        <a class="btn btn-secondary btn-sm" href="javascript:history.back()">← Annuler</a>
      </div>

      <div class="page-content" style="max-width:720px; margin:0 auto;">
        <div class="steps-indicator">
          <div class="step-item active">
            <div class="step-num">1</div><span class="step-label">Contenu</span>
          </div>
          <div class="step-sep"></div>
          <div class="step-item">
            <div class="step-num">2</div><span class="step-label">Dépôt</span>
          </div>
        </div>

        <c:if test="${not empty erreur}">
          <div class="alert alert-error">${erreur}</div>
        </c:if>

        <div class="card">
          <div class="card-header"><h3 class="card-title">📝 Contenu du rapport</h3></div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/rapports?action=soumettre-etape1">
              <div class="form-group">
                <label class="form-label">Titre du rapport <span class="required">*</span></label>
                <input class="form-control" name="titre" required
                       value="<c:out value="${titre}"/>"
                       placeholder="Ex : Développement d'une application de gestion…"/>
              </div>
              <div class="form-group">
                <label class="form-label">Résumé <span class="required">*</span></label>
                <textarea class="form-control" id="champResume" name="resume" rows="5" required
                          placeholder="Résumez votre stage : contexte, missions, résultats…"><c:out value="${resume}"/></textarea>
                <p class="form-hint">⏱️ <span id="compteurMots">0 mot</span></p>
              </div>
              <div class="form-group">
                <label class="form-label">Compétences acquises <span class="required">*</span></label>
                <textarea class="form-control" name="competences" rows="4" required
                          placeholder="Listez les compétences techniques et humaines développées…"><c:out value="${competences}"/></textarea>
              </div>
              <button type="submit" class="btn btn-primary btn-lg mt-3">Étape suivante →</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>