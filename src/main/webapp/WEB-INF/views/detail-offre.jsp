<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Detail du dossier"/>
  <%@ include file="include/head.jsp" %>
  <style>
    .badge {
      padding: 6px 14px;
      border-radius: 20px;
      font-weight: bold;
      font-size: 13px;
      border: 1px solid transparent;
    }
    .badge-warning { background: #fff3cd; color: #856404; border-color: #ffc107; }
    .badge-info { background: #d1ecf1; color: #0c5460; border-color: #17a2b8; }
    .badge-danger { background: #f8d7da; color: #721c24; border-color: #dc3545; }
    .badge-success { background: #d4edda; color: #155724; border-color: #28a745; }
    .badge-primary { background: #cce5ff; color: #004085; border-color: #007bff; }
    .badge-secondary { background: #e2e3e5; color: #383d41; border-color: #6c757d; }
    .badge-orange { background: #ffe5cc; color: #7d3c00; border-color: #fd7e14; }
    .badge-purple { background: #e8d5f5; color: #4a235a; border-color: #6f42c1; }
    .badge-dark { background: #d6d8d9; color: #1b1e21; border-color: #343a40; }
    .summary-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 1rem;
      margin-top: 1rem;
    }
    .action-box {
      padding: 1rem;
      border-radius: var(--radius-md);
      border: 1px solid var(--color-border);
      background: var(--color-surface-alt);
    }
    .action-box h3 {
      margin-bottom: 0.5rem;
      font-size: 1rem;
      color: var(--color-text-primary);
    }
    .action-box p {
      margin-bottom: 0.75rem;
      color: var(--color-text-secondary);
    }
    .action-stack {
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
    }
    .inline-actions {
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
    }
    .details-toggle {
      border: 1px solid var(--color-border);
      border-radius: var(--radius-md);
      background: #ffffff;
      padding: 0.85rem 1rem;
    }
    .details-toggle summary {
      cursor: pointer;
      font-weight: 600;
      color: var(--color-text-primary);
    }
    .details-toggle form {
      margin: 1rem 0 0;
    }
    .info-list {
      display: grid;
      gap: 0.9rem;
    }
    .section-note {
      background: #f8fafc;
      border: 1px solid #dbeafe;
      border-radius: var(--radius-md);
      padding: 1rem;
    }
    .status-line {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      flex-wrap: wrap;
    }
    @media (max-width: 768px) {
      .summary-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/login?action=logout">
  <%@ include file="include/sidebar.jsp" %>

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

  <c:set var="afficherConvention"
         value="${offre.statut == 'VALIDEE'
               or offre.statut == 'STAGE_EN_COURS'
               or offre.statut == 'PAUSE'
               or offre.statut == 'RAPPORT_SOUMIS'
               or offre.statut == 'EN_CORRECTION'
               or offre.statut == 'RAPPORT_VALIDE'
               or offre.statut == 'NOTE_ATTRIBUEE'
               or offre.statut == 'ARCHIVE'}"/>

  <main class="main-content">
    <div class="container">
      <div class="flex-between mb-3">
        <a href="${pageContext.request.contextPath}/offres" class="btn btn-secondary btn-sm">Retour a la liste</a>
      </div>

      <c:if test="${not empty succes}">
        <div class="alert alert-success"><c:out value="${succes}"/></div>
      </c:if>
      <c:if test="${not empty erreur}">
        <div class="alert alert-error"><c:out value="${erreur}"/></div>
      </c:if>

      <div class="detail-header">
        <div class="status-line">
          <h1 style="margin:0;font-size:1.45rem;">Dossier de stage</h1>
          <span class="badge ${badgeClass}"><c:out value="${statutLibelle}"/></span>
        </div>
        <div class="summary-grid">
          <div class="detail-field">
            <div class="detail-field-label">Etudiant</div>
            <div class="detail-field-value">
              <c:out value="${offre.etudiant.utilisateur.prenom}"/>
              <c:out value="${offre.etudiant.utilisateur.nom}"/>
            </div>
          </div>
          <div class="detail-field">
            <div class="detail-field-label">Entreprise</div>
            <div class="detail-field-value"><c:out value="${offre.entreprise.nom}"/></div>
          </div>
          <div class="detail-field">
            <div class="detail-field-label">Poste</div>
            <div class="detail-field-value"><c:out value="${offre.intitulePoste}"/></div>
          </div>
          <div class="detail-field">
            <div class="detail-field-label">Date de debut</div>
            <div class="detail-field-value"><c:out value="${offre.dateDebut}"/></div>
          </div>
          <div class="detail-field">
            <div class="detail-field-label">Duree</div>
            <div class="detail-field-value"><c:out value="${offre.dureeEnMois}"/> mois</div>
          </div>
          <div class="detail-field">
            <div class="detail-field-label">Date de soumission</div>
            <div class="detail-field-value"><c:out value="${offre.dateSoumission}"/></div>
          </div>
        </div>
      </div>

      <div class="detail-grid">
        <div class="info-list">
          <div class="card">
            <div class="card-header">
              <span class="card-title">Informations etudiant</span>
            </div>
            <div class="card-body">
              <div class="detail-field">
                <div class="detail-field-label">Nom complet</div>
                <div class="detail-field-value">
                  <c:out value="${offre.etudiant.utilisateur.prenom}"/>
                  <c:out value="${offre.etudiant.utilisateur.nom}"/>
                </div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Matricule</div>
                <div class="detail-field-value"><c:out value="${offre.etudiant.matricule}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Promotion</div>
                <div class="detail-field-value"><c:out value="${offre.etudiant.promotion}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Email</div>
                <div class="detail-field-value"><c:out value="${offre.etudiant.utilisateur.email}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Telephone</div>
                <div class="detail-field-value"><c:out value="${offre.etudiant.telephone}"/></div>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-header">
              <span class="card-title">Informations entreprise</span>
            </div>
            <div class="card-body">
              <div class="detail-field">
                <div class="detail-field-label">Nom</div>
                <div class="detail-field-value"><c:out value="${offre.entreprise.nom}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Secteur</div>
                <div class="detail-field-value"><c:out value="${offre.entreprise.secteur}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Adresse</div>
                <div class="detail-field-value"><c:out value="${offre.entreprise.adresse}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Ville</div>
                <div class="detail-field-value"><c:out value="${offre.entreprise.ville}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Responsable</div>
                <div class="detail-field-value"><c:out value="${offre.entreprise.nomResponsable}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Email</div>
                <div class="detail-field-value"><c:out value="${offre.entreprise.emailContact}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Telephone</div>
                <div class="detail-field-value"><c:out value="${offre.entreprise.telephone}"/></div>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-header">
              <span class="card-title">Detail du stage</span>
            </div>
            <div class="card-body">
              <div class="detail-field">
                <div class="detail-field-label">Poste</div>
                <div class="detail-field-value"><c:out value="${offre.intitulePoste}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Description</div>
                <div class="detail-field-value"><c:out value="${offre.description}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Taches prevues</div>
                <div class="detail-field-value"><c:out value="${offre.tachesPrevues}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Date de debut</div>
                <div class="detail-field-value"><c:out value="${offre.dateDebut}"/></div>
              </div>
              <div class="detail-field">
                <div class="detail-field-label">Duree</div>
                <div class="detail-field-value"><c:out value="${offre.dureeEnMois}"/> mois</div>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="card-header">
              <span class="card-title">Pieces jointes declarees</span>
            </div>
            <div class="card-body">
              <c:choose>
                <c:when test="${empty offre.piecesJointes}">
                  <p class="text-muted">Aucune piece jointe declaree.</p>
                </c:when>
                <c:otherwise>
                  <div class="notice-box notice-warning">
                    <span class="notice-icon">!</span>
                    <div class="notice-content">
                      <strong>Documents physiques a recuperer</strong>
                      <p>Les fichiers declares ici doivent etre remis en main propre ou transmis directement au superviseur.</p>
                    </div>
                  </div>
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Type</th>
                        <th>Nom du fichier</th>
                        <th>Date</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${offre.piecesJointes}" var="piece">
                        <tr>
                          <td><c:out value="${piece.typePiece}"/></td>
                          <td><code class="filename"><c:out value="${piece.nomFichier}"/></code></td>
                          <td><c:out value="${piece.dateAjout}"/></td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

          <c:if test="${not empty offre.commentaireSuperviseur}">
            <div class="card">
              <div class="card-header">
                <span class="card-title">Commentaire superviseur</span>
              </div>
              <div class="card-body">
                <div class="alert alert-warning" style="margin-bottom:0;">
                  <c:out value="${offre.commentaireSuperviseur}"/>
                </div>
              </div>
            </div>
          </c:if>

          <c:if test="${afficherConvention}">
            <div class="card">
              <div class="card-header">
                <span class="card-title">Convention</span>
              </div>
              <div class="card-body">
                <c:choose>
                  <c:when test="${not empty offre.convention}">
                    <p class="mb-3">La convention associee au dossier est disponible.</p>
                    <a href="${pageContext.request.contextPath}/conventions?action=voir&id=${offre.convention.id}"
                       class="btn btn-secondary btn-sm">Voir la convention</a>
                  </c:when>
                  <c:otherwise>
                    <div class="notice-box notice-info">
                      <span class="notice-icon">i</span>
                      <div class="notice-content">
                        <strong>Convention non encore disponible</strong>
                        <p>Le dossier est deja dans une phase qui necessite une convention, mais aucun document n'est encore rattache.</p>
                      </div>
                    </div>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </c:if>

          <c:if test="${not empty offre.rapport}">
            <div class="card">
              <div class="card-header">
                <span class="card-title">Rapport de stage</span>
              </div>
              <div class="card-body">
                <div class="detail-field">
                  <div class="detail-field-label">Titre</div>
                  <div class="detail-field-value"><c:out value="${offre.rapport.titre}"/></div>
                </div>
                <div class="detail-field">
                  <div class="detail-field-label">Resume</div>
                  <div class="detail-field-value"><c:out value="${offre.rapport.resume}"/></div>
                </div>
                <div class="detail-field">
                  <div class="detail-field-label">Competences acquises</div>
                  <div class="detail-field-value"><c:out value="${offre.rapport.competencesAcquises}"/></div>
                </div>
                <div class="detail-field">
                  <div class="detail-field-label">Fichier PDF declare</div>
                  <div class="detail-field-value"><code class="filename"><c:out value="${offre.rapport.nomFichierPdf}"/></code></div>
                </div>
              </div>
            </div>
          </c:if>

          <c:if test="${not empty offre.rapport and not empty offre.rapport.note}">
            <div class="card">
              <div class="card-header">
                <span class="card-title">Note finale</span>
              </div>
              <div class="card-body">
                <div class="section-note">
                  <div class="detail-field">
                    <div class="detail-field-label">Note de stage</div>
                    <div class="detail-field-value"><c:out value="${offre.rapport.note.noteStage}"/> / 20</div>
                  </div>
                  <div class="detail-field">
                    <div class="detail-field-label">Note du rapport</div>
                    <div class="detail-field-value"><c:out value="${offre.rapport.note.noteRapport}"/> / 20</div>
                  </div>
                  <div class="detail-field">
                    <div class="detail-field-label">Note de presentation</div>
                    <div class="detail-field-value"><c:out value="${offre.rapport.note.notePresentation}"/> / 20</div>
                  </div>
                  <div class="detail-field">
                    <div class="detail-field-label">Note finale</div>
                    <div class="detail-field-value"><strong><c:out value="${offre.rapport.note.noteFinale}"/> / 20</strong></div>
                  </div>
                  <div class="detail-field" style="margin-bottom:0;">
                    <div class="detail-field-label">Mention</div>
                    <div class="detail-field-value"><c:out value="${offre.rapport.note.mention}"/></div>
                  </div>
                </div>
              </div>
            </div>
          </c:if>
        </div>

        <div>
          <div class="card">
            <div class="card-header">
              <span class="card-title">Actions</span>
            </div>
            <div class="card-body action-stack">

              <c:if test="${sessionScope.role == 'SUPERVISEUR'}">
                <c:choose>
                  <c:when test="${offre.statut == 'OFFRE_SOUMISE'}">
                    <div class="action-box">
                      <h3>Dossier en attente d'examen</h3>
                      <p>Le dossier vient d'etre soumis. Vous pouvez l'ouvrir pour commencer la validation.</p>
                      <form method="post" action="${pageContext.request.contextPath}/offres">
                        <input type="hidden" name="action" value="ouvrir"/>
                        <input type="hidden" name="offreId" value="${offre.id}"/>
                        <button type="submit" class="btn btn-primary btn-block">Ouvrir et examiner le dossier</button>
                      </form>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'EN_VALIDATION'}">
                    <div class="action-box">
                      <h3>Dossier en cours d'examen</h3>
                      <p>Le dossier est en analyse. Vous pouvez le valider ou demander des corrections detaillees.</p>
                      <div class="inline-actions">
                        <form method="post" action="${pageContext.request.contextPath}/offres">
                          <input type="hidden" name="action" value="valider"/>
                          <input type="hidden" name="offreId" value="${offre.id}"/>
                          <button type="submit" class="btn btn-success btn-block">Valider le dossier</button>
                        </form>

                        <details class="details-toggle">
                          <summary>Dossier incomplet</summary>
                          <form method="post" action="${pageContext.request.contextPath}/offres">
                            <input type="hidden" name="action" value="incomplet"/>
                            <input type="hidden" name="offreId" value="${offre.id}"/>
                            <div class="form-group">
                              <label class="form-label required" for="motif">Motif des corrections</label>
                              <textarea id="motif" name="motif" class="form-control" rows="4"
                                        minlength="10" required
                                        placeholder="Expliquez clairement ce qui manque ou doit etre corrige."></textarea>
                            </div>
                            <button type="submit" class="btn btn-warning btn-block">Envoyer le dossier en incomplet</button>
                          </form>
                        </details>
                      </div>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'DOSSIER_INCOMPLET'}">
                    <div class="action-box">
                      <h3>Dossier incomplet</h3>
                      <p>Le dossier attend les corrections de l'etudiant avant toute nouvelle action.</p>
                      <c:if test="${not empty offre.commentaireSuperviseur}">
                        <div class="alert alert-warning" style="margin-bottom:0;">
                          Motif envoye a l'etudiant : <c:out value="${offre.commentaireSuperviseur}"/>
                        </div>
                      </c:if>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'VALIDEE'}">
                    <div class="action-box">
                      <h3>Dossier valide</h3>
                      <p>Le dossier est pret pour la convention et le lancement du stage.</p>
                      <form method="post" action="${pageContext.request.contextPath}/offres">
                        <input type="hidden" name="action" value="demarrer"/>
                        <input type="hidden" name="offreId" value="${offre.id}"/>
                        <button type="submit" class="btn btn-primary btn-block">Generer la convention et demarrer le stage</button>
                      </form>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'STAGE_EN_COURS'}">
                    <div class="action-box">
                      <h3>Stage en cours</h3>
                      <p>Le stage est actif. Vous pouvez le suspendre temporairement en precisant la raison.</p>
                      <details class="details-toggle" open>
                        <summary>Mettre le stage en pause</summary>
                        <form method="post" action="${pageContext.request.contextPath}/offres">
                          <input type="hidden" name="action" value="pause"/>
                          <input type="hidden" name="offreId" value="${offre.id}"/>
                          <div class="form-group">
                            <label class="form-label required" for="raison">Raison de la pause</label>
                            <textarea id="raison" name="raison" class="form-control" rows="4"
                                      minlength="10" required
                                      placeholder="Precisez le contexte de la suspension temporaire."></textarea>
                          </div>
                          <button type="submit" class="btn btn-warning btn-block">Mettre en pause</button>
                        </form>
                      </details>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'PAUSE'}">
                    <div class="action-box">
                      <h3>Stage en pause</h3>
                      <p>Le stage est temporairement suspendu.</p>
                      <c:if test="${not empty offre.commentaireSuperviseur}">
                        <div class="alert alert-warning">
                          Raison : <c:out value="${offre.commentaireSuperviseur}"/>
                        </div>
                      </c:if>
                      <form method="post" action="${pageContext.request.contextPath}/offres">
                        <input type="hidden" name="action" value="reprendre"/>
                        <input type="hidden" name="offreId" value="${offre.id}"/>
                        <button type="submit" class="btn btn-success btn-block">Reprendre le stage</button>
                      </form>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'RAPPORT_SOUMIS'}">
                    <div class="action-box">
                      <h3>Rapport soumis</h3>
                      <p>Le rapport attend votre evaluation finale. Demandez aussi le fichier PDF physique ou transmis directement.</p>
                      <c:if test="${not empty offre.rapport}">
                        <div class="alert alert-info">
                          Fichier declare : <code class="filename"><c:out value="${offre.rapport.nomFichierPdf}"/></code>
                        </div>
                      </c:if>
                      <div class="inline-actions">
                        <form method="post" action="${pageContext.request.contextPath}/offres">
                          <input type="hidden" name="action" value="valider-rapport"/>
                          <input type="hidden" name="offreId" value="${offre.id}"/>
                          <button type="submit" class="btn btn-success btn-block">Valider le rapport</button>
                        </form>

                        <details class="details-toggle">
                          <summary>Demander des corrections</summary>
                          <form method="post" action="${pageContext.request.contextPath}/offres">
                            <input type="hidden" name="action" value="corriger-rapport"/>
                            <input type="hidden" name="offreId" value="${offre.id}"/>
                            <div class="form-group">
                              <label class="form-label required" for="commentaire">Commentaire de correction</label>
                              <textarea id="commentaire" name="commentaire" class="form-control" rows="4"
                                        minlength="10" required
                                        placeholder="Expliquez les ajustements attendus sur le rapport."></textarea>
                            </div>
                            <button type="submit" class="btn btn-warning btn-block">Retourner le rapport en correction</button>
                          </form>
                        </details>
                      </div>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'EN_CORRECTION'}">
                    <div class="action-box">
                      <h3>Rapport en correction</h3>
                      <p>L'etudiant corrige actuellement son rapport. Une nouvelle soumission est necessaire avant validation.</p>
                      <c:if test="${not empty offre.commentaireSuperviseur}">
                        <div class="alert alert-warning">
                          Commentaire envoye : <c:out value="${offre.commentaireSuperviseur}"/>
                        </div>
                      </c:if>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'RAPPORT_VALIDE'}">
                    <div class="action-box">
                      <h3>Rapport valide</h3>
                      <p>Le rapport est accepte. Vous pouvez maintenant attribuer la note finale.</p>
                      <a href="${pageContext.request.contextPath}/notes?action=evaluer&offreId=${offre.id}"
                         class="btn btn-primary btn-block">Attribuer la note finale</a>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'NOTE_ATTRIBUEE'}">
                    <div class="action-box">
                      <h3>Note attribuee</h3>
                      <p>Le dossier attend maintenant l'archivage par l'administration.</p>
                      <c:if test="${not empty offre.rapport and not empty offre.rapport.note}">
                        <div class="alert alert-success" style="margin-bottom:0;">
                          Note finale : <c:out value="${offre.rapport.note.noteFinale}"/> / 20
                          <br/>
                          Mention : <c:out value="${offre.rapport.note.mention}"/>
                        </div>
                      </c:if>
                    </div>
                  </c:when>

                  <c:when test="${offre.statut == 'ARCHIVE'}">
                    <div class="action-box">
                      <h3>Dossier archive</h3>
                      <p>Le traitement du dossier est termine.</p>
                    </div>
                  </c:when>
                </c:choose>
              </c:if>

              <c:if test="${sessionScope.role == 'ADMIN'}">
                <div class="action-box">
                  <h3>Actions administration</h3>
                  <c:choose>
                    <c:when test="${empty offre.superviseur}">
                      <p>Aucun superviseur n'est encore affecte a ce dossier.</p>
                      <a href="${pageContext.request.contextPath}/dashboard/admin" class="btn btn-secondary btn-block">Affecter depuis le dashboard admin</a>
                    </c:when>
                    <c:otherwise>
                      <p>Ce dossier est deja rattache au superviseur
                        <strong>
                          <c:out value="${offre.superviseur.utilisateur.prenom}"/>
                          <c:out value="${offre.superviseur.utilisateur.nom}"/>
                        </strong>.
                      </p>
                    </c:otherwise>
                  </c:choose>
                </div>
              </c:if>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
