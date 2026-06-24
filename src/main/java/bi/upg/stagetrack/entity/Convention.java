package bi.upg.stagetrack.entity;

import java.time.LocalDate;
import jakarta.persistence.*;

/**
 * Entité représentant la convention de stage signée entre l'étudiant, l'entreprise et l'université.
 */
@Entity
@Table(name = "convention")
public class Convention {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "numero_convention", unique = true, nullable = false)
    private String numeroConvention;

    @Column(name = "date_generation", nullable = false)
    private LocalDate dateGeneration;

    @Column(name = "objectifs_pedagogiques", columnDefinition = "TEXT")
    private String objectifsPedagogiques;

    @Column(name = "signee_etudiant", nullable = false)
    private boolean signeeEtudiant = false;

    @Column(name = "signee_entreprise", nullable = false)
    private boolean signeeEntreprise = false;

    @Column(name = "signee_universite", nullable = false)
    private boolean signeeUniversite = false;

    @OneToOne
    @JoinColumn(name = "offre_stage_id", nullable = false)
    private OffreStage offreStage;

    // Getters et setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNumeroConvention() { return numeroConvention; }
    public void setNumeroConvention(String numeroConvention) { this.numeroConvention = numeroConvention; }

    public LocalDate getDateGeneration() { return dateGeneration; }
    public void setDateGeneration(LocalDate dateGeneration) { this.dateGeneration = dateGeneration; }

    public String getObjectifsPedagogiques() { return objectifsPedagogiques; }
    public void setObjectifsPedagogiques(String objectifsPedagogiques) { this.objectifsPedagogiques = objectifsPedagogiques; }

    public boolean isSigneeEtudiant() { return signeeEtudiant; }
    public void setSigneeEtudiant(boolean signeeEtudiant) { this.signeeEtudiant = signeeEtudiant; }

    public boolean isSigneeEntreprise() { return signeeEntreprise; }
    public void setSigneeEntreprise(boolean signeeEntreprise) { this.signeeEntreprise = signeeEntreprise; }

    public boolean isSigneeUniversite() { return signeeUniversite; }
    public void setSigneeUniversite(boolean signeeUniversite) { this.signeeUniversite = signeeUniversite; }

    public OffreStage getOffreStage() { return offreStage; }
    public void setOffreStage(OffreStage offreStage) { this.offreStage = offreStage; }
}
