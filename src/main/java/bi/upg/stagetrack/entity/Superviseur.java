package bi.upg.stagetrack.entity;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "superviseur")
public class Superviseur implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @OneToOne
    @JoinColumn(name = "utilisateur_id", nullable = false, unique = true)
    private Utilisateur utilisateur;

    @Column(name = "grade", length = 100)
    private String grade;

    @Column(name = "specialite", length = 150)
    private String specialite;

    public Superviseur() {}

    public Superviseur(Utilisateur utilisateur, String grade, String specialite) {
        this.utilisateur = utilisateur;
        this.grade = grade;
        this.specialite = specialite;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Utilisateur getUtilisateur() { return utilisateur; }
    public void setUtilisateur(Utilisateur utilisateur) { this.utilisateur = utilisateur; }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getSpecialite() { return specialite; }
    public void setSpecialite(String specialite) { this.specialite = specialite; }
}
