package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.Note;
import bi.upg.stagetrack.entity.RapportStage;
import java.time.LocalDate;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.util.Optional;

/**
 * Session Bean contenant la logique de calcul des notes finales.
 * Calcule la note finale et la mention selon les coefficients définis.
 */
@Stateless
public class NoteBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager entityManager;

    /**
     * Calcule la note finale selon les coefficients :
     * - note de stage (pratique) : 40%
     * - note du rapport (écrit) : 40%
     * - note de présentation orale : 20%
     */
    public double calculerNoteFinale(double noteStage, double noteRapport, double notePresentation) {
        return (noteStage * 0.40) + (noteRapport * 0.40) + (notePresentation * 0.20);
    }

    /**
     * Calcule la mention en fonction de la note finale.
     * ≥ 18 → Très Bien
     * ≥ 16 → Bien
     * ≥ 14 → Assez Bien
     * ≥ 12 → Passable
     * < 12 → Insuffisant
     */
    public String calculerMention(double noteFinale) {
        if (noteFinale >= 18) {
            return "Très Bien";
        } else if (noteFinale >= 16) {
            return "Bien";
        } else if (noteFinale >= 14) {
            return "Assez Bien";
        } else if (noteFinale >= 12) {
            return "Passable";
        } else {
            return "Insuffisant";
        }
    }

    /**
     * Attribue une note à un rapport de stage.
     * Calcule automatiquement la note finale et la mention.
     */
    @Transactional
    public void attribuerNote(Note note, Long rapportId) {
        Optional<RapportStage> rapportOpt = Optional.ofNullable(entityManager.find(RapportStage.class, rapportId));
        rapportOpt.ifPresent(rapport -> {
            // Calcul de la note finale et de la mention
            double noteFinale = calculerNoteFinale(note.getNoteStage(), note.getNoteRapport(), note.getNotePresentation());
            String mention = calculerMention(noteFinale);

            Note noteCible = rapport.getNote();
            if (noteCible == null) {
                noteCible = note;
                noteCible.setRapportStage(rapport);
                entityManager.persist(noteCible);
                rapport.setNote(noteCible);
            }

            noteCible.setNoteStage(note.getNoteStage());
            noteCible.setNoteRapport(note.getNoteRapport());
            noteCible.setNotePresentation(note.getNotePresentation());
            noteCible.setAppreciation(note.getAppreciation());
            noteCible.setNoteFinale(noteFinale);
            noteCible.setMention(mention);
            noteCible.setDateAttribution(LocalDate.now());

            // Mise à jour du statut de l'offre
            bi.upg.stagetrack.entity.OffreStage offre = rapport.getOffreStage();
            offre.setStatut(bi.upg.stagetrack.enums.StatutOffre.NOTE_ATTRIBUEE);
            entityManager.merge(offre);
        });
    }

    /**
     * Recherche la note attribuée à un étudiant via son rapport de stage.
     */
    public Optional<Note> findByEtudiant(Long etudiantId) {
        String jpql = "SELECT n FROM Note n JOIN n.rapportStage r JOIN r.offreStage o WHERE o.etudiant.id = :etudiantId";
        return entityManager.createQuery(jpql, Note.class)
                .setParameter("etudiantId", etudiantId)
                .getResultStream()
                .findFirst();
    }
}
