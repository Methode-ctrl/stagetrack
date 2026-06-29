<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Mon espace etudiant"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/login?action=logout">


  <%@ include file="include/sidebar.jsp" %>

  <main class="main-content">

      <div class="hero">
        <div class="hero-title">Bonjour, <c:out value="${sessionScope.utilisateur.prenom}"/></div>
        <div class="hero-subtitle">Espace etudiant - Suivi de stage</div>
      </div>

      <div class="offres-grid">
        <c:choose>
          <c:when test="${not empty offres}">
            <c:forEach items="${offres}" var="offre">
              <div class="offre-card">
                <div class="offre-header">
                  <div class="offre-title-group">
                    <div class="offre-title">
                      <c:out value="${offre.intitulePoste}"/>
                    </div>
                    <div class="offre-company">
                      <c:out value="${offre.entreprise.nom}"/>
                    </div>
                  </div>
                  <div class="offre-status">
                    <span class="badge badge-${offre.statut}"><c:out value="${offre.statut}"/></span>
                  </div>
                </div>

                <div class="offre-body">
                  <c:if test="${not empty offre.superviseur}">
                    <div class="superviseur-info">
                      <c:out value="${offre.superviseur.utilisateur.prenom}"/> <c:out value="${offre.superviseur.utilisateur.nom}"/>
                    </div>
                  </c:if>

                  <c:choose>
                    <c:when test="${offre.statut == 'OFFRE_SOUMISE'}">
                      <div class="alert-box alert-info">
                        Votre dossier est en cours d'examen. Vous recevrez une notification dès que votre superviseur aura examiné votre candidature.
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'EN_VALIDATION'}">
                      <div class="alert-box alert-info">
                        Votre dossier est actuellement examiné par votre superviseur. Vous serez notifié de sa décision très prochainement.
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'DOSSIER_INCOMPLET'}">
                      <div class="alert-box alert-error">
                        <strong>Action requise</strong>
                        <p>Le superviseur a demandé des compléments à votre dossier :</p>
                        <p><c:out value="${offre.commentaireSuperviseur}"/></p>
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'VALIDEE'}">
                      <div class="alert-box alert-success">
                        Votre dossier a été approuvé ! Votre convention de stage est maintenant disponible.
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'STAGE_EN_COURS'}">
                      <div class="alert-box alert-success">
                        Votre stage est actuellement en cours. Bon courage !
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'PAUSE'}">
                      <div class="alert-box alert-warning">
                        Votre stage est actuellement en pause. Merci de contacter votre superviseur pour plus d'informations.
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'RAPPORT_SOUMIS'}">
                      <div class="alert-box alert-info">
                        Votre rapport de stage a été soumis. Il est maintenant en cours d'évaluation.
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'EN_CORRECTION'}">
                      <div class="alert-box alert-error">
                        <strong>Corrections nécessaires</strong>
                        <p>Veuillez corriger votre rapport selon les commentaires de votre superviseur :</p>
                        <p><c:out value="${offre.commentaireSuperviseur}"/></p>
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'RAPPORT_VALIDE'}">
                      <div class="alert-box alert-success">
                        Votre rapport a été validé. Votre évaluation est en cours.
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'NOTE_ATTRIBUEE'}">
                      <div class="alert-box alert-success">
                        Votre note finale a été attribuée.
                      </div>
                    </c:when>
                    <c:when test="${offre.statut == 'ARCHIVE'}">
                      <div class="alert-box alert-info">
                        Votre dossier de stage est archivé. Votre stage est maintenant terminé.
                      </div>
                    </c:when>
                  </c:choose>

                  <!-- Détails du stage -->
                  <div class="stage-details">
                    <div class="detail-item">
                      <div class="detail-label">Date de début</div>
                      <div class="detail-value">
                        <c:out value="${offre.dateDebut}"/>
                      </div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">Durée</div>
                      <div class="detail-value">
                        <c:out value="${offre.dureeEnMois}"/> mois
                      </div>
                    </div>
                    <div class="detail-item">
                      <div class="detail-label">Localité</div>
                      <div class="detail-value">
                        <c:out value="${offre.entreprise.ville}"/>
                      </div>
                    </div>
                  </div>

                  <!-- Fichiers du rapport -->
                  <c:if test="${not empty offre.rapport}">
                    <div class="files-section">
                      <div class="files-section-title">📎 Fichiers déposés</div>
                      <ul class="files-list">
                        <c:if test="${not empty offre.rapport.nomFichierPdf}">
                          <li>
                            <a href="${pageContext.request.contextPath}/rapports/download/${offre.rapport.id}/pdf" class="file-chip">
                              <span class="file-icon">📄</span>
                              <span class="file-name">Rapport PDF</span>
                            </a>
                          </li>
                        </c:if>
                        <c:if test="${not empty offre.rapport.nomFichierAnnexe}">
                          <li>
                            <a href="${pageContext.request.contextPath}/rapports/download/${offre.rapport.id}/annexe" class="file-chip">
                              <span class="file-icon">📎</span>
                              <span class="file-name">Annexes</span>
                            </a>
                          </li>
                        </c:if>
                      </ul>
                    </div>
                  </c:if>

                  <!-- Évaluation et notes -->
                  <c:if test="${not empty offre.rapport and not empty offre.rapport.note}">
                    <div class="evaluation-section">
                      <div class="evaluation-title">Votre évaluation</div>
                      
                      <div class="notes-grid">
                        <div class="note-card">
                          <div class="note-label">Note Stage</div>
                          <div class="note-value"><c:out value="${offre.rapport.note.noteStage}"/></div>
                          <div class="note-max">/ 20</div>
                        </div>
                        <div class="note-card">
                          <div class="note-label">Note Rapport</div>
                          <div class="note-value"><c:out value="${offre.rapport.note.noteRapport}"/></div>
                          <div class="note-max">/ 20</div>
                        </div>
                        <div class="note-card">
                          <div class="note-label">Note Présentation</div>
                          <div class="note-value"><c:out value="${offre.rapport.note.notePresentation}"/></div>
                          <div class="note-max">/ 20</div>
                        </div>
                        <div class="note-card">
                          <div class="note-label">Note Finale</div>
                          <div class="note-value"><c:out value="${offre.rapport.note.noteFinale}"/></div>
                          <div class="note-max">/ 20</div>
                        </div>
                      </div>

                      <div style="text-align: center; margin-bottom: 1.5rem;">
                        <span class="mention-badge">
                          Mention : <strong><c:out value="${offre.rapport.note.mention}"/></strong>
                        </span>
                      </div>

                      <c:if test="${not empty offre.rapport.note.appreciation}">
                        <div class="appreciation-card">
                          <div class="appreciation-label">Appréciation du superviseur</div>
                          <div class="appreciation-text">
                            <c:out value="${offre.rapport.note.appreciation}"/>
                          </div>
                        </div>
                      </c:if>
                    </div>
                  </c:if>

                </div>

                <!-- Actions -->
                <div class="offre-actions">
                  <a href="${pageContext.request.contextPath}/offres?action=detail&id=${offre.id}"
                     class="action-button">Voir le dossier complet</a>
                  <c:if test="${offre.statut == 'VALIDEE' or offre.statut == 'STAGE_EN_COURS'}">
                    <a href="${pageContext.request.contextPath}/conventions?offreId=${offre.id}"
                       class="action-button secondary">Consulter la convention</a>
                  </c:if>
                  <c:if test="${offre.statut == 'DOSSIER_INCOMPLET'}">
                    <a href="${pageContext.request.contextPath}/offres?action=new"
                       class="action-button" style="background: linear-gradient(135deg, #f59e0b, #d97706);">Corriger mon dossier</a>
                  </c:if>
                  <c:if test="${offre.statut == 'STAGE_EN_COURS'}">
                    <a href="${pageContext.request.contextPath}/rapports?action=new"
                       class="action-button">Déposer mon rapport</a>
                  </c:if>
                  <c:if test="${offre.statut == 'EN_CORRECTION'}">
                    <a href="${pageContext.request.contextPath}/rapports?action=new"
                       class="action-button" style="background: linear-gradient(135deg, #f59e0b, #d97706);">Corriger mon rapport</a>
                  </c:if>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div style="text-align: center; padding: 3rem; grid-column: 1; animation: fadeInUp 0.6s ease both;">
              <div class="empty-state-icon">📚</div>
              <div class="empty-state-title">Aucun dossier de stage pour le moment</div>
              <p class="empty-state-message">Soumettez votre première offre de stage pour commencer votre parcours professionnel.</p>
              <a href="${pageContext.request.contextPath}/offres?action=new" class="btn btn-primary">
                Soumettre une offre de stage
              </a>
            </div>
          </c:otherwise>
        </c:choose>
      </div>
  </main>

  <%@ include file="include/footer.jsp" %>

  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>

</body>
</html>

