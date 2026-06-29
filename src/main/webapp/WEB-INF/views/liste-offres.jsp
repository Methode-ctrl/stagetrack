<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Liste des offres de stage"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/login?action=logout">
  <%@ include file="include/sidebar.jsp" %>
  <main class="main-content">
    <div class="container">

      <div class="management-header">
        <h2 class="section-title">Dossiers de stage</h2>
        <c:if test="${sessionScope.role == 'ETUDIANT'}">
          <a href="${pageContext.request.contextPath}/offres?action=new" class="btn btn-primary btn-sm">➕ Nouvelle offre</a>
        </c:if>
      </div>

      <!-- Filtres -->
      <div class="card mb-3">
        <form method="get" action="${pageContext.request.contextPath}/offres" class="flex flex-wrap flex-gap-2" style="align-items:flex-end;">
          <div class="form-group" style="margin:0;flex:1;min-width:180px;">
            <label class="form-label" for="statut">Statut</label>
            <select id="statut" name="statut" class="form-control">
              <option value="">Tous les statuts</option>
              <option value="OFFRE_SOUMISE"     ${param.statut == 'OFFRE_SOUMISE' ? 'selected' : ''}>Offre soumise</option>
              <option value="EN_VALIDATION"     ${param.statut == 'EN_VALIDATION' ? 'selected' : ''}>En validation</option>
              <option value="DOSSIER_INCOMPLET" ${param.statut == 'DOSSIER_INCOMPLET' ? 'selected' : ''}>Dossier incomplet</option>
              <option value="VALIDEE"           ${param.statut == 'VALIDEE' ? 'selected' : ''}>Validée</option>
              <option value="STAGE_EN_COURS"    ${param.statut == 'STAGE_EN_COURS' ? 'selected' : ''}>Stage en cours</option>
              <option value="PAUSE"             ${param.statut == 'PAUSE' ? 'selected' : ''}>En pause</option>
              <option value="RAPPORT_SOUMIS"    ${param.statut == 'RAPPORT_SOUMIS' ? 'selected' : ''}>Rapport soumis</option>
              <option value="EN_CORRECTION"     ${param.statut == 'EN_CORRECTION' ? 'selected' : ''}>En correction</option>
              <option value="RAPPORT_VALIDE"    ${param.statut == 'RAPPORT_VALIDE' ? 'selected' : ''}>Rapport validé</option>
              <option value="NOTE_ATTRIBUEE"    ${param.statut == 'NOTE_ATTRIBUEE' ? 'selected' : ''}>Note attribuée</option>
              <option value="ARCHIVE"           ${param.statut == 'ARCHIVE' ? 'selected' : ''}>Archivé</option>
            </select>
          </div>
          <div class="form-group" style="margin:0;flex:2;min-width:220px;">
            <label class="form-label" for="recherche">Recherche</label>
            <input type="text" id="recherche" name="recherche" class="form-control"
                   placeholder="Rechercher un étudiant ou entreprise..." value="${param.recherche}">
          </div>
          <button type="submit" class="btn btn-primary">🔍 Filtrer</button>
          <a href="${pageContext.request.contextPath}/offres" class="btn btn-secondary">Réinitialiser</a>
        </form>
      </div>

      <!-- Tableau -->
      <div class="table-wrapper scroll-reveal">
        <table class="table">
          <thead>
            <tr>
              <th>#</th>
              <th>Étudiant</th>
              <th>Entreprise</th>
              <th>Poste</th>
              <th>Statut</th>
              <th>Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty offres}">
                <tr><td colspan="7" class="table-empty">Aucune offre trouvée</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach items="${offres}" var="offre" varStatus="loop">
                  <tr>
                    <td class="text-muted text-sm"><c:out value="${loop.count}"/></td>
                    <td><c:out value="${offre.etudiant.utilisateur.nom}"/> <c:out value="${offre.etudiant.utilisateur.prenom}"/></td>
                    <td><c:out value="${offre.entreprise.nom}"/></td>
                    <td><c:out value="${offre.intitulePoste}"/></td>
                    <td><span class="badge badge-${offre.statut}"><c:out value="${offre.statut}"/></span></td>
                    <td class="text-sm text-muted"><c:out value="${offre.dateSoumission}"/></td>
                    <td>
                      <a href="${pageContext.request.contextPath}/offres?action=detail&id=${offre.id}" class="btn btn-secondary btn-sm">👁 Voir</a>
                      <c:if test="${sessionScope.role == 'ADMIN' and empty offre.superviseur}">
                        <a href="${pageContext.request.contextPath}/offres?action=affecter&id=${offre.id}" class="btn btn-primary btn-sm">Affecter</a>
                      </c:if>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

    </div>
  </main>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
