<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Soumettre une offre – Étape 2"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard">
  <%@ include file="include/navbar.jsp" %>
  <main class="main-content">
    <div class="container">
      <div class="form-card">
        <div class="steps mb-4">
          <div class="step completed">
            <div class="step-circle">✓</div>
            <div class="step-label">Entreprise</div>
          </div>
          <div class="step active">
            <div class="step-circle">2</div>
            <div class="step-label">Stage</div>
          </div>
          <div class="step pending">
            <div class="step-circle">3</div>
            <div class="step-label">Documents</div>
          </div>
        </div>

        <h2>Soumettre mon offre de stage – Étape 2/3</h2>
        <p class="text-secondary mb-3">Détails du poste et du stage</p>

        <c:if test="${not empty erreurs}">
          <c:forEach items="${erreurs}" var="erreur">
            <div class="alert alert-error"><c:out value="${erreur}"/></div>
          </c:forEach>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/offres?action=soumettre-etape2" novalidate>
          <div class="form-group">
            <label class="form-label required" for="intitulePoste">Intitulé du poste</label>
            <input type="text" id="intitulePoste" name="intitulePoste" class="form-control"
                   placeholder="Développeur Web Java EE" required maxlength="200"
                   value="${param.intitulePoste}">
          </div>
          <div class="form-group">
            <label class="form-label required" for="description">Description du stage</label>
            <textarea id="description" name="description" class="form-control" rows="4"
                      placeholder="Décrivez le contexte et les objectifs du stage..." required><c:out value="${param.description}"/></textarea>
          </div>
          <div class="form-group">
            <label class="form-label required" for="tachesPrevues">Tâches prévues</label>
            <textarea id="tachesPrevues" name="tachesPrevues" class="form-control" rows="4"
                      placeholder="Listez les tâches que vous allez effectuer..." required><c:out value="${param.tachesPrevues}"/></textarea>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label required" for="dateDebut">Date de début prévue</label>
              <input type="date" id="dateDebut" name="dateDebut" class="form-control"
                     required value="${param.dateDebut}">
            </div>
            <div class="form-group">
              <label class="form-label required" for="dureeEnMois">Durée en mois</label>
              <input type="number" id="dureeEnMois" name="dureeEnMois" class="form-control"
                     min="1" max="12" required placeholder="3" value="${param.dureeEnMois}">
            </div>
          </div>
          <div class="form-group">
            <label class="form-label required" for="typeStage">Type de stage</label>
            <select id="typeStage" name="typeStage" class="form-control" required>
              <option value="">-- Sélectionnez --</option>
              <option value="FIN_ETUDES"       ${param.typeStage == 'FIN_ETUDES' ? 'selected' : ''}>Stage de fin d'études</option>
              <option value="OBSERVATION"      ${param.typeStage == 'OBSERVATION' ? 'selected' : ''}>Stage d'observation</option>
              <option value="PERFECTIONNEMENT" ${param.typeStage == 'PERFECTIONNEMENT' ? 'selected' : ''}>Stage de perfectionnement</option>
              <option value="AUTRE"            ${param.typeStage == 'AUTRE' ? 'selected' : ''}>Autre</option>
            </select>
          </div>
          <div class="flex-between mt-4">
            <a href="${pageContext.request.contextPath}/offres?action=new" class="btn btn-secondary">← Précédent</a>
            <button type="submit" class="btn btn-primary">Suivant →</button>
          </div>
        </form>
      </div>
    </div>
  </main>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
