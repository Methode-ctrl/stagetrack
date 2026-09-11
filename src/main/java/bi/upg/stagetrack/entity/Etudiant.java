package bi.upg.stagetrack.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "etudiant")
public class Etudiant implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @OneToOne
    @JoinColumn(name = "utilisateur_id", nullable = false, unique = true)
    private Utilisateur utilisateur;

    @Column(name = "matricule", nullable = false, unique = true, length = 50)
    private String matricule;

    @Column(name = "filiere", nullable = false, length = 100)
    private String filiere;

    @Column(name = "promotion", nullable = false, length = 50)
    private String promotion;

    public Etudiant() {}

    public Etudiant(Utilisateur utilisateur, String matricule, String filiere, String promotion) {
        this.utilisateur = utilisateur;
        this.matricule = matricule;
        this.filiere = filiere;
        this.promotion = promotion;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Utilisateur getUtilisateur() { return utilisateur; }
    public void setUtilisateur(Utilisateur utilisateur) { this.utilisateur = utilisateur; }

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    public String getFiliere() { return filiere; }
    public void setFiliere(String filiere) { this.filiere = filiere; }

    public String getPromotion() { return promotion; }
    public void setPromotion(String promotion) { this.promotion = promotion; }
}
