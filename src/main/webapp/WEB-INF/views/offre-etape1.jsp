<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Soumettre une offre – Étape 1"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/login?action=logout">
  <%@ include file="include/sidebar.jsp" %>
  <main class="main-content">
    <div class="container">
      <div class="form-card">
        <div class="steps mb-4">
          <div class="step active">
            <div class="step-circle">1</div>
            <div class="step-label">Entreprise</div>
          </div>
          <div class="step pending">
            <div class="step-circle">2</div>
            <div class="step-label">Stage</div>
          </div>
          <div class="step pending">
            <div class="step-circle">3</div>
            <div class="step-label">Documents</div>
          </div>
        </div>

        <h2>Soumettre mon offre de stage – Étape 1/3</h2>
        <p class="text-secondary mb-3">Informations sur l'entreprise d'accueil</p>

        <c:if test="${not empty erreurs}">
          <c:forEach items="${erreurs}" var="erreur">
            <div class="alert alert-error"><c:out value="${erreur}"/></div>
          </c:forEach>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/offres?action=soumettre-etape1" novalidate>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label required" for="nomEntreprise">Nom de l'entreprise</label>
              <input type="text" id="nomEntreprise" name="entreprise.nom" class="form-control"
                     required maxlength="150" value="${param['entreprise.nom']}">
            </div>
            <div class="form-group">
              <label class="form-label required" for="secteur">Secteur d'activité</label>
              <input type="text" id="secteur" name="entreprise.secteur" class="form-control"
                     placeholder="Informatique / Finance / Santé..." required maxlength="100"
                     value="${param['entreprise.secteur']}">
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label required" for="ville">Ville</label>
              <input type="text" id="ville" name="entreprise.ville" class="form-control"
                     required maxlength="100" value="${param['entreprise.ville']}">
            </div>
            <div class="form-group">
              <label class="form-label" for="adresse">Adresse complète</label>
              <input type="text" id="adresse" name="entreprise.adresse" class="form-control"
                     maxlength="200" value="${param['entreprise.adresse']}">
            </div>
          </div>
          <div class="form-group">
            <label class="form-label required" for="nomResponsable">Nom du responsable de stage</label>
            <input type="text" id="nomResponsable" name="entreprise.nomResponsable" class="form-control"
                   required maxlength="150" value="${param['entreprise.nomResponsable']}">
          </div>
          <div class="form-row">
            <div class="form-group">
              <label class="form-label required" for="emailContact">Email du responsable</label>
              <input type="email" id="emailContact" name="entreprise.emailContact" class="form-control"
                     required value="${param['entreprise.emailContact']}">
            </div>
            <div class="form-group">
              <label class="form-label" for="telephone">Téléphone</label>
              <input type="tel" id="telephone" name="entreprise.telephone" class="form-control"
                     placeholder="+257 79 000 000" value="${param['entreprise.telephone']}">
            </div>
          </div>
          <div class="flex-between mt-4">
            <span></span>
            <button type="submit" class="btn btn-primary">Suivant →</button>
          </div>
        </form>
      </div>
    </div>
  </main>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
