-- ============================================================
-- Migration PostgreSQL : statut de offre_stage
-- À exécuter UNE FOIS sur ta base existante (pgAdmin ou psql).
--
-- Contexte : si la table offre_stage a été créée par une
-- version antérieure du script, sa contrainte CHECK ne
-- connaît pas les statuts récents (STAGE_EN_COURS, PAUSE,
-- RAPPORT_SOUMIS, ...). PostgreSQL refuse alors l'UPDATE et
-- le stage ne peut pas démarrer.
--
-- Ce script est idempotent : on peut le relancer sans risque.
-- ============================================================

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

-- Vérification : doit lister les 11 statuts.
SELECT pg_get_constraintdef(oid) AS contrainte_statut
FROM pg_constraint
WHERE conrelid = 'offre_stage'::regclass
  AND contype = 'c'
  AND pg_get_constraintdef(oid) ILIKE '%statut%';
