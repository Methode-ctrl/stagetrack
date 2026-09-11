<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Erreur"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>

    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Erreur</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/dashboard">Retour au tableau de bord</a>
      </div>

      <div class="page-content" style="max-width:640px; margin:0 auto;">
        <div class="card">
          <div class="card-body text-center" style="padding:48px;">
            <div style="font-size:64px;">😵</div>
            <h2 class="mt-2">Une erreur s'est produite</h2>
            <p class="text-secondary mt-1 mb-3">
              <c:choose>
                <c:when test="${not empty messageErreur}">
                  <c:out value="${messageErreur}"/>
                </c:when>
                <c:otherwise>
                  Une erreur inattendue est survenue. Veuillez réessayer ou contacter l'administration.
                </c:otherwise>
              </c:choose>
            </p>
            <div class="inline-flex gap-2">
              <a class="btn btn-primary" href="javascript:history.back()">← Retour</a>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/dashboard">🏠 Accueil</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
</body>
</html>