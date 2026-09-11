package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.*;
import bi.upg.stagetrack.enums.StatutOffre;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class OffreStageBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    public OffreStage soumettreOffre(OffreStage offre) {
        Etudiant etudiant = em.find(Etudiant.class, offre.getEtudiant().getId());
        Entreprise entreprise = em.find(Entreprise.class, offre.getEntreprise().getId());

        if (etudiant == null) {
            throw new IllegalArgumentException("Etudiant introuvable");
        }
        if (entreprise == null) {
            throw new IllegalArgumentException("Entreprise introuvable");
        }

        offre.setEtudiant(etudiant);
        offre.setEntreprise(entreprise);
        offre.setStatut(StatutOffre.OFFRE_SOUMISE);
        offre.setDateSoumission(LocalDateTime.now());

        em.persist(offre);
        return offre;
    }

    public OffreStage ouvrirDossier(Long id) {
        OffreStage offre = em.find(OffreStage.class, id);
        if (offre == null) throw new IllegalArgumentException("Offre introuvable");
        offre.setStatut(StatutOffre.EN_VALIDATION);
        return em.merge(offre);
    }

    public OffreStage validerOffre(Long id) {
        OffreStage offre = em.find(OffreStage.class, id);
        if (offre == null) throw new IllegalArgumentException("Offre introuvable");
        offre.setStatut(StatutOffre.VALIDEE);
        return em.merge(offre);
    }

    public OffreStage demanderCorrection(Long id, String motif) {
        OffreStage offre = em.find(OffreStage.class, id);
        if (offre == null) throw new IllegalArgumentException("Offre introuvable");
        offre.setStatut(StatutOffre.DOSSIER_INCOMPLET);
        offre.setMotifRejet(motif);
        return em.merge(offre);
    }

    public OffreStage demarrerStage(Long id) {
        OffreStage offre = em.find(OffreStage.class, id);
        if (offre == null) throw new IllegalArgumentException("Offre introuvable");
        offre.setStatut(StatutOffre.STAGE_EN_COURS);
        return em.merge(offre);
    }

    public OffreStage mettreEnPause(Long id) {
        OffreStage offre = em.find(OffreStage.class, id);
        if (offre == null) throw new IllegalArgumentException("Offre introuvable");
        offre.setStatut(StatutOffre.PAUSE);
        return em.merge(offre);
    }

    public OffreStage reprendreStage(Long id) {
        OffreStage offre = em.find(OffreStage.class, id);
        if (offre == null) throw new IllegalArgumentException("Offre introuvable");
        offre.setStatut(StatutOffre.STAGE_EN_COURS);
        return em.merge(offre);
    }

    public OffreStage affecterSuperviseur(Long offreId, Long supId) {
        OffreStage offre = em.find(OffreStage.class, offreId);
        Superviseur superviseur = em.find(Superviseur.class, supId);
        if (offre == null) throw new IllegalArgumentException("Offre introuvable");
        if (superviseur == null) throw new IllegalArgumentException("Superviseur introuvable");
        offre.setSuperviseur(superviseur);
        return em.merge(offre);
    }

    public OffreStage archiverDossier(Long id) {
        OffreStage offre = em.find(OffreStage.class, id);
        if (offre == null) throw new IllegalArgumentException("Offre introuvable");
        offre.setStatut(StatutOffre.ARCHIVE);
        return em.merge(offre);
    }

    public Etudiant findEtudiantByUtilisateurId(Long utilisateurId) {
        TypedQuery<Etudiant> q = em.createQuery(
            "SELECT e FROM Etudiant e WHERE e.utilisateur.id = :uid", Etudiant.class);
        q.setParameter("uid", utilisateurId);
        return q.getResultList().stream().findFirst().orElse(null);
    }

    public Superviseur findSuperviseurByUtilisateurId(Long utilisateurId) {
        TypedQuery<Superviseur> q = em.createQuery(
            "SELECT s FROM Superviseur s WHERE s.utilisateur.id = :uid", Superviseur.class);
        q.setParameter("uid", utilisateurId);
        return q.getResultList().stream().findFirst().orElse(null);
    }

    public Entreprise creerOuTrouverEntreprise(String nom, String adresse, String telephone, String email, String secteur, String representant) {
        TypedQuery<Entreprise> q = em.createQuery(
            "SELECT e FROM Entreprise e WHERE e.nom = :nom", Entreprise.class);
        q.setParameter("nom", nom);
        List<Entreprise> resultats = q.getResultList();
        if (!resultats.isEmpty()) {
            return resultats.get(0);
        }
        Entreprise entreprise = new Entreprise(nom, adresse, telephone, email, secteur, representant);
        em.persist(entreprise);
        return entreprise;
    }

    public List<OffreStage> listerToutes() {
        return em.createQuery("SELECT o FROM OffreStage o ORDER BY o.dateSoumission DESC", OffreStage.class)
                 .getResultList();
    }

    public List<OffreStage> listerParSuperviseur(Superviseur superviseur) {
        TypedQuery<OffreStage> q = em.createQuery(
            "SELECT o FROM OffreStage o WHERE o.superviseur = :sup ORDER BY o.dateSoumission DESC", OffreStage.class);
        q.setParameter("sup", superviseur);
        return q.getResultList();
    }

    public List<OffreStage> listerParEtudiant(Long etudiantId) {
        TypedQuery<OffreStage> q = em.createQuery(
            "SELECT o FROM OffreStage o WHERE o.etudiant.id = :eid ORDER BY o.dateSoumission DESC", OffreStage.class);
        q.setParameter("eid", etudiantId);
        return q.getResultList();
    }

    public List<OffreStage> listerSansSuperviseur() {
        TypedQuery<OffreStage> q = em.createQuery(
            "SELECT o FROM OffreStage o WHERE o.superviseur IS NULL ORDER BY o.dateSoumission DESC", OffreStage.class);
        return q.getResultList();
    }

    public List<Superviseur> getSuperviseursDisponibles() {
        return em.createQuery("SELECT s FROM Superviseur s ORDER BY s.utilisateur.nom", Superviseur.class)
                 .getResultList();
    }

    public Entreprise trouverEntreprise(Long id) {
        return em.find(Entreprise.class, id);
    }
}
