<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Liste des stages"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>

    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Tous les stages</span>
        <div class="topbar-spacer"></div>
        <div class="topbar-actions">
          <input class="form-control" id="filtreRecherche" type="search"
                 placeholder="🔎 Rechercher…" style="width:220px;"/>
        </div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>📋 <span class="hero-gradient">Tous les stages</span></h1>
          <p>Filtrez par étudiant, entreprise, poste ou statut.</p>
        </div>

        <c:choose>
          <c:when test="${empty offres}">
            <div class="empty-state">
              <div class="empty-icon">🗂️</div>
              <h3>Aucun stage enregistré</h3>
              <p>Les dossiers soumis apparaîtront ici.</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="table-container">
              <table class="table" id="tableOffres">
                <thead>
                  <tr>
                    <th>Étudiant</th>
                    <th>Entreprise</th>
                    <th>Poste</th>
                    <th>Superviseur</th>
                    <th>Statut</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${offres}" var="offre">
                    <tr>
                      <td>
                        <strong><c:out value="${offre.etudiant.prenom}"/> <c:out value="${offre.etudiant.nom}"/></strong>
                      </td>
                      <td><c:out value="${offre.entreprise.nom}"/></td>
                      <td class="cell-secondary"><c:out value="${offre.intitulePoste}"/></td>
                      <td class="cell-secondary">
                        <c:choose>
                          <c:when test="${not empty offre.superviseur}">
                            <c:out value="${offre.superviseur.prenom}"/> <c:out value="${offre.superviseur.nom}"/>
                          </c:when>
                          <c:otherwise><span class="text-warning">Non affecté</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td><span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span></td>
                      <td class="text-right">
                        <a class="btn btn-secondary btn-sm"
                           href="${pageContext.request.contextPath}/offres?action=detail&amp;id=${offre.id}">
                          Voir le détail →
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
  <script>
    document.getElementById('filtreRecherche').addEventListener('input', function () {
      var terme = this.value.toLowerCase();
      document.querySelectorAll('#tableOffres tbody tr').forEach(function (row) {
        row.style.display = row.textContent.toLowerCase().includes(terme) ? '' : 'none';
      });
    });
  </script>
</body>
</html>