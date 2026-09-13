# ╔══════════════════════════════════════════════════════════════╗
# ║                      STAGETRACK                             ║
# ║          Système de Gestion des Stages Étudiants            ║
# ╚══════════════════════════════════════════════════════════════╝

<p align="center">
  <strong>🎓 Université Polytechnique de Gitega (UPG)</strong><br>
  <em>Faculté FTIC — Filière Génie Logiciel — BAC4</em><br>
  <em>Année Académique 2025–2026</em><br>
  <br>
  <strong>Cours : Projet Libre Java EE — Application Web Multi-tiers</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Java_EE-10-E76F00?logo=oracle&logoColor=white" alt="Java EE 10"/>
  <img src="https://img.shields.io/badge/GlassFish-7.0.9-E74C3C" alt="GlassFish 7"/>
  <img src="https://img.shields.io/badge/PostgreSQL-18-4169E1?logo=postgresql&logoColor=white" alt="PostgreSQL 18"/>
  <img src="https://img.shields.io/badge/JDK-21-0F9D58?logo=openjdk&logoColor=white" alt="JDK 21"/>
  <img src="https://img.shields.io/badge/Maven-3.8+-C71A36?logo=apache-maven&logoColor=white" alt="Maven"/>
</p>

---

## Membres du Groupe

| Photo | Nom | Rôle | Responsabilités |
|:-----:|-----|------|-----------------|
| 👨‍💻 | **NIYURUKUNDO Méthode** | **Backend** — Couche Métier et Persistance | Base de données, Entités JPA, EJBs Session Beans, Servlets, Filtre de sécurité, Script SQL |
| 👩‍💻 | **NSABIYUMVA Nice Stella** | **Frontend** — Couche Présentation | CSS, JavaScript, JSP/JSTL, Design système, Pages et formulaires *(en cours)* |

---

## Table des matières

- [1. Description du Projet](#1-description-du-projet)
- [2. Technologies Utilisées](#2-technologies-utilisées)
- [3. Architecture du Projet](#3-architecture-du-projet)
- [4. Répartition des Tâches par Membre](#4-répartition-des-tâches-par-membre)
- [5. Fonctionnalités Implémentées](#5-fonctionnalités-implémentées)
- [6. Le Workflow (11 États)](#6-le-workflow-11-états)
- [7. Base de Données](#7-base-de-données)
- [8. Guide d'Installation et Démarrage](#8-guide-dinstallation-et-démarrage)
- [9. Choix Techniques Justifiés](#9-choix-techniques-justifiés)
- [10. Conformité au Cahier des Charges](#10-conformité-au-cahier-des-charges)
- [11. Journal des Corrections et Améliorations](#11-journal-des-corrections-et-améliorations)

---

## 1. Description du Projet

**StageTrack** est une application web multi-tiers développée en Jakarta EE qui digitalise la gestion complète des stages étudiants à l'Université Polytechnique de Gitega (UPG).

### Problème Résolu

La gestion manuelle des stages (formulaires papier, suivi oral, notation sur carnet) provoque des pertes d'informations, des retards de validation, et un manque de traçabilité. StageTrack offre une plateforme numérique centralisée où chaque étape du cycle de stage — de la soumission de l'offre à l'archivage final — est tracée, validée et consultable en temps réel.

### Les 3 Acteurs du Système

| Acteur | Description | Permissions |
|--------|-------------|-------------|
| **ADMIN** | Administrateur universitaire | Gère les utilisateurs, affecte les superviseurs, archive les dossiers |
| **SUPERVISEUR** | Enseignant encadrant | Valide les offres, évalue les rapports, suit les étudiants |
| **ÉTUDIANT** | Étudiant en stage | Soumet les offres et rapports, consulte l'avancement |

### Workflow en 11 États

Le cœur du système repose sur un workflow de 11 états pour chaque offre de stage, assurant un suivi complet du processus :
`OFFRE_SOUMISE → EN_VALIDATION → VALIDEE → STAGE_EN_COURS → RAPPORT_SOUMIS → EN_CORRECTION → RAPPORT_VALIDE → NOTE_ATTRIBUEE → ARCHIVE`

Avec les cas alternatifs : `DOSSIER_INCOMPLET` (retour à l'étudiant) et `PAUSE` (interruption temporaire).

### Valeur Ajoutée pour l'UPG

- Traçabilité complète de chaque dossier de stage
- Réduction des délais de traitement (validation numérique)
- Tableaux de bord en temps réel pour chaque acteur
- Calcul automatique de la note finale
- Archivage numérique des dossiers

---

## 2. Technologies Utilisées

| Technologie | Version | Usage dans le Projet |
|-------------|---------|----------------------|
| Java | 21 | Langage de programmation principal |
| Jakarta Servlet | 6.0 | Contrôleurs HTTP (8 Servlets) |
| Jakarta JSP + JSTL | 3.0 | Vues dynamiques (27 JSP, zéro scriptlet) |
| Jakarta EJB | 4.0 | Logique métier (5 Stateless Beans) |
| Jakarta JPA / EclipseLink | 3.0 | Persistance des données (9 entités) |
| Jakarta CDI | 4.0 | Injection de dépendances |
| GlassFish | 7.0.9 | Serveur d'application Jakarta EE |
| PostgreSQL | 18.x | Système de gestion de base de données (déploiement) |
| Maven | 3.8+ | Gestion du build et des dépendances |
| JDK | 21 | Kit de développement Java |
| UTF-8 | — | Encodage global (pomp, filtres, web.xml, JSP) |

> **Note :** Le script `stagetrack-postgresql.sql` fournit le schéma et les données de test pour **PostgreSQL 18** (base réellement déployée). Le schéma a été conçu au départ pour MySQL 8 ; les deux moteurs restent compatibles au niveau des entités JPA.

### Dépendances Maven

```xml
<dependencies>
    <!-- Jakarta EE API (fourni par GlassFish) -->
    <dependency>
        <groupId>jakarta.platform</groupId>
        <artifactId>jakarta.jakartaee-api</artifactId>
        <version>10.0.0</version>
        <scope>provided</scope>
    </dependency>
    
    <!-- JSTL pour JSP -->
    <dependency>
        <groupId>org.glassfish.web</groupId>
        <artifactId>jakarta.servlet.jsp.jstl</artifactId>
        <version>3.0.1</version>
    </dependency>
</dependencies>
```

> **Note :** Aucun framework Spring, JSF, ou REST n'est utilisé. Le projet est 100% Jakarta EE natif.
>
> **Encodage build :** `pom.xml` force `project.build.sourceEncoding` et `project.reporting.outputEncoding` à `UTF-8`, ainsi que `<encoding>UTF-8</encoding>` dans `maven-compiler-plugin`.

---

## 3. Architecture du Projet

### Architecture en Couches (Multi-tiers)

```
┌─────────────────────────────────────────────────────────┐
│                  COUCHE PRÉSENTATION                     │
│  27 JSP/JSTL + 4 CSS + 2 JS (design système complet)    │
│  (Responsable : NSABIYUMVA Nice Stella — terminé)       │
└───────────────────────┬─────────────────────────────────┘
                        │ HTTP (Servlet)
┌───────────────────────▼─────────────────────────────────┐
│                  COUCHE CONTRÔLEUR                       │
│  8 Servlets Jakarta Servlet 6.0 + AuthFilter (sécurité,  │
│  contrôle de rôle par action, encodage UTF-8)           │
│  + util/WebUtil                                         │
│  (Responsable : NIYURUKUNDO Méthode)                    │
└───────────────────────┬─────────────────────────────────┘
                        │ @EJB @Inject
┌───────────────────────▼─────────────────────────────────┐
│                  COUCHE MÉTIER                           │
│  5 EJB Session Beans @Stateless                         │
│  (Responsable : NIYURUKUNDO Méthode)                    │
└───────────────────────┬─────────────────────────────────┘
                        │ EntityManager
┌───────────────────────▼─────────────────────────────────┐
│                  COUCHE PERSISTANCE                      │
│  9 Entités JPA + JPQL + EclipseLink                     │
│  (Responsable : NIYURUKUNDO Méthode)                    │
└───────────────────────┬─────────────────────────────────┘
                        │ JDBC
┌───────────────────────▼─────────────────────────────────┐
│                  BASE DE DONNÉES                         │
│  PostgreSQL 18 — stagetrack_db — 9 tables              │
│  (Responsable : NIYURUKUNDO Méthode)                    │
└─────────────────────────────────────────────────────────┘
```

### Arborescence du Projet

```
stagetrack/
├── pom.xml                                      # Configuration Maven (build UTF-8)
├── stagetrack-postgresql.sql                    # Script PostgreSQL (schéma + données de test)
├── .vscode/settings.json                        # Encodage UTF-8 (VS Code)
├── src/
│   └── main/
│       ├── java/bi/upg/stagetrack/
│       │   ├── enums/                           # Énumérations métier
│       │   │   ├── Role.java                    #   ADMIN, SUPERVISEUR, ETUDIANT
│       │   │   ├── StatutOffre.java             #   11 états du workflow
│       │   │   ├── StatutRapport.java           #   SOUMIS, EN_CORRECTION, VALIDE
│       │   │   └── TypePiece.java               #   LETTRE_ACCEPTATION, CV, AUTRE
│       │   ├── entity/                          # Entités JPA (9 tables)
│       │   │   ├── Utilisateur.java             #   Classe mère de tous les utilisateurs
│       │   │   ├── Etudiant.java                #   Hérite de Utilisateur (OneToOne)
│       │   │   ├── Superviseur.java             #   Hérite de Utilisateur (OneToOne)
│       │   │   ├── Entreprise.java              #   Organisme d'accueil
│       │   │   ├── OffreStage.java              #   Offre de stage (entité centrale)
│       │   │   ├── PieceJointe.java             #   Documents joints à une offre
│       │   │   ├── Convention.java              #   Convention de stage
│       │   │   ├── RapportStage.java            #   Rapport de stage
│       │   │   └── Note.java                    #   Évaluation finale
│       │   ├── ejb/                             # Logique métier (5 EJBs)
│       │   │   ├── OffreStageBean.java          #   CRUD offres + workflow
│       │   │   ├── RapportStageBean.java        #   Gestion des rapports
│       │   │   ├── NoteBean.java                #   Calcul des notes
│       │   │   ├── StatistiqueBean.java         #   Statistiques & compteurs
│       │   │   └── GestionBean.java             #   CRUD utilisateurs & entreprises (transactionnel)
│       │   ├── servlet/                         # Contrôleurs HTTP (8 Servlets)
│       │   │   ├── AuthServlet.java             #   Login / Logout
│       │   │   ├── DashboardServlet.java        #   Tableaux de bord
│       │   │   ├── OffreStageServlet.java       #   Gestion des offres
│       │   │   ├── RapportServlet.java          #   Gestion des rapports
│       │   │   ├── NoteServlet.java             #   Attribution des notes
│       │   │   ├── ConventionServlet.java       #   Conventions de stage
│       │   │   ├── UtilisateurServlet.java      #   CRUD utilisateurs
│       │   │   └── EntrepriseServlet.java       #   CRUD entreprises
│       │   ├── util/
│       │   │   └── WebUtil.java                 #   Contrôle de rôle + messages d'erreur
│       │   └── filter/
│       │       └── AuthFilter.java              #   Filtre de sécurité + encodage UTF-8
│       ├── resources/META-INF/
│       │   └── persistence.xml                  #   Configuration JPA (EclipseLink + PostgreSQL)
│       └── webapp/
│           ├── login.jsp                        #   Connexion moderne (split-screen)
│           ├── index.jsp                        #   Redirection vers /login
│           ├── css/                             #   main, navbar, components, animations
│           ├── js/                              #   navbar.js, utils.js
│           └── WEB-INF/
│               ├── web.xml                      #   jsp-config : page-encoding + contentType UTF-8
│               ├── beans.xml                    #   Activation CDI
│               └── views/                       #   27 vues JSP (terminé)
└── target/
    └── stagetrack.war                           #   Artefact déployable (généré, non versionné)
```

---

## 4. Répartition des Tâches par Membre

---

### 👨‍💻 NIYURUKUNDO Méthode — Backend

Responsable de **toute la couche technique** : base de données, persistance, métier, contrôleurs, sécurité.

#### 4.1 Configuration du Projet

| Fichier | Chemin | Rôle |
|---------|--------|------|
| `pom.xml` | `pom.xml` | Configuration Maven — dépendances Jakarta EE 10, JSTL, plugins compiler 3.11.0 et war 3.4.0, Java 21 |
| `persistence.xml` | `src/main/resources/META-INF/persistence.xml` | Unité de persistance `stagetrack-pu`, transaction JTA, source `jdbc/stagetrackDS`, 9 entités déclarées |
| `beans.xml` | `src/main/webapp/WEB-INF/beans.xml` | Activer CDI `bean-discovery-mode="all"` |
| `stagetrack.sql` | `stagetrack.sql` | Script complet : 9 tables MySQL + 15+ enregistrements de test |

#### 4.2 Énumérations (4 fichiers)

| Fichier | Chemin | Valeurs |
|---------|--------|---------|
| `Role.java` | `src/main/java/bi/upg/stagetrack/enums/Role.java` | `ADMIN`, `SUPERVISEUR`, `ETUDIANT` |
| `StatutOffre.java` | `src/main/java/bi/upg/stagetrack/enums/StatutOffre.java` | 11 états : `OFFRE_SOUMISE`, `EN_VALIDATION`, `DOSSIER_INCOMPLET`, `VALIDEE`, `STAGE_EN_COURS`, `PAUSE`, `RAPPORT_SOUMIS`, `EN_CORRECTION`, `RAPPORT_VALIDE`, `NOTE_ATTRIBUEE`, `ARCHIVE` |
| `StatutRapport.java` | `src/main/java/bi/upg/stagetrack/enums/StatutRapport.java` | `SOUMIS`, `EN_CORRECTION`, `VALIDE` |
| `TypePiece.java` | `src/main/java/bi/upg/stagetrack/enums/TypePiece.java` | `LETTRE_ACCEPTATION`, `CV`, `AUTRE` |

#### 4.3 Entités JPA (9 fichiers)

**`Utilisateur.java`** — `bi.upg.stagetrack.entity.Utilisateur`
- Table : `utilisateur`
- Champs : `id` (BIGINT PK AUTO), `nom` (VARCHAR 100), `prenom` (VARCHAR 100), `email` (VARCHAR 150 UNIQUE), `motDePasse` (VARCHAR 255), `role` (ENUM Role), `dateCreation` (DATETIME)
- Méthodes : getters/setters + `getNomComplet()`

**`Etudiant.java`** — `bi.upg.stagetrack.entity.Etudiant`
- Table : `etudiant`
- Champs : `id` (BIGINT PK), `utilisateur` (@OneToOne → Utilisateur), `matricule` (VARCHAR 50 UNIQUE), `filiere` (VARCHAR 100), `promotion` (VARCHAR 50)

**`Superviseur.java`** — `bi.upg.stagetrack.entity.Superviseur`
- Table : `superviseur`
- Champs : `id` (BIGINT PK), `utilisateur` (@OneToOne → Utilisateur), `grade` (VARCHAR 100), `specialite` (VARCHAR 150)

**`Entreprise.java`** — `bi.upg.stagetrack.entity.Entreprise`
- Table : `entreprise`
- Champs : `id` (BIGINT PK), `nom` (VARCHAR 200), `adresse` (VARCHAR 255), `telephone` (VARCHAR 30), `email` (VARCHAR 150), `secteur` (VARCHAR 150), `representant` (VARCHAR 150)

**`OffreStage.java`** — `bi.upg.stagetrack.entity.OffreStage`
- Table : `offre_stage` — **entité centrale du système**
- Champs : `id` (BIGINT PK), `titre` (VARCHAR 200), `description` (TEXT), `dateSoumission` (DATETIME), `dateDebut` (DATE), `dateFin` (DATE), `dureeEnMois` (INT), `statut` (ENUM StatutOffre), `motifRejet` (TEXT)
- Relations : `etudiant` (@ManyToOne), `entreprise` (@ManyToOne), `superviseur` (@ManyToOne), `piecesJointes` (@OneToMany cascade ALL), `convention` (@OneToOne), `rapports` (@OneToMany)

**`PieceJointe.java`** — `bi.upg.stagetrack.entity.PieceJointe`
- Table : `piece_jointe`
- Champs : `id` (BIGINT PK), `nomFichier` (VARCHAR 255), `typePiece` (ENUM TypePiece), `chemin` (VARCHAR 500), `dateAjout` (DATETIME)
- Relations : `offreStage` (@ManyToOne)

**`Convention.java`** — `bi.upg.stagetrack.entity.Convention`
- Table : `convention`
- Champs : `id` (BIGINT PK), `dateGeneration` (DATETIME), `contenu` (TEXT), `statut` (VARCHAR 20)
- Relations : `offreStage` (@OneToOne)
- Constructeur paramétré : initialise `statut = "EN_ATTENTE"`

**`RapportStage.java`** — `bi.upg.stagetrack.entity.RapportStage`
- Table : `rapport_stage`
- Champs : `id` (BIGINT PK), `titre` (VARCHAR 200), `cheminFichier` (VARCHAR 500), `dateSoumission` (DATETIME), `statut` (ENUM StatutRapport), `commentaire` (TEXT)
- Relations : `offreStage` (@ManyToOne), `note` (@OneToOne mappedBy)
- Constructeur paramétré : initialise `statut = StatutRapport.SOUMIS`

**`Note.java`** — `bi.upg.stagetrack.entity.Note`
- Table : `note`
- Champs : `id` (BIGINT PK), `noteStage` (DOUBLE), `noteRapport` (DOUBLE), `notePresence` (DOUBLE), `noteFinale` (DOUBLE), `mention` (VARCHAR 50), `appreciation` (TEXT), `dateAttribution` (DATETIME)
- Relations : `rapportStage` (@OneToOne)

#### 4.4 EJB Session Beans (5 fichiers)

**`OffreStageBean.java`** — `bi.upg.stagetrack.ejb.OffreStageBean` — `@Stateless`

| Méthode | Paramètres | Description |
|---------|------------|-------------|
| `soumettreOffre(OffreStage)` | Offre | Recherche etudiant/entreprise, définit OFFRE_SOUMISE, persiste |
| `ouvrirDossier(Long)` | id offre | Passe le statut à EN_VALIDATION |
| `validerOffre(Long)` | id offre | Passe le statut à VALIDEE |
| `demanderCorrection(Long, String)` | id + motif | Passe à DOSSIER_INCOMPLET + enregistre motifRejet |
| `demarrerStage(Long)` | id offre | Passe à STAGE_EN_COURS |
| `mettreEnPause(Long)` | id offre | Passe à PAUSE |
| `reprendreStage(Long)` | id offre | Passe à STAGE_EN_COURS (depuis PAUSE) |
| `affecterSuperviseur(Long, Long)` | id offre + id superviseur | Associe un superviseur à l'offre |
| `archiverDossier(Long)` | id offre | Passe à ARCHIVE |
| `findEtudiantByUtilisateurId(Long)` | id utilisateur | Recherche l'entité Etudiant via JPQL |
| `findSuperviseurByUtilisateurId(Long)` | id utilisateur | Recherche l'entité Superviseur via JPQL |
| `creerOuTrouverEntreprise(...)` | 6 champs entreprise | Recherche par nom ou crée nouvelle |
| `listerToutes()` | — | Toutes les offres, triées par date DESC |
| `listerParSuperviseur(Superviseur)` | superviseur | Offres filtrées par superviseur |
| `listerParEtudiant(Long)` | etudiantId | Offres d'un étudiant |
| `listerSansSuperviseur()` | — | Offres sans superviseur affecté |
| `getSuperviseursDisponibles()` | — | Tous les superviseurs |
| `trouverEntreprise(Long)` | id entreprise | em.find |

**`RapportStageBean.java`** — `bi.upg.stagetrack.ejb.RapportStageBean` — `@Stateless`

| Méthode | Paramètres | Description |
|---------|------------|-------------|
| `soumettreRapport(RapportStage, Long)` | rapport + offreId | Définit rapport SOUMIS, offre RAPPORT_SOUMIS |
| `validerRapport(Long)` | rapportId | Rapport VALIDE + offre RAPPORT_VALIDE |
| `demanderCorrection(Long, String)` | rapportId + commentaire | Rapport EN_CORRECTION + offre EN_CORRECTION |
| `resoumettreRapport(Long, RapportStage)` | offreId + nouveau rapport | Crée nouveau rapport SOUMIS + offre RAPPORT_SOUMIS |
| `findByOffreId(Long)` | offreId | Liste des rapports pour une offre |
| `listerTous()` | — | Tous les rapports, triés par date DESC |
| `trouverRapport(Long)` | id | em.find |

**`NoteBean.java`** — `bi.upg.stagetrack.ejb.NoteBean` — `@Stateless`

| Méthode | Paramètres | Description |
|---------|------------|-------------|
| `calculerNoteFinale(double, double, double)` | noteStage, noteRapport, notePresence | Formule : `0.40 × stage + 0.40 × rapport + 0.20 × présence` |
| `calculerMention(double)` | noteFinale | ≥18 Très Bien, ≥16 Bien, ≥14 Assez Bien, ≥12 Passable, sinon Insuffisant |
| `attribuerNote(Long, double, double, double, String)` | rapportId + 3 notes + appréciation | Trouve rapport, calcule noteFinale+mention, persiste Note, passe offre à NOTE_ATTRIBUEE |

**`StatistiqueBean.java`** — `bi.upg.stagetrack.ejb.StatistiqueBean` — `@Stateless`

| Méthode | Paramètres | Description |
|---------|------------|-------------|
| `compterParStatut(StatutOffre)` | statut | COUNT des offres par statut |
| `getNombreStagesActifs()` | — | Nombre de stages en cours |
| `getSansSuperviseur()` | — | Offres sans superviseur affecté |
| `getAllSuperviseurs()` | — | Tous les superviseurs |

**`GestionBean.java`** — `bi.upg.stagetrack.ejb.GestionBean` — `@Stateless`

EJB transactionnel dédié aux écritures des Servlets administratives (les `em.persist/remove` directs hors EJB échouent avec `TransactionRequiredException`).

| Méthode | Paramètres | Description |
|---------|------------|-------------|
| `creerUtilisateur(...)` | infos + rôle | Crée utilisateur + entité Etudiant/Superviseur ; **pré-vérifie l'unicité de l'e-mail** |
| `supprimerUtilisateur(Long)` | id | Supprime un utilisateur |
| `modifierMotDePasse(Long, String)` | id + nouveau mdp | Change le mot de passe |
| `creerEntreprise(...)` | 6 champs | Crée une entreprise |
| `modifierEntreprise(...)` | id + champs | Modifie une entreprise |
| `supprimerEntreprise(Long)` | id | Supprime une entreprise |

#### 4.5 Servlets — Contrôleurs HTTP (8 fichiers)

> **Contrôle de rôle par action :** chaque action vérifie le rôle via `WebUtil.exigerRole()` (`util/WebUtil.java`).
> ADMIN → gestion utilisateurs/entreprises/notes/conventions, affectation et archivage ;
> SUPERVISEUR → ouverture, validation, correction, démarrage, pause/reprise (offres) et évaluation (rapports) ;
> ÉTUDIANT → soumission d'offres et de rapports, accès « Mon stage » et « Convention ».
> Les accès non autorisés sont redirigés (302) vers le dashboard du rôle.

**`AuthServlet.java`** — `@WebServlet("/login")`

| Méthode | Action | Description |
|---------|--------|-------------|
| `doGet` | `?action=deconnexion` | Invalide la session → redirection vers `/login` |
| `doGet` | (défaut) | Forward vers `login.jsp` |
| `doPost` | — | Authentifie par email/motDePasse via JPQL, stocke l'utilisateur en session, redirige vers `/dashboard` |

**`DashboardServlet.java`** — `@WebServlet("/dashboard/*")`

| Méthode | Action | Description |
|---------|--------|-------------|
| `doGet` | rôle=ETUDIANT | Forward vers `dashboard-etudiant.jsp` avec liste offres |
| `doGet` | rôle=SUPERVISEUR | Forward vers `dashboard-superviseur.jsp` avec offres assignées |
| `doGet` | rôle=ADMIN (défaut) | Forward vers `dashboard-admin.jsp` avec statistiques (par statut, stages actifs, sans superviseur) |

**`OffreStageServlet.java`** — `@WebServlet("/offres")`

| Méthode | Action | Description |
|---------|--------|-------------|
| `doGet` | `nouvelle` | Forward vers `offre-etape1.jsp` (formulaire étape 1) — ÉTUDIANT |
| `doGet` | `etape2` | Forward vers `offre-etape2.jsp` (choix entreprise) — ÉTUDIANT |
| `doGet` | `etape3` | Forward vers `offre-etape3.jsp` (pièces jointes + résumé) — ÉTUDIANT |
| `doGet` | `detail?id=X` | Forward vers `detail-offre.jsp` — ADMIN/SUPERVISEUR |
| `doGet` | `affecter` | Forward vers formulaire d'affectation superviseur — ADMIN |
| `doGet` | `mon-stage` | Page « Mes stages » (liste de ses demandes + bouton « Déposer une demande ») — ÉTUDIANT |
| `doGet` | (défaut) | Forward vers `liste-offres.jsp` (filtrées par rôle) |
| `doPost` | `soumettre` | Soumet l'offre (étape 3 → OFFRE_SOUMISE) |
| `doPost` | `ouvrir` | Ouvre le dossier (→ EN_VALIDATION) |
| `doPost` | `valider` | Valide l'offre (→ VALIDEE) |
| `doPost` | `corriger` | Demande correction (→ DOSSIER_INCOMPLET) |
| `doPost` | `demarrer` | Démarre le stage (→ STAGE_EN_COURS) |
| `doPost` | `pause` / `reprendre` | Pause ou reprend le stage |
| `doPost` | `archiver` | Archive le dossier (→ ARCHIVE) |
| `doPost` | `affecterSuperviseur` | Affecte un superviseur |

**`RapportServlet.java`** — `@WebServlet("/rapports")`

| Méthode | Action | Description |
|---------|--------|-------------|
| `doGet` | `nouveau` / `resoumettre` | Forward vers `rapport-etape1.jsp` |
| `doGet` | `etape2` | Forward vers `rapport-etape2.jsp` |
| `doGet` | `evaluer?id=X` | Forward vers `evaluer-rapport.jsp` |
| `doGet` | (défaut) | Liste des rapports |
| `doPost` | `soumettre` | Soumet le rapport (2 étapes) |
| `doPost` | `resoumettre` | Nouvelle soumission après correction |
| `doPost` | `valider` | Valide le rapport |
| `doPost` | `corriger` | Demande correction du rapport |

**`NoteServlet.java`** — `@WebServlet("/notes")`

| Méthode | Action | Description |
|---------|--------|-------------|
| `doGet` | `noter?id=X` | Formulaire de notation |
| `doGet` | (défaut) | Liste des rapports notables (VALIDE) |
| `doPost` | — | Appelle `noteBean.attribuerNote()`, affiche le résultat |

**`ConventionServlet.java`** — `@WebServlet("/conventions")`

| Méthode | Action | Description |
|---------|--------|-------------|
| `doGet` | `detail?id=X` | Détail d'une convention |
| `doGet` | (défaut) | Liste des conventions |

**`UtilisateurServlet.java`** — `@WebServlet("/utilisateurs")`

| Méthode | Action | Description |
|---------|--------|-------------|
| `doGet` | — | Liste tous les utilisateurs → `gestion-utilisateurs.jsp` |
| `doPost` | `creer` | Crée un utilisateur + entité Etudiant/Superviseur selon le rôle |
| `doPost` | `supprimer` | Supprime un utilisateur |
| `doPost` | `modifierMotDePasse` | Change le mot de passe |

**`EntrepriseServlet.java`** — `@WebServlet("/entreprises")`

| Méthode | Action | Description |
|---------|--------|-------------|
| `doGet` | — | Liste toutes les entreprises → `gestion-entreprises.jsp` |
| `doPost` | `creer` | Crée une entreprise |
| `doPost` | `modifier` | Modifie une entreprise |
| `doPost` | `supprimer` | Supprime une entreprise |

#### 4.6 Filtre de Sécurité (1 fichier)

**`AuthFilter.java`** — `@WebFilter("/*")`

- En première instruction : `request.setCharacterEncoding("UTF-8")` et `response.setCharacterEncoding("UTF-8")` (encodage global)
- URL publiques (accessibles sans session) : `/login`, `/login.jsp`, `/index.jsp`, `/`, `/css/`, `/js/`, `/images/`
- Pour toute autre URL : vérifie la présence de `HttpSession` avec l'attribut `"utilisateur"`
- Sans session → redirection vers `/login`

> **Complément :** `WEB-INF/web.xml` ajoute un `jsp-property-group` (`*.jsp`) qui force `page-encoding=UTF-8`,
> `trim-directive-whitespaces` et `default-content-type=text/html;charset=UTF-8` — toutes les JSP sont lues et servies en UTF-8.

---

### 👩‍💻 NSABIYUMVA Nice Stella — Frontend

> **Statut : terminé.** L'ensemble des pages JSP, CSS et JavaScript est intégré au code source
> (27 JSP dans `src/main/webapp`, 4 feuilles CSS, 2 fichiers JS) et déployé avec l'application.

#### Fichiers CSS

| Fichier | Rôle |
|---------|------|
| `css/main.css` | Styles globaux, variables CSS, palette de couleurs, layout 3 colonnes, typographie Inter |
| `css/navbar.css` | Barre de navigation latérale, menu responsive, états actifs |
| `css/components.css` | Composants réutilisables : badges, cartes, boutons, formulaires, tableaux, alertes, timeline |
| `css/animations.css` | Animations : fadeInUp, pulse-glow, slideInLeft |

#### Fichiers JS

| Fichier | Rôle |
|---------|------|
| `js/navbar.js` | Menu hamburger responsive, toggle sidebar sous 768px |
| `js/utils.js` | Fonctions utilitaires : validation formulaires, gestion des étapes multi-formulaires |

#### Fichiers JSP

| Fichier | Description |
|---------|-------------|
| `login.jsp` | Page de connexion moderne (split-screen, icônes SVG, affichage mot de passe) |
| `index.jsp` | Page d'accueil / redirection vers `/login` |
| `WEB-INF/views/include/head.jsp` | En-tête HTML (meta charset UTF-8), inclusion CSS/JS |
| `WEB-INF/views/include/navbar.jsp` | Barre de navigation latérale (conditionnelle par rôle via `<c:if>`) |
| `WEB-INF/views/include/footer.jsp` | Pied de page |
| `WEB-INF/views/dashboard-admin.jsp` | Tableau de bord administrateur avec 4 cartes statistiques |
| `WEB-INF/views/dashboard-superviseur.jsp` | Tableau de bord superviseur avec offres assignées |
| `WEB-INF/views/dashboard-etudiant.jsp` | Tableau de bord étudiant : toutes les offres + notes + motifs de correction |
| `WEB-INF/views/offre-etape1.jsp` | Formulaire multi-étapes — Étape 1 : infos offre |
| `WEB-INF/views/offre-etape2.jsp` | Formulaire multi-étapes — Étape 2 : choix entreprise |
| `WEB-INF/views/offre-etape3.jsp` | Formulaire multi-étapes — Étape 3 : pièces jointes + soumission |
| `WEB-INF/views/liste-offres.jsp` | Liste des offres (filtrée par rôle ; « Mes stages » pour l'étudiant) |
| `WEB-INF/views/detail-offre.jsp` | Détail d'une offre avec workflow |
| `WEB-INF/views/rapport-etape1.jsp` | Formulaire rapport — Étape 1 |
| `WEB-INF/views/rapport-etape2.jsp` | Formulaire rapport — Étape 2 |
| `WEB-INF/views/evaluer-rapport.jsp` | Formulaire d'évaluation d'un rapport |
| `WEB-INF/views/resultat-note.jsp` | Résultat de la note finale (note + mention) |
| `WEB-INF/views/noter-rapport.jsp` | Formulaire d'attribution de la note |
| `WEB-INF/views/liste-rapports.jsp` | Liste des rapports (filtrée par rôle) |
| `WEB-INF/views/liste-notes.jsp` | Liste des notes attribuées |
| `WEB-INF/views/liste-conventions.jsp` | Liste des conventions |
| `WEB-INF/views/convention.jsp` | Détail d'une convention de stage |
| `WEB-INF/views/affecter-superviseur.jsp` | Formulaire d'affectation d'un superviseur (Admin) |
| `WEB-INF/views/gestion-utilisateurs.jsp` | CRUD utilisateurs (Admin) |
| `WEB-INF/views/gestion-entreprises.jsp` | CRUD entreprises (Admin) |
| `WEB-INF/views/erreur.jsp` | Page d'erreur générique (message métier dégainé via `WebUtil.messageReel`) |
| `WEB-INF/views/acces-refuse.jsp` | Page d'accès refusé |

#### Design System

- **Thème** : Dark mode professionnel
- **Typographie** : Inter (Google Fonts)
- **Layout** : 3 colonnes (sidebar 220px + centre flexible + panneau droit 320px)
- **Composants CSS** : Badges de statut (11 couleurs), badges de rôle, cartes statistiques (4 gradients), boutons (primary/secondary/success/warning/danger), formulaires, tableaux, alertes, timeline, indicateur multi-étapes
- **Responsive** : Menu hamburger sous 768px
- **Animations** : fadeInUp, pulse-glow, slideInLeft

---

## 5. Fonctionnalités Implémentées

### Tableau Récapitulatif

| # | Fonctionnalité | Rôle | Statut Backend | Responsable |
|---|----------------|------|:--------------:|-------------|
| 1 | Authentification / Déconnexion | Tous | ✅ Complet | Méthode |
| 2 | Dashboard Admin (4 statistiques) | Admin | ✅ Complet | Méthode |
| 3 | Dashboard Superviseur | Superviseur | ✅ Complet | Méthode |
| 4 | Dashboard Étudiant | Étudiant | ✅ Complet | Méthode |
| 5 | Soumission offre (3 étapes) | Étudiant | ✅ Complet | Méthode |
| 6 | Validation workflow offre | Superviseur | ✅ Complet | Méthode |
| 7 | Affectation superviseur | Admin | ✅ Complet | Méthode |
| 8 | Soumission rapport (2 étapes) | Étudiant | ✅ Complet | Méthode |
| 9 | Évaluation rapport | Superviseur | ✅ Complet | Méthode |
| 10 | Calcul note automatique | Système | ✅ Complet | Méthode |
| 11 | Gestion utilisateurs (CRUD) | Admin | ✅ Complet | Méthode |
| 12 | Gestion entreprises (CRUD) | Admin | ✅ Complet | Méthode |
| 13 | Convention de stage | Tous | ✅ Complet | Méthode |
| 14 | Archivage dossiers | Admin | ✅ Complet | Méthode |
| 15 | Sécurité / Filtre HTTP | Système | ✅ Complet | Méthode |
| 16 | Interface utilisateur (JSP/CSS/JS) | Tous | ✅ Complet | Nice Stella |
| 17 | Contrôle de rôle par action (`WebUtil`) | Tous | ✅ Complet | Méthode |
| 18 | Encodage UTF-8 global (filtre + web.xml + JSP) | Système | ✅ Complet | Méthode |

### Détails Techniques des Fonctionnalités

#### 1. Authentification
- **Servlet** : `AuthServlet` → `@WebServlet("/login")`
- **Mécanisme** : Requête JPQL `SELECT u FROM Utilisateur u WHERE u.email = :email AND u.motDePasse = :motDePasse`
- **Session** : `HttpSession` avec clé `"utilisateur"` stockant l'objet `Utilisateur`
- **Filtre** : `AuthFilter` protège toutes les URLs sauf `/login`, `/index.jsp`, `/css/`, `/js/`

#### 2-4. Tableaux de bord
- **Servlet** : `DashboardServlet` → `@WebServlet("/dashboard/*")`
- **Admin** : Affiche `compterParStatut()` pour chaque statut, `getNombreStagesActifs()`, offres sans superviseur
- **Superviseur** : Liste des offres assignées via `listerParSuperviseur()`
- **Étudiant** : Liste des offres de l'étudiant via `listerParEtudiant()`

#### 5. Soumission offre (3 étapes)
- **Étape 1** (`offre-etape1`) : Titre, description, dates (début/fin/durée)
- **Étape 2** (`offre-etape2`) : Sélection ou création de l'entreprise
- **Étape 3** (`offre-etape3`) : Pièces jointes (lettre, CV), résumé et soumission
- **Stockage intermédiaire** : `HttpSession` pour les données des étapes non encore persistées
- **Persistance** : `OffreStageBean.soumettreOffre()` crée l'entité avec statut `OFFRE_SOUMISE`

#### 6-7. Workflow offre
- **Validation** : `OffreStageBean.validerOffre()` → statut `VALIDEE`
- **Correction** : `OffreStageBean.demanderCorrection()` → statut `DOSSIER_INCOMPLET` + motif
- **Affectation** : `OffreStageBean.affecterSuperviseur()` → lien vers entité `Superviseur`

#### 8-9. Rapports
- **Soumission** : 2 étapes via `RapportServlet` → `RapportStageBean.soumettreRapport()`
- **Évaluation** : `RapportServlet` → `evaluer-rapport.jsp` → `validerRapport()` ou `demanderCorrection()`

#### 10. Calcul note automatique
- **Formule** : `noteFinale = 0.40 × noteStage + 0.40 × noteRapport + 0.20 × notePresence`
- **Mentions** : ≥18 Très Bien | ≥16 Bien | ≥14 Assez Bien | ≥12 Passable | <12 Insuffisant
- **Implémentation** : `NoteBean.attribuerNote()` → crée l'entité `Note` + passe offre à `NOTE_ATTRIBUEE`

---

## 6. Le Workflow (11 États)

### Schéma du Workflow Complet

```
                          ┌─────────────────────┐
                          │   OFFRE_SOUMISE     │
                          │   (Étudiant soumet) │
                          └─────────┬───────────┘
                                    │ Admin affecte superviseur
                          ┌─────────▼───────────┐
                          │   EN_VALIDATION     │
                          │  (Superviseur ouvre) │
                          └─────────┬───────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
          ┌─────────▼───────┐  ┌───▼──────────┐   │
          │ DOSSIER_        │  │   VALIDEE    │   │
          │ INCOMPLET       │  │  (Validé)    │   │
          │ (→ retour       │  └───┬──────────┘   │
          │  à l'étudiant)  │      │              │
          └─────────▲───────┘      │ Démarrage    │
                    │              │              │
                    └──────────────┼──────────────┘
                                   │
                        ┌──────────▼──────────┐
                        │   STAGE_EN_COURS    │◄────► PAUSE
                        │   (Stage actif)     │       (interruption)
                        └──────────┬──────────┘
                                   │ Étudiant soumet rapport
                        ┌──────────▼──────────┐
                        │   RAPPORT_SOUMIS    │
                        └──────────┬──────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │                              │
          ┌─────────▼──────────┐      ┌───────────▼─────┐
          │   EN_CORRECTION    │      │   RAPPORT_      │
          │   (→ retour à      │      │   VALIDE        │
          │    l'étudiant)     │      └─────────┬───────┘
          └─────────▲──────────┘                │
                    │                           │ Note attribuée
                    └───────────────────────────┘
                                   │
                        ┌──────────▼──────────┐
                        │  NOTE_ATTRIBUEE     │
                        │  (Note finale calculée)│
                        └──────────┬──────────┘
                                   │ Archivage Admin
                        ┌──────────▼──────────┐
                        │      ARCHIVE        │
                        │  (Dossier finalisé) │
                        └─────────────────────┘
```

### Tableau des États

| # | État | Déclencheur | Acteur | Servlet / Bean | Transition |
|---|------|-------------|--------|----------------|------------|
| 1 | `OFFRE_SOUMISE` | Soumission formulaire 3 étapes | ÉTUDIANT | `OffreStageServlet` → `OffreStageBean.soumettreOffre()` | → EN_VALIDATION |
| 2 | `EN_VALIDATION` | Clic "Ouvrir dossier" | SUPERVISEUR | `OffreStageBean.ouvrirDossier()` | → VALIDEE ou DOSSIER_INCOMPLET |
| 3 | `DOSSIER_INCOMPLET` | Demande correction + motif | SUPERVISEUR | `OffreStageBean.demanderCorrection()` | → OFFRE_SOUMISE (resoumission) |
| 4 | `VALIDEE` | Validation du dossier | SUPERVISEUR | `OffreStageBean.validerOffre()` | → STAGE_EN_COURS |
| 5 | `STAGE_EN_COURS` | Démarrage du stage | SUPERVISEUR | `OffreStageBean.demarrerStage()` | → PAUSE ou RAPPORT_SOUMIS |
| 6 | `PAUSE` | Interruption temporaire | SUPERVISEUR | `OffreStageBean.mettreEnPause()` | → STAGE_EN_COURS (reprise) |
| 7 | `RAPPORT_SOUMIS` | Soumission rapport 2 étapes | ÉTUDIANT | `RapportStageBean.soumettreRapport()` | → EN_CORRECTION ou RAPPORT_VALIDE |
| 8 | `EN_CORRECTION` | Demande correction rapport | SUPERVISEUR | `RapportStageBean.demanderCorrection()` | → RAPPORT_SOUMIS (résoumission) |
| 9 | `RAPPORT_VALIDE` | Validation rapport | SUPERVISEUR | `RapportStageBean.validerRapport()` | → NOTE_ATTRIBUEE |
| 10 | `NOTE_ATTRIBUEE` | Attribution note finale | SUPERVISEUR | `NoteBean.attribuerNote()` | → ARCHIVE |
| 11 | `ARCHIVE` | Archivage du dossier | ADMIN | `OffreStageBean.archiverDossier()` | (terminal) |

### Scénario Complet de A à Z

1. **Étudiant** remplit le formulaire en 3 étapes (infos → entreprise → pièces jointes)
2. **Offre créée** avec statut `OFFRE_SOUMISE`
3. **Admin** affecte un superviseur à l'offre
4. **Superviseur** ouvre le dossier → `EN_VALIDATION`
5. **Superviseur** valide → `VALIDEE`
6. **Superviseur** démarre le stage → `STAGE_EN_COURS`
7. **Étudiant** soumet son rapport en 2 étapes → `RAPPORT_SOUMIS`
8. **Superviseur** évalue le rapport → `RAPPORT_VALIDE`
9. **Superviseur** attribue une note (3 composantes) → `NOTE_ATTRIBUEE`
10. **Admin** archive le dossier → `ARCHIVE`

---

## 7. Base de Données

### Schéma des Relations

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  utilisateur │     │   etudiant   │     │ superviseur  │
│──────────────│     │──────────────│     │──────────────│
│ PK id        │◄─1:1─│ FK utilisateur_id│   │ FK utilisateur_id│
│ nom          │     │ matricule    │     │ grade        │
│ prenom       │     │ filiere      │     │ specialite   │
│ email (UQ)   │     │ promotion    │     └──────┬───────┘
│ mot_de_passe │     └──────┬───────┘            │
│ role (ENUM)  │            │                    │
│ date_creation│            │                    │
└──────────────┘            │                    │
                            │                    │
                    ┌───────▼────────────────────▼───────┐
                    │          offre_stage                │
                    │────────────────────────────────────│
                    │ PK id                               │
                    │ titre                               │
                    │ description (TEXT)                  │
                    │ date_soumission                     │
                    │ date_debut / date_fin               │
                    │ duree_en_mois                       │
                    │ statut (ENUM — 11 valeurs)          │
                    │ motif_rejet (TEXT)                  │
                    │ FK etudiant_id → etudiant.id        │
                    │ FK entreprise_id → entreprise.id    │
                    │ FK superviseur_id → superviseur.id  │
                    └───┬──────────┬──────────┬──────────┘
                        │          │          │
               ┌────────▼──┐  ┌────▼─────┐  ┌▼──────────┐
               │piece_jointe│  │convention│  │rapport_stage│
               │───────────│  │──────────│  │───────────│
               │ PK id      │  │ PK id    │  │ PK id      │
               │ nom_fichier│  │ FK offre_│  │ titre      │
               │ type_piece │  │ stage_id │  │ chemin_fich│
               │ chemin     │  │ date_gen │  │ date_soum  │
               │ date_ajout │  │ contenu  │  │ statut     │
               │ FK offre_  │  │ statut   │  │ commentaire│
               │ stage_id   │  └──────────┘  │ FK offre_  │
               └────────────┘                 │ stage_id   │
                                              └─────┬──────┘
                                                    │
                                              ┌─────▼──────┐
                                              │   note     │
                                              │────────────│
                                              │ PK id      │
                                              │ FK rapport_│
                                              │ stage_id   │
                                              │ note_stage │
                                              │ note_rapport│
                                              │ note_presence│
                                              │ note_finale│
                                              │ mention    │
                                              │ appreciation│
                                              │ date_attrib│
                                              └────────────┘
```

### Description des Tables

#### `utilisateur`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `nom` | VARCHAR(100) | NOT NULL | Nom de famille |
| `prenom` | VARCHAR(100) | NOT NULL | Prénom |
| `email` | VARCHAR(150) | NOT NULL, UNIQUE | Adresse email (identifiant de connexion) |
| `mot_de_passe` | VARCHAR(255) | NOT NULL | Mot de passe en clair *(à sécuriser)* |
| `role` | ENUM('ADMIN','SUPERVISEUR','ETUDIANT') | NOT NULL | Rôle de l'utilisateur |
| `date_creation` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Date de création du compte |

#### `etudiant`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `utilisateur_id` | BIGINT | FK → utilisateur.id, UNIQUE, ON DELETE CASCADE | Lien vers compte utilisateur |
| `matricule` | VARCHAR(50) | NOT NULL, UNIQUE | Matricule étudiant |
| `filiere` | VARCHAR(100) | NOT NULL | Filière (ex: Génie Logiciel) |
| `promotion` | VARCHAR(50) | NOT NULL | Promotion (ex: BAC4) |

#### `superviseur`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `utilisateur_id` | BIGINT | FK → utilisateur.id, UNIQUE, ON DELETE CASCADE | Lien vers compte utilisateur |
| `grade` | VARCHAR(100) | — | Grade académique |
| `specialite` | VARCHAR(150) | — | Domaine de spécialité |

#### `entreprise`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `nom` | VARCHAR(200) | NOT NULL | Nom de l'entreprise |
| `adresse` | VARCHAR(255) | — | Adresse physique |
| `telephone` | VARCHAR(30) | — | Numéro de téléphone |
| `email` | VARCHAR(150) | — | Email de contact |
| `secteur` | VARCHAR(150) | — | Secteur d'activité |
| `representant` | VARCHAR(150) | — | Nom du représentant |

#### `offre_stage`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `titre` | VARCHAR(200) | NOT NULL | Titre de l'offre de stage |
| `description` | TEXT | — | Description détaillée |
| `date_soumission` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Date de soumission |
| `date_debut` | DATE | — | Date de début prévue |
| `date_fin` | DATE | — | Date de fin prévue |
| `duree_en_mois` | INT | — | Durée en mois |
| `statut` | ENUM(11 valeurs) | NOT NULL, DEFAULT 'OFFRE_SOUMISE' | Statut dans le workflow |
| `motif_rejet` | TEXT | — | Raison du rejet/correction |
| `etudiant_id` | BIGINT | FK → etudiant.id, NOT NULL | Étudiant demandeur |
| `entreprise_id` | BIGINT | FK → entreprise.id | Entreprise d'accueil |
| `superviseur_id` | BIGINT | FK → superviseur.id | Superviseur affecté |

#### `piece_jointe`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `nom_fichier` | VARCHAR(255) | NOT NULL | Nom du fichier |
| `type_piece` | ENUM('LETTRE_ACCEPTATION','CV','AUTRE') | NOT NULL | Type de document |
| `chemin` | VARCHAR(500) | — | Chemin du fichier |
| `date_ajout` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Date d'ajout |
| `offre_stage_id` | BIGINT | FK → offre_stage.id, ON DELETE CASCADE | Offre parente |

#### `convention`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `offre_stage_id` | BIGINT | FK → offre_stage.id, UNIQUE | Offre liée |
| `date_generation` | DATETIME | — | Date de génération |
| `contenu` | TEXT | — | Texte de la convention |
| `statut` | VARCHAR(20) | DEFAULT 'EN_ATTENTE' | Statut : EN_ATTENTE / GENEREE / SIGNEE |

#### `rapport_stage`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `titre` | VARCHAR(200) | NOT NULL | Titre du rapport |
| `chemin_fichier` | VARCHAR(500) | — | Chemin du fichier |
| `date_soumission` | DATETIME | DEFAULT CURRENT_TIMESTAMP | Date de soumission |
| `statut` | ENUM('SOUMIS','EN_CORRECTION','VALIDE') | NOT NULL | Statut du rapport |
| `commentaire` | TEXT | — | Commentaire du superviseur |
| `offre_stage_id` | BIGINT | FK → offre_stage.id | Offre liée |

#### `note`
| Colonne | Type | Contraintes | Description |
|---------|------|-------------|-------------|
| `id` | BIGINT | PK, AUTO_INCREMENT | Identifiant unique |
| `rapport_stage_id` | BIGINT | FK → rapport_stage.id, UNIQUE | Rapport évalué |
| `note_stage` | DOUBLE | — | Note sur le stage (sur 20) |
| `note_rapport` | DOUBLE | — | Note sur le rapport (sur 20) |
| `note_presence` | DOUBLE | — | Note de présence (sur 20) |
| `note_finale` | DOUBLE | — | Note finale calculée (0.4×stage + 0.4×rapport + 0.2×présence) |
| `mention` | VARCHAR(50) | — | Très Bien / Bien / Assez Bien / Passable / Insuffisant |
| `appreciation` | TEXT | — | Commentaire du superviseur |
| `date_attribution` | DATETIME | — | Date d'attribution de la note |

### Données de Test

| Compte | Email | Mot de Passe | Rôle |
|--------|-------|-------------|------|
| Admin | `admin@upg.bi` | `admin123` | ADMIN |
| Superviseur 1 | `nkurunziza@upg.bi` | `super123` | SUPERVISEUR |
| Superviseur 2 | `manirambona@upg.bi` | `super123` | SUPERVISEUR |
| Étudiant 1 | `irakoze@etud.upg.bi` | `etud123` | ETUDIANT |
| Étudiant 2 | `nshimirimana@etud.upg.bi` | `etud123` | ETUDIANT |

**Données supplémentaires :** 3 entreprises (BurundAI Tech, BIC Bank, Semicolon Technologies), 4 offres de stage (en cours, en correction, dossier incomplet, archivée), 1 convention, rapports de stage (validé, en correction), 1 note finale (14.4/20 — Assez Bien).

---

## 8. Guide d'Installation et Démarrage

### Prérequis

| Outil | Version | Vérification |
|-------|---------|--------------|
| JDK | 21 | `java -version` |
| Maven | 3.8+ | `mvn -version` |
| PostgreSQL | 18.x | `psql --version` |
| GlassFish | 7.0.9 | `asadmin version` |
| Driver PostgreSQL | postgresql-42.x | dans `domain1/lib/` |

### Étape 1 : Créer la Base de Données

```cmd
psql -U postgres -f stagetrack-postgresql.sql
```

Ou manuellement :
```sql
CREATE DATABASE stagetrack_db WITH ENCODING 'UTF8' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
-- puis exécuter les CREATE TABLE et INSERT du fichier stagetrack-postgresql.sql
```

### Étape 2 : Configurer la Source de Données GlassFish

```cmd
# Créer le pool de connexion PostgreSQL
asadmin create-jdbc-connection-pool ^
  --datasourceclassname=org.postgresql.ds.PGSimpleDataSource ^
  --restype=javax.sql.DataSource ^
  --property=serverName=localhost:portNumber=5432:databaseName=stagetrack_db:user=postgres:password=VOTRE_MDP ^
  stagetrackPool

# Créer la ressource JNDI
asadmin create-jdbc-resource --connectionpoolid=stagetrackPool jdbc/stagetrackDS

# Tester la connexion
asadmin ping-connection-pool stagetrackPool
```

### Étape 3 : Compiler le Projet

```cmd
mvn clean package
```

Le fichier `target/stagetrack.war` est généré.

### Étape 4 : Démarrer GlassFish et Déployer

```cmd
# Démarrer le domaine
asadmin start-domain domain1

# Déployer l'application
asadmin deploy --force=true --name=stagetrack --contextroot=/stagetrack target\stagetrack.war
```

### Étape 5 : Accéder à l'Application

| URL | Description |
|-----|-------------|
| `http://localhost:8080/stagetrack` | Application StageTrack |
| `http://localhost:4848` | Console d'administration GlassFish |

### Comptes de Test

| Rôle | Email | Mot de passe |
|------|-------|-------------|
| Admin | `admin@upg.bi` | `admin123` |
| Superviseur | `nkurunziza@upg.bi` | `super123` |
| Étudiant | `irakoze@etud.upg.bi` | `etud123` |

---

## 9. Choix Techniques Justifiés

### Pourquoi GlassFish plutôt que Tomcat ?

GlassFish est un serveur d'application Jakarta EE complet qui supporte nativement les **EJB**, **CDI**, **JPA** et les **transactions JTA** sans nécessiter de configuration externe. Tomcat n'est qu'un conteneur Servlet/JSP et nécessiterait Spring ou d'autres frameworks pour le même niveau d'intégration.

### Pourquoi EJB @Stateless pour la logique métier ?

Les Stateless Session Beans offrent la **gestion automatique des transactions** (chaque méthode est une transaction JTA), un **pool de beans** pour la montée en charge, et une **séparation claire** entre la couche contrôleur (Servlet) et la logique métier.

### Pourquoi CDI @Inject plutôt que lookup JNDI ?

L'injection par `@EJB` et `@Inject` rend le code **plus lisible**, **moins verbeux**, et **plus facilement testable**. Le conteneur gère le cycle de vie des dépendances automatiquement.

### Pourquoi JSTL + EL plutôt que scriptlets JSP ?

Les scriptlets (`<% %>`) mélangent la logique Java et la présentation dans les JSP, rendant le code illisible et difficile à maintenir. Les balises JSTL (`<c:forEach>`, `<c:if>`) et les expressions EL (`${variable}`) assurent une **séparation propre entre vue et logique**, conformément aux bonnes pratiques Java EE.

### Pourquoi HttpSession pour les étapes multi-formulaires ?

Les formulaires en 3 étapes (offre) et 2 étapes (rapport) utilisent `HttpSession` pour stocker temporairement les données des étapes intermédiaires avant la soumission finale. Cela évite la perte de données sans nécessiter de base de données temporaire.

### Pourquoi les noms de fichiers en String (pas de vrai upload) ?

La contrainte du cahier des charges se concentre sur l'architecture Java EE multi-tiers. Les fichiers sont stockés en tant que **noms de fichiers texte** dans la base de données, ce qui simplifie l'implémentation tout en démontrant la maîtrise des concepts JPA et EJB.

### Pourquoi ArrayList pour les paramètres JPQL enum ?

`List.of()` retourne une liste **immutable** incompatible avec le moteur EclipseLink lors de la construction de requêtes JPQL. L'utilisation de `ArrayList` avec `add()` un par un produit une liste mutable que le persisteur peut manipuler correctement.

---

## 10. Conformité au Cahier des Charges

| Exigence du Professeur | Statut | Détail |
|-------------------------|:------:|--------|
| Servlet 6 (contrôleurs) | ✅ | 8 Servlets Jakarta Servlet 6.0 + AuthFilter + WebUtil |
| JSP + JSTL (vues) | ✅ | **27 fichiers JSP** intégrés et déployés |
| **ZÉRO scriptlet** dans JSP | ✅ | Vérifiable : aucun `<%` dans les JSP |
| EJB @Stateless (métier) | ✅ | 5 EJBs avec 40+ méthodes business |
| JPA / EclipseLink (persistance) | ✅ | 9 entités avec relations + JPQL |
| CDI @Inject / @EJB | ✅ | Injection dans toutes les Servlets |
| Minimum 3 rôles | ✅ | ADMIN, SUPERVISEUR, ETUDIANT |
| Minimum 6 entités JPA | ✅ | **9 entités** (dépasse l'exigence) |
| Minimum 3–4 EJBs | ✅ | **5 EJBs** (dépasse l'exigence) |
| Workflow multi-états | ✅ | **11 états** avec transitions contrôlées |
| Formulaires multi-étapes | ✅ | 3 étapes (offre) + 2 étapes (rapport) |
| Authentification | ✅ | HttpSession + AuthFilter sur `/*` + contrôle de rôle par action |
| Script SQL + données de test | ✅ | `stagetrack-postgresql.sql` (PostgreSQL 18) |
| GlassFish 7 | ✅ | Déployé sur GlassFish 7.0.9 |
| Encodage UTF-8 | ✅ | pom.xml + AuthFilter + `web.xml` (jsp-config) + directives JSP |
| Pas de Spring / JSF / REST | ✅ | Vérifiable dans `pom.xml` — dépendances uniquement Jakarta EE + JSTL |

---

## 11. Journal des Corrections et Améliorations

| # | Correction | Détail technique |
|---|------------|------------------|
| 1 | **Contrôle de rôle par action** | `util/WebUtil.java` (`aLeRole`, `exigerRole`→booléen + redirect, `messageReel`). Gardes par rôle dans `OffreStageServlet`, `RapportServlet`, `NoteServlet`, `ConventionServlet`, `UtilisateurServlet`, `EntrepriseServlet`, `DashboardServlet`. Évite le bug « Cannot forward after response has been committed » (le code s'arrête après une redirection). |
| 2 | **Dashboard étudiant multi-offres** | `DashboardServlet` expose `offres` + `notesParOffre` + `motifParOffre` ; `dashboard-etudiant.jsp` itère toutes les offres (statut, note, timeline). |
| 3 | **Motif EN_CORRECTION affiché** | `RapportStageBean.trouverCommentaireCorrection(offreId)` retourne le commentaire du rapport → affiché dans l'alerte du dashboard étudiant (au lieu d'un champ vide). |
| 4 | **Erreur doublon e-mail lisible** | `GestionBean.creerUtilisateur` pré-vérifie `COUNT(email)` → message français ; `WebUtil.messageReel` dégage l'`EJBException` dans tous les catch de servlets. |
| 5 | **Écritures transactionnelles** | `GestionBean` (nouvel EJB `@Stateless`) : `creer/supprimerUtilisateur`, `modifierMotDePasse`, `creer/modifier/supprimerEntreprise`. Les `em.persist/remove` directs dans un servlet échouaient avec `TransactionRequiredException`. |
| 6 | **Encodage UTF-8 global** | `AuthFilter` (`setCharacterEncoding` en tête), `web.xml` (`jsp-property-group` : page-encoding, default-content-type UTF-8), directives `pageEncoding="UTF-8"` sur les 27 JSP, `pom.xml` (project.build.sourceEncoding / encoding compiler). |
| 7 | **Login moderne** | `login.jsp` repensé en split-screen (panneau marque + formulaire), champs larges avec icônes SVG, bouton affichage/masquage du mot de passe, « Se souvenir de moi », bouton pleine largeur arrondi — couleurs inchangées (réutilisation des variables CSS). |
| 8 | **Page « Mon stage »** | Remplace la redirection vers le dashboard : liste des demandes de l'étudiant + bouton « ＋ Déposer une demande » (topbar et état vide), titres conditionnels au rôle. |
| 9 | **Note finale → offre `NOTE_ATTRIBUEE`** | `NoteBean.attribuerNote` met l'offre dans l'état terminal (le bouton « Archiver » du superviseur/administrateur devient disponible). |
| 10 | **Unicité e-mail en base** | Contrainte `UNIQUE` sur `utilisateur.email` appliquée sur l'instance de déploiement (en complément du script SQL). |

---

<p align="center">
  <em>Ce projet a été réalisé dans le cadre du cours de Projet Libre Java EE,<br>
  sous la supervision du professeur, à la Faculté FTIC de l'Université Polytechnique de Gitega.<br><br>
  <strong>NIYURUKUNDO Méthode</strong> — Backend &nbsp;|&nbsp; <strong>NSABIYUMVA Nice Stella</strong> — Frontend<br>
  Année Académique 2025–2026
  </em>
</p>
