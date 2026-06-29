<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Affecter un superviseur"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/login?action=logout">
  <%@ include file="include/sidebar.jsp" %>
  <main class="main-content">
    <div class="container">
      <div class="form-card" style="max-width:560px;">
        <h2>👤 Affecter un superviseur</h2>

        <c:if test="${not empty offre}">
          <div style="background:var(--color-surface-alt);border:1px solid var(--color-border);border-radius:var(--radius-md);padding:1rem;margin-bottom:1.5rem;">
            <div class="detail-field"><div class="detail-field-label">Étudiant</div><div class="detail-field-value"><c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/></div></div>
            <div class="detail-field"><div class="detail-field-label">Entreprise</div><div class="detail-field-value"><c:out value="${offre.entreprise.nom}"/></div></div>
            <div class="detail-field"><div class="detail-field-label">Poste</div><div class="detail-field-value"><c:out value="${offre.intitulePoste}"/></div></div>
            <div class="detail-field"><div class="detail-field-label">Statut</div><div class="detail-field-value"><span class="badge badge-${offre.statut}"><c:out value="${offre.statut}"/></span></div></div>
          </div>
        </c:if>

        <c:if test="${not empty erreur}"><div class="alert alert-error"><c:out value="${erreur}"/></div></c:if>

        <form method="post" action="${pageContext.request.contextPath}/offres" novalidate>
          <input type="hidden" name="action" value="affecter">
          <input type="hidden" name="offreId" value="${offre.id}">
          <div class="form-group">
            <label class="form-label required" for="superviseurId">Superviseur</label>
            <select id="superviseurId" name="superviseurId" class="form-control" required>
              <option value="">-- Sélectionnez un superviseur --</option>
              <c:forEach items="${superviseurs}" var="sup">
                <option value="${sup.id}">
                  <c:out value="${sup.grade}"/> <c:out value="${sup.utilisateur.prenom}"/> <c:out value="${sup.utilisateur.nom}"/> – <c:out value="${sup.specialite}"/>
                </option>
              </c:forEach>
            </select>
          </div>
          <div class="flex-between mt-4">
            <a href="${pageContext.request.contextPath}/offres?action=detail&id=${offre.id}" class="btn btn-secondary">Annuler</a>
            <button type="submit" class="btn btn-primary">✅ Affecter ce superviseur</button>
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
