package bi.upg.stagetrack.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "convention")
public class Convention implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @OneToOne
    @JoinColumn(name = "offre_stage_id", nullable = false, unique = true)
    private OffreStage offreStage;

    @Column(name = "date_generation")
    private LocalDateTime dateGeneration;

    @Column(name = "contenu", columnDefinition = "TEXT")
    private String contenu;

    @Column(name = "statut", length = 20)
    private String statut;

    public Convention() {}

    public Convention(OffreStage offreStage, String contenu) {
        this.offreStage = offreStage;
        this.contenu = contenu;
        this.statut = "EN_ATTENTE";
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public OffreStage getOffreStage() { return offreStage; }
    public void setOffreStage(OffreStage offreStage) { this.offreStage = offreStage; }

    public LocalDateTime getDateGeneration() { return dateGeneration; }
    public void setDateGeneration(LocalDateTime dateGeneration) { this.dateGeneration = dateGeneration; }

    public String getContenu() { return contenu; }
    public void setContenu(String contenu) { this.contenu = contenu; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }
}
