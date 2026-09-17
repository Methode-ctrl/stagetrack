<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Générer une convention"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Générer une convention</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/conventions">← Retour</a>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>📑 <span class="hero-gradient">Générer une convention</span></h1>
          <p>Choisissez un dossier validé ou en cours de stage pour générer sa convention.</p>
        </div>

        <c:choose>
          <c:when test="${empty offresSansConvention}">
            <div class="empty-state">
              <div class="empty-icon">✅</div>
              <h3>Aucune convention à générer</h3>
              <p>Tous les dossiers éligibles disposent déjà d'une convention.</p>
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
                  <c:forEach items="${offresSansConvention}" var="offre">
                    <tr>
                      <td>
                        <strong><c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/></strong>
                      </td>
                      <td class="cell-secondary"><c:out value="${offre.entreprise.nom}"/></td>
                      <td class="cell-secondary"><c:out value="${offre.titre}"/></td>
                      <td><span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span></td>
                      <td class="text-right">
                        <form class="inline-form" method="post"
                              action="${pageContext.request.contextPath}/conventions?action=creer">
                          <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                          <button type="submit" class="btn btn-primary btn-sm">📑 Générer →</button>
                        </form>
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