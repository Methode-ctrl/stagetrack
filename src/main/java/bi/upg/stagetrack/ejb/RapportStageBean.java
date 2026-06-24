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
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Session Bean gerant la soumission et l'evaluation des rapports de stage.
 */
@Stateless
public class RapportStageBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager entityManager;

    /**
     * Soumet un nouveau rapport, ou met a jour le rapport existant si le
     * superviseur avait demande une correction.
     */
    @Transactional
    public void soumettreRapport(RapportStage rapport, Long offreId) {
        OffreStage offre = entityManager.find(OffreStage.class, offreId);
        if (offre == null) {
            throw new IllegalArgumentException("Offre de stage introuvable");
        }

        boolean statutAutorise = offre.getStatut() == StatutOffre.STAGE_EN_COURS
                || offre.getStatut() == StatutOffre.EN_CORRECTION;
        if (!statutAutorise) {
            throw new IllegalStateException(
                    "Le rapport ne peut etre soumis que pour un stage en cours ou en correction");
        }

        RapportStage rapportCible = offre.getRapport();
        if (rapportCible == null) {
            rapportCible = rapport;
            rapportCible.setOffreStage(offre);
            offre.setRapport(rapportCible);
            entityManager.persist(rapportCible);
        } else {
            copierRapport(rapport, rapportCible);
        }

        rapportCible.setStatut(StatutRapport.SOUMIS);
        rapportCible.setDateSoumission(LocalDate.now());
        offre.setCommentaireSuperviseur(null);
        offre.setStatut(StatutOffre.RAPPORT_SOUMIS);
    }

    /**
     * Resoumet un rapport existant apres correction.
     */
    @Transactional
    public void resoumettreRapport(RapportStage rapport, Long offreId) {
        soumettreRapport(rapport, offreId);
    }

    /**
     * Demande des corrections sur le rapport par le superviseur.
     */
    @Transactional
    public void demanderCorrection(Long rapportId, String commentaire) {
        RapportStage rapport = entityManager.find(RapportStage.class, rapportId);
        if (rapport == null || rapport.getOffreStage() == null) {
            throw new IllegalArgumentException("Rapport introuvable");
        }

        rapport.setStatut(StatutRapport.EN_CORRECTION);
        OffreStage offre = rapport.getOffreStage();
        offre.setCommentaireSuperviseur(commentaire);
        offre.setStatut(StatutOffre.EN_CORRECTION);
    }

    /**
     * Valide definitivement le rapport de stage.
     */
    @Transactional
    public void validerRapport(Long rapportId) {
        RapportStage rapport = entityManager.find(RapportStage.class, rapportId);
        if (rapport == null || rapport.getOffreStage() == null) {
            throw new IllegalArgumentException("Rapport introuvable");
        }

        OffreStage offre = rapport.getOffreStage();
        if (offre.getStatut() != StatutOffre.RAPPORT_SOUMIS
                || rapport.getStatut() != StatutRapport.SOUMIS) {
            throw new IllegalStateException("Seuls les rapports soumis peuvent etre valides");
        }

        rapport.setStatut(StatutRapport.VALIDE);
        offre.setCommentaireSuperviseur(null);
        offre.setStatut(StatutOffre.RAPPORT_VALIDE);
    }

    /**
     * Liste les rapports en attente de traitement pour un superviseur.
     */
    public List<RapportStage> listerRapportsEnAttente(Long superviseurId) {
        List<StatutRapport> statuts = new ArrayList<>();
        statuts.add(StatutRapport.SOUMIS);
        statuts.add(StatutRapport.EN_CORRECTION);

        String jpql = "SELECT r FROM RapportStage r JOIN r.offreStage o " +
                "WHERE o.superviseur.id = :superviseurId " +
                "AND r.statut IN :statuts";
        return entityManager.createQuery(jpql, RapportStage.class)
                .setParameter("superviseurId", superviseurId)
                .setParameter("statuts", statuts)
                .getResultList();
    }

    /**
     * Recherche un rapport par l'offre de stage associee.
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

    private void copierRapport(RapportStage source, RapportStage cible) {
        cible.setTitre(source.getTitre());
        cible.setResume(source.getResume());
        cible.setCompetencesAcquises(source.getCompetencesAcquises());
        cible.setNomFichierPdf(source.getNomFichierPdf());
        cible.setNomFichierAnnexe(source.getNomFichierAnnexe());
    }
}
