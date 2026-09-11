package bi.upg.stagetrack.enums;

public enum StatutOffre {
    OFFRE_SOUMISE,       // L'étudiant a soumis son offre
    EN_VALIDATION,       // En cours de validation par admin/superviseur
    DOSSIER_INCOMPLET,   // Dossier incomplet, correction requise
    VALIDEE,             // Offre validée, stage prêt à commencer
    STAGE_EN_COURS,      // Stage en cours
    PAUSE,               // Stage en pause temporaire
    RAPPORT_SOUMIS,      // Rapport de stage soumis
    EN_CORRECTION,       // Rapport en cours de correction
    RAPPORT_VALIDE,      // Rapport validé
    NOTE_ATTRIBUEE,      // Note attribuée au stagiaire
    ARCHIVE              // Dossier archivé
}
