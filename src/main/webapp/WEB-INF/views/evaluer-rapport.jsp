<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Évaluer le rapport"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Évaluation</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="javascript:history.back()">← Retour</a>
      </div>

      <div class="page-content page-content-md">
        <div class="hero">
          <h1>🏅 <span class="hero-gradient">Attribuer la note finale</span></h1>
          <p>Rapport : <c:out value="${rapport.titre}"/></p>
        </div>

        <c:if test="${not empty erreurs}">
          <div class="alert alert-error">
            <c:forEach items="${erreurs}" var="err"><p class="mb-1"><c:out value="${err}"/></p></c:forEach>
          </div>
        </c:if>
        <c:if test="${not empty erreur}">
          <div class="alert alert-error"><c:out value="${erreur}"/></div>
        </c:if>

        <div class="card mb-4">
          <div class="card-header"><h3 class="card-title">🎓 Étudiant</h3></div>
          <div class="card-body">
            <p class="mb-0"><strong><c:out value="${rapport.offreStage.etudiant.utilisateur.prenom}"/> <c:out value="${rapport.offreStage.etudiant.utilisateur.nom}"/></strong></p>
            <p class="text-secondary mt-0 mb-0">Stage : <c:out value="${rapport.offreStage.titre}"/> — <c:out value="${rapport.offreStage.entreprise.nom}"/></p>
          </div>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/notes">
          <input type="hidden" name="rapportId" value="<c:out value="${rapport.id}"/>"/>

          <div class="card mb-4">
            <div class="card-header"><h3 class="card-title">📊 Notes par critère</h3></div>
            <div class="card-body">
              <div class="grid-2">
                <div class="form-group">
                  <label class="form-label">Note de stage (×40%) <span class="required">*</span></label>
                  <input class="form-control" type="number" id="noteStage" name="noteStage"
                         min="0" max="20" step="0.5" required
                         placeholder="0 à 20"/>
                  <p class="form-hint">Assiduité, implication, réalisation des tâches.</p>
                </div>
                <div class="form-group">
                  <label class="form-label">Note du rapport (×40%) <span class="required">*</span></label>
                  <input class="form-control" type="number" id="noteRapport" name="noteRapport"
                         min="0" max="20" step="0.5" required
                         placeholder="0 à 20"/>
                  <p class="form-hint">Qualité rédactionnelle, pertinence du contenu.</p>
                </div>
                <div class="form-group">
                  <label class="form-label">Note de présentation (×20%) <span class="required">*</span></label>
                  <input class="form-control" type="number" id="notePresence" name="notePresence"
                         min="0" max="20" step="0.5" required
                         placeholder="0 à 20"/>
                  <p class="form-hint">Soutenance, communication, supports utilisés.</p>
                </div>
                <div class="card" style="background:var(--bg-secondary);">
                  <div class="card-body text-center">
                    <p class="text-muted mb-0">Note finale calculée</p>
                    <p class="note-finale-value mt-0" id="noteFinaleAffichee" style="font-size:44px;">—</p>
                    <p class="mt-1 mb-0"><strong id="mentionAffichee" style="color:var(--text-secondary);">—</strong></p>
                  </div>
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">Appréciation <span class="required">*</span></label>
                <textarea class="form-control" name="appreciation" rows="4" required
                          placeholder="Rédigez une appréciation détaillée du travail de l'étudiant…"></textarea>
              </div>
            </div>
          </div>

          <button type="submit" class="btn btn-success btn-lg">✅ Valider et attribuer la note</button>
        </form>
      </div>
    </div>
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>