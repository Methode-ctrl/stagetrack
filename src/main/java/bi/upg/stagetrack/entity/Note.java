package bi.upg.stagetrack.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

/**
 * Entité représentant la note finale attribuée à un étudiant pour son stage.
 */
@Entity
@Table(name = "note")
public class Note {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "note_stage", nullable = false)
    private double noteStage; // /20, coefficient 40%

    @Column(name = "note_rapport", nullable = false)
    private double noteRapport; // /20, coefficient 40%

    @Column(name = "note_presentation", nullable = false)
    private double notePresentation; // /20, coefficient 20%

    @Column(name = "note_finale", nullable = false)
    private double noteFinale; // calculée par EJB NoteBean

    @Column(name = "mention", nullable = false)
    private String mention; // calculée par EJB NoteBean

    @Column(name = "appreciation", columnDefinition = "TEXT")
    private String appreciation;

    @Column(name = "date_attribution", nullable = false)
    private LocalDate dateAttribution;

    @OneToOne
    @JoinColumn(name = "rapport_stage_id", nullable = false)
    private RapportStage rapportStage;

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public double getNoteStage() { return noteStage; }
    public void setNoteStage(double noteStage) { this.noteStage = noteStage; }

    public double getNoteRapport() { return noteRapport; }
    public void setNoteRapport(double noteRapport) { this.noteRapport = noteRapport; }

    public double getNotePresentation() { return notePresentation; }
    public void setNotePresentation(double notePresentation) { this.notePresentation = notePresentation; }

    public double getNoteFinale() { return noteFinale; }
    public void setNoteFinale(double noteFinale) { this.noteFinale = noteFinale; }

    public String getMention() { return mention; }
    public void setMention(String mention) { this.mention = mention; }

    public String getAppreciation() { return appreciation; }
    public void setAppreciation(String appreciation) { this.appreciation = appreciation; }

    public LocalDate getDateAttribution() { return dateAttribution; }
    public void setDateAttribution(LocalDate dateAttribution) { this.dateAttribution = dateAttribution; }

    public RapportStage getRapportStage() { return rapportStage; }
    public void setRapportStage(RapportStage rapportStage) { this.rapportStage = rapportStage; }
}
