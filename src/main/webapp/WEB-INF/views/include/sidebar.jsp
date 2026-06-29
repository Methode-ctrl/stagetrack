<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar" role="navigation" aria-label="Navigation latérale">

  <div class="sidebar-header">
    <div class="sidebar-logo">🎓</div>
    <div class="sidebar-title">StageTrack</div>
  </div>

  <ul class="sidebar-nav">

    <li class="nav-item">
      <a href="${pageContext.request.contextPath}/dashboard/<c:choose><c:when test="${sessionScope.role == 'ADMIN'}">admin</c:when><c:when test="${sessionScope.role == 'SUPERVISEUR'}">superviseur</c:when><c:otherwise>etudiant</c:otherwise></c:choose>"
         class="nav-link">
        <span class="nav-icon">🏠</span>
        <span class="nav-label">Tableau de bord</span>
      </a>
    </li>

    <c:if test="${sessionScope.role == 'ETUDIANT'}">
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/offres" class="nav-link">
          <span class="nav-icon">📋</span>
          <span class="nav-label">Mon stage</span>
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/conventions" class="nav-link">
          <span class="nav-icon">📜</span>
          <span class="nav-label">Convention</span>
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/rapports" class="nav-link">
          <span class="nav-icon">📄</span>
          <span class="nav-label">Mon rapport</span>
        </a>
      </li>
    </c:if>

    <c:if test="${sessionScope.role == 'ADMIN'}">
      <li class="nav-item has-dropdown">
        <a href="#" class="nav-link nav-link-dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="nav-icon">⚙️</span>
          <span class="nav-label">Administration</span>
          <span class="nav-arrow" style="margin-left:auto;font-size:.75rem;transition:transform .3s ease;">▾</span>
        </a>
        <ul class="dropdown-menu" role="menu">
          <li><a href="${pageContext.request.contextPath}/utilisateurs" class="dropdown-item" role="menuitem">👥 Utilisateurs</a></li>
          <li><a href="${pageContext.request.contextPath}/entreprises"  class="dropdown-item" role="menuitem">🏢 Entreprises</a></li>
          <li><a href="${pageContext.request.contextPath}/offres"       class="dropdown-item" role="menuitem">📋 Tous les stages</a></li>
        </ul>
      </li>
    </c:if>

    <c:if test="${sessionScope.role == 'SUPERVISEUR'}">
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/offres" class="nav-link">
          <span class="nav-icon">👥</span>
          <span class="nav-label">Mes étudiants</span>
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/rapports" class="nav-link">
          <span class="nav-icon">📄</span>
          <span class="nav-label">Rapports</span>
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/evaluations" class="nav-link">
          <span class="nav-icon">⭐</span>
          <span class="nav-label">Évaluations</span>
        </a>
      </li>
    </c:if>

  </ul>

  <div class="sidebar-footer">
    <div class="user-avatar">
      <c:out value="${sessionScope.utilisateur.prenom.charAt(0)}${sessionScope.utilisateur.nom.charAt(0)}"/>
    </div>
    <div class="user-info">
      <div class="user-name">
        <c:out value="${sessionScope.utilisateur.prenom}"/> <c:out value="${sessionScope.utilisateur.nom}"/>
      </div>
      <div class="user-role-badge">
        <c:choose>
          <c:when test="${sessionScope.role == 'ADMIN'}">ADMIN</c:when>
          <c:when test="${sessionScope.role == 'SUPERVISEUR'}">SUPERVISEUR</c:when>
          <c:otherwise>ÉTUDIANT</c:otherwise>
        </c:choose>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/login?action=logout"
       class="logout-btn"
       title="Se déconnecter"
       data-logout="true"
       aria-label="Se déconnecter">🚪</a>
  </div>

  <button class="sidebar-toggle" id="sidebarToggle" aria-label="Réduire/Développer le menu"></button>

</aside>
