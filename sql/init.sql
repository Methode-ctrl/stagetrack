-- =============================================
-- StageTrack - Script d'initialisation de la base de données
-- Université Polytechnique de Gitega (UPG)
-- Année académique 2025-2026
-- =============================================

-- Création de la base de données
CREATE DATABASE IF NOT EXISTS stagetrack_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE stagetrack_db;

-- =============================================
-- Table: utilisateur
-- =============================================
CREATE TABLE IF NOT EXISTS utilisateur (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    role ENUM('ADMIN', 'SUPERVISEUR', 'ETUDIANT') NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    actif BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: etudiant
-- =============================================
CREATE TABLE IF NOT EXISTS etudiant (
    utilisateur_id BIGINT PRIMARY KEY,
    matricule VARCHAR(50) NOT NULL UNIQUE,
    niveau VARCHAR(50),
    specialite VARCHAR(100),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: superviseur
-- =============================================
CREATE TABLE IF NOT EXISTS superviseur (
    utilisateur_id BIGINT PRIMARY KEY,
    specialite VARCHAR(100),
    telephone VARCHAR(20),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: entreprise
-- =============================================
CREATE TABLE IF NOT EXISTS entreprise (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    secteur_activite VARCHAR(100),
    adresse TEXT,
    email VARCHAR(255),
    telephone VARCHAR(20),
    site_web VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: offre_stage
-- =============================================
CREATE TABLE IF NOT EXISTS offre_stage (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    date_soumission DATE NOT NULL,
    statut ENUM(
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
    date_debut DATE,
    date_fin DATE,
    date_validation DATE,
    date_demarrage DATE,
    etudiant_id BIGINT NOT NULL,
    superviseur_id BIGINT,
    entreprise_id BIGINT NOT NULL,
    FOREIGN KEY (etudiant_id) REFERENCES etudiant(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (superviseur_id) REFERENCES superviseur(utilisateur_id) ON DELETE SET NULL,
    FOREIGN KEY (entreprise_id) REFERENCES entreprise(id) ON DELETE CASCADE,
    INDEX idx_statut (statut),
    INDEX idx_etudiant (etudiant_id),
    INDEX idx_entreprise (entreprise_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: piece_jointe
-- =============================================
CREATE TABLE IF NOT EXISTS piece_jointe (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('CV', 'LETTRE_MOTIVATION', 'ATTESTATION_INSCRIPTION', 'AUTRE') NOT NULL,
    nom_fichier VARCHAR(255) NOT NULL,
    chemin_fichier VARCHAR(500) NOT NULL,
    date_upload DATE NOT NULL,
    offre_stage_id BIGINT NOT NULL,
    FOREIGN KEY (offre_stage_id) REFERENCES offre_stage(id) ON DELETE CASCADE,
    INDEX idx_offre (offre_stage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: convention
-- =============================================
CREATE TABLE IF NOT EXISTS convention (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(100) UNIQUE,
    date_generation DATE NOT NULL,
    chemin_fichier VARCHAR(500),
    signee BOOLEAN DEFAULT FALSE,
    offre_stage_id BIGINT NOT NULL UNIQUE,
    FOREIGN KEY (offre_stage_id) REFERENCES offre_stage(id) ON DELETE CASCADE,
    INDEX idx_offre (offre_stage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: rapport_stage
-- =============================================
CREATE TABLE IF NOT EXISTS rapport_stage (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    resume TEXT,
    competences_acquises TEXT,
    date_soumission DATE NOT NULL,
    statut ENUM('BROUILLON', 'SOUMIS', 'EN_CORRECTION', 'VALIDE') NOT NULL DEFAULT 'BROUILLON',
    nom_fichier_pdf VARCHAR(255),
    nom_fichier_annexe VARCHAR(255),
    offre_stage_id BIGINT NOT NULL UNIQUE,
    FOREIGN KEY (offre_stage_id) REFERENCES offre_stage(id) ON DELETE CASCADE,
    INDEX idx_offre (offre_stage_id),
    INDEX idx_statut (statut)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Table: note
-- =============================================
CREATE TABLE IF NOT EXISTS note (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    note_stage DOUBLE NOT NULL,
    note_rapport DOUBLE NOT NULL,
    note_presentation DOUBLE NOT NULL,
    note_finale DOUBLE NOT NULL,
    mention VARCHAR(50),
    date_attribution DATE NOT NULL,
    rapport_stage_id BIGINT NOT NULL UNIQUE,
    FOREIGN KEY (rapport_stage_id) REFERENCES rapport_stage(id) ON DELETE CASCADE,
    INDEX idx_rapport (rapport_stage_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================
-- Données d'exemple
-- =============================================

-- Insertion des utilisateurs (mot de passe: password123)
-- Le mot de passe est hashé avec BCrypt en production
INSERT INTO utilisateur (email, mot_de_passe, nom, prenom, role) VALUES
('admin@upg.br', 'password123', 'Admin', 'System', 'ADMIN'),
('s.kalisa@upg.br', 'password123', 'Kalisa', 'Jean', 'SUPERVISEUR'),
('m.umar@upg.br', 'password123', 'Umar', 'Marie', 'SUPERVISEUR'),
('e.niyonzima@upg.br', 'password123', 'Niyonzima', 'Eric', 'ETUDIANT'),
('e.hatungimana@upg.br', 'password123', 'Hatungimana', 'Alice', 'ETUDIANT'),
('e.nkurunziza@upg.br', 'password123', 'Nkurunziza', 'Bob', 'ETUDIANT');

-- Insertion des étudiants
INSERT INTO etudiant (utilisateur_id, matricule, niveau, specialite) VALUES
(4, 'UPG2023001', 'BAC3', 'Génie Logiciel'),
(5, 'UPG2023002', 'BAC3', 'Génie Logiciel'),
(6, 'UPG2023003', 'BAC3', 'Génie Logiciel');

-- Insertion des superviseurs
INSERT INTO superviseur (utilisateur_id, specialite, telephone) VALUES
(2, 'Développement Web', '+257 79 123 456'),
(3, 'Base de données', '+257 79 234 567');

-- Insertion des entreprises
INSERT INTO entreprise (nom, secteur_activite, adresse, email, telephone, site_web) VALUES
('TechSolutions Burundi', 'Technologies', 'Bujumbura, Rohero', 'contact@techsolutions.bi', '+257 22 123 456', 'https://techsolutions.bi'),
('Innovatech', 'Technologies', 'Bujumbura, Ngagara', 'info@innovatech.bi', '+257 22 234 567', 'https://innovatech.bi'),
('Digital Gitega', 'Technologies', 'Gitega, Centre-ville', 'contact@digital-gitega.bi', '+257 40 123 456', 'https://digital-gitega.bi');

-- Insertion d'offres de stage
INSERT INTO offre_stage (titre, description, date_soumission, statut, date_debut, date_fin, etudiant_id, superviseur_id, entreprise_id) VALUES
('Développeur Web Full Stack', 'Stage de développement d\'une application web de gestion scolaire', '2025-06-01', 'VALIDEE', '2025-07-01', '2025-09-30', 4, 2, 1),
('Analyste de données', 'Analyse des données de vente et création de tableaux de bord', '2025-06-05', 'EN_VALIDATION', NULL, NULL, 5, 3, 2),
('Stagiaire en développement mobile', 'Développement d\'une application mobile Android', '2025-06-10', 'OFFRE_SOUMISE', NULL, NULL, 6, NULL, 3);

-- Insertion de pièces jointes
INSERT INTO piece_jointe (type, nom_fichier, chemin_fichier, date_upload, offre_stage_id) VALUES
('CV', 'cv_eric.pdf', '/uploads/cv_eric.pdf', '2025-06-01', 1),
('LETTRE_MOTIVATION', 'lm_eric.pdf', '/uploads/lm_eric.pdf', '2025-06-01', 1),
('ATTESTATION_INSCRIPTION', 'attestation_eric.pdf', '/uploads/attestation_eric.pdf', '2025-06-01', 1),
('CV', 'cv_alice.pdf', '/uploads/cv_alice.pdf', '2025-06-05', 2),
('LETTRE_MOTIVATION', 'lm_alice.pdf', '/uploads/lm_alice.pdf', '2025-06-05', 2);

-- Insertion de conventions
INSERT INTO convention (numero, date_generation, chemin_fichier, signee, offre_stage_id) VALUES
('CONV-2025-001', '2025-06-15', '/conventions/conv_001.pdf', TRUE, 1);

-- Insertion de rapports de stage
INSERT INTO rapport_stage (titre, resume, competences_acquises, date_soumission, statut, nom_fichier_pdf, nom_fichier_annexe, offre_stage_id) VALUES
('Rapport de stage - Développeur Web', 'Développement d\'une application de gestion scolaire avec React et Spring Boot', 'Maîtrise de React, Spring Boot, MySQL, travail en équipe', '2025-09-25', 'SOUMIS', 'rapport_eric.pdf', 'annexes_eric.zip', 1);

-- Insertion de notes
INSERT INTO note (note_stage, note_rapport, note_presentation, note_finale, mention, date_attribution, rapport_stage_id) VALUES
(16.0, 15.0, 17.0, 15.8, 'Assez Bien', '2025-10-05', 1);

-- =============================================
-- Vues pour les statistiques
-- =============================================

-- Vue: Statistiques par statut d'offre
CREATE OR REPLACE VIEW v_stats_offres_par_statut AS
SELECT 
    statut,
    COUNT(*) as nombre
FROM offre_stage
GROUP BY statut;

-- Vue: Statistiques par entreprise
CREATE OR REPLACE VIEW v_stats_offres_par_entreprise AS
SELECT 
    e.nom as entreprise,
    COUNT(o.id) as nombre_offres
FROM entreprise e
LEFT JOIN offre_stage o ON e.id = o.entreprise_id
GROUP BY e.id, e.nom;

-- Vue: Moyennes des notes par superviseur
CREATE OR REPLACE VIEW v_moyennes_par_superviseur AS
SELECT 
    CONCAT(u.prenom, ' ', u.nom) as superviseur,
    AVG(n.note_finale) as moyenne_finale,
    COUNT(n.id) as nombre_notes
FROM superviseur s
JOIN utilisateur u ON s.utilisateur_id = u.id
JOIN offre_stage o ON s.utilisateur_id = o.superviseur_id
JOIN rapport_stage r ON o.id = r.offre_stage_id
JOIN note n ON r.id = n.rapport_stage_id
GROUP BY s.utilisateur_id, u.prenom, u.nom;

-- =============================================
-- Procédures stockées (optionnel)
-- =============================================

DELIMITER //

-- Procédure: Obtenir les statistiques globales
CREATE PROCEDURE IF NOT EXISTS sp_stats_globales()
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM offre_stage) as total_offres,
        (SELECT COUNT(*) FROM offre_stage WHERE statut = 'VALIDEE') as offres_validees,
        (SELECT COUNT(*) FROM offre_stage WHERE statut = 'STAGE_EN_COURS') as stages_en_cours,
        (SELECT COUNT(*) FROM rapport_stage WHERE statut = 'VALIDE') as rapports_valides,
        (SELECT COUNT(*) FROM note) as notes_attribuees,
        (SELECT AVG(note_finale) FROM note) as moyenne_generale;
END //

DELIMITER ;

-- =============================================
-- Index supplémentaires pour les performances
-- =============================================

CREATE INDEX idx_offre_dates ON offre_stage(date_debut, date_fin);
CREATE INDEX idx_rapport_dates ON rapport_stage(date_soumission);
CREATE INDEX idx_note_finale ON note(note_finale);

-- =============================================
-- Fin du script
-- =============================================