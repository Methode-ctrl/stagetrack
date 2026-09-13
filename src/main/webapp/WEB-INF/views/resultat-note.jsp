<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Note attribuée"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Résultat de la notation</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/notes">← Retour</a>
      </div>

      <div class="page-content" style="max-width:700px; margin:0 auto;">
        <div class="hero text-center">
          <div style="font-size:48px;">🏅</div>
          <h1><span class="hero-gradient">Note attribuée</span></h1>
          <p>La note finale a été calculée et enregistrée.</p>
        </div>

        <div class="card mb-4">
          <div class="card-body text-center">
            <p class="text-muted mb-1">Note finale</p>
            <p class="note-finale-value" style="font-size:64px;"><c:out value="${note.noteFinale}"/>/20</p>
            <span class="badge" style="background:#064E3B; color:#34D399;"><c:out value="${note.mention}"/></span>
          </div>
        </div>

        <div class="card">
          <div class="card-header"><h3 class="card-title">📊 Détail des notes</h3></div>
          <div class="card-body">
            <div class="grid-2">
              <div>
                <p class="text-muted mb-0">Note de stage (×40%)</p>
                <p class="mt-0"><strong><c:out value="${note.noteStage}"/>/20</strong></p>
              </div>
              <div>
                <p class="text-muted mb-0">Note du rapport (×40%)</p>
                <p class="mt-0"><strong><c:out value="${note.noteRapport}"/>/20</strong></p>
              </div>
              <div>
                <p class="text-muted mb-0">Note de présence (×20%)</p>
                <p class="mt-0"><strong><c:out value="${note.notePresence}"/>/20</strong></p>
              </div>
              <div>
                <p class="text-muted mb-0">Date d'attribution</p>
                <p class="mt-0"><strong><c:out value="${note.dateAttribution}"/></strong></p>
              </div>
            </div>
            <c:if test="${not empty note.appreciation}">
              <div class="divider"></div>
              <p class="text-muted mb-0">💬 Appréciation</p>
              <p class="mt-1"><c:out value="${note.appreciation}"/></p>
            </c:if>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
</body>
</html>