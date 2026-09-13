package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.enums.StatutOffre;
import bi.upg.stagetrack.enums.StatutRapport;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class RapportStageBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    public RapportStage soumettreRapport(RapportStage rapport, Long offreId) {
        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null) {
            throw new IllegalArgumentException("Offre introuvable avec l'ID : " + offreId);
        }

        rapport.setOffreStage(offre);
        rapport.setStatut(StatutRapport.SOUMIS);
        rapport.setDateSoumission(LocalDateTime.now());

        em.persist(rapport);

        offre.setStatut(StatutOffre.RAPPORT_SOUMIS);
        em.merge(offre);

        return rapport;
    }

    public RapportStage validerRapport(Long rapportId) {
        RapportStage rapport = em.find(RapportStage.class, rapportId);
        if (rapport == null) {
            throw new IllegalArgumentException("Rapport introuvable");
        }

        rapport.setStatut(StatutRapport.VALIDE);

        OffreStage offre = rapport.getOffreStage();
        offre.setStatut(StatutOffre.RAPPORT_VALIDE);

        em.merge(rapport);
        em.merge(offre);

        return rapport;
    }

    public RapportStage demanderCorrection(Long rapportId, String commentaire) {
        RapportStage rapport = em.find(RapportStage.class, rapportId);
        if (rapport == null) {
            throw new IllegalArgumentException("Rapport introuvable");
        }

        rapport.setStatut(StatutRapport.EN_CORRECTION);
        rapport.setCommentaire(commentaire);

        OffreStage offre = rapport.getOffreStage();
        offre.setStatut(StatutOffre.EN_CORRECTION);

        em.merge(rapport);
        em.merge(offre);

        return rapport;
    }

    public RapportStage resoumettreRapport(Long offreId, RapportStage nouveauRapport) {
        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null) {
            throw new IllegalArgumentException("Offre introuvable");
        }

        nouveauRapport.setOffreStage(offre);
        nouveauRapport.setStatut(StatutRapport.SOUMIS);
        nouveauRapport.setDateSoumission(LocalDateTime.now());

        em.persist(nouveauRapport);

        offre.setStatut(StatutOffre.RAPPORT_SOUMIS);
        em.merge(offre);

        return nouveauRapport;
    }

    public List<RapportStage> findByOffreId(Long offreId) {
        TypedQuery<RapportStage> q = em.createQuery(
            "SELECT r FROM RapportStage r WHERE r.offreStage.id = :oid ORDER BY r.dateSoumission DESC",
            RapportStage.class);
        q.setParameter("oid", offreId);
        return q.getResultList();
    }

    public String trouverCommentaireCorrection(Long offreId) {
        TypedQuery<RapportStage> q = em.createQuery(
            "SELECT r FROM RapportStage r WHERE r.offreStage.id = :oid AND r.statut = :st ORDER BY r.dateSoumission DESC",
            RapportStage.class);
        q.setParameter("oid", offreId);
        q.setParameter("st", StatutRapport.EN_CORRECTION);
        return q.getResultList().stream().findFirst().map(RapportStage::getCommentaire).orElse(null);
    }

    public List<RapportStage> listerTous() {
        return em.createQuery(
            "SELECT r FROM RapportStage r ORDER BY r.dateSoumission DESC", RapportStage.class)
            .getResultList();
    }

    public RapportStage trouverRapport(Long id) {
        return em.find(RapportStage.class, id);
    }
}
