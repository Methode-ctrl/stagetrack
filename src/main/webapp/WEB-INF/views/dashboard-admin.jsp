<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Tableau de bord Admin"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/logout">
  <%@ include file="include/sidebar.jsp" %>

  <main class="main-content">
    <div class="container">

      <!-- Hero -->
      <div class="hero">
        <div class="hero-title">Bonjour, <c:out value="${sessionScope.utilisateur.prenom}"/> 👋</div>
        <div class="hero-subtitle">Administration · StageTrack UPG</div>
      </div>

      <!-- Stats -->
      <div class="dashboard-stats">
        <div class="stat-card stat-card-blue scroll-reveal stagger-1">
          <span class="stat-icon">📋</span>
          <div class="stat-number"><c:out value="${nbSoumises}"/></div>
          <div class="stat-label">Dossiers soumis</div>
        </div>
        <div class="stat-card stat-card-green scroll-reveal stagger-2">
          <span class="stat-icon">🎯</span>
          <div class="stat-number"><c:out value="${nbEnCours}"/></div>
          <div class="stat-label">Stages en cours</div>
        </div>
        <div class="stat-card stat-card-orange scroll-reveal stagger-3">
          <span class="stat-icon">📦</span>
          <div class="stat-number"><c:out value="${nbArchives}"/></div>
          <div class="stat-label">Archivés</div>
        </div>
        <div class="stat-card stat-card-grey scroll-reveal stagger-4">
          <span class="stat-icon">📊</span>
          <div class="stat-number"><c:out value="${nbTotal}"/></div>
          <div class="stat-label">Total</div>
        </div>
      </div>

      <!-- Section : Dossiers sans superviseur -->
      <c:if test="${not empty sansSuperviseur}">
        <div class="alert alert-warning scroll-reveal" style="margin-bottom:1.5rem;">
          <strong>⚠️ ${sansSuperviseur.size()} dossier(s) sans superviseur affecté</strong>
        </div>
        <div class="flex-between mb-3">
        <h2 class="section-title"><a href="${pageContext.request.contextPath}/dashboard/admin" style="text-decoration:none;color:inherit;">📌 Dossiers à affecter</a></h2>

        </div>
        <div class="table-wrapper scroll-reveal" style="margin-bottom:2rem;">
          <table class="table">
            <thead>
              <tr>
                <th>Étudiant</th>
                <th>Entreprise</th>
                <th>Poste</th>
                <th>Date soumission</th>
                <th>Affecter superviseur</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${sansSuperviseur}" var="offre">
                <tr>
                  <td>
                    <strong><c:out value="${offre.etudiant.utilisateur.prenom}"/>
                    <c:out value="${offre.etudiant.utilisateur.nom}"/></strong>
                    <br/><small class="text-muted"><c:out value="${offre.etudiant.matricule}"/></small>
                  </td>
                  <td><c:out value="${offre.entreprise.nom}"/></td>
                  <td><c:out value="${offre.intitulePoste}"/></td>
                  <td><c:out value="${offre.dateSoumission}"/></td>
                  <td>
                    <!-- Formulaire d'affectation superviseur -->
                    <form method="post"
                          action="${pageContext.request.contextPath}/offres?action=affecter"
                          style="display:flex;gap:0.5rem;align-items:center;">
                      <input type="hidden" name="offreId" value="${offre.id}"/>
                      <select name="superviseurId" class="form-control" style="min-width:180px;" required>
                        <option value="">-- Choisir --</option>
                        <c:forEach items="${superviseurs}" var="sup">
                          <option value="${sup.id}">
                            <c:out value="${sup.grade}"/>
                            <c:out value="${sup.utilisateur.prenom}"/>
                            <c:out value="${sup.utilisateur.nom}"/>
                          </option>
                        </c:forEach>
                      </select>
                      <button type="submit" class="btn btn-primary btn-sm">✅ Affecter</button>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:if>

      <!-- Section : Tous les dossiers -->
      <div class="flex-between mb-3">
        <h2 class="section-title"><a href="${pageContext.request.contextPath}/dashboard/admin" style="text-decoration:none;color:inherit;">Tous les dossiers de stage</a></h2>

        <a href="${pageContext.request.contextPath}/offres" class="btn btn-secondary btn-sm">Voir tout</a>
      </div>
      <div class="table-wrapper scroll-reveal">
        <table class="table">
          <thead>
            <tr>
              <th>Étudiant</th>
              <th>Entreprise</th>
              <th>Poste</th>
              <th>Superviseur</th>
              <th>Statut</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${offres}" var="offre">
              <tr>
                <td>
                  <c:out value="${offre.etudiant.utilisateur.prenom}"/>
                  <c:out value="${offre.etudiant.utilisateur.nom}"/>
                </td>
                <td><c:out value="${offre.entreprise.nom}"/></td>
                <td><c:out value="${offre.intitulePoste}"/></td>
                <td>
                  <c:choose>
                    <c:when test="${not empty offre.superviseur}">
                      <c:out value="${offre.superviseur.utilisateur.prenom}"/>
                      <c:out value="${offre.superviseur.utilisateur.nom}"/>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-DOSSIER_INCOMPLET">Non affecté</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <span class="badge badge-${offre.statut}">
                    <c:out value="${offre.statut}"/>
                  </span>
                </td>
                <td>
                  <a href="${pageContext.request.contextPath}/offres?action=detail&id=${offre.id}"
                     class="btn btn-secondary btn-sm">👁 Voir</a>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty offres}">
              <tr><td colspan="6" class="table-empty">Aucun dossier de stage</td></tr>
            </c:if>
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

