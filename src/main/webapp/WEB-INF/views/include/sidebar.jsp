<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="sidebar" role="navigation" aria-label="Navigation latérale">

  <!-- Header avec logo -->
  <div class="sidebar-header">
    <div class="sidebar-logo">🎓</div>
    <div class="sidebar-title">StageTrack</div>
  </div>

  <!-- Navigation menu -->
  <ul class="sidebar-nav">

    <!-- Tableau de bord -->
    <li class="nav-item">
      <a href="${pageContext.request.contextPath}/dashboard/<c:choose><c:when test="${sessionScope.role == 'ADMIN'}">admin</c:when><c:when test="${sessionScope.role == 'SUPERVISEUR'}">superviseur</c:when><c:otherwise>etudiant</c:otherwise></c:choose>" 
         class="nav-link">
        <span class="nav-icon">🏠</span>
        <span class="nav-label">Tableau de bord</span>
      </a>
    </li>

    <!-- Étudiants (pour ETUDIANT) -->
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

    <!-- Administration (pour ADMIN) -->
    <c:if test="${sessionScope.role == 'ADMIN'}">
      <li class="nav-item has-dropdown">
        <a href="#" class="nav-link nav-link-dropdown" aria-haspopup="true">
          <span class="nav-icon">⚙️</span>
          <span class="nav-label">Admin</span>
          <span style="margin-left: auto; font-size: 0.75rem;">▾</span>
        </a>
        <ul class="dropdown-menu" role="menu" style="list-style: none; padding: 0.5rem; margin: 0.5rem 0.5rem 0 0.5rem; background: rgba(0,0,0,0.3); border-radius: 6px; display: none;">
          <li><a href="${pageContext.request.contextPath}/utilisateurs" class="dropdown-item" role="menuitem" style="display: block; padding: 0.6rem 0.75rem; border-radius: 6px; color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.85rem; transition: all 0.3s ease;">👥 Utilisateurs</a></li>
          <li><a href="${pageContext.request.contextPath}/entreprises" class="dropdown-item" role="menuitem" style="display: block; padding: 0.6rem 0.75rem; border-radius: 6px; color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.85rem; transition: all 0.3s ease;">🏢 Entreprises</a></li>
          <li><a href="${pageContext.request.contextPath}/offres" class="dropdown-item" role="menuitem" style="display: block; padding: 0.6rem 0.75rem; border-radius: 6px; color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.85rem; transition: all 0.3s ease;">📋 Tous les stages</a></li>
        </ul>
      </li>
    </c:if>

    <!-- Superviseur - Mes étudiants & Rapports -->
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

  <!-- Footer avec infos utilisateur -->
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
    <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-btn" title="Déconnexion">
      🚪
    </a>
  </div>

  <!-- Toggle button (visible en haut à droite du sidebar) -->
  <button class="sidebar-toggle" id="sidebarToggle" aria-label="Réduire/Développer le menu"></button>

</aside>

<style>
  /* Dropdown menu styling pour le dropdown ADMIN */
  .dropdown-menu {
    display: none !important;
  }

  .has-dropdown.is-open .dropdown-menu,
  .has-dropdown:hover .dropdown-menu {
    display: block !important;
  }

  .dropdown-item:hover {
    background: rgba(100, 200, 255, 0.15) !important;
    color: #64c8ff !important;
    transform: translateX(4px);
  }

  .dropdown-item.active {
    background: rgba(100, 200, 255, 0.2) !important;
    color: #00d4ff !important;
  }
</style>
