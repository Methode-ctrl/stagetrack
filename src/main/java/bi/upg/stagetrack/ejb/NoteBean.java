package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.Note;
import bi.upg.stagetrack.entity.RapportStage;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDateTime;

@Stateless
public class NoteBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    public double calculerNoteFinale(double noteStage, double noteRapport, double notePresence) {
        return (noteStage * 0.40) + (noteRapport * 0.40) + (notePresence * 0.20);
    }

    public String calculerMention(double noteFinale) {
        if (noteFinale >= 18) return "Très Bien";
        if (noteFinale >= 16) return "Bien";
        if (noteFinale >= 14) return "Assez Bien";
        if (noteFinale >= 12) return "Passable";
        return "Insuffisant";
    }

    public Note attribuerNote(Long rapportId, double noteStage, double noteRapport, double notePresence, String appreciation) {
        RapportStage rapport = em.find(RapportStage.class, rapportId);
        if (rapport == null) {
            throw new IllegalArgumentException("Rapport introuvable avec l'ID : " + rapportId);
        }

        double noteFinale = calculerNoteFinale(noteStage, noteRapport, notePresence);
        String mention = calculerMention(noteFinale);

        Note note = new Note(rapport, noteStage, noteRapport, notePresence);
        note.setNoteFinale(noteFinale);
        note.setMention(mention);
        note.setAppreciation(appreciation);
        note.setDateAttribution(LocalDateTime.now());

        em.persist(note);
        return note;
    }
}
