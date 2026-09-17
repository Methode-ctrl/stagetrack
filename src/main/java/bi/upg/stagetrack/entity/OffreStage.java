package bi.upg.stagetrack.entity;

import bi.upg.stagetrack.enums.StatutOffre;
import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Entity
@Table(name = "offre_stage")
public class OffreStage implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "titre", nullable = false, length = 200)
    private String titre;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "date_soumission")
    private LocalDateTime dateSoumission;

    @Column(name = "date_debut")
    private LocalDate dateDebut;

    @Column(name = "date_fin")
    private LocalDate dateFin;

    @Column(name = "duree_en_mois")
    private Integer dureeEnMois;

    @Column(name = "statut", nullable = false)
    @Enumerated(EnumType.STRING)
    private StatutOffre statut;

    @Column(name = "motif_rejet", columnDefinition = "TEXT")
    private String motifRejet;

    @ManyToOne
    @JoinColumn(name = "etudiant_id", nullable = false)
    private Etudiant etudiant;

    @ManyToOne
    @JoinColumn(name = "entreprise_id")
    private Entreprise entreprise;

    @ManyToOne
    @JoinColumn(name = "superviseur_id")
    private Superviseur superviseur;

    @OneToMany(mappedBy = "offreStage", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PieceJointe> piecesJointes = new ArrayList<>();

    @OneToOne(mappedBy = "offreStage")
    private Convention convention;

    @OneToMany(mappedBy = "offreStage")
    private List<RapportStage> rapports = new ArrayList<>();

    public OffreStage() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getDateSoumission() { return dateSoumission; }
    public void setDateSoumission(LocalDateTime dateSoumission) { this.dateSoumission = dateSoumission; }

    public LocalDate getDateDebut() { return dateDebut; }
    public void setDateDebut(LocalDate dateDebut) { this.dateDebut = dateDebut; }

    public LocalDate getDateFin() { return dateFin; }
    public void setDateFin(LocalDate dateFin) { this.dateFin = dateFin; }

    public Integer getDureeEnMois() { return dureeEnMois; }
    public void setDureeEnMois(Integer dureeEnMois) { this.dureeEnMois = dureeEnMois; }

    public StatutOffre getStatut() { return statut; }
    public void setStatut(StatutOffre statut) { this.statut = statut; }

    public String getMotifRejet() { return motifRejet; }
    public void setMotifRejet(String motifRejet) { this.motifRejet = motifRejet; }

    public Etudiant getEtudiant() { return etudiant; }
    public void setEtudiant(Etudiant etudiant) { this.etudiant = etudiant; }

    public Entreprise getEntreprise() { return entreprise; }
    public void setEntreprise(Entreprise entreprise) { this.entreprise = entreprise; }

    public Superviseur getSuperviseur() { return superviseur; }
    public void setSuperviseur(Superviseur superviseur) { this.superviseur = superviseur; }

    public List<PieceJointe> getPiecesJointes() { return piecesJointes; }
    public void setPiecesJointes(List<PieceJointe> piecesJointes) { this.piecesJointes = piecesJointes; }

    public Convention getConvention() { return convention; }
    public void setConvention(Convention convention) { this.convention = convention; }

    public List<RapportStage> getRapports() { return rapports; }
    public void setRapports(List<RapportStage> rapports) { this.rapports = rapports; }

    public String getDateDebutAffichage() { return formaterDate(dateDebut); }
    public String getDateFinAffichage() { return formaterDate(dateFin); }

    private String formaterDate(LocalDate date) {
        if (date == null) {
            return "";
        }
        return date.format(DateTimeFormatter.ofPattern("dd MMM yyyy", Locale.FRENCH));
    }
}
