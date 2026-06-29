<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Tableau de bord superviseur"/>
  <%@ include file="include/head.jsp" %>
  <style>
    .badge {
      padding: 6px 14px;
      border-radius: 20px;
      font-weight: bold;
      font-size: 13px;
      border: 1px solid transparent;
    }
    .badge-warning { background: rgba(245, 158, 11, 0.2); color: #fbbf24; border-color: rgba(245, 158, 11, 0.4); }
    .badge-info { background: rgba(59, 130, 246, 0.2); color: #60a5fa; border-color: rgba(59, 130, 246, 0.4); }
    .badge-danger { background: rgba(239, 68, 68, 0.2); color: #f87171; border-color: rgba(239, 68, 68, 0.4); }
    .badge-success { background: rgba(16, 185, 129, 0.2); color: #34d399; border-color: rgba(16, 185, 129, 0.4); }
    .badge-primary { background: rgba(99, 102, 241, 0.2); color: #818cf8; border-color: rgba(99, 102, 241, 0.4); }
    .badge-secondary { background: rgba(107, 114, 128, 0.2); color: #9ca3af; border-color: rgba(107, 114, 128, 0.4); }
    .badge-orange { background: rgba(249, 115, 22, 0.2); color: #fb923c; border-color: rgba(249, 115, 22, 0.4); }
    .badge-purple { background: rgba(139, 92, 246, 0.2); color: #a78bfa; border-color: rgba(139, 92, 246, 0.4); }
    .badge-dark { background: rgba(55, 65, 81, 0.3); color: #9ca3af; border-color: rgba(75, 85, 99, 0.4); }
    .quick-filters {
      display: flex;
      flex-wrap: wrap;
      gap: 0.75rem;
      margin-bottom: 1.5rem;
    }
    .filter-link {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      padding: 0.55rem 1rem;
      border-radius: 999px;
      border: 1px solid var(--color-border);
      background: #ffffff;
      color: var(--color-text-secondary);
      text-decoration: none;
      font-weight: 600;
      transition: 0.2s ease;
    }
    .filter-link:hover,
    .filter-link.active {
      background: var(--color-primary);
      color: #ffffff;
      border-color: var(--color-primary);
    }
    .superviseur-meta {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 1rem;
      margin-bottom: 1.5rem;
    }
    .meta-card {
      background: #ffffff;
      border: 1px solid var(--color-border);
      border-radius: var(--radius-lg);
      padding: 1rem 1.25rem;
      box-shadow: var(--shadow-sm);
    }
    .meta-card .label {
      font-size: 0.8rem;
      color: var(--color-text-muted);
      text-transform: uppercase;
      letter-spacing: 0.05em;
      margin-bottom: 0.35rem;
    }
    .meta-card .value {
      color: var(--color-text-primary);
      font-weight: 600;
    }
    @media (max-width: 900px) {
      .superviseur-meta {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/login?action=logout">
  <%@ include file="include/sidebar.jsp" %>


  <c:set var="filtreActifValue" value="${empty filtreActif ? 'tous' : filtreActif}"/>

  <main class="main-content">
    <div class="container">
      <div class="hero">
        <div class="hero-title">
          Bonjour,
          <c:out value="${superviseur.utilisateur.prenom}"/>
          <c:out value="${superviseur.utilisateur.nom}"/>
        </div>
        <div class="hero-subtitle">Suivi des dossiers affectes a votre supervision</div>
      </div>

      <c:if test="${not empty succes}">
        <div class="alert alert-success"><c:out value="${succes}"/></div>
      </c:if>

      <div class="superviseur-meta">
        <div class="meta-card">
          <div class="label">Grade</div>
          <div class="value"><c:out value="${superviseur.grade}"/></div>
        </div>
        <div class="meta-card">
          <div class="label">Specialite</div>
          <div class="value"><c:out value="${superviseur.specialite}"/></div>
        </div>
        <div class="meta-card">
          <div class="label">Bureau</div>
          <div class="value"><c:out value="${superviseur.bureau}"/></div>
        </div>
      </div>

      <div class="dashboard-stats">
        <div class="stat-card stat-card-blue scroll-reveal stagger-1">
          <span class="stat-icon">1</span>
          <div class="stat-number"><c:out value="${nbEtudiantsAffectes}"/></div>
          <div class="stat-label">Etudiants affectes</div>
        </div>
        <div class="stat-card stat-card-green scroll-reveal stagger-2">
          <span class="stat-icon">2</span>
          <div class="stat-number"><c:out value="${nbDossiersAExaminer}"/></div>
          <div class="stat-label">Dossiers a examiner</div>
        </div>
        <div class="stat-card stat-card-orange scroll-reveal stagger-3">
          <span class="stat-icon">3</span>
          <div class="stat-number"><c:out value="${nbDossiersIncomplets}"/></div>
          <div class="stat-label">Dossiers incomplets</div>
        </div>
        <div class="stat-card stat-card-grey scroll-reveal stagger-4">
          <span class="stat-icon">4</span>
          <div class="stat-number"><c:out value="${nbRapportsEnAttente}"/></div>
          <div class="stat-label">Rapports a evaluer</div>
        </div>
      </div>

      <div class="flex-between mb-3">
        <h2 class="section-title">Mes dossiers de stage</h2>
      </div>

      <div class="quick-filters">
        <a href="${pageContext.request.contextPath}/dashboard/superviseur?filtre=tous"
           class="filter-link ${filtreActifValue == 'tous' ? 'active' : ''}">Tous</a>
        <a href="${pageContext.request.contextPath}/dashboard/superviseur?filtre=a-examiner"
           class="filter-link ${filtreActifValue == 'a-examiner' ? 'active' : ''}">A examiner</a>
        <a href="${pageContext.request.contextPath}/dashboard/superviseur?filtre=en-cours"
           class="filter-link ${filtreActifValue == 'en-cours' ? 'active' : ''}">En cours</a>
        <a href="${pageContext.request.contextPath}/dashboard/superviseur?filtre=rapports"
           class="filter-link ${filtreActifValue == 'rapports' ? 'active' : ''}">Rapports a evaluer</a>
        <a href="${pageContext.request.contextPath}/dashboard/superviseur?filtre=termines"
           class="filter-link ${filtreActifValue == 'termines' ? 'active' : ''}">Termines</a>
      </div>

      <div class="table-wrapper scroll-reveal">
        <table class="table">
          <thead>
            <tr>
              <th>Etudiant</th>
              <th>Entreprise</th>
              <th>Poste</th>
              <th>Statut</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${offres}" var="offre">
              <c:set var="badgeClass" value="badge-dark"/>
              <c:set var="statutLibelle" value="Archive"/>
              <c:choose>
                <c:when test="${offre.statut == 'OFFRE_SOUMISE'}">
                  <c:set var="badgeClass" value="badge-warning"/>
                  <c:set var="statutLibelle" value="Offre soumise"/>
                </c:when>
                <c:when test="${offre.statut == 'EN_VALIDATION'}">
                  <c:set var="badgeClass" value="badge-info"/>
                  <c:set var="statutLibelle" value="En validation"/>
                </c:when>
                <c:when test="${offre.statut == 'DOSSIER_INCOMPLET'}">
                  <c:set var="badgeClass" value="badge-danger"/>
                  <c:set var="statutLibelle" value="Dossier incomplet"/>
                </c:when>
                <c:when test="${offre.statut == 'VALIDEE'}">
                  <c:set var="badgeClass" value="badge-success"/>
                  <c:set var="statutLibelle" value="Validee"/>
                </c:when>
                <c:when test="${offre.statut == 'STAGE_EN_COURS'}">
                  <c:set var="badgeClass" value="badge-primary"/>
                  <c:set var="statutLibelle" value="Stage en cours"/>
                </c:when>
                <c:when test="${offre.statut == 'PAUSE'}">
                  <c:set var="badgeClass" value="badge-secondary"/>
                  <c:set var="statutLibelle" value="Pause"/>
                </c:when>
                <c:when test="${offre.statut == 'RAPPORT_SOUMIS'}">
                  <c:set var="badgeClass" value="badge-warning"/>
                  <c:set var="statutLibelle" value="Rapport soumis"/>
                </c:when>
                <c:when test="${offre.statut == 'EN_CORRECTION'}">
                  <c:set var="badgeClass" value="badge-orange"/>
                  <c:set var="statutLibelle" value="En correction"/>
                </c:when>
                <c:when test="${offre.statut == 'RAPPORT_VALIDE'}">
                  <c:set var="badgeClass" value="badge-success"/>
                  <c:set var="statutLibelle" value="Rapport valide"/>
                </c:when>
                <c:when test="${offre.statut == 'NOTE_ATTRIBUEE'}">
                  <c:set var="badgeClass" value="badge-purple"/>
                  <c:set var="statutLibelle" value="Note attribuee"/>
                </c:when>
              </c:choose>

              <tr>
                <td>
                  <strong>
                    <c:out value="${offre.etudiant.utilisateur.nom}"/>
                    <c:out value="${offre.etudiant.utilisateur.prenom}"/>
                  </strong>
                </td>
                <td><c:out value="${offre.entreprise.nom}"/></td>
                <td><c:out value="${offre.intitulePoste}"/></td>
                <td><span class="badge ${badgeClass}"><c:out value="${statutLibelle}"/></span></td>
                <td>
                  <a href="${pageContext.request.contextPath}/offres?action=detail&id=${offre.id}"
                     class="btn btn-secondary btn-sm">Voir le detail</a>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty offres}">
              <tr>
                <td colspan="5" class="table-empty">Aucun dossier affecte pour ce filtre.</td>
              </tr>
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

