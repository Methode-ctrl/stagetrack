<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar" role="navigation" aria-label="Navigation principale">
  <div class="navbar-container">

    <a href="${pageContext.request.contextPath}/dashboard/${sessionScope.role == 'ADMIN' ? 'admin' : sessionScope.role == 'SUPERVISEUR' ? 'superviseur' : 'etudiant'}" class="navbar-brand">
      <div class="brand-icon">🎓</div>
      <div class="brand-text">
        <span class="brand-title">StageTrack</span>
        <span class="brand-subtitle">UPG · Génie Logiciel</span>
      </div>
    </a>

    <ul class="navbar-menu" id="navbarMenu">

      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/dashboard/<c:choose><c:when test="${sessionScope.role == 'ADMIN'}">admin</c:when><c:when test="${sessionScope.role == 'SUPERVISEUR'}">superviseur</c:when><c:otherwise>etudiant</c:otherwise></c:choose>" class="nav-link">
          <span class="nav-icon">🏠</span>
          <span class="nav-label">Tableau de bord</span>
        </a>
      </li>

      <c:if test="${sessionScope.role == 'ADMIN'}">
        <li class="nav-item has-dropdown">
          <a href="#" class="nav-link nav-link-dropdown" aria-haspopup="true">
            <span class="nav-icon">⚙️</span>
            <span class="nav-label">Administration</span>
            <span class="nav-arrow">▾</span>
          </a>
          <ul class="dropdown-menu" role="menu">
            <li><a href="${pageContext.request.contextPath}/utilisateurs" class="dropdown-item" role="menuitem">👥 Utilisateurs</a></li>
            <li><a href="${pageContext.request.contextPath}/entreprises" class="dropdown-item" role="menuitem">🏢 Entreprises</a></li>
            <li><a href="${pageContext.request.contextPath}/offres" class="dropdown-item" role="menuitem">📋 Tous les stages</a></li>
          </ul>
        </li>
      </c:if>

      <c:if test="${sessionScope.role == 'SUPERVISEUR'}">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/offres" class="nav-link">
            <span class="nav-icon">📋</span>
            <span class="nav-label">Mes étudiants</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/rapports" class="nav-link">
            <span class="nav-icon">📄</span>
            <span class="nav-label">Rapports</span>
          </a>
        </li>
      </c:if>

      <c:if test="${sessionScope.role == 'ETUDIANT'}">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/offres?action=new" class="nav-link">
            <span class="nav-icon">➕</span>
            <span class="nav-label">Mon stage</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/conventions" class="nav-link">
            <span class="nav-icon">📑</span>
            <span class="nav-label">Convention</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/rapports?action=new" class="nav-link">
            <span class="nav-icon">📝</span>
            <span class="nav-label">Mon rapport</span>
          </a>
        </li>
      </c:if>

    </ul>

    <div class="navbar-user">
      <c:choose>
        <c:when test="${not empty sessionScope.role and not empty sessionScope.utilisateur}">
          <div class="user-avatar" title="${sessionScope.utilisateur.prenom} ${sessionScope.utilisateur.nom}" id="userAvatar"
               data-prenom="${sessionScope.utilisateur.prenom}" data-nom="${sessionScope.utilisateur.nom}">
          </div>
          <div class="user-info">
            <span class="user-name">
              <c:out value="${sessionScope.utilisateur.prenom}"/>
              <c:out value="${sessionScope.utilisateur.nom}"/>
            </span>
            <span class="user-role badge-role-${sessionScope.role}"><c:out value="${sessionScope.role}"/></span>
          </div>
          <a href="${pageContext.request.contextPath}/login?action=logout" class="btn-logout" title="Déconnexion" aria-label="Déconnexion">⏻</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/login" class="btn-logout" title="Se connecter" aria-label="Se connecter">🔐</a>
        </c:otherwise>
      </c:choose>
    </div>

    <button class="navbar-toggle" id="navbarToggle" aria-label="Ouvrir le menu" aria-expanded="false">
      <span class="hamburger-line"></span>
      <span class="hamburger-line"></span>
      <span class="hamburger-line"></span>
    </button>

  </div>
</nav>
<script>
(function(){
  var el = document.getElementById('userAvatar');
  if(el){
    var p = (el.dataset.prenom||'').charAt(0).toUpperCase();
    var n = (el.dataset.nom||'').charAt(0).toUpperCase();
    el.textContent = p + n;
  }
})();
</script>
