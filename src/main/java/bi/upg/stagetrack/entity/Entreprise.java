package bi.upg.stagetrack.entity;

import java.util.List;
import jakarta.persistence.*;

/**
 * Entité représentant une entreprise partenaire pouvant accueillir des stagiaires.
 */
@Entity
@Table(name = "entreprise")
public class Entreprise {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nom", nullable = false)
    private String nom;

    @Column(name = "secteur")
    private String secteur;

    @Column(name = "adresse")
    private String adresse;

    @Column(name = "ville", nullable = false)
    private String ville;

    @Column(name = "nom_responsable")
    private String nomResponsable;

    @Column(name = "email_contact")
    private String emailContact;

    @Column(name = "telephone")
    private String telephone;

    /**
     * Liste des offres de stage proposées par cette entreprise.
     */
    @OneToMany(mappedBy = "entreprise", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OffreStage> offres;

    // Constructeurs
    public Entreprise() {
    }

    public Entreprise(String nom, String secteur, String adresse, String ville, String nomResponsable, String emailContact, String telephone) {
        this.nom = nom;
        this.secteur = secteur;
        this.adresse = adresse;
        this.ville = ville;
        this.nomResponsable = nomResponsable;
        this.emailContact = emailContact;
        this.telephone = telephone;
    }

    // Getters et setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getSecteur() { return secteur; }
    public void setSecteur(String secteur) { this.secteur = secteur; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getVille() { return ville; }
    public void setVille(String ville) { this.ville = ville; }

    public String getNomResponsable() { return nomResponsable; }
    public void setNomResponsable(String nomResponsable) { this.nomResponsable = nomResponsable; }

    public String getEmailContact() { return emailContact; }
    public void setEmailContact(String emailContact) { this.emailContact = emailContact; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public List<OffreStage> getOffres() { return offres; }
    public void setOffres(List<OffreStage> offres) { this.offres = offres; }

    public void ajouterOffre(OffreStage offre) {
        this.offres.add(offre);
        offre.setEntreprise(this);
    }

    public void retirerOffre(OffreStage offre) {
        this.offres.remove(offre);
        offre.setEntreprise(null);
    }
}