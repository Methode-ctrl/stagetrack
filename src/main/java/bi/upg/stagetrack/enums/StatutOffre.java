package bi.upg.stagetrack.enums;

/**
 * Énumération des statuts possibles pour une offre de stage
 * Correspond au workflow complet du système StageTrack
 */
public enum StatutOffre {
    OFFRE_SOUMISE,       // Étudiant vient de soumettre son dossier
    EN_VALIDATION,       // Superviseur a ouvert le dossier pour examen
    DOSSIER_INCOMPLET,   // Superviseur demande des corrections
    VALIDEE,             // Dossier validé par le superviseur
    STAGE_EN_COURS,      // Convention signée, stage en cours
    PAUSE,               // Stage temporairement suspendu
    RAPPORT_SOUMIS,      // Étudiant a déposé son rapport de stage
    EN_CORRECTION,       // Superviseur demande des corrections sur le rapport
    RAPPORT_VALIDE,      // Rapport accepté définitivement
    NOTE_ATTRIBUEE,      // Note finale saisie et calculée
    ARCHIVE              // Dossier clôturé définitivement
}