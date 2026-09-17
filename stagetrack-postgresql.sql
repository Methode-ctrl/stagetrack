-- =====================================================
-- STAGETRACK — Script SQL PostgreSQL
-- Base de données de gestion de stages
-- PostgreSQL 18.x
-- Usage : psql -U postgres -h localhost -d stagetrack_db -f stagetrack-postgresql.sql
-- =====================================================

-- =====================================================
-- 1. TABLE UTILISATEUR
-- =====================================================
CREATE TABLE IF NOT EXISTS utilisateur (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'SUPERVISEUR', 'ETUDIANT')),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. TABLE ETUDIANT
-- =====================================================
CREATE TABLE IF NOT EXISTS etudiant (
    id BIGSERIAL PRIMARY KEY,
    utilisateur_id BIGINT NOT NULL UNIQUE,
    matricule VARCHAR(50) NOT NULL UNIQUE,
    filiere VARCHAR(100) NOT NULL,
    promotion VARCHAR(50) NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE CASCADE
);

-- =====================================================
-- 3. TABLE SUPERVISEUR
-- =====================================================
CREATE TABLE IF NOT EXISTS superviseur (
    id BIGSERIAL PRIMARY KEY,
    utilisateur_id BIGINT NOT NULL UNIQUE,
    grade VARCHAR(100),
    specialite VARCHAR(150),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE CASCADE
);

-- =====================================================
-- 4. TABLE ENTREPRISE
-- =====================================================
CREATE TABLE IF NOT EXISTS entreprise (
    id BIGSERIAL PRIMARY KEY,
    nom VARCHAR(200) NOT NULL,
    adresse VARCHAR(255),
    telephone VARCHAR(30),
    email VARCHAR(150),
    secteur VARCHAR(150),
    representant VARCHAR(150)
);

-- =====================================================
-- 5. TABLE OFFRE_STAGE
-- =====================================================
CREATE TABLE IF NOT EXISTS offre_stage (
    id BIGSERIAL PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    description TEXT,
    date_soumission TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_debut DATE,
    date_fin DATE,
    duree_en_mois INT,
    statut VARCHAR(30) NOT NULL DEFAULT 'OFFRE_SOUMISE' CHECK (statut IN (
        'OFFRE_SOUMISE', 'EN_VALIDATION', 'DOSSIER_INCOMPLET', 'VALIDEE',
        'STAGE_EN_COURS', 'PAUSE', 'RAPPORT_SOUMIS', 'EN_CORRECTION',
        'RAPPORT_VALIDE', 'NOTE_ATTRIBUEE', 'ARCHIVE'
    )),
    motif_rejet TEXT,
    etudiant_id BIGINT NOT NULL,
    entreprise_id BIGINT,
    superviseur_id BIGINT,
    FOREIGN KEY (etudiant_id) REFERENCES etudiant(id),
    FOREIGN KEY (entreprise_id) REFERENCES entreprise(id),
    FOREIGN KEY (superviseur_id) REFERENCES superviseur(id)
);

-- =====================================================
-- 6. TABLE PIECE_JOINTE
-- =====================================================
CREATE TABLE IF NOT EXISTS piece_jointe (
    id BIGSERIAL PRIMARY KEY,
    nom_fichier VARCHAR(255) NOT NULL,
    type_piece VARCHAR(30) NOT NULL CHECK (type_piece IN ('LETTRE_ACCEPTATION', 'CV', 'AUTRE')),
    chemin VARCHAR(500),
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    offre_stage_id BIGINT NOT NULL,
    FOREIGN KEY (offre_stage_id) REFERENCES offre_stage(id) ON DELETE CASCADE
);

-- =====================================================
-- 7. TABLE CONVENTION
-- =====================================================
CREATE TABLE IF NOT EXISTS convention (
    id BIGSERIAL PRIMARY KEY,
    offre_stage_id BIGINT NOT NULL UNIQUE,
    date_generation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    contenu TEXT,
    statut VARCHAR(20) DEFAULT 'EN_ATTENTE' CHECK (statut IN ('EN_ATTENTE', 'GENERE', 'SIGNEE')),
    FOREIGN KEY (offre_stage_id) REFERENCES offre_stage(id)
);

-- =====================================================
-- 8. TABLE RAPPORT_STAGE
-- =====================================================
CREATE TABLE IF NOT EXISTS rapport_stage (
    id BIGSERIAL PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    chemin_fichier VARCHAR(500),
    date_soumission TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    statut VARCHAR(20) NOT NULL DEFAULT 'SOUMIS' CHECK (statut IN ('SOUMIS', 'EN_CORRECTION', 'VALIDE')),
    commentaire TEXT,
    offre_stage_id BIGINT NOT NULL,
    FOREIGN KEY (offre_stage_id) REFERENCES offre_stage(id)
);

-- =====================================================
-- 9. TABLE NOTE
-- =====================================================
CREATE TABLE IF NOT EXISTS note (
    id BIGSERIAL PRIMARY KEY,
    rapport_stage_id BIGINT NOT NULL UNIQUE,
    note_stage DOUBLE PRECISION DEFAULT 0,
    note_rapport DOUBLE PRECISION DEFAULT 0,
    note_presence DOUBLE PRECISION DEFAULT 0,
    note_finale DOUBLE PRECISION DEFAULT 0,
    mention VARCHAR(50),
    appreciation TEXT,
    date_attribution TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rapport_stage_id) REFERENCES rapport_stage(id)
);

-- =====================================================
-- DONNEES DE TEST
-- =====================================================

-- Utilisateurs
INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, role) VALUES
('Admin', 'Système', 'admin@upg.bi', 'admin123', 'ADMIN'),
('Nkurunziza', 'Jean', 'nkurunziza@upg.bi', 'super123', 'SUPERVISEUR'),
('Irakoze', 'Claude', 'irakoze@etud.upg.bi', 'etud123', 'ETUDIANT'),
('Niyonkuru', 'Alice', 'niyonkuru@etud.upg.bi', 'etud123', 'ETUDIANT'),
('Manirambona', 'Pierre', 'manirambona@upg.bi', 'super123', 'SUPERVISEUR');

-- Etudiants
INSERT INTO etudiant (utilisateur_id, matricule, filiere, promotion) VALUES
(3, 'ETU-2024-001', 'Génie Logiciel', 'L3'),
(4, 'ETU-2024-002', 'Génie Logiciel', 'L3');

-- Superviseurs
INSERT INTO superviseur (utilisateur_id, grade, specialite) VALUES
(2, 'Professeur', 'Génie Logiciel et IA'),
(5, 'Maître Assistant', 'Sécurité Informatique');

-- Entreprises
INSERT INTO entreprise (nom, adresse, telephone, email, secteur, representant) VALUES
('BurundAI Tech', 'Bujumbura, Rohero', '+257 22 24 56 78', 'info@burundai.bi', 'Intelligence Artificielle', 'Dr. Hakizimana'),
('BIC Bank', 'Bujumbura, Centre', '+257 22 23 45 67', 'contact@bicbank.bi', 'Finance et Banque', 'M. Ndayisaba');

-- Offres de stage (3 dans des états différents)
INSERT INTO offre_stage (titre, description, date_debut, date_fin, duree_en_mois, statut, etudiant_id, entreprise_id, superviseur_id) VALUES
('Stage Développeur Full Stack', 'Développement d''une application web de gestion de stocks pour BurundAI Tech.', '2025-01-15', '2025-04-15', 3, 'STAGE_EN_COURS', 1, 1, 1),
('Stage Analyste Cybersécurité', 'Audit de sécurité du système bancaire BIC Bank.', '2025-02-01', '2025-05-01', 3, 'VALIDEE', 2, 2, NULL),
('Stage DevOps', 'Mise en place CI/CD pour les projets internes de BurundAI Tech.', '2025-03-01', '2025-06-01', 3, 'OFFRE_SOUMISE', 1, 1, NULL);

-- Pièces jointes
INSERT INTO piece_jointe (nom_fichier, type_piece, offre_stage_id) VALUES
('lettre_acceptation_burundai.pdf', 'LETTRE_ACCEPTATION', 1),
('cv_irakoze.pdf', 'CV', 1),
('lettre_acceptation_bic.pdf', 'LETTRE_ACCEPTATION', 2);

-- Convention
INSERT INTO convention (offre_stage_id, contenu, statut) VALUES
(1, 'Convention de stage entre UPG et BurundAI Tech pour Irakoze Claude - Stage Développeur Full Stack - 3 mois.', 'GENERE');

-- Rapport de stage
INSERT INTO rapport_stage (titre, statut, offre_stage_id) VALUES
('Rapport de stage - Développement Full Stack chez BurundAI Tech', 'VALIDE', 1);

-- Note
-- =====================================================
-- MIGRATION
-- Garantit que la contrainte CHECK sur offre_stage.statut
-- contient bien les 11 statuts. Nécessaire si la table a
-- été créée par une version antérieure du script, car
-- "CREATE TABLE IF NOT EXISTS" ne met pas à jour la
-- contrainte existante (sinon : erreur au démarrage d'un
-- stage -> statut STAGE_EN_COURS refusé par PostgreSQL).
-- Bloc idempotent : peut être exécuté plusieurs fois.
-- =====================================================
DO $$
DECLARE
    c record;
BEGIN
    FOR c IN
        SELECT conname
        FROM pg_constraint
        WHERE conrelid = 'offre_stage'::regclass
          AND contype = 'c'
          AND pg_get_constraintdef(oid) ILIKE '%statut%'
    LOOP
        EXECUTE 'ALTER TABLE offre_stage DROP CONSTRAINT ' || quote_ident(c.conname);
    END LOOP;

    ALTER TABLE offre_stage
        ADD CONSTRAINT offre_stage_statut_check CHECK (statut IN (
            'OFFRE_SOUMISE', 'EN_VALIDATION', 'DOSSIER_INCOMPLET', 'VALIDEE',
            'STAGE_EN_COURS', 'PAUSE', 'RAPPORT_SOUMIS', 'EN_CORRECTION',
            'RAPPORT_VALIDE', 'NOTE_ATTRIBUEE', 'ARCHIVE'
        ));
END $$;

INSERT INTO note (rapport_stage_id, note_stage, note_rapport, note_presence, note_finale, mention, appreciation) VALUES
(1, 16.5, 17.0, 18.0, 17.0, 'Bien', 'Excellent travail de développement. Bonne maîtrise des technologies web.');

-- =====================================================
-- FIN DU SCRIPT
-- =====================================================