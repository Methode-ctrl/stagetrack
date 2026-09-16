<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Offre de stage — Étape 2"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Soumettre mon offre de stage</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content page-content-sm">
        <div class="steps-indicator">
          <div class="step-item done">
            <div class="step-num">✓</div><span class="step-label">Entreprise</span>
          </div>
          <div class="step-sep"></div>
          <div class="step-item active">
            <div class="step-num">2</div><span class="step-label">Stage</span>
          </div>
          <div class="step-sep"></div>
          <div class="step-item">
            <div class="step-num">3</div><span class="step-label">Pièces jointes</span>
          </div>
        </div>

        <c:if test="${not empty erreurs}">
          <div class="alert alert-error">
            <c:forEach items="${erreurs}" var="err">
              <p class="mb-1"><c:out value="${err}"/></p>
            </c:forEach>
          </div>
        </c:if>

        <div class="card">
          <div class="card-header"><h3 class="card-title">💼 Détails du stage</h3></div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/offres?action=soumettre-etape2">
              <div class="form-group">
                <label class="form-label">Intitulé du poste <span class="required">*</span></label>
                <input class="form-control" name="intitulePoste" required
                       value="<c:out value="${intitulePoste}"/>"/>
              </div>
              <div class="form-group">
                <label class="form-label">Description du stage <span class="required">*</span></label>
                <textarea class="form-control" name="description" rows="4" required
                          placeholder="Décrivez brièvement le contexte et les objectifs du stage…"><c:out value="${description}"/></textarea>
              </div>
              <div class="form-group">
                <label class="form-label">Tâches prévues <span class="required">*</span></label>
                <textarea class="form-control" name="tachesPrevues" rows="4" required
                          placeholder="Listez les principales tâches que l'étudiant réalisera…"><c:out value="${tachesPrevues}"/></textarea>
              </div>
              <div class="grid-2">
                <div class="form-group">
                  <label class="form-label">Date de début <span class="required">*</span></label>
                  <input class="form-control" type="date" name="dateDebut" required
                         value="<c:out value="${dateDebut}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Durée (mois) <span class="required">*</span></label>
                  <input class="form-control" type="number" name="dureeEnMois" min="1" max="24" required
                         value="<c:out value="${dureeEnMois}"/>"/>
                </div>
              </div>
              <button type="submit" class="btn btn-primary btn-lg mt-3">Étape suivante →</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
</body>
</html>