package bi.upg.stagetrack.entity;

import bi.upg.stagetrack.enums.StatutRapport;
import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "rapport_stage")
public class RapportStage implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "titre", nullable = false, length = 200)
    private String titre;

    @Column(name = "chemin_fichier", length = 500)
    private String cheminFichier;

    @Column(name = "date_soumission")
    private LocalDateTime dateSoumission;

    @Column(name = "statut", nullable = false)
    @Enumerated(EnumType.STRING)
    private StatutRapport statut;

    @Column(name = "commentaire", columnDefinition = "TEXT")
    private String commentaire;

    @ManyToOne
    @JoinColumn(name = "offre_stage_id", nullable = false)
    private OffreStage offreStage;

    @OneToOne(mappedBy = "rapportStage")
    private Note note;

    public RapportStage() {}

    public RapportStage(String titre, OffreStage offreStage) {
        this.titre = titre;
        this.offreStage = offreStage;
        this.statut = StatutRapport.SOUMIS;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getCheminFichier() { return cheminFichier; }
    public void setCheminFichier(String cheminFichier) { this.cheminFichier = cheminFichier; }

    public LocalDateTime getDateSoumission() { return dateSoumission; }
    public void setDateSoumission(LocalDateTime dateSoumission) { this.dateSoumission = dateSoumission; }

    public StatutRapport getStatut() { return statut; }
    public void setStatut(StatutRapport statut) { this.statut = statut; }

    public String getCommentaire() { return commentaire; }
    public void setCommentaire(String commentaire) { this.commentaire = commentaire; }

    public OffreStage getOffreStage() { return offreStage; }
    public void setOffreStage(OffreStage offreStage) { this.offreStage = offreStage; }

    public Note getNote() { return note; }
    public void setNote(Note note) { this.note = note; }
}
