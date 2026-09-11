<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Tableau de bord"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>

    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Supervision</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>Bonjour Dr. <span class="hero-gradient"><c:out value="${sessionScope.utilisateur.prenom}"/></span> 👋</h1>
          <p>Bienvenue sur votre espace de supervision — <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE d MMMM yyyy" var="date"/><c:out value="${date}"/></p>
        </div>

        <c:if test="${nbRapportsEnAttente > 0}">
          <div class="alert alert-info">
            📥 <strong>${nbRapportsEnAttente}</strong> rapport(s) de stage à valider.
            <a href="${pageContext.request.contextPath}/offres" class="mt-1">Voir les dossiers →</a>
          </div>
        </c:if>

        <c:if test="${nbDossiersIncomplets > 0}">
          <div class="alert alert-warning">
            ⚠️ <strong>${nbDossiersIncomplets}</strong> dossier(s) incomplet(s) nécessitant une correction.
          </div>
        </c:if>

        <div class="card">
          <div class="card-header">
            <h3 class="card-title">🎓 Mes étudiants</h3>
            <span class="badge badge-purple"><c:out value="${offres.size()}"/> dossiers</span>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty offres}">
                <div class="empty-state">
                  <div class="empty-icon">👨‍🎓</div>
                  <h3>Aucun étudiant assigné</h3>
                  <p>Les étudiants vous étant affectés apparaîtront ici.</p>
                </div>
              </c:when>
              <c:otherwise>
                <div class="table-container">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Étudiant</th>
                        <th>Entreprise</th>
                        <th>Poste</th>
                        <th>Statut</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${offres}" var="offre">
                        <tr>
                          <td><strong><c:out value="${offre.etudiant.prenom}"/> <c:out value="${offre.etudiant.nom}"/></strong></td>
                          <td><c:out value="${offre.entreprise.nom}"/></td>
                          <td class="cell-secondary"><c:out value="${offre.intitulePoste}"/></td>
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
    </div>
  </div>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>