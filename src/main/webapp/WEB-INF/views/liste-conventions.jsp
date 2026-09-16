<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Liste des conventions"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Conventions</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>📑 <span class="hero-gradient">Conventions de stage</span></h1>
          <p>Consultez les conventions générées pour chaque dossier.</p>
        </div>

        <c:choose>
          <c:when test="${empty conventions}">
            <div class="empty-state">
              <div class="empty-icon">🗂️</div>
              <h3>Aucune convention</h3>
              <p>Les conventions seront générées après validation des offres.</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="table-container">
              <table class="table">
                <thead>
                  <tr>
                    <th>N°</th>
                    <th>Étudiant</th>
                    <th>Entreprise</th>
                    <th>Poste</th>
                    <th>Statut</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${conventions}" var="conv">
                    <tr>
                      <td>#<c:out value="${conv.id}"/></td>
                      <td>
                        <strong><c:out value="${conv.offreStage.etudiant.utilisateur.prenom}"/> <c:out value="${conv.offreStage.etudiant.utilisateur.nom}"/></strong>
                      </td>
                      <td class="cell-secondary"><c:out value="${conv.offreStage.entreprise.nom}"/></td>
                      <td class="cell-secondary"><c:out value="${conv.offreStage.titre}"/></td>
                      <td><span class="badge"><c:out value="${conv.statut}"/></span></td>
                      <td class="text-right">
                        <a class="btn btn-secondary btn-sm"
                           href="${pageContext.request.contextPath}/conventions?action=detail&amp;id=${conv.id}">
                          Détail →
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
</body>
</html>