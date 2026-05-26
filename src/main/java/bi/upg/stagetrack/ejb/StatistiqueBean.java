package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.Entreprise;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.enums.StatutOffre;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Session Bean fournissant les données statistiques pour les tableaux de bord.
 * Contient la logique de calcul des statistiques du système.
 */
@Stateless
public class StatistiqueBean {

    @PersistenceContext
    private EntityManager entityManager;

    /**
     * Compte le nombre d'offres par statut.
     * Retourne une map associant chaque statut au nombre d'offres correspondantes.
     */
    public Map<StatutOffre, Long> compterParStatut() {
        String jpql = "SELECT o.statut, COUNT(o) FROM OffreStage o GROUP BY o.statut";
        List<Object[]> results = entityManager.createQuery(jpql, Object[].class).getResultList();
        Map<StatutOffre, Long> stats = new HashMap<>();
        for (Object[] row : results) {
            StatutOffre statut = (StatutOffre) row[0];
            Long count = (Long) row[1];
            stats.put(statut, count);
        }
        return stats;
    }

    public long compterParStatut(StatutOffre statut) {
        String jpql = "SELECT COUNT(o) FROM OffreStage o WHERE o.statut = :statut";
        return entityManager.createQuery(jpql, Long.class)
                .setParameter("statut", statut)
                .getSingleResult();
    }

    /**
     * Calcule la moyenne des notes finales pour une promotion et une année universitaire données.
     * Utilise la relation OffreStage -> RapportStage -> Note.
     */
    public double calculerMoyennePromotion(String promotion, String anneeUniv) {
        String jpql = "SELECT AVG(n.noteFinale) FROM Note n " +
                      "JOIN n.rapportStage r " +
                      "JOIN r.offreStage o " +
                      "JOIN o.etudiant e " +
                      "WHERE e.promotion = :promotion AND e.anneeUniv = :anneeUniv";
        TypedQuery<Double> query = entityManager.createQuery(jpql, Double.class);
        query.setParameter("promotion", promotion);
        query.setParameter("anneeUniv", anneeUniv);
        Double result = query.getSingleResult();
        return result != null ? result : 0.0;
    }

    /**
     * Retourne la liste des entreprises partenaires (ayant au moins une offre de stage).
     */
    public List<Entreprise> getEntreprisesPartenaires() {
        String jpql = "SELECT DISTINCT o.entreprise FROM OffreStage o WHERE o.entreprise IS NOT NULL";
        return entityManager.createQuery(jpql, Entreprise.class).getResultList();
    }

    /**
     * Retourne la liste des stages considérés comme en retard.
     * Critère : stage en cours depuis plus de 3 mois sans rapport soumis.
     */
    public List<OffreStage> getStagesEnRetard() {
        String jpql = "SELECT o FROM OffreStage o " +
                      "WHERE o.statut = :statutEnCours " +
                      "AND o.dateDebut < :dateLimite " +
                      "AND NOT EXISTS (SELECT r FROM RapportStage r WHERE r.offreStage = o)";
        return entityManager.createQuery(jpql, OffreStage.class)
                .setParameter("statutEnCours", StatutOffre.STAGE_EN_COURS)
                .setParameter("dateLimite", java.time.LocalDate.now().minusMonths(3))
                .getResultList();
    }

    /**
     * Retourne le nombre total de stages actifs (statut STAGE_EN_COURS).
     */
    public long getNombreStagesActifs() {
        String jpql = "SELECT COUNT(o) FROM OffreStage o WHERE o.statut = :statut";
        return entityManager.createQuery(jpql, Long.class)
                .setParameter("statut", StatutOffre.STAGE_EN_COURS)
                .getSingleResult();
    }
}