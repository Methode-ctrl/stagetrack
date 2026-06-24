# CORRECTIONS EFFECTUÉES - StageTrack

## Problèmes corrigés

### 1. AuthServlet.java
- URL changée de `/auth/login` à `/login` (correspondant au formulaire login.jsp)
- Ajout gestion déconnexion via `action=logout`
- Redirection correcte si déjà connecté

### 2. AuthFilter.java
- Ajout `/login` dans les URLs publiques
- Vérification sur `utilisateur` en session (pas juste `role`)
- Correction de la redirection vers `/login`

### 3. DashboardServlet.java (CRITIQUE)
- **Erreur List.of()** : Remplacé `List.of(StatutOffre...)` par `new ArrayList<>()` 
  car EclipseLink ne supporte pas List.of() comme paramètre JPQL
- **Erreur String dans JPQL** : Remplacé les strings `'SOUMIS'` dans le JPQL
  par des paramètres typés `StatutRapport.SOUMIS`
- Ajout de la section "Dossiers sans superviseur" dans le dashboard admin
- Chargement correct du superviseur depuis la base

### 4. OffreStageServlet.java (CRITIQUE)
- Correction du flux en 3 étapes (session correcte entre étapes)
- Utilisation de `offreStageBean.findEtudiantByUtilisateurId()` pour charger l'entité managée
- Utilisation de `offreStageBean.creerOuTrouverEntreprise()` pour l'entreprise managée
- Correction des noms de paramètres correspondant aux JSPs

### 5. RapportServlet.java
- Ajout du doGet pour `soumettre-etape1` et `soumettre-etape2`
- Correction de la vérification du stage en cours avant de permettre le rapport
- Correction du nom du paramètre `competences` (au lieu de `competencesAcquises`)
- Gestion correcte de l'offreId depuis la session

### 6. NoteServlet.java
- Redirection vers `/dashboard/superviseur` après notation
- Meilleure gestion des erreurs

### 7. dashboard-admin.jsp
- Ajout de la section "Dossiers à affecter" avec formulaire d'affectation superviseur
- Correction des variables `nbTotal`, `nbArchives` (correspondant au DashboardServlet)

## Pour compiler et déployer

```bash
cd stagetrack
mvn clean package
asadmin deploy --force=true target/stagetrack.war
```

## Comptes de test
- Admin      : admin@upg.bi / admin123
- Superviseur: nkurunziza.t@upg.bi / super123
- Étudiant   : irakoze.jean@etud.upg.bi / etud123
