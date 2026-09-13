<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Liste des rapports"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Rapports</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>📝 <span class="hero-gradient">Rapports de stage</span></h1>
          <p>Suivez les rapports soumis et leur évaluation.</p>
        </div>

        <c:choose>
          <c:when test="${empty rapports}">
            <div class="empty-state">
              <div class="empty-icon">🗂️</div>
              <h3>Aucun rapport soumis</h3>
              <p>Les rapports déposés apparaîtront ici.</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="table-container">
              <table class="table">
                <thead>
                  <tr>
                    <th>Titre</th>
                    <th>Étudiant</th>
                    <th>Stage</th>
                    <th>Statut</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${rapports}" var="rapport">
                    <tr>
                      <td><strong><c:out value="${rapport.titre}"/></strong></td>
                      <td class="cell-secondary">
                        <c:out value="${rapport.offreStage.etudiant.utilisateur.prenom}"/> <c:out value="${rapport.offreStage.etudiant.utilisateur.nom}"/>
                      </td>
                      <td class="cell-secondary"><c:out value="${rapport.offreStage.titre}"/></td>
                      <td><span class="badge"><c:out value="${rapport.statut}"/></span></td>
                      <td class="text-right">
                        <c:if test="${sessionScope.role == 'SUPERVISEUR' && (rapport.statut == 'SOUMIS' || rapport.statut == 'EN_CORRECTION')}">
                          <a class="btn btn-primary btn-sm"
                             href="${pageContext.request.contextPath}/rapports?action=evaluer&amp;id=${rapport.id}">
                            Évaluer →
                          </a>
                        </c:if>
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
</body>
</html>