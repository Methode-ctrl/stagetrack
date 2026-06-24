# 🔄 Adaptation des Autres Dashboards

Ce document explique comment adapter les dashboards ADMIN et SUPERVISEUR au nouveau système sidebar.

---

## 📋 Fichiers à Adapter

```
src/main/webapp/WEB-INF/views/
├── dashboard-admin.jsp           # À adapter
├── dashboard-superviseur.jsp     # À adapter
└── include/
    ├── sidebar.jsp               # ✅ Prêt (gère les 3 rôles)
    └── head.jsp                  # ✅ Prêt
```

---

## 🔧 Template pour adapter dashboard-admin.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Tableau de bord Administrateur"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/logout">

  <%@ include file="include/sidebar.jsp" %>

  <main class="main-content">
    <div class="hero">
      <div class="hero-title">Tableau de bord Administrateur</div>
      <div class="hero-subtitle">Gestion complète du système</div>
    </div>

    <!-- Stats cards -->
    <div class="dashboard-stats">
      <div class="stat-card stat-card-blue">
        <span class="stat-icon">👥</span>
        <div class="stat-number"><c:out value="${totalUsers}"/></div>
        <div class="stat-label">Utilisateurs</div>
      </div>
      
      <div class="stat-card stat-card-green">
        <span class="stat-icon">📋</span>
        <div class="stat-number"><c:out value="${totalOffres}"/></div>
        <div class="stat-label">Offres de Stage</div>
      </div>
      
      <div class="stat-card stat-card-orange">
        <span class="stat-icon">🏢</span>
        <div class="stat-number"><c:out value="${totalEntreprises}"/></div>
        <div class="stat-label">Entreprises</div>
      </div>
      
      <div class="stat-card stat-card-grey">
        <span class="stat-icon">⚙️</span>
        <div class="stat-number">3</div>
        <div class="stat-label">Sections</div>
      </div>
    </div>

    <!-- Contenu spécifique admin -->
    <!-- ... -->

  </main>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
```

---

## 🔧 Template pour adapter dashboard-superviseur.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Tableau de bord Superviseur"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/logout">

  <%@ include file="include/sidebar.jsp" %>

  <main class="main-content">
    <div class="hero">
      <div class="hero-title">Tableau de bord Superviseur</div>
      <div class="hero-subtitle">Supervision des stages étudiants</div>
    </div>

    <!-- Stats cards pour superviseur -->
    <div class="dashboard-stats">
      <div class="stat-card stat-card-blue">
        <span class="stat-icon">👥</span>
        <div class="stat-number"><c:out value="${totalEtudiants}"/></div>
        <div class="stat-label">Mes Étudiants</div>
      </div>
      
      <div class="stat-card stat-card-green">
        <span class="stat-icon">✅</span>
        <div class="stat-number"><c:out value="${offresValidees}"/></div>
        <div class="stat-label">Offres Validées</div>
      </div>
      
      <div class="stat-card stat-card-orange">
        <span class="stat-icon">📄</span>
        <div class="stat-number"><c:out value="${rapportsEnAttente}"/></div>
        <div class="stat-label">Rapports en Attente</div>
      </div>
      
      <div class="stat-card stat-card-grey">
        <span class="stat-icon">⭐</span>
        <div class="stat-number"><c:out value="${evaluationsRestantes}"/></div>
        <div class="stat-label">Évaluations</div>
      </div>
    </div>

    <!-- Contenu spécifique superviseur -->
    <!-- ... -->

  </main>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
```

---

## 🎨 Stat Cards Styles

Le CSS inclut des classes pour les stat cards :

```html
<!-- Bleu -->
<div class="stat-card stat-card-blue">
  <span class="stat-icon">👥</span>
  <div class="stat-number">42</div>
  <div class="stat-label">Label</div>
</div>

<!-- Vert -->
<div class="stat-card stat-card-green">
  ...
</div>

<!-- Orange -->
<div class="stat-card stat-card-orange">
  ...
</div>

<!-- Gris -->
<div class="stat-card stat-card-grey">
  ...
</div>
```

---

## 🎯 Composants Admin-Spécifiques

### Tables modernes

```html
<div class="table-wrapper">
  <table class="table">
    <thead>
      <tr>
        <th>Colonne 1</th>
        <th>Colonne 2</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Données</td>
        <td>Données</td>
        <td>
          <a href="#" class="btn btn-sm btn-secondary">Éditer</a>
          <a href="#" class="btn btn-sm btn-danger">Supprimer</a>
        </td>
      </tr>
    </tbody>
  </table>
</div>
```

### Formulaires admin

```html
<form class="form-card">
  <h2>Ajouter un utilisateur</h2>
  
  <div class="form-group">
    <label class="form-label required">Nom</label>
    <input type="text" class="form-control" required>
  </div>
  
  <div class="form-group">
    <label class="form-label required">Email</label>
    <input type="email" class="form-control" required>
  </div>
  
  <div class="form-group">
    <label class="form-label required">Rôle</label>
    <select class="form-control" required>
      <option>ADMIN</option>
      <option>SUPERVISEUR</option>
      <option>ETUDIANT</option>
    </select>
  </div>
  
  <button type="submit" class="btn btn-primary btn-block">Créer</button>
</form>
```

---

## 🔀 Navigation Dynamique dans Sidebar

Le `sidebar.jsp` gère automatiquement la navigation selon le rôle :

```jsp
<!-- Pour ADMIN, affiche le menu admin -->
<c:if test="${sessionScope.role == 'ADMIN'}">
  <li class="nav-item has-dropdown">
    <a href="#" class="nav-link nav-link-dropdown">
      <span class="nav-icon">⚙️</span>
      <span class="nav-label">Administration</span>
    </a>
    <ul class="dropdown-menu">
      <li><a href="${pageContext.request.contextPath}/utilisateurs">👥 Utilisateurs</a></li>
      <li><a href="${pageContext.request.contextPath}/entreprises">🏢 Entreprises</a></li>
      <li><a href="${pageContext.request.contextPath}/offres">📋 Tous les stages</a></li>
    </ul>
  </li>
</c:if>

<!-- Pour SUPERVISEUR, affiche le menu superviseur -->
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
</c:if>
```

---

## 📱 Autres pages à adapter

### Pages sans sidebar (login, etc)
```jsp
<!-- ✅ Ces pages N'ONT PAS besoin d'être modifiées -->
<!-- Elles n'incluent pas le sidebar -->
```

### Pages avec contenu spécifique
```jsp
<!-- Gestion des utilisateurs -->
src/main/webapp/WEB-INF/views/gestion-utilisateurs.jsp

<!-- Gestion des entreprises -->
src/main/webapp/WEB-INF/views/gestion-entreprises.jsp

<!-- Listes des offres -->
src/main/webapp/WEB-INF/views/liste-offres.jsp
```

Chacune de ces pages peut utiliser le même `sidebar.jsp` et bénéficier des nouveaux styles CSS.

---

## 🎯 Checklist Adaptation

### Pour chaque dashboard à adapter :

- [ ] Remplacer `<%@ include file="include/navbar.jsp" %>` par `<%@ include file="include/sidebar.jsp" %>`
- [ ] Ajouter `data-logout-url="${pageContext.request.contextPath}/logout"` au body
- [ ] Ajouter la section hero (titre + sous-titre)
- [ ] Ajouter les stat cards appropriées
- [ ] Ajouter le script `sidebar.js` avant la fermeture du body
- [ ] Tester le toggle du sidebar
- [ ] Tester les liens actifs
- [ ] Tester la navigation mobile

---

## 🧪 Tests

Pour tester les dashboards adaptés :

```bash
# Build du projet
mvn clean package

# Déploiement sur GlassFish
# Via IDE ou console d'administration

# Tests
1. Accéder à http://localhost:8080/stagetrack/login
2. Se connecter avec compte ADMIN/SUPERVISEUR
3. Vérifier l'affichage du sidebar
4. Tester le toggle
5. Vérifier les liens actifs
6. Tester le responsive
```

---

## 🚨 Erreurs Communes

### ❌ "Sidebar n'apparaît pas pour ADMIN"
```
✅ Solution: Vérifier que head.jsp inclut sidebar.css
```

### ❌ "Navigation manquante pour SUPERVISEUR"
```
✅ Solution: Vérifier les conditions <c:if> dans sidebar.jsp
```

### ❌ "Dropdown ne fonctionne pas"
```
✅ Solution: Vérifier que sidebar.js est chargé
```

---

## 📚 Ressources

- Documentation CSS: Voir les commentaires dans `sidebar.css`
- Documentation JS: Voir les commentaires dans `sidebar.js`
- Styles réutilisables: `modern-components.css`
- Dashboard example: `dashboard-etudiant.jsp`

---

**Prochaine étape**: Une fois les 3 dashboards adaptés, le système sera homogène et professionnel!
