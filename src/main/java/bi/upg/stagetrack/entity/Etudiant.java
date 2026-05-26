package bi.upg.stagetrack.entity;

import java.time.LocalDate;
import java.util.List;
import jakarta.persistence.*;

/**
 * Entité représentant un étudiant inscrit dans le système StageTrack.
 * Chaque étudiant est lié à un utilisateur et peut soumettre plusieurs offres de stage.
 */
@Entity
@Table(name = "etudiant")
public class Etudiant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Numéro d'étudiant unique (matricule) attribué par l'université.
     */
    @Column(name = "matricule", unique = true, nullable = false)
    private String matricule;

    @Column(name = "filiere", nullable = false)
    private String filiere;

    @Column(name = "promotion", nullable = false)
    private String promotion;

    @Column(name = "annee_univ", nullable = false)
    private String anneeUniv;

    @Column(name = "telephone")
    private String telephone;

    /**
     * Relation avec l'entité Utilisateur.
     * Un étudiant possède exactement un utilisateur (authentification).
     */
    @OneToOne
    @JoinColumn(name = "utilisateur_id", referencedColumnName = "id", nullable = false)
    private Utilisateur utilisateur;

    /**
     * Ensemble des offres de stage soumises par cet étudiant.
     */
    @OneToMany(mappedBy = "etudiant", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OffreStage> offres;

    // Constructeurs
    public Etudiant() {
    }

    public Etudiant(String matricule, String filiere, String promotion, String anneeUniv, String telephone) {
        this.matricule = matricule;
        this.filiere = filiere;
        this.promotion = promotion;
        this.anneeUniv = anneeUniv;
        this.telephone = telephone;
    }

    // Getters et setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    public String getFiliere() { return filiere; }
    public void setFiliere(String filiere) { this.filiere = filiere; }

    public String getPromotion() { return promotion; }
    public void setPromotion(String promotion) { this.promotion = promotion; }

    public String getAnneeUniv() { return anneeUniv; }
    public void setAnneeUniv(String anneeUniv) { this.anneeUniv = anneeUniv; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public Utilisateur getUtilisateur() { return utilisateur; }
    public void setUtilisateur(Utilisateur utilisateur) { this.utilisateur = utilisateur; }

    public List<OffreStage> getOffres() { return offres; }
    public void setOffres(List<OffreStage> offres) { this.offres = offres; }

    public void ajouterOffre(OffreStage offre) {
        this.offres.add(offre);
        offre.setEtudiant(this);
    }

    public void retirerOffre(OffreStage offre) {
        this.offres.remove(offre);
        offre.setEtudiant(null);
    }
}