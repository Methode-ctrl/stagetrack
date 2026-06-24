<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Déposer mon rapport – Étape 1"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard">
  <%@ include file="include/navbar.jsp" %>
  <main class="main-content">
    <div class="container">
      <div class="form-card">
        <div class="steps mb-4">
          <div class="step active">
            <div class="step-circle">1</div>
            <div class="step-label">Informations</div>
          </div>
          <div class="step pending">
            <div class="step-circle">2</div>
            <div class="step-label">Fichiers</div>
          </div>
        </div>

        <h2>Déposer mon rapport de stage – Étape 1/2</h2>
        <p class="text-secondary mb-3">Informations générales sur le rapport</p>

        <c:if test="${not empty erreurs}">
          <c:forEach items="${erreurs}" var="erreur">
            <div class="alert alert-error"><c:out value="${erreur}"/></div>
          </c:forEach>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/rapports?action=soumettre-etape1" novalidate>
          <div class="form-group">
            <label class="form-label required" for="titre">Titre du rapport</label>
            <input type="text" id="titre" name="titre" class="form-control"
                   placeholder="Ex: Développement d'une application de gestion..." required maxlength="255"
                   value="${param.titre}">
          </div>
          <div class="form-group">
            <label class="form-label required" for="resume">Résumé <span class="text-muted">(500 mots max)</span></label>
            <textarea id="resume" name="resume" class="form-control" rows="6"
                      placeholder="Décrivez brièvement votre stage, les missions réalisées et vos principaux apprentissages..."
                      required maxlength="3000"><c:out value="${param.resume}"/></textarea>
            <p class="text-sm text-muted mt-1" id="wordCount">0 / 500 mots</p>
          </div>
          <div class="form-group">
            <label class="form-label required" for="competencesAcquises">Compétences techniques acquises</label>
            <textarea id="competencesAcquises" name="competences" class="form-control" rows="4"
                      placeholder="Java EE, GlassFish, JPA, CDI, Servlet, JSP..." required><c:out value="${param.competencesAcquises}"/></textarea>
          </div>
          <div class="form-group">
            <label class="form-label" for="autoEvaluation">Auto-évaluation (note sur 20)</label>
            <input type="number" id="autoEvaluation" name="autoEvaluation" class="form-control"
                   min="0" max="20" step="0.5" placeholder="15" value="${param.autoEvaluation}"
                   style="max-width:160px;">
          </div>
          <div class="flex-between mt-4">
            <span></span>
            <button type="submit" class="btn btn-primary">Suivant →</button>
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
      var ta = document.getElementById('resume');
      var counter = document.getElementById('wordCount');
      function countWords(str) {
        return str.trim() === '' ? 0 : str.trim().split(/\s+/).length;
      }
      ta.addEventListener('input', function() {
        var words = countWords(this.value);
        counter.textContent = words + ' / 500 mots';
        counter.style.color = words > 500 ? 'var(--color-danger)' : 'var(--color-text-muted)';
      });
    })();
  </script>
</body>
</html>
