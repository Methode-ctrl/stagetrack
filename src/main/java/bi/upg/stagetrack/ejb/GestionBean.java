package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.Entreprise;
import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDateTime;

@Stateless
public class GestionBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    public Utilisateur creerUtilisateur(String nom, String prenom, String email, String motDePasse, Role role,
            String matricule, String filiere, String promotion, String grade, String specialite) {
        Long existants = em.createQuery(
                "SELECT COUNT(u) FROM Utilisateur u WHERE u.email = :email", Long.class)
                .setParameter("email", email)
                .getSingleResult();
        if (existants > 0) {
            throw new IllegalArgumentException("Un compte existe déjà avec cette adresse e-mail : " + email);
        }

        Utilisateur utilisateur = new Utilisateur(nom, prenom, email, motDePasse, role);
        utilisateur.setDateCreation(LocalDateTime.now());
        em.persist(utilisateur);
        em.flush();

        if (Role.ETUDIANT.equals(role)) {
            Etudiant etudiant = new Etudiant(utilisateur, matricule, filiere, promotion);
            em.persist(etudiant);
        } else if (Role.SUPERVISEUR.equals(role)) {
            Superviseur superviseur = new Superviseur(utilisateur, grade, specialite);
            em.persist(superviseur);
        }
        return utilisateur;
    }

    public void supprimerUtilisateur(Long id) {
        Utilisateur utilisateur = em.find(Utilisateur.class, id);
        if (utilisateur != null) {
            em.remove(utilisateur);
        }
    }

    public void modifierMotDePasse(Long id, String motDePasse) {
        Utilisateur utilisateur = em.find(Utilisateur.class, id);
        if (utilisateur != null) {
            utilisateur.setMotDePasse(motDePasse);
            em.merge(utilisateur);
        }
    }

    public Entreprise creerEntreprise(String nom, String adresse, String telephone, String email, String secteur, String representant) {
        Entreprise entreprise = new Entreprise(nom, adresse, telephone, email, secteur, representant);
        em.persist(entreprise);
        return entreprise;
    }

    public void modifierEntreprise(Long id, String nom, String adresse, String telephone, String email, String secteur, String representant) {
        Entreprise entreprise = em.find(Entreprise.class, id);
        if (entreprise == null) throw new IllegalArgumentException("Entreprise introuvable");
        entreprise.setNom(nom);
        entreprise.setAdresse(adresse);
        entreprise.setTelephone(telephone);
        entreprise.setEmail(email);
        entreprise.setSecteur(secteur);
        entreprise.setRepresentant(representant);
        em.merge(entreprise);
    }

    public void supprimerEntreprise(Long id) {
        Entreprise entreprise = em.find(Entreprise.class, id);
        if (entreprise != null) {
            em.remove(entreprise);
        }
    }
}