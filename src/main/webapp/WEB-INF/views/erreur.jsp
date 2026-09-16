<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
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

      <div class="page-content page-content-xs">
        <div class="card">
          <div class="card-body text-center" style="padding:48px;">
            <div style="font-size:64px;">😵</div>
            <h2 class="mt-2">Une erreur s'est produite</h2>
            <c:choose>
              <c:when test="${not empty erreurs}">
                <c:forEach items="${erreurs}" var="err">
                  <p class="text-secondary mt-1 mb-1"><c:out value="${err}"/></p>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <p class="text-secondary mt-1 mb-3">
                  ${not empty erreur ? erreur : not empty messageErreur ? messageErreur : 'Une erreur inattendue est survenue. Veuillez réessayer ou contacter l\'administration.'}
                </p>
              </c:otherwise>
            </c:choose>
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