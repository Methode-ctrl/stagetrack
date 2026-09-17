<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<c:if test="${not empty sessionScope.utilisateur}">
  <c:set var="role" value="${sessionScope.role}"/>
  <aside class="sidebar" id="sidebar">
    <nav class="navbar">
      <div class="sidebar-logo">
        <div class="sidebar-logo-icon">🎓</div>
        <div class="sidebar-logo-text">
          <strong>StageTrack</strong>
          <span>UPG · Génie Logiciel</span>
        </div>
      </div>

      <div class="nav-menu">

        <c:if test="${role == 'ADMIN'}">
          <div class="nav-section-label">Administration</div>
          <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
            <span class="nav-icon">🏠</span><span class="nav-text">Tableau de bord</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/offres">
            <span class="nav-icon">📋</span><span class="nav-text">Tous les stages</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/utilisateurs">
            <span class="nav-icon">👥</span><span class="nav-text">Utilisateurs</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/entreprises">
            <span class="nav-icon">🏢</span><span class="nav-text">Entreprises</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/notes">
            <span class="nav-icon">🏅</span><span class="nav-text">Notes</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/conventions">
            <span class="nav-icon">📑</span><span class="nav-text">Conventions</span>
          </a>
        </c:if>

        <c:if test="${role == 'SUPERVISEUR'}">
          <div class="nav-section-label">Supervision</div>
          <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
            <span class="nav-icon">🏠</span><span class="nav-text">Tableau de bord</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/offres">
            <span class="nav-icon">📋</span><span class="nav-text">Mes étudiants</span>
          </a>
        </c:if>

        <c:if test="${role == 'ETUDIANT'}">
          <div class="nav-section-label">Mon espace</div>
          <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
            <span class="nav-icon">🏠</span><span class="nav-text">Tableau de bord</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/offres?action=mon-stage">
            <span class="nav-icon">📁</span><span class="nav-text">Mon stage</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/offres?action=convention">
            <span class="nav-icon">📑</span><span class="nav-text">Convention</span>
          </a>
          <a class="nav-link" href="${pageContext.request.contextPath}/rapports?action=mon-rapport">
            <span class="nav-icon">📝</span><span class="nav-text">Mon rapport</span>
          </a>
        </c:if>
      </div>

      <div class="navbar-user">
        <div class="user-avatar"><c:out value="${sessionScope.utilisateur.prenom.charAt(0)}"/></div>
        <div class="flex-1" style="min-width:0;">
          <div class="user-name"><c:out value="${sessionScope.utilisateur.prenom}"/> <c:out value="${sessionScope.utilisateur.nom}"/></div>
          <div class="user-role"><c:out value="${role}"/></div>
        </div>
      </div>

      <a class="nav-logout" href="${pageContext.request.contextPath}/login?action=logout">
        <span class="nav-icon">🚪</span><span class="nav-text">Se déconnecter</span>
      </a>
    </nav>
  </aside>
  <div class="navbar-overlay" id="navbarOverlay"></div>
</c:if>