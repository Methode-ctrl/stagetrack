<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
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
        <span class="topbar-title">Mon espace</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>Bonjour <span class="hero-gradient"><c:out value="${sessionScope.utilisateur.prenom}"/></span> 👋</h1>
          <p>Vue d'ensemble de votre stage — <fmt:formatDate value="${dateJour}" pattern="EEEE d MMMM yyyy" var="date"/><c:out value="${date}"/></p>
        </div>

        <c:set var="nbDossiers" value="${offres.size()}"/>
        <c:set var="nbStagesEnCours" value="0"/>
        <c:set var="nbRapportsDeposes" value="0"/>
        <c:forEach items="${offres}" var="o">
          <c:if test="${o.statut == 'STAGE_EN_COURS' || o.statut == 'PAUSE'}">
            <c:set var="nbStagesEnCours" value="${nbStagesEnCours + 1}"/>
          </c:if>
          <c:if test="${o.statut == 'RAPPORT_SOUMIS' || o.statut == 'EN_CORRECTION' || o.statut == 'RAPPORT_VALIDE' || o.statut == 'NOTE_ATTRIBUEE' || o.statut == 'ARCHIVE'}">
            <c:set var="nbRapportsDeposes" value="${nbRapportsDeposes + 1}"/>
          </c:if>
        </c:forEach>

        <div class="stats-grid">
          <div class="stat-card stat-card-purple">
            <span class="stat-icon">📋</span>
            <div class="stat-value"><c:out value="${nbDossiers}"/></div>
            <div class="stat-label">Dossiers soumis</div>
          </div>
          <div class="stat-card stat-card-green">
            <span class="stat-icon">🚀</span>
            <div class="stat-value"><c:out value="${nbStagesEnCours}"/></div>
            <div class="stat-label">Stages en cours</div>
          </div>
          <div class="stat-card stat-card-orange">
            <span class="stat-icon">📝</span>
            <div class="stat-value"><c:out value="${nbRapportsDeposes}"/></div>
            <div class="stat-label">Rapports déposés</div>
          </div>
          <div class="stat-card stat-card-pink">
            <span class="stat-icon">🏅</span>
            <div class="stat-value">
              <c:choose>
                <c:when test="${not empty note && not empty note.noteFinale}"><c:out value="${note.noteFinale}"/></c:when>
                <c:otherwise>—</c:otherwise>
              </c:choose>
            </div>
            <div class="stat-label">Note finale</div>
          </div>
        </div>

        <c:choose>
          <c:when test="${empty offres}">
            <div class="card">
              <div class="card-header">
                <h3 class="card-title">📁 Mon stage</h3>
              </div>
              <div class="card-body">
                <div class="empty-state">
                  <div class="empty-icon">🎓</div>
                  <h3>Vous n'avez pas encore de stage</h3>
                  <p>Déposez votre offre de stage pour démarrer le processus d'attribution.</p>
                  <a href="${pageContext.request.contextPath}/offres?action=nouveau" class="btn btn-primary mt-2">Déposer une offre →</a>
                </div>
              </div>
            </div>
          </c:when>
          <c:otherwise>
            <c:if test="${offres.size() > 1}">
              <div class="alert alert-warning mb-3">
                <div class="alert-icon">⚠️</div>
                <div class="alert-content">
                  <strong>${offres.size()} dossiers soumis.</strong> Seul votre stage attribué est affiché en détail ci-dessous.
                </div>
              </div>
            </c:if>

            <c:forEach items="${offres}" var="offre" varStatus="loop">
              <c:if test="${loop.first}">
                <div class="card mb-4">
                  <div class="card-header">
                    <h3 class="card-title">📁 Mon stage</h3>
                    <span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span>
                  </div>
                  <div class="card-body">
                    <c:if test="${not empty motifParOffre[offre.id] && (offre.statut == 'DOSSIER_INCOMPLET' || offre.statut == 'EN_CORRECTION')}">
                      <div class="alert alert-warning mb-3">
                        <div class="alert-icon">📌</div>
                        <div class="alert-content">
                          <strong>Corrections demandées :</strong> <c:out value="${motifParOffre[offre.id]}"/>
                          <a href="${pageContext.request.contextPath}/offres?action=detail&amp;id=${offre.id}" class="alert-link">Modifier mon dossier →</a>
                        </div>
                      </div>
                    </c:if>

                    <div class="info">
                      <span class="info-label">Entreprise</span>
                      <span class="info-value">
                        <c:choose>
                          <c:when test="${not empty offre.entreprise}"><c:out value="${offre.entreprise.nom}"/></c:when>
                          <c:otherwise>Non attribuée</c:otherwise>
                        </c:choose>
                      </span>
                    </div>
                    <div class="info">
                      <span class="info-label">Poste</span>
                      <span class="info-value">
                        <c:choose>
                          <c:when test="${not empty offre.titre}"><c:out value="${offre.titre}"/></c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </span>
                    </div>
                    <div class="info">
                      <span class="info-label">Superviseur</span>
                      <span class="info-value">
                        <c:choose>
                          <c:when test="${not empty offre.superviseur}">
                            <c:out value="${offre.superviseur.utilisateur.prenom}"/> <c:out value="${offre.superviseur.utilisateur.nom}"/>
                          </c:when>
                          <c:otherwise>Non assigné</c:otherwise>
                        </c:choose>
                      </span>
                    </div>

                    <div class="info">
                      <span class="info-label">Dates</span>
                      <span class="info-value">
                        <fmt:formatDate value="${offre.dateDebut}" pattern="dd MMM yyyy" var="dateDebut"/>
                        <fmt:formatDate value="${offre.dateFin}" pattern="dd MMM yyyy" var="dateFin"/>
                        <c:out value="${dateDebut}"/> → <c:out value="${dateFin}"/>
                      </span>
                    </div>

                    <div class="actions gap-1 mt-3">
                      <a href="${pageContext.request.contextPath}/offres?action=detail&amp;id=${offre.id}" class="btn btn-secondary">Voir le détail →</a>
                      <c:if test="${offre.statut == 'RAPPORT_SOUMIS' || offre.statut == 'EN_CORRECTION' || offre.statut == 'RAPPORT_VALIDE'}">
                        <a href="${pageContext.request.contextPath}/rapports?action=mon-rapport" class="btn btn-secondary">Mon rapport →</a>
                      </c:if>
                      <a href="${pageContext.request.contextPath}/offres?action=convention" class="btn btn-secondary">Ma convention →</a>
                    </div>
                  </div>
                </div>

                <c:set var="progression" value="0"/>
                <c:if test="${offre.statut == 'EN_VALIDATION' || offre.statut == 'DOSSIER_INCOMPLET'}"><c:set var="progression" value="1"/></c:if>
                <c:if test="${offre.statut == 'VALIDEE' || offre.statut == 'STAGE_EN_COURS' || offre.statut == 'PAUSE'}"><c:set var="progression" value="2"/></c:if>
                <c:if test="${offre.statut == 'RAPPORT_SOUMIS' || offre.statut == 'EN_CORRECTION'}"><c:set var="progression" value="3"/></c:if>
                <c:if test="${offre.statut == 'RAPPORT_VALIDE'}"><c:set var="progression" value="4"/></c:if>
                <c:if test="${offre.statut == 'NOTE_ATTRIBUEE'}"><c:set var="progression" value="5"/></c:if>
                <c:if test="${offre.statut == 'ARCHIVE'}"><c:set var="progression" value="6"/></c:if>

                <div class="card">
                  <div class="card-header">
                    <h3 class="card-title">🗺️ Ma progression</h3>
                    <span class="badge badge-purple"><c:out value="${progression}"/> / 6 étapes</span>
                  </div>
                  <div class="card-body">
                    <div class="steps-indicator">
                      <div class="step <c:out value="${progression >= 1 ? 'step-active' : ''}"/>"><span class="step-dot">1</span><span class="step-label">Dossier soumis</span></div>
                      <div class="step-line <c:out value="${progression >= 2 ? 'step-line-active' : ''}"/>"></div>
                      <div class="step <c:out value="${progression >= 2 ? 'step-active' : ''}"/>"><span class="step-dot">2</span><span class="step-label">Validation</span></div>
                      <div class="step-line <c:out value="${progression >= 3 ? 'step-line-active' : ''}"/>"></div>
                      <div class="step <c:out value="${progression >= 3 ? 'step-active' : ''}"/>"><span class="step-dot">3</span><span class="step-label">Stage</span></div>
                      <div class="step-line <c:out value="${progression >= 4 ? 'step-line-active' : ''}"/>"></div>
                      <div class="step <c:out value="${progression >= 4 ? 'step-active' : ''}"/>"><span class="step-dot">4</span><span class="step-label">Rapport</span></div>
                      <div class="step-line <c:out value="${progression >= 5 ? 'step-line-active' : ''}"/>"></div>
                      <div class="step <c:out value="${progression >= 5 ? 'step-active' : ''}"/>"><span class="step-dot">5</span><span class="step-label">Note</span></div>
                    </div>

                    <c:if test="${not empty notesParOffre[offre.id]}">
                      <div class="info mt-3">
                        <span class="info-label">Note obtenue</span>
                        <span class="info-value"><strong><c:out value="${notesParOffre[offre.id].noteFinale}"/> / 20</strong></span>
                      </div>
                    </c:if>
                  </div>
                </div>
              </c:if>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <c:if test="${not empty etudiant}">
      <aside class="right-panel">
        <div class="page-content">
          <div class="card mb-4">
            <div class="card-header"><h3 class="card-title">📌 Ma fiche</h3></div>
            <div class="card-body">
              <div class="info-row">
                <span class="text-muted">Matricule</span>
                <strong><c:out value="${etudiant.matricule}"/></strong>
              </div>
              <div class="info-row">
                <span class="text-muted">Filière</span>
                <strong><c:out value="${etudiant.filiere}"/></strong>
              </div>
              <div class="info-row">
                <span class="text-muted">Promotion</span>
                <strong><c:out value="${etudiant.promotion}"/></strong>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-header"><h3 class="card-title">📁 Mes dossiers</h3></div>
            <div class="card-body">
              <c:choose>
                <c:when test="${empty offres}">
                  <p class="text-muted">Aucun dossier pour le moment.</p>
                </c:when>
                <c:otherwise>
                  <div class="order-list">
                    <c:forEach items="${offres}" var="offre" end="6">
                      <a class="order-item" href="${pageContext.request.contextPath}/offres?action=detail&amp;id=${offre.id}">
                        <div class="order-avatar green">📁</div>
                        <div class="order-body">
                          <div class="order-name"><c:out value="${offre.titre}"/></div>
                          <div class="order-meta">
                            <c:choose>
                              <c:when test="${not empty offre.entreprise}"><c:out value="${offre.entreprise.nom}"/></c:when>
                              <c:otherwise>Entreprise en attente</c:otherwise>
                            </c:choose>
                          </div>
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
    </c:if>
  </div>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>