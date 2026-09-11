<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Détail du dossier"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>

    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Dossier de stage</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="javascript:history.back()">← Retour</a>
      </div>

      <div class="page-content">
        <div class="hero flex-between">
          <div>
            <h1>📁 <span class="hero-gradient"><c:out value="${offre.etudiant.prenom}"/> <c:out value="${offre.etudiant.nom}"/></span></h1>
            <p>Dossier de stage n° <c:out value="${offre.id}"/></p>
          </div>
          <span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span>
        </div>

        <div class="card mb-4">
          <div class="card-header"><h3 class="card-title">🏢 Informations du dossier</h3></div>
          <div class="card-body">
            <div class="grid-2">
              <div>
                <p class="text-muted mb-0">👨‍🎓 Étudiant</p>
                <p class="mt-0"><strong><c:out value="${offre.etudiant.prenom}"/> <c:out value="${offre.etudiant.nom}"/></strong></p>
              </div>
              <div>
                <p class="text-muted mb-0">🏢 Entreprise</p>
                <p class="mt-0"><strong><c:out value="${offre.entreprise.nom}"/></strong>
                  <span class="text-secondary">— <c:out value="${offre.entreprise.secteur}"/>, <c:out value="${offre.entreprise.ville}"/></span></p>
              </div>
              <div>
                <p class="text-muted mb-0">💼 Poste</p>
                <p class="mt-0"><strong><c:out value="${offre.intitulePoste}"/></strong></p>
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

            <c:if test="${not empty offre.description || not empty offre.tachesPrevues}">
              <div class="divider"></div>
              <div class="grid-2">
                <c:if test="${not empty offre.description}">
                  <div>
                    <p class="text-muted mb-0">📝 Description</p>
                    <p class="mt-1"><c:out value="${offre.description}"/></p>
                  </div>
                </c:if>
                <c:if test="${not empty offre.tachesPrevues}">
                  <div>
                    <p class="text-muted mb-0">🎯 Tâches prévues</p>
                    <p class="mt-1"><c:out value="${offre.tachesPrevues}"/></p>
                  </div>
                </c:if>
              </div>
            </c:if>

            <div class="divider"></div>

            <div>
              <p class="text-muted mb-0">👨‍🔬 Superviseur</p>
              <p class="mt-1">
                <c:choose>
                  <c:when test="${not empty offre.superviseur}">
                    <strong>Dr. <c:out value="${offre.superviseur.prenom}"/> <c:out value="${offre.superviseur.nom}"/></strong>
                  </c:when>
                  <c:otherwise><span class="text-warning">⚠️ Aucun superviseur affecté</span></c:otherwise>
                </c:choose>
              </p>
            </div>

            <div class="divider"></div>

            <p class="text-muted mb-1">📎 Pièces jointes</p>
            <c:choose>
              <c:when test="${empty offre.nomFichierLettre && empty offre.nomFichierCV}">
                <p class="text-secondary">Aucune pièce jointe.</p>
              </c:when>
              <c:otherwise>
                <div class="order-list">
                  <c:if test="${not empty offre.nomFichierLettre}">
                    <div class="order-item">
                      <div class="order-avatar green">📜</div>
                      <div class="order-body">
                        <div class="order-name">Lettre d'acceptation</div>
                        <div class="order-meta"><c:out value="${offre.nomFichierLettre}"/></div>
                      </div>
                    </div>
                  </c:if>
                  <c:if test="${not empty offre.nomFichierCV}">
                    <div class="order-item">
                      <div class="order-avatar green">👤</div>
                      <div class="order-body">
                        <div class="order-name">Curriculum Vitae</div>
                        <div class="order-meta"><c:out value="${offre.nomFichierCV}"/></div>
                      </div>
                    </div>
                  </c:if>
                </div>
              </c:otherwise>
            </c:choose>

            <c:if test="${not empty offre.commentaire}">
              <div class="divider"></div>
              <div class="alert alert-warning">
                💬 Commentaire : <c:out value="${offre.commentaire}"/>
              </div>
            </c:if>
          </div>
        </div>

        <c:if test="${sessionScope.role == 'ADMIN'}">
          <div class="card mb-4">
            <div class="card-header"><h3 class="card-title">⚙️ Actions administrateur</h3></div>
            <div class="card-body">

              <c:if test="${empty offre.superviseur}">
                <form class="flex flex-wrap gap-2" method="post"
                      action="${pageContext.request.contextPath}/offres?action=affecter">
                  <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                  <select name="superviseurId" class="form-control" style="width:auto;" required>
                    <option value="" disabled selected>Affecter un superviseur…</option>
                    <c:forEach items="${superviseurs}" var="sup">
                      <option value="<c:out value="${sup.id}"/>">
                        <c:out value="${sup.prenom}"/> <c:out value="${sup.nom}"/>
                      </option>
                    </c:forEach>
                  </select>
                  <button type="submit" class="btn btn-primary">👨‍🔬 Affecter</button>
                </form>
              </c:if>

              <c:if test="${offre.statut == 'NOTE_ATTRIBUEE'}">
                <form class="inline-form" method="post"
                      action="${pageContext.request.contextPath}/offres?action=archiver">
                  <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                  <button type="submit" class="btn btn-secondary">🗃️ Archiver le dossier</button>
                </form>
              </c:if>

              <c:if test="${not empty offre.superviseur && offre.statut != 'NOTE_ATTRIBUEE'}">
                <p class="text-muted mb-0">Ce dossier est déjà affecté et aucune action administrative n'est requise.</p>
              </c:if>
            </div>
          </div>
        </c:if>

        <c:if test="${sessionScope.role == 'SUPERVISEUR'}">
          <div class="card mb-4">
            <div class="card-header"><h3 class="card-title">⚙️ Traitement du dossier</h3></div>
            <div class="card-body">

              <c:choose>

                <c:when test="${offre.statut == 'OFFRE_SOUMISE'}">
                  <div class="alert alert-info">
                    📥 Ce dossier vient d'être soumis. Ouvrez-le pour l'examiner.
                  </div>
                  <form class="inline-form" method="post"
                        action="${pageContext.request.contextPath}/offres?action=ouvrir">
                    <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                    <button type="submit" class="btn btn-primary">🔓 Ouvrir le dossier</button>
                  </form>
                </c:when>

                <c:when test="${offre.statut == 'EN_VALIDATION'}">
                  <div class="alert alert-info">
                    🔍 Le dossier est en cours d'examen. Validez-le ou demandez une correction.
                  </div>
                  <div class="flex flex-wrap gap-2">
                    <form class="inline-form" method="post"
                          action="${pageContext.request.contextPath}/offres?action=valider">
                      <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                      <button type="submit" class="btn btn-success">✅ Valider le dossier</button>
                    </form>
                    <details class="mt-2">
                      <summary class="btn btn-warning btn-sm" style="display:inline-flex;">✏️ Demander une correction</summary>
                      <form class="mt-2 card" style="padding:16px;" method="post"
                            action="${pageContext.request.contextPath}/offres?action=corriger">
                        <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                        <div class="form-group">
                          <label class="form-label">Motif de la correction <span class="required">*</span></label>
                          <textarea class="form-control" name="commentaire" rows="3" required
                                    placeholder="Expliquez ce qui doit être corrigé…"></textarea>
                        </div>
                        <button type="submit" class="btn btn-warning">Envoyer la demande</button>
                      </form>
                    </details>
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'VALIDEE'}">
                  <div class="alert alert-success">
                    ✅ Dossier validé. Démarrez le stage quand l'étudiant est prêt.
                  </div>
                  <form class="inline-form" method="post"
                        action="${pageContext.request.contextPath}/offres?action=demarrer">
                    <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                    <button type="submit" class="btn btn-success">🚀 Démarrer le stage</button>
                  </form>
                </c:when>

                <c:when test="${offre.statut == 'STAGE_EN_COURS'}">
                  <div class="alert alert-info">
                    🚀 Le stage est en cours. Vous pouvez le mettre en pause si nécessaire.
                  </div>
                  <form class="inline-form" method="post"
                        action="${pageContext.request.contextPath}/offres?action=pause">
                    <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                    <button type="submit" class="btn btn-warning">⏸️ Mettre en pause</button>
                  </form>
                </c:when>

                <c:when test="${offre.statut == 'PAUSE'}">
                  <div class="alert alert-warning">
                    ⏸️ Le stage est en pause.
                  </div>
                  <form class="inline-form" method="post"
                        action="${pageContext.request.contextPath}/offres?action=reprendre">
                    <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                    <button type="submit" class="btn btn-success">▶️ Reprendre le stage</button>
                  </form>
                </c:when>

                <c:when test="${offre.statut == 'RAPPORT_SOUMIS'}">
                  <div class="alert alert-info">
                    📥 L'étudiant a soumis son rapport. Validez-le ou demandez une correction.
                  </div>
                  <div class="flex flex-wrap gap-2">
                    <form class="inline-form" method="post"
                          action="${pageContext.request.contextPath}/rapports?action=valider">
                      <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                      <button type="submit" class="btn btn-success">✅ Valider le rapport</button>
                    </form>
                    <details class="mt-2">
                      <summary class="btn btn-warning btn-sm" style="display:inline-flex;">✏️ Demander une correction</summary>
                      <form class="mt-2 card" style="padding:16px;" method="post"
                            action="${pageContext.request.contextPath}/rapports?action=corriger">
                        <input type="hidden" name="offreId" value="<c:out value="${offre.id}"/>"/>
                        <div class="form-group">
                          <label class="form-label">Motif de la correction <span class="required">*</span></label>
                          <textarea class="form-control" name="commentaire" rows="3" required
                                    placeholder="Expliquez ce qui doit être corrigé…"></textarea>
                        </div>
                        <button type="submit" class="btn btn-warning">Envoyer la demande</button>
                      </form>
                    </details>
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'RAPPORT_VALIDE'}">
                  <div class="alert alert-success">
                    ⭐ Rapport validé ! Attribuez maintenant la note finale.
                  </div>
                  <a class="btn btn-primary"
                     href="${pageContext.request.contextPath}/notes?offreId=${offre.id}">
                    🏅 Attribuer la note
                  </a>
                </c:when>

                <c:when test="${offre.statut == 'DOSSIER_INCOMPLET' || offre.statut == 'EN_CORRECTION'}">
                  <div class="alert alert-warning">
                    ⏳ Correction demandée, en attente de la réponse de l'étudiant.
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'NOTE_ATTRIBUEE'}">
                  <div class="alert alert-success">
                    🏅 Note attribuée. Le dossier attend l'archivage par l'administrateur.
                  </div>
                </c:when>

                <c:when test="${offre.statut == 'ARCHIVE'}">
                  <div class="alert alert-info">
                    🗃️ Ce dossier est archivé.
                  </div>
                </c:when>

                <c:otherwise>
                  <div class="alert alert-info">Aucune action disponible pour le statut <c:out value="${offre.statut}"/>.</div>
                </c:otherwise>

              </c:choose>
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