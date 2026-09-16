<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Affecter un superviseur"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Affectation superviseur</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="javascript:history.back()">← Retour</a>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>👨‍🔬 <span class="hero-gradient">Affecter un superviseur</span></h1>
          <p>Associez un superviseur UPG aux dossiers sans encadrement.</p>
        </div>

        <c:if test="${not empty erreurs}">
          <div class="alert alert-error">
            <c:forEach items="${erreurs}" var="err"><p class="mb-1"><c:out value="${err}"/></p></c:forEach>
          </div>
        </c:if>
        <c:if test="${not empty erreur}">
          <div class="alert alert-error"><c:out value="${erreur}"/></div>
        </c:if>

        <c:choose>
          <c:when test="${empty offresSansSuperviseur}">
            <div class="empty-state">
              <div class="empty-icon">✅</div>
              <h3>Aucun dossier en attente d'affectation</h3>
              <p>Tous les dossiers disposent d'un superviseur.</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="card mb-4">
              <div class="card-header"><h3 class="card-title">📋 Dossiers sans superviseur</h3></div>
              <div class="card-body">
                <div class="table-container">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Étudiant</th>
                        <th>Poste</th>
                        <th>Entreprise</th>
                        <th>Statut</th>
                        <th>Superviseur</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${offresSansSuperviseur}" var="offre">
                        <tr>
                          <td><strong><c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/></strong></td>
                          <td class="cell-secondary"><c:out value="${offre.titre}"/></td>
                          <td class="cell-secondary"><c:out value="${offre.entreprise.nom}"/></td>
                          <td><span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span></td>
                          <td>
                            <form method="post" action="${pageContext.request.contextPath}/offres?action=affecterSuperviseur" class="inline-form">
                              <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                              <select name="superviseurId" class="form-control" style="width:auto;" required>
                                <option value="" disabled selected>Choisir…</option>
                                <c:forEach items="${superviseurs}" var="sup">
                                  <option value="<c:out value="${sup.id}"/>">
                                    <c:out value="${sup.utilisateur.prenom}"/> <c:out value="${sup.utilisateur.nom}"/>
                                  </option>
                                </c:forEach>
                              </select>
                              <button type="submit" class="btn btn-primary btn-sm">Affecter</button>
                            </form>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </div>
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