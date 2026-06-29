-- ============================================================
--   STAGETRACK – Système de Gestion des Stages Étudiants
--   Université Polytechnique de Gitega | BAC3 Génie Logiciel
--   Année universitaire 2025-2026
--   Script MySQL complet : création des tables + jeu de données
-- ============================================================

DROP DATABASE IF EXISTS stagetrack_db;
CREATE DATABASE stagetrack_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE stagetrack_db;

-- ============================================================
--   TABLE 1 : utilisateur
--   Tous les comptes du système (admin, superviseur, étudiant)
-- ============================================================
CREATE TABLE utilisateur (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom            VARCHAR(100)  NOT NULL,
    prenom         VARCHAR(100)  NOT NULL,
    email          VARCHAR(150)  NOT NULL UNIQUE,
    mot_de_passe   VARCHAR(255)  NOT NULL,
    role           ENUM('ADMIN','SUPERVISEUR','ETUDIANT') NOT NULL,
    date_creation  DATE          NOT NULL DEFAULT (CURRENT_DATE),
    actif          BOOLEAN       NOT NULL DEFAULT TRUE
);

-- ============================================================
--   TABLE 2 : etudiant
--   Profil détaillé de chaque étudiant
-- ============================================================
CREATE TABLE etudiant (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    matricule      VARCHAR(50)   NOT NULL UNIQUE,
    filiere        VARCHAR(100)  NOT NULL,
    promotion      VARCHAR(50)   NOT NULL,
    annee_univ     VARCHAR(20)   NOT NULL,
    telephone      VARCHAR(20),
    utilisateur_id BIGINT        NOT NULL UNIQUE,
    FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateur(id) ON DELETE CASCADE
);

-- ============================================================
--   TABLE 3 : superviseur
--   Profil détaillé de chaque enseignant superviseur
-- ============================================================
CREATE TABLE superviseur (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    grade          VARCHAR(50)   NOT NULL,
    specialite     VARCHAR(100)  NOT NULL,
    bureau         VARCHAR(50),
    utilisateur_id BIGINT        NOT NULL UNIQUE,
    FOREIGN KEY (utilisateur_id)
        REFERENCES utilisateur(id) ON DELETE CASCADE
);

-- ============================================================
--   TABLE 4 : entreprise
--   Sociétés d'accueil des stagiaires
-- ============================================================
CREATE TABLE entreprise (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom              VARCHAR(150)  NOT NULL,
    secteur          VARCHAR(100)  NOT NULL,
    adresse          VARCHAR(200),
    ville            VARCHAR(100)  NOT NULL,
    nom_responsable  VARCHAR(150),
    email_contact    VARCHAR(150),
    telephone        VARCHAR(20)
);

-- ============================================================
--   TABLE 5 : offre_stage  (ENTITÉ CENTRALE)
--   Demande de stage soumise par un étudiant
--   Porte le workflow complet à 11 états
-- ============================================================
CREATE TABLE offre_stage (
    id                       BIGINT AUTO_INCREMENT PRIMARY KEY,
    intitule_poste           VARCHAR(200) NOT NULL,
    description              TEXT,
    taches_prevues           TEXT,
    date_debut               DATE         NOT NULL,
    duree_en_mois            INT          NOT NULL,
    statut                   ENUM(
                                 'OFFRE_SOUMISE',
                                 'EN_VALIDATION',
                                 'DOSSIER_INCOMPLET',
                                 'VALIDEE',
                                 'STAGE_EN_COURS',
                                 'PAUSE',
                                 'RAPPORT_SOUMIS',
                                 'EN_CORRECTION',
                                 'RAPPORT_VALIDE',
                                 'NOTE_ATTRIBUEE',
                                 'ARCHIVE'
                             ) NOT NULL DEFAULT 'OFFRE_SOUMISE',
    commentaire_superviseur  TEXT,
    date_soumission          DATE         NOT NULL DEFAULT (CURRENT_DATE),
    etudiant_id              BIGINT       NOT NULL,
    superviseur_id           BIGINT,
    entreprise_id            BIGINT       NOT NULL,
    FOREIGN KEY (etudiant_id)
        REFERENCES etudiant(id),
    FOREIGN KEY (superviseur_id)
        REFERENCES superviseur(id),
    FOREIGN KEY (entreprise_id)
        REFERENCES entreprise(id)
);

-- ============================================================
--   TABLE 6 : piece_jointe
--   Fichiers attachés à une offre (nom stocké en base)
-- ============================================================
CREATE TABLE piece_jointe (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom_fichier    VARCHAR(255)  NOT NULL,
    type_piece     ENUM('LETTRE_ACCEPTATION','CV','AUTRE') NOT NULL,
    date_ajout     DATE          NOT NULL DEFAULT (CURRENT_DATE),
    offre_stage_id BIGINT        NOT NULL,
    FOREIGN KEY (offre_stage_id)
        REFERENCES offre_stage(id) ON DELETE CASCADE
);

-- ============================================================
--   TABLE 7 : convention
--   Document officiel généré après validation de l'offre
-- ============================================================
CREATE TABLE convention (
    id                     BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero_convention      VARCHAR(50)  NOT NULL UNIQUE,
    date_generation        DATE         NOT NULL DEFAULT (CURRENT_DATE),
    objectifs_pedagogiques TEXT,
    signee_etudiant        BOOLEAN      NOT NULL DEFAULT FALSE,
    signee_entreprise      BOOLEAN      NOT NULL DEFAULT FALSE,
    signee_universite      BOOLEAN      NOT NULL DEFAULT FALSE,
    offre_stage_id         BIGINT       NOT NULL UNIQUE,
    FOREIGN KEY (offre_stage_id)
        REFERENCES offre_stage(id) ON DELETE CASCADE
);

-- ============================================================
--   TABLE 8 : rapport_stage
--   Rapport final soumis par l'étudiant en fin de stage
-- ============================================================
CREATE TABLE rapport_stage (
    id                   BIGINT AUTO_INCREMENT PRIMARY KEY,
    titre                VARCHAR(255) NOT NULL,
    resume               TEXT,
    competences_acquises TEXT,
    nom_fichier_pdf      VARCHAR(255),
    nom_fichier_annexe   VARCHAR(255),
    date_soumission      DATE         NOT NULL DEFAULT (CURRENT_DATE),
    statut               ENUM('SOUMIS','EN_CORRECTION','VALIDE')
                         NOT NULL DEFAULT 'SOUMIS',
    offre_stage_id       BIGINT       NOT NULL UNIQUE,
    FOREIGN KEY (offre_stage_id)
        REFERENCES offre_stage(id) ON DELETE CASCADE
);

-- ============================================================
--   TABLE 9 : note
--   Évaluation finale calculée et attribuée par le superviseur
-- ============================================================
CREATE TABLE note (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    note_stage        DECIMAL(4,2) NOT NULL,
    note_rapport      DECIMAL(4,2) NOT NULL,
    note_presentation DECIMAL(4,2) NOT NULL,
    note_finale       DECIMAL(4,2) NOT NULL,   -- calculée par EJB NoteBean
    mention           VARCHAR(50)  NOT NULL,   -- calculée par EJB NoteBean
    appreciation      TEXT,
    date_attribution  DATE         NOT NULL DEFAULT (CURRENT_DATE),
    rapport_stage_id  BIGINT       NOT NULL UNIQUE,
    FOREIGN KEY (rapport_stage_id)
        REFERENCES rapport_stage(id) ON DELETE CASCADE
);

-- ============================================================
--                      JEU DE DONNÉES
-- ============================================================

-- ------------------------------------------------------------
-- 1. UTILISATEURS
--    8 comptes : 1 admin + 2 superviseurs + 5 étudiants
--    Mot de passe commun en clair pour les tests : "Password123"
-- ------------------------------------------------------------
INSERT INTO utilisateur
    (id, nom, prenom, email, mot_de_passe, role, date_creation, actif)
VALUES
-- Mots de passe hachés SHA-256 :
--   admin123  → 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
--   super123  → 4e4c56e4a15f89f05c2f4c72613da2a18c9665d4f0d6acce16415eb06f9be776
--   etud123   → 8285f134eeefb1b59dcde5eb4c322e5939f52e053480b9d3757517d3b93e20bb
(1, 'Niyonzima',    'Pascal',   'admin@upg.bi',                  '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',  'ADMIN',       '2025-09-01', TRUE),
(2, 'Nkurunziza',   'Theodore', 'nkurunziza.t@upg.bi',           '4e4c56e4a15f89f05c2f4c72613da2a18c9665d4f0d6acce16415eb06f9be776',  'SUPERVISEUR', '2025-09-01', TRUE),
(3, 'Hakizimana',   'Vestine',  'hakizimana.v@upg.bi',           '4e4c56e4a15f89f05c2f4c72613da2a18c9665d4f0d6acce16415eb06f9be776',  'SUPERVISEUR', '2025-09-01', TRUE),
(4, 'Irakoze',      'Jean',     'irakoze.jean@etud.upg.bi',      '8285f134eeefb1b59dcde5eb4c322e5939f52e053480b9d3757517d3b93e20bb',   'ETUDIANT',    '2025-09-05', TRUE),
(5, 'Ntakirutimana','Marie',    'ntakirut.marie@etud.upg.bi',    '8285f134eeefb1b59dcde5eb4c322e5939f52e053480b9d3757517d3b93e20bb',   'ETUDIANT',    '2025-09-05', TRUE),
(6, 'Niyongabo',    'Pierre',   'niyongabo.p@etud.upg.bi',       '8285f134eeefb1b59dcde5eb4c322e5939f52e053480b9d3757517d3b93e20bb',   'ETUDIANT',    '2025-09-05', TRUE),
(7, 'Uwimana',      'Claudine', 'uwimana.c@etud.upg.bi',         '8285f134eeefb1b59dcde5eb4c322e5939f52e053480b9d3757517d3b93e20bb',   'ETUDIANT',    '2025-09-05', TRUE),
(8, 'Bizimana',     'Alexis',   'bizimana.a@etud.upg.bi',        '8285f134eeefb1b59dcde5eb4c322e5939f52e053480b9d3757517d3b93e20bb',   'ETUDIANT',    '2025-09-05', TRUE);

-- ------------------------------------------------------------
-- 2. ÉTUDIANTS (5 profils détaillés)
-- ------------------------------------------------------------
INSERT INTO etudiant
    (id, matricule, filiere, promotion, annee_univ, telephone, utilisateur_id)
VALUES
(1, 'UPG-GL-2026-001', 'Genie Logiciel', 'BAC3-GL', '2025-2026', '+257 79 111 001', 4),
(2, 'UPG-GL-2026-002', 'Genie Logiciel', 'BAC3-GL', '2025-2026', '+257 79 111 002', 5),
(3, 'UPG-GL-2026-003', 'Genie Logiciel', 'BAC3-GL', '2025-2026', '+257 79 111 003', 6),
(4, 'UPG-GL-2026-004', 'Genie Logiciel', 'BAC3-GL', '2025-2026', '+257 79 111 004', 7),
(5, 'UPG-GL-2026-005', 'Genie Logiciel', 'BAC3-GL', '2025-2026', '+257 79 111 005', 8);

-- ------------------------------------------------------------
-- 3. SUPERVISEURS (2 profils détaillés)
-- ------------------------------------------------------------
INSERT INTO superviseur
    (id, grade, specialite, bureau, utilisateur_id)
VALUES
(1, 'Docteur',    'Genie Logiciel et Java EE',          'Bureau A-12', 2),
(2, 'Ingenieur',  'Reseaux et Securite Informatique',   'Bureau B-05', 3);

-- ------------------------------------------------------------
-- 4. ENTREPRISES (5 sociétés partenaires)
-- ------------------------------------------------------------
INSERT INTO entreprise
    (id, nom, secteur, adresse, ville, nom_responsable, email_contact, telephone)
VALUES
(1, 'BurundAI Tech',         'Informatique et IA',        'Avenue de l OUA, Zone Industrielle',  'Bujumbura', 'M. Karabagire Joel',    'contact@burundai.bi',     '+257 22 111 001'),
(2, 'BIC Bank Burundi',      'Finance et Banque',          'Boulevard du Peuple Murundi',          'Bujumbura', 'Mme. Ndayisenga Alice', 'stages@bicbank.bi',       '+257 22 222 002'),
(3, 'REGIDESO',              'Eau et Electricite',         'Chaussee du Peuple Murundi',           'Bujumbura', 'M. Hakizimana Faustin', 'rh@regideso.bi',          '+257 22 333 003'),
(4, 'OAG Consulting',        'Conseil et Audit',           'Quartier Rohero, Immeuble Novotel',    'Bujumbura', 'Mme. Nkurunziza Rose',  'info@oagconsulting.bi',   '+257 79 444 004'),
(5, 'Ministere du Numerique','Administration Publique',    'Boulevard de l UPRONA',                'Gitega',    'M. Nduwimana Eric',     'stages@min-numerique.bi', '+257 22 555 005');

-- ------------------------------------------------------------
-- 5. OFFRES DE STAGE
--    5 offres couvrant 5 états différents du workflow
-- ------------------------------------------------------------
INSERT INTO offre_stage (
    id, intitule_poste, description, taches_prevues,
    date_debut, duree_en_mois, statut,
    commentaire_superviseur, date_soumission,
    etudiant_id, superviseur_id, entreprise_id
) VALUES

-- Offre 1 : cycle complet terminé → ARCHIVE
(1,
 'Developpeur Web Java EE',
 'Developpement d une application de gestion RH pour BurundAI Tech.',
 'Analyse des besoins, conception UML, developpement Java EE, tests, deploiement GlassFish.',
 '2026-01-05', 3, 'ARCHIVE',
 'Excellent dossier. Etudiant tres serieux et competent.',
 '2025-12-01', 1, 1, 1),

-- Offre 2 : stage en cours → STAGE_EN_COURS
(2,
 'Stagiaire Developpeur Systeme Bancaire',
 'Participation au developpement du module de gestion des comptes clients BIC Bank.',
 'Developpement Java, tests unitaires, documentation technique, reunions equipe.',
 '2026-02-01', 3, 'STAGE_EN_COURS',
 'Convention signee. Stage bien demarre.',
 '2025-12-15', 2, 1, 2),

-- Offre 3 : rapport soumis → RAPPORT_SOUMIS
(3,
 'Stagiaire Reseau et Administration Systeme',
 'Administration des serveurs Linux et configuration des equipements reseau REGIDESO.',
 'Configuration routeurs Cisco, monitoring reseau, documentation, support utilisateurs.',
 '2026-01-15', 2, 'RAPPORT_SOUMIS',
 NULL,
 '2025-12-20', 3, 2, 3),

-- Offre 4 : dossier incomplet → DOSSIER_INCOMPLET
(4,
 'Stagiaire Auditeur Systemes d Information',
 'Participation aux missions d audit SI des clients d OAG Consulting.',
 'Collecte de donnees, analyse des risques SI, redaction rapports, presentation clients.',
 '2026-03-01', 3, 'DOSSIER_INCOMPLET',
 'La lettre d acceptation de l entreprise est manquante. Merci de la fournir.',
 '2026-01-10', 4, 2, 4),

-- Offre 5 : toute fraiche → OFFRE_SOUMISE (pas encore de superviseur)
(5,
 'Developpeur Applications Mobiles',
 'Developpement d une application mobile pour les services numeriques du Ministere.',
 'Conception UI/UX, developpement Android/Java, integration API, tests fonctionnels.',
 '2026-04-01', 3, 'OFFRE_SOUMISE',
 NULL,
 '2026-01-20', 5, NULL, 5);

-- ------------------------------------------------------------
-- 6. PIÈCES JOINTES (9 fichiers liés aux offres)
-- ------------------------------------------------------------
INSERT INTO piece_jointe
    (id, nom_fichier, type_piece, date_ajout, offre_stage_id)
VALUES
(1, 'lettre_acceptation_burundai_irakoze.pdf',   'LETTRE_ACCEPTATION', '2025-12-01', 1),
(2, 'cv_irakoze_jean_2026.pdf',                  'CV',                 '2025-12-01', 1),
(3, 'lettre_acceptation_bicbank_ntakirut.pdf',   'LETTRE_ACCEPTATION', '2025-12-15', 2),
(4, 'cv_ntakirutimana_marie_2026.pdf',           'CV',                 '2025-12-15', 2),
(5, 'lettre_acceptation_regideso_niyongabo.pdf', 'LETTRE_ACCEPTATION', '2025-12-20', 3),
(6, 'cv_niyongabo_pierre_2026.pdf',              'CV',                 '2025-12-20', 3),
(7, 'cv_uwimana_claudine_2026.pdf',              'CV',                 '2026-01-10', 4),
(8, 'lettre_acceptation_min_numerique_biz.pdf',  'LETTRE_ACCEPTATION', '2026-01-20', 5),
(9, 'cv_bizimana_alexis_2026.pdf',               'CV',                 '2026-01-20', 5);

-- ------------------------------------------------------------
-- 7. CONVENTIONS (3 conventions générées)
-- ------------------------------------------------------------
INSERT INTO convention (
    id, numero_convention, date_generation,
    objectifs_pedagogiques,
    signee_etudiant, signee_entreprise, signee_universite,
    offre_stage_id
) VALUES
(1, 'CONV-2026-001', '2026-01-02',
 'Developper les competences en Java EE. Maitriser l architecture multi-tiers, les EJBs, JPA et le deploiement sur GlassFish. Acquerir une experience professionnelle.',
 TRUE, TRUE, TRUE, 1),

(2, 'CONV-2026-002', '2026-01-25',
 'Acquerir une experience pratique dans le domaine bancaire. Participer au developpement de modules Java pour la gestion des comptes clients.',
 TRUE, TRUE, TRUE, 2),

(3, 'CONV-2026-003', '2026-01-10',
 'Renforcer les competences en administration reseau et systemes Linux. Apprehender la gestion d une infrastructure informatique d une grande entreprise publique.',
 TRUE, TRUE, FALSE, 3);

-- ------------------------------------------------------------
-- 8. RAPPORTS DE STAGE (2 rapports soumis)
-- ------------------------------------------------------------
INSERT INTO rapport_stage (
    id, titre, resume, competences_acquises,
    nom_fichier_pdf, nom_fichier_annexe,
    date_soumission, statut, offre_stage_id
) VALUES
(1,
 'Developpement d une Application RH Multi-tiers avec Java EE et GlassFish',
 'Durant ce stage de 3 mois chez BurundAI Tech, j ai concu et developpe une application web de gestion RH. J ai applique l architecture multi-tiers Java EE avec Servlets, JSP/JSTL, EJBs et JPA. Le projet m a permis de maitriser la separation des responsabilites et le deploiement sur GlassFish 7.',
 'Java EE 10, GlassFish 7, Servlet/JSP/JSTL, EJB Stateless, JPA/EclipseLink, CDI, MySQL, UML, Git',
 'rapport_irakoze_jean_final.pdf',
 'annexes_irakoze_jean.pdf',
 '2026-03-25', 'VALIDE', 1),

(2,
 'Administration Reseau et Systemes Linux a REGIDESO : Bilan et Retour d Experience',
 'Ce stage de 2 mois a REGIDESO m a permis de decouvrir l infrastructure reseau d une grande entreprise publique burundaise. J ai participe a la configuration d equipements Cisco et au monitoring reseau.',
 'Administration Linux Ubuntu Server, Cisco IOS, Nagios, documentation technique, support utilisateurs niveau 2',
 'rapport_niyongabo_pierre.pdf',
 NULL,
 '2026-03-28', 'SOUMIS', 3);

-- ------------------------------------------------------------
-- 9. NOTES (1 note attribuée – dossier archivé d'Irakoze)
--    Formule EJB : (15×0.40) + (16×0.40) + (14×0.20) = 15.20
-- ------------------------------------------------------------
INSERT INTO note (
    id,
    note_stage, note_rapport, note_presentation,
    note_finale, mention, appreciation,
    date_attribution, rapport_stage_id
) VALUES
(1,
 15.00, 16.00, 14.00,
 15.20, 'Bien',
 'Irakoze Jean a demontre une excellente maitrise des technologies Java EE. Travail rigoureux, bien documente, application fonctionnelle et deployable. Bonne presentation orale. Etudiant recommande.',
 '2026-04-02', 1);

-- ============================================================
--                    VÉRIFICATION FINALE
-- ============================================================
SELECT '===== RESUME DU JEU DE DONNEES =====' AS '';

SELECT 'utilisateur'   AS table_name, COUNT(*) AS total FROM utilisateur  UNION ALL
SELECT 'etudiant',                    COUNT(*)           FROM etudiant     UNION ALL
SELECT 'superviseur',                 COUNT(*)           FROM superviseur  UNION ALL
SELECT 'entreprise',                  COUNT(*)           FROM entreprise   UNION ALL
SELECT 'offre_stage',                 COUNT(*)           FROM offre_stage  UNION ALL
SELECT 'piece_jointe',                COUNT(*)           FROM piece_jointe UNION ALL
SELECT 'convention',                  COUNT(*)           FROM convention   UNION ALL
SELECT 'rapport_stage',               COUNT(*)           FROM rapport_stage UNION ALL
SELECT 'note',                        COUNT(*)           FROM note;

SELECT '===== ETAT ACTUEL DE TOUS LES STAGES =====' AS '';

SELECT
    CONCAT(u.prenom, ' ', u.nom)   AS etudiant,
    e.matricule                     AS matricule,
    ent.nom                         AS entreprise,
    os.intitule_poste               AS poste,
    os.statut                       AS statut,
    IFNULL(CONCAT(us.prenom,' ',us.nom), 'Non affecte') AS superviseur
FROM offre_stage os
JOIN etudiant    e   ON os.etudiant_id    = e.id
JOIN utilisateur u   ON e.utilisateur_id  = u.id
JOIN entreprise  ent ON os.entreprise_id  = ent.id
LEFT JOIN superviseur  s  ON os.superviseur_id = s.id
LEFT JOIN utilisateur  us ON s.utilisateur_id  = us.id
ORDER BY os.id;

-- ============================================================
--   FIN DU SCRIPT stagetrack_mysql.sql
-- ============================================================