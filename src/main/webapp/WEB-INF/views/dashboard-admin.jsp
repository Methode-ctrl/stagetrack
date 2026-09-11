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
        <span class="topbar-title">Administration</span>
        <div class="topbar-spacer"></div>
        <div class="topbar-actions">
          <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/utilisateurs">+ Utilisateur</a>
          <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/entreprises">+ Entreprise</a>
        </div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>Bonjour <span class="hero-gradient"><c:out value="${sessionScope.utilisateur.prenom}"/></span> 👋</h1>
          <p>Voici l'état du suivi des stages — <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE d MMMM yyyy" var="date"/><c:out value="${date}"/></p>
        </div>

        <div class="stats-grid">
          <div class="stat-card stat-card-purple">
            <span class="stat-icon">📋</span>
            <div class="stat-value"><c:out value="${nbTotal}"/></div>
            <div class="stat-label">Total des stages</div>
          </div>
          <div class="stat-card stat-card-green">
            <span class="stat-icon">🚀</span>
            <div class="stat-value"><c:out value="${nbEnCours}"/></div>
            <div class="stat-label">Stages en cours</div>
          </div>
          <div class="stat-card stat-card-orange">
            <span class="stat-icon">⏳</span>
            <div class="stat-value"><c:out value="${nbSoumises}"/></div>
            <div class="stat-label">En attente</div>
          </div>
          <div class="stat-card stat-card-pink">
            <span class="stat-icon">🗃️</span>
            <div class="stat-value"><c:out value="${nbArchives}"/></div>
            <div class="stat-label">Archivés</div>
          </div>
        </div>

        <c:if test="${not empty sansSuperviseur}">
          <div class="card mb-4">
            <div class="card-header">
              <h3 class="card-title">📌 Dossiers à affecter</h3>
              <span class="badge badge-warning"><c:out value="${sansSuperviseur.size()}"/> en attente</span>
            </div>
            <div class="card-body">
              <c:forEach items="${sansSuperviseur}" var="offre">
                <form class="order-item mb-2" method="post" action="${pageContext.request.contextPath}/offres?action=affecter">
                  <div class="order-avatar orange">📌</div>
                  <div class="order-body">
                    <div class="order-name">
                      <c:out value="${offre.etudiant.prenom}"/> <c:out value="${offre.etudiant.nom}"/>
                      <span class="text-muted">— <c:out value="${offre.entreprise.nom}"/></span>
                    </div>
                    <div class="order-meta"><c:out value="${offre.intitulePoste}"/></div>
                  </div>
                  <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                  <select name="superviseurId" class="form-control" style="width:auto;" required>
                    <option value="" disabled selected>Choisir un superviseur…</option>
                    <c:forEach items="${superviseurs}" var="sup">
                      <option value="<c:out value="${sup.id}"/>">
                        <c:out value="${sup.prenom}"/> <c:out value="${sup.nom}"/>
                      </option>
                    </c:forEach>
                  </select>
                  <button type="submit" class="btn btn-primary btn-sm">Affecter</button>
                </form>
              </c:forEach>
            </div>
          </div>
        </c:if>

        <div class="card">
          <div class="card-header">
            <h3 class="card-title">📋 Tous les stages</h3>
            <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/offres">Voir tout →</a>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty offres}">
                <div class="empty-state">
                  <div class="empty-icon">🗂️</div>
                  <h3>Aucun stage pour le moment</h3>
                  <p>Les dossiers soumis par les étudiants apparaîtront ici.</p>
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
                          <td><span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span></td>
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

    <aside class="right-panel">
      <div class="page-content">
        <div class="card">
          <div class="card-header"><h3 class="card-title">🕘 Dossiers récents</h3></div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty offres}">
                <p class="text-muted">Aucun dossier récent.</p>
              </c:when>
              <c:otherwise>
                <div class="order-list">
                  <c:forEach items="${offres}" var="offre" end="5">
                    <a class="order-item" href="${pageContext.request.contextPath}/offres?action=detail&amp;id=${offre.id}">
                      <div class="order-avatar green">👨‍🎓</div>
                      <div class="order-body">
                        <div class="order-name"><c:out value="${offre.etudiant.prenom}"/> <c:out value="${offre.etudiant.nom}"/></div>
                        <div class="order-meta"><c:out value="${offre.entreprise.nom}"/> · <c:out value="${offre.intitulePoste}"/></div>
                      </div>
                      <span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span>
                    </a>
                  </c:forEach>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </aside>
  </div>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>