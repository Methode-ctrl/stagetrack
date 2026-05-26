package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.enums.StatutOffre;
import bi.upg.stagetrack.enums.StatutRapport;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Session Bean gérant la soumission et l'évaluation des rapports de stage.
 * Contient toute la logique métier liée aux rapports.
 */
@Stateless
public class RapportStageBean {

    @PersistenceContext
    private EntityManager entityManager;

    /**
     * Soumet un rapport de stage par l'étudiant.
     * Met à jour le statut du rapport et de l'offre associée.
     */
    @Transactional
    public void soumettreRapport(RapportStage rapport, Long offreId) {
        Optional<OffreStage> offreOpt = Optional.ofNullable(entityManager.find(OffreStage.class, offreId));
        offreOpt.ifPresent(offre -> {
            rapport.setOffreStage(offre);
            rapport.setStatut(StatutRapport.SOUMIS);
            rapport.setDateSoumission(LocalDate.now());
            entityManager.persist(rapport);
            // Mise à jour du statut de l'offre
            offre.setStatut(StatutOffre.RAPPORT_SOUMIS);
            entityManager.merge(offre);
        });
    }

    /**
     * Demande des corrections sur le rapport par le superviseur.
     */
    @Transactional
    public void demanderCorrection(Long rapportId, String commentaire) {
        Optional<RapportStage> rapportOpt = findById(rapportId);
        rapportOpt.ifPresent(rapport -> {
            rapport.setStatut(StatutRapport.EN_CORRECTION);
            // Stockage du commentaire dans l'offre associée
            OffreStage offre = rapport.getOffreStage();
            offre.setCommentaireSuperviseur(commentaire);
            entityManager.merge(offre);
            entityManager.merge(rapport);
        });
    }

    /**
     * Valide définitivement le rapport de stage.
     */
    @Transactional
    public void validerRapport(Long rapportId) {
        Optional<RapportStage> rapportOpt = findById(rapportId);
        rapportOpt.ifPresent(rapport -> {
            rapport.setStatut(StatutRapport.VALIDE);
            // Mise à jour du statut de l'offre
            OffreStage offre = rapport.getOffreStage();
            offre.setStatut(StatutOffre.RAPPORT_VALIDE);
            entityManager.merge(offre);
            entityManager.merge(rapport);
        });
    }

    /**
     * Liste les rapports en attente de traitement pour un superviseur.
     */
    public List<RapportStage> listerRapportsEnAttente(Long superviseurId) {
        String jpql = "SELECT r FROM RapportStage r JOIN r.offreStage o " +
                      "WHERE o.superviseur.id = :superviseurId " +
                      "AND r.statut IN (:statutSoumis, :statutCorrection)";
        return entityManager.createQuery(jpql, RapportStage.class)
                .setParameter("superviseurId", superviseurId)
                .setParameter("statutSoumis", StatutRapport.SOUMIS)
                .setParameter("statutCorrection", StatutRapport.EN_CORRECTION)
                .getResultList();
    }

    /**
     * Recherche un rapport par l'offre de stage associée.
     */
    public Optional<RapportStage> findByOffre(Long offreId) {
        String jpql = "SELECT r FROM RapportStage r WHERE r.offreStage.id = :offreId";
        List<RapportStage> result = entityManager.createQuery(jpql, RapportStage.class)
                .setParameter("offreId", offreId)
                .getResultList();
        return result.isEmpty() ? Optional.empty() : Optional.of(result.get(0));
    }

    /**
     * Recherche un rapport par son identifiant.
     */
    public Optional<RapportStage> findById(Long id) {
        return Optional.ofNullable(entityManager.find(RapportStage.class, id));
    }
}