<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Accès refusé"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>

    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Accès refusé</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content" style="max-width:560px; margin:0 auto;">
        <div class="card">
          <div class="card-body text-center" style="padding:48px;">
            <div style="font-size:64px;">🔒</div>
            <h2 class="mt-2">Accès refusé</h2>
            <p class="text-secondary mt-1 mb-3">
              <c:choose>
                <c:when test="${not empty messageErreur}">
                  <c:out value="${messageErreur}"/>
                </c:when>
                <c:otherwise>
                  Vous n'avez pas les droits nécessaires pour accéder à cette page.
                </c:otherwise>
              </c:choose>
            </p>
            <div class="inline-flex gap-2">
              <a class="btn btn-primary" href="javascript:history.back()">← Retour</a>
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/dashboard">🏠 Accueil</a>
              <c:if test="${empty sessionScope.utilisateur}">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/login.jsp">Connexion</a>
              </c:if>
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