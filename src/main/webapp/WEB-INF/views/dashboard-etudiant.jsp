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
        <span class="topbar-title">Mon espace</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>Bonjour <span class="hero-gradient"><c:out value="${etudiant.prenom}"/></span> 👋</h1>
          <p>Suivez l'avancement de votre stage — <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE d MMMM yyyy" var="date"/><c:out value="${date}"/></p>
        </div>

        <c:if test="${empty offre}">
          <div class="card text-center">
            <div class="card-body">
              <div class="empty-state">
                <div class="empty-icon">🚀</div>
                <h3>Vous n'avez pas encore de stage</h3>
                <p>Commencez par soumettre votre offre de stage : l'équipe pédagogique l'examinera.</p>
                <a class="btn btn-primary btn-lg mt-3"
                   href="${pageContext.request.contextPath}/offres?action=soumettre">
                  ➕ Soumettre mon offre de stage
                </a>
              </div>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty offre}">
          <div class="card mb-4">
            <div class="card-header">
              <h3 class="card-title">📁 Mon stage</h3>
              <span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span>
            </div>
            <div class="card-body">
              <div class="grid-2">
                <div>
                  <p class="text-muted mb-0">🏢 Entreprise</p>
                  <p class="mt-0"><strong><c:out value="${offre.entreprise.nom}"/></strong>
                    <span class="text-secondary">— <c:out value="${offre.entreprise.ville}"/></span></p>
                </div>
                <div>
                  <p class="text-muted mb-0">💼 Poste</p>
                  <p class="mt-0"><strong><c:out value="${offre.intitulePoste}"/></strong></p>
                </div>
                <div>
                  <p class="text-muted mb-0">👨‍🔬 Superviseur</p>
                  <p class="mt-0">
                    <c:choose>
                      <c:when test="${not empty offre.superviseur}">
                        <strong>Dr. <c:out value="${offre.superviseur.prenom}"/> <c:out value="${offre.superviseur.nom}"/></strong>
                      </c:when>
                      <c:otherwise>
                        <span class="text-warning">En attente d'affectation</span>
                      </c:otherwise>
                    </c:choose>
                  </p>
                </div>
                <div>
                  <p class="text-muted mb-0">🗓️ Période</p>
                  <p class="mt-0">
                    <c:choose>
                      <c:when test="${not empty offre.dateDebut}">
                        <strong><c:out value="${offre.dateDebut}"/> — <c:out value="${offre.dureeEnMois}"/> mois</strong>
                      </c:when>
                      <c:otherwise><span class="text-secondary">Non définie</span></c:otherwise>
                    </c:choose>
                  </p>
                </div>
              </div>

              <div class="divider"></div>

              <c:choose>

                <c:when test="${offre.statut == 'OFFRE_SOUMISE'}">
                  <div class="alert alert-info">
                    ✅ Votre offre a bien été soumise ! L'équipe pédagogique va l'examiner.
                    Vous serez notifié(e) dès qu'un superviseur sera affecté.
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'EN_VALIDATION'}">
                  <div class="alert alert-info">
                    🔍 Votre dossier est en cours d'examen par les superviseurs. Merci de patienter.
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'DOSSIER_INCOMPLET'}">
                  <div class="alert alert-error">
                    ⚠️ Votre dossier nécessite des corrections :
                    <p class="mt-1"><c:out value="${offre.commentaire}"/></p>
                  </div>
                  <a class="btn btn-warning" href="${pageContext.request.contextPath}/offres?action=corriger">
                    ✏️ Corriger mon dossier
                  </a>
                </c:when>

                <c:when test="${offre.statut == 'VALIDEE'}">
                  <div class="alert alert-success">
                    🎉 Votre offre a été validée ! Vous pouvez consulter votre convention de stage.
                  </div>
                  <a class="btn btn-primary" href="${pageContext.request.contextPath}/offres?action=convention">
                    📑 Voir ma convention
                  </a>
                </c:when>

                <c:when test="${offre.statut == 'STAGE_EN_COURS'}">
                  <div class="alert alert-success">
                    🚀 Votre stage est officiellement en cours ! À la fin, déposez votre rapport de stage.
                  </div>
                  <a class="btn btn-primary" href="${pageContext.request.contextPath}/rapports?action=soumettre">
                    📤 Déposer mon rapport de stage
                  </a>
                </c:when>

                <c:when test="${offre.statut == 'PAUSE'}">
                  <div class="alert alert-warning">
                    ⏸️ Votre stage est actuellement en pause. Contactez votre superviseur pour plus d'informations.
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'RAPPORT_SOUMIS'}">
                  <div class="alert alert-info">
                    📥 Votre rapport a été soumis ! Il est en attente de relecture par votre superviseur.
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'EN_CORRECTION'}">
                  <div class="alert alert-error">
                    ⚠️ Votre rapport nécessite des corrections :
                    <p class="mt-1"><c:out value="${offre.commentaire}"/></p>
                  </div>
                  <a class="btn btn-warning" href="${pageContext.request.contextPath}/rapports?action=corriger">
                    ✏️ Corriger mon rapport
                  </a>
                </c:when>

                <c:when test="${offre.statut == 'RAPPORT_VALIDE'}">
                  <div class="alert alert-info">
                    ⭐ Votre rapport a été validé ! La note finale vous sera communiquée après délibération.
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'NOTE_ATTRIBUEE'}">
                  <div class="note-finale-card">
                    <p class="text-muted mb-1">🎓 Votre note finale</p>
                    <div class="note-finale-value">
                      <c:choose>
                        <c:when test="${not empty note}"><c:out value="${note.noteFinale}"/>/20</c:when>
                        <c:otherwise>…/20</c:otherwise>
                      </c:choose>
                    </div>
                    <p class="mt-2"><strong>
                      <c:choose>
                        <c:when test="${not empty note}"><c:out value="${note.mention}"/></c:when>
                        <c:otherwise>En attente</c:otherwise>
                      </c:choose>
                    </strong></p>
                    <p class="text-secondary">
                      <c:if test="${not empty note.appreciation}">« <c:out value="${note.appreciation}"/> »</c:if>
                    </p>
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'ARCHIVE'}">
                  <div class="alert alert-info">
                    🗃️ Votre dossier est archivé. Voici votre résultat final :
                  </div>
                  <div class="note-finale-card">
                    <p class="text-muted mb-1">🏅 Note finale</p>
                    <div class="note-finale-value">
                      <c:choose>
                        <c:when test="${not empty note}"><c:out value="${note.noteFinale}"/>/20</c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </div>
                    <p class="mt-2"><strong>
                      <c:choose>
                        <c:when test="${not empty note}"><c:out value="${note.mention}"/></c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </strong></p>
                  </div>
                </c:when>

                <c:otherwise>
                  <div class="alert alert-info">Statut : <c:out value="${offre.statut}"/></div>
                </c:otherwise>

              </c:choose>
            </div>
          </div>

          <div class="workflow-timeline">
            <h3 class="card-title mb-3">📈 Progression de votre stage</h3>

            <c:set var="progression" value="0"/>
            <c:if test="${offre.statut == 'EN_VALIDATION' || offre.statut == 'DOSSIER_INCOMPLET'}"><c:set var="progression" value="1"/></c:if>
            <c:if test="${offre.statut == 'VALIDEE'}"><c:set var="progression" value="2"/></c:if>
            <c:if test="${offre.statut == 'STAGE_EN_COURS' || offre.statut == 'PAUSE'}"><c:set var="progression" value="3"/></c:if>
            <c:if test="${offre.statut == 'RAPPORT_SOUMIS' || offre.statut == 'EN_CORRECTION'}"><c:set var="progression" value="4"/></c:if>
            <c:if test="${offre.statut == 'RAPPORT_VALIDE'}"><c:set var="progression" value="5"/></c:if>
            <c:if test="${offre.statut == 'NOTE_ATTRIBUEE' || offre.statut == 'ARCHIVE'}"><c:set var="progression" value="6"/></c:if>

            <div class="timeline">
              <div class="timeline-step <c:if test="${progression > 1}">done</c:if><c:if test="${progression == 1}">active</c:if>">
                <div class="timeline-dot">📄</div>
                <div class="timeline-label">Soumis</div>
              </div>
              <div class="timeline-step <c:if test="${progression > 2}">done</c:if><c:if test="${progression == 2}">active</c:if>">
                <div class="timeline-dot">✅</div>
                <div class="timeline-label">Validé</div>
              </div>
              <div class="timeline-step <c:if test="${progression > 3}">done</c:if><c:if test="${progression == 3}">active</c:if>">
                <div class="timeline-dot">🚀</div>
                <div class="timeline-label">En cours</div>
              </div>
              <div class="timeline-step <c:if test="${progression > 4}">done</c:if><c:if test="${progression == 4}">active</c:if>">
                <div class="timeline-dot">📝</div>
                <div class="timeline-label">Rapport</div>
              </div>
              <div class="timeline-step <c:if test="${progression > 5}">done</c:if><c:if test="${progression == 5}">active</c:if>">
                <div class="timeline-dot">🏅</div>
                <div class="timeline-label">Noté</div>
              </div>
              <div class="timeline-step <c:if test="${progression > 6}">done</c:if><c:if test="${progression == 6}">active</c:if>">
                <div class="timeline-dot">🗃️</div>
                <div class="timeline-label">Archivé</div>
              </div>
            </div>
          </div>
        </c:if>
      </div>
    </div>
  </div>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>