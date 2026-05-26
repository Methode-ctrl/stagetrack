package bi.upg.stagetrack.entity;

import java.util.List;
import jakarta.persistence.*;

/**
 * Entité représentant un superviseur enseignant dans le système StageTrack.
 * Chaque superviseur est lié à un utilisateur et peut encadrer plusieurs offres de stage.
 */
@Entity
@Table(name = "superviseur")
public class Superviseur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "grade", nullable = false)
    private String grade;

    @Column(name = "specialite", nullable = false)
    private String specialite;

    @Column(name = "bureau", nullable = false)
    private String bureau;

    /**
     * Relation avec l'entité Utilisateur.
     * Un superviseur possède exactement un utilisateur (authentification).
     */
    @OneToOne
    @JoinColumn(name = "utilisateur_id", referencedColumnName = "id", nullable = false)
    private Utilisateur utilisateur;

    /**
     * Ensemble des offres de stage encadrées par ce superviseur.
     */
    @OneToMany(mappedBy = "superviseur", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OffreStage> offres;

    // Constructeurs
    public Superviseur() {
    }

    public Superviseur(String grade, String specialite, String bureau) {
        this.grade = grade;
        this.specialite = specialite;
        this.bureau = bureau;
    }

    // Getters et setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getSpecialite() { return specialite; }
    public void setSpecialite(String specialite) { this.specialite = specialite; }

    public String getBureau() { return bureau; }
    public void setBureau(String bureau) { this.bureau = bureau; }

    public Utilisateur getUtilisateur() { return utilisateur; }
    public void setUtilisateur(Utilisateur utilisateur) { this.utilisateur = utilisateur; }

    public List<OffreStage> getOffres() { return offres; }
    public void setOffres(List<OffreStage> offres) { this.offres = offres; }

    public void ajouterOffre(OffreStage offre) {
        this.offres.add(offre);
        offre.setSuperviseur(this);
    }

    public void retirerOffre(OffreStage offre) {
        this.offres.remove(offre);
        offre.setSuperviseur(null);
    }
}