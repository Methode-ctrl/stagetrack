# 📘 Guide d'Installation - Nouvelles Améliorations UI/UX

## 🎯 Résumé des Changements

Le dashboard étudiant de StageTrack a été entièrement refactorisé avec :
- **Sidebar latéral collapsible** remplaçant la navbar horizontale
- **Composants CSS modernes** (boutons, badges, chips)
- **Dashboard structuré** avec cartes élégantes et animations fluides
- **Thème dark mode raffiné** avec palette bleu/électrique

---

## 📦 Fichiers Ajoutés

### CSS Files
```
src/main/webapp/css/
├── sidebar.css                    (410 lignes)
├── modern-components.css          (380 lignes)
├── dashboard-student.css          (450 lignes)
└── responsive-layout.css          (180 lignes)
```

### JavaScript Files
```
src/main/webapp/js/
└── sidebar.js                     (160 lignes)
```

### JSP Files
```
src/main/webapp/WEB-INF/views/
└── include/sidebar.jsp            (90 lignes)
```

---

## 🔧 Installation

### 1. Copier les fichiers CSS
Les 4 fichiers CSS ont été créés dans `src/main/webapp/css/` :
- `sidebar.css` - Styles du sidebar collapsible
- `modern-components.css` - Boutons, badges, chips modernes
- `dashboard-student.css` - Styles spécifiques du dashboard étudiant
- `responsive-layout.css` - Layouts responsifs

### 2. Copier le fichier JavaScript
Le fichier `src/main/webapp/js/sidebar.js` gère :
- Toggle du sidebar avec animation
- Persistance de l'état (localStorage)
- Lien actif détection
- Tooltips au hover en mode collapsed

### 3. Copier le composant JSP
Le fichier `src/main/webapp/WEB-INF/views/include/sidebar.jsp` contient :
- Structure du sidebar
- Navigation par rôle (ADMIN, SUPERVISEUR, ÉTUDIANT)
- Infos utilisateur et bouton logout

### 4. Mettre à jour head.jsp
Le fichier `include/head.jsp` a été modifié pour inclure les nouveaux CSS :
```jsp
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive-layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-components.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-student.css">
```

### 5. Mettre à jour dashboard-etudiant.jsp
Le fichier a été modifié pour :
- Remplacer `navbar.jsp` par `sidebar.jsp`
- Ajouter le script `sidebar.js`
- Restructurer les cartes d'offres
- Ajouter la section d'évaluation/notes

---

## 🎨 Utilisation dans d'autres pages

### Pour les pages authentifiées (avec sidebar)

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Ma page"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard">

  <%@ include file="include/sidebar.jsp" %>

  <main class="main-content">
    <!-- Votre contenu -->
  </main>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
```

### Pour les pages login (sans sidebar)

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Connexion"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-login">
  <!-- Contenu login (pas de sidebar) -->
</body>
</html>
```

---

## 🎯 Composants réutilisables

### Boutons

```html
<!-- Primary -->
<a href="#" class="btn btn-primary">Action</a>

<!-- Secondary -->
<button class="btn btn-secondary">Annuler</button>

<!-- Success, Warning, Danger -->
<button class="btn btn-success">Valider</button>
<button class="btn btn-warning">Attention</button>
<button class="btn btn-danger">Supprimer</button>

<!-- Sizes -->
<button class="btn btn-primary btn-sm">Petit</button>
<button class="btn btn-primary btn-lg">Grand</button>
<button class="btn btn-primary btn-block">Full Width</button>
```

### Badges

```html
<span class="badge badge-VALIDEE">VALIDÉE</span>
<span class="badge badge-STAGE_EN_COURS">STAGE_EN_COURS</span>
<span class="badge badge-ARCHIVE">ARCHIVE</span>
```

### File Chips

```html
<a href="#" class="file-chip">
  <span class="file-icon">📄</span>
  <span class="file-name">Rapport.pdf</span>
</a>
```

### Alert Boxes

```html
<div class="alert-box alert-success">Succès !</div>
<div class="alert-box alert-info">Information</div>
<div class="alert-box alert-warning">Attention</div>
<div class="alert-box alert-error">Erreur</div>
```

---

## 🔐 Sécurité

### Pour le logout
Assurez-vous que le data attribute du body est correct :
```jsp
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/logout">
```

Le bouton logout dans le sidebar utilise cet URL pour rediriger.

---

## 🌐 Responsive Design

| Device | Sidebar | Navigation |
|--------|---------|-----------|
| Desktop (≥1024px) | Fixe à gauche (292px) | Collapsible via toggle |
| Tablet (768-1023px) | Réduit (260px) | Collapsible |
| Mobile (<768px) | Bottom navigation | Full screen si ouvert |

### Tester le responsive
- Ouvrir DevTools (F12)
- Activer Device Toolbar (Ctrl+Shift+M)
- Tester sur différentes résolutions

---

## 🐛 Troubleshooting

### Sidebar n'apparaît pas
- ✅ Vérifier que `sidebar.jsp` est inclus
- ✅ Vérifier que `sidebar.css` est chargé
- ✅ Vérifier la console (F12) pour les erreurs CSS

### Sidebar ne toggle pas
- ✅ Vérifier que `sidebar.js` est chargé
- ✅ Ouvrir la console et taper `document.querySelector('.sidebar')`
- ✅ Vérifier que le bouton toggle a l'ID `sidebarToggle`

### Styles ne s'appliquent pas
- ✅ Forcer le refresh (Ctrl+Shift+R)
- ✅ Vérifier l'ordre des CSS dans `head.jsp` (modern-components doit être avant dashboard-student)
- ✅ Vérifier les CSS variables dans `main.css`

### État sidebar ne persiste pas
- ✅ Vérifier que localStorage est activé
- ✅ Vérifier dans DevTools → Application → Local Storage
- ✅ Vérifier la clé `stagetrack-sidebar-collapsed`

---

## 🚀 Performance

Les fichiers CSS sont optimisés pour :
- ✅ Minimal animation lag (GPU acceleration)
- ✅ CSS variables (pas de calcul répété)
- ✅ Transitions fluides (cubic-bezier)
- ✅ Mobile-first responsive design

---

## 📱 Mobile Optimizations

En mobile, le sidebar :
- Se transforme en **bottom navigation bar**
- Peut être ouvert en **full-screen modal**
- Utilise **flex-direction: row** au lieu de column
- Les fichiers PDF/annexes utilisent les mêmes `file-chip` mais sont stacked verticalement

---

## 🎨 Personnalisation

Pour modifier les couleurs, éditer `main.css` :
```css
:root {
  --color-primary: #D47A45;        /* Orange primary */
  --color-blue-electric: #00d4ff;  /* Bleu électrique */
  --color-blue-accent: #64c8ff;    /* Bleu accent */
  --color-blue-dark: #1a1a2e;      /* Fond très foncé */
}
```

Pour modifier les transitions, éditer `main.css` :
```css
--transition-fast:   all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
--transition-spring: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
```

---

## 📋 Checklist d'intégration

- [ ] Fichiers CSS copiés dans `css/`
- [ ] Fichier JS copié dans `js/`
- [ ] Fichier JSP copié dans `WEB-INF/views/include/`
- [ ] `head.jsp` mis à jour avec les nouveaux CSS
- [ ] `dashboard-etudiant.jsp` mis à jour
- [ ] Tester sur desktop (1920x1080)
- [ ] Tester sur tablette (768px)
- [ ] Tester sur mobile (375px)
- [ ] Vérifier les animations au hover
- [ ] Tester le toggle du sidebar
- [ ] Vérifier la persistance de l'état

---

## 📚 Documentation Supplémentaire

- **CHANGELOG_UI_IMPROVEMENTS.md** - Liste des améliorations détaillées
- **Palette de couleurs** - Voir `main.css` variables
- **Animations** - Voir `animations.css` et `sidebar.css`

---

**Support**: Pour toute question, consultez le CHANGELOG ou les commentaires dans les fichiers CSS/JS.
