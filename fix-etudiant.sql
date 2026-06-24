-- Script pour créer un profil étudiant pour l'utilisateur connecté
-- Remplacez les valeurs selon votre situation

-- 1. Vérifier quel utilisateur est connecté
SELECT id, nom, prenom, email, role FROM utilisateur WHERE role = 'ETUDIANT';

-- 2. Vérifier si un profil étudiant existe
SELECT * FROM etudiant;

-- 3. Si aucun profil étudiant n'existe, en créer un
-- REMPLACEZ 1 par l'ID de votre utilisateur étudiant
INSERT INTO etudiant (matricule, promotion, telephone, utilisateur_id)
VALUES ('ETU2026001', 'Promotion 2026', '+257 79 123 456', 1);

-- 4. Vérifier que c'est bien créé
SELECT e.id, e.matricule, e.promotion, u.nom, u.prenom, u.email
FROM etudiant e
JOIN utilisateur u ON e.utilisateur_id = u.id;
