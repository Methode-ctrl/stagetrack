<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Offre de stage — Étape 1"/>
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
        <a class="btn btn-secondary btn-sm" href="javascript:history.back()">← Annuler</a>
      </div>

      <div class="page-content page-content-sm">
        <div class="steps-indicator">
          <div class="step-item active">
            <div class="step-num">1</div><span class="step-label">Entreprise</span>
          </div>
          <div class="step-sep"></div>
          <div class="step-item">
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
          <div class="card-header"><h3 class="card-title">🏢 Informations entreprise</h3></div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/offres?action=soumettre-etape1">
              <div class="grid-2">
                <div class="form-group">
                  <label class="form-label">Nom de l'entreprise <span class="required">*</span></label>
                  <input class="form-control" name="nomEntreprise" required
                         value="<c:out value="${nomEntreprise}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Secteur d'activité <span class="required">*</span></label>
                  <input class="form-control" name="secteur" required
                         value="<c:out value="${secteur}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Ville <span class="required">*</span></label>
                  <input class="form-control" name="ville" required
                         value="<c:out value="${ville}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Adresse</label>
                  <input class="form-control" name="adresse"
                         value="<c:out value="${adresse}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Nom du responsable <span class="required">*</span></label>
                  <input class="form-control" name="nomResponsable" required
                         value="<c:out value="${nomResponsable}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">E-mail contact <span class="required">*</span></label>
                  <input class="form-control" type="email" name="emailContact" required
                         value="<c:out value="${emailContact}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Téléphone</label>
                  <input class="form-control" name="telephone"
                         value="<c:out value="${telephone}"/>"/>
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