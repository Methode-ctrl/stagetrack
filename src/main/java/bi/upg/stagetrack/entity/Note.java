package bi.upg.stagetrack.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "note")
public class Note implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @OneToOne
    @JoinColumn(name = "rapport_stage_id", nullable = false, unique = true)
    private RapportStage rapportStage;

    @Column(name = "note_stage")
    private Double noteStage;

    @Column(name = "note_rapport")
    private Double noteRapport;

    @Column(name = "note_presence")
    private Double notePresence;

    @Column(name = "note_finale")
    private Double noteFinale;

    @Column(name = "mention", length = 50)
    private String mention;

    @Column(name = "appreciation", columnDefinition = "TEXT")
    private String appreciation;

    @Column(name = "date_attribution")
    private LocalDateTime dateAttribution;

    public Note() {}

    public Note(RapportStage rapportStage, Double noteStage, Double noteRapport, Double notePresence) {
        this.rapportStage = rapportStage;
        this.noteStage = noteStage;
        this.noteRapport = noteRapport;
        this.notePresence = notePresence;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public RapportStage getRapportStage() { return rapportStage; }
    public void setRapportStage(RapportStage rapportStage) { this.rapportStage = rapportStage; }

    public Double getNoteStage() { return noteStage; }
    public void setNoteStage(Double noteStage) { this.noteStage = noteStage; }

    public Double getNoteRapport() { return noteRapport; }
    public void setNoteRapport(Double noteRapport) { this.noteRapport = noteRapport; }

    public Double getNotePresence() { return notePresence; }
    public void setNotePresence(Double notePresence) { this.notePresence = notePresence; }

    public Double getNoteFinale() { return noteFinale; }
    public void setNoteFinale(Double noteFinale) { this.noteFinale = noteFinale; }

    public String getMention() { return mention; }
    public void setMention(String mention) { this.mention = mention; }

    public String getAppreciation() { return appreciation; }
    public void setAppreciation(String appreciation) { this.appreciation = appreciation; }

    public LocalDateTime getDateAttribution() { return dateAttribution; }
    public void setDateAttribution(LocalDateTime dateAttribution) { this.dateAttribution = dateAttribution; }
}
