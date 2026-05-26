package bi.upg.stagetrack.entity;

import java.time.LocalDate;
import java.util.List;
import bi.upg.stagetrack.enums.StatutOffre;
import jakarta.persistence.*;

/**
 * Entité centrale représentant une offre de stage soumise par un étudiant.
 */
@Entity
@Table(name = "offre_stage")
public class OffreStage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "intitule_poste", nullable = false)
    private String intitulePoste;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "taches_prevues", columnDefinition = "TEXT")
    private String tachesPrevues;

    @Column(name = "date_debut")
    private LocalDate dateDebut;

    @Column(name = "date_soumission", nullable = false)
    private LocalDate dateSoumission;

    @Column(name = "duree_en_mois")
    private int dureeEnMois;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatutOffre statut;

    @Column(name = "commentaire_superviseur")
    private String commentaireSuperviseur;

    // Relations
    @ManyToOne
    @JoinColumn(name = "etudiant_id", nullable = false)
    private Etudiant etudiant;

    @ManyToOne
    @JoinColumn(name = "superviseur_id")
    private Superviseur superviseur; // peut être null au départ

    @ManyToOne
    @JoinColumn(name = "entreprise_id", nullable = false)
    private Entreprise entreprise;

    @OneToMany(mappedBy = "offreStage", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PieceJointe> piecesJointes;

    @OneToOne(mappedBy = "offreStage", cascade = CascadeType.ALL, orphanRemoval = true)
    private Convention convention;

    @OneToOne(mappedBy = "offreStage", cascade = CascadeType.ALL, orphanRemoval = true)
    private RapportStage rapport;

    // Getters et setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getIntitulePoste() { return intitulePoste; }
    public void setIntitulePoste(String intitulePoste) { this.intitulePoste = intitulePoste; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getTachesPrevues() { return tachesPrevues; }
    public void setTachesPrevues(String tachesPrevues) { this.tachesPrevues = tachesPrevues; }

    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }

    public LocalDate getDateSoumission() { return dateSoumission; }
    public void setDateSoumission(LocalDate dateSoumission) { this.dateSoumission = dateSoumission; }

    public int getDureeEnMois() { return dureeEnMois; }
    public void setDureeEnMois(int dureeEnMois) { this.dureeEnMois = dureeEnMois; }

    public StatutOffre getStatut() { return statut; }
    public void setStatut(StatutOffre statut) { this.statut = statut; }

    public String getCommentaireSuperviseur() { return commentaireSuperviseur; }
    public void setCommentaireSuperviseur(String commentaireSuperviseur) { this.commentaireSuperviseur = commentaireSuperviseur; }

    public Etudiant getEtudiant() { return etudiant; }
    public void setEtudiant(Etudiant etudiant) { this.etudiant = etudiant; }

    public Superviseur getSuperviseur() { return superviseur; }
    public void setSuperviseur(Superviseur superviseur) { this.superviseur = superviseur; }

    public Entreprise getEntreprise() { return entreprise; }
    public void setEntreprise(Entreprise entreprise) { this.entreprise = entreprise; }

    public List<PieceJointe> getPiecesJointes() { return piecesJointes; }
    public void setPiecesJointes(List<PieceJointe> piecesJointes) { this.piecesJointes = piecesJointes; }

    public Convention getConvention() { return convention; }
    public void setConvention(Convention convention) { this.convention = convention; }

    public RapportStage getRapport() { return rapport; }
    public void setRapport(RapportStage rapport) { this.rapport = rapport; }
}