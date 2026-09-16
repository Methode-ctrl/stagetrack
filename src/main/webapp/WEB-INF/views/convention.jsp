<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Convention de stage"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Convention de stage</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="javascript:history.back()">← Retour</a>
      </div>

      <div class="page-content page-content-md">
        <div class="hero text-center">
          <div style="font-size:40px;">📑</div>
          <h1><span class="hero-gradient">Convention de stage</span></h1>
          <p>Université Polytechnique de Gitega — Année académique 2025-2026</p>
        </div>

        <c:choose>
          <c:when test="${empty convention}">
            <div class="empty-state">
              <div class="empty-icon">🗂️</div>
              <h3>Aucune convention disponible</h3>
              <p>Votre convention sera générée une fois votre offre validée.</p>
            </div>
          </c:when>
          <c:otherwise>
            <div class="card">
              <div class="card-header">
                <h3 class="card-title">Convention n° <c:out value="${convention.id}"/></h3>
                <span class="badge"><c:out value="${convention.statut}"/></span>
              </div>
              <div class="card-body">
                <p class="text-secondary">
                  Entre les soussignés : l'étudiant ci-après, l'entreprise d'accueil,
                  et l'<strong>Université Polytechnique de Gitega</strong>, il est convenu ce qui suit :
                </p>

                <div class="divider"></div>

                <c:if test="${not empty convention.offreStage}">
                  <div class="grid-2">
                    <div>
                      <p class="text-muted mb-0">👨‍🎓 Étudiant</p>
                      <p class="mt-0"><strong><c:out value="${convention.offreStage.etudiant.utilisateur.prenom}"/> <c:out value="${convention.offreStage.etudiant.utilisateur.nom}"/></strong></p>
                    </div>
                    <div>
                      <p class="text-muted mb-0">🎓 Promotion</p>
                      <p class="mt-0"><strong><c:out value="${convention.offreStage.etudiant.promotion}"/></strong></p>
                    </div>
                    <div>
                      <p class="text-muted mb-0">🏢 Entreprise d'accueil</p>
                      <p class="mt-0"><strong><c:out value="${convention.offreStage.entreprise.nom}"/></strong>
                        <span class="text-secondary">— <c:out value="${convention.offreStage.entreprise.secteur}"/></span></p>
                    </div>
                    <div>
                      <p class="text-muted mb-0">📍 Adresse</p>
                      <p class="mt-0"><c:out value="${convention.offreStage.entreprise.adresse}"/></p>
                    </div>
                    <div>
                      <p class="text-muted mb-0">🤝 Responsable entreprise</p>
                      <p class="mt-0"><c:out value="${convention.offreStage.entreprise.representant}"/>
                        <span class="text-secondary">— <c:out value="${convention.offreStage.entreprise.email}"/></span></p>
                    </div>
                    <div>
                      <p class="text-muted mb-0">👨‍🔬 Superviseur UPG</p>
                      <p class="mt-0">
                        <c:choose>
                          <c:when test="${not empty convention.offreStage.superviseur}">
                            <strong>Dr. <c:out value="${convention.offreStage.superviseur.utilisateur.prenom}"/> <c:out value="${convention.offreStage.superviseur.utilisateur.nom}"/></strong>
                          </c:when>
                          <c:otherwise><span class="text-warning">À déterminer</span></c:otherwise>
                        </c:choose>
                      </p>
                    </div>
                  </div>

                  <div class="divider"></div>

                  <p class="form-label">📄 Objet du stage</p>
                  <p class="mt-0"><strong><c:out value="${convention.offreStage.titre}"/></strong></p>

                  <c:if test="${not empty convention.offreStage.description}">
                    <p class="form-label">📝 Description</p>
                    <p class="mt-0"><c:out value="${convention.offreStage.description}"/></p>
                  </c:if>

                  <div class="grid-2 mt-3">
                    <div>
                      <p class="text-muted mb-0">🗓️ Date de début</p>
                      <p class="mt-0"><strong><c:out value="${convention.offreStage.dateDebut}"/></strong></p>
                    </div>
                    <div>
                      <p class="text-muted mb-0">⏱️ Durée</p>
                      <p class="mt-0"><strong><c:out value="${convention.offreStage.dureeEnMois}"/> mois</strong></p>
                    </div>
                  </div>
                </c:if>

                <c:if test="${not empty convention.contenu}">
                  <div class="divider"></div>
                  <p class="form-label">📄 Contenu de la convention</p>
                  <p class="mt-0"><c:out value="${convention.contenu}"/></p>
                </c:if>

                <div class="divider"></div>

                <div class="grid-2 text-center mt-4">
                  <div>
                    <p class="text-muted mb-0">Fait à Gitega, le _________________</p>
                    <p class="mt-3 mb-0"><strong>L'étudiant</strong></p>
                    <p class="text-secondary mt-0" style="opacity:0.6;">(signature)</p>
                  </div>
                  <div>
                    <p class="text-muted mb-0">Pour l'Université Polytechnique de Gitega</p>
                    <p class="mt-3 mb-0"><strong>Le Directeur</strong></p>
                    <p class="text-secondary mt-0" style="opacity:0.6;">(signature)</p>
                  </div>
                </div>
              </div>
              <div class="card-footer">
                <button type="button" class="btn btn-secondary" onclick="window.print()">🖨️ Imprimer</button>
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