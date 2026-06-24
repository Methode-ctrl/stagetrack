package bi.upg.stagetrack.enums;

/**
 * État du rapport de stage soumis par l'étudiant.
 */
public enum StatutRapport {
    SOUMIS,        // Rapport déposé, en attente de validation
    EN_CORRECTION, // Corrections demandées par le superviseur
    VALIDE         // Rapport accepté définitivement
}