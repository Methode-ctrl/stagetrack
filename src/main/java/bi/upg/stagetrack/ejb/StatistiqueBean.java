package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.enums.StatutOffre;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;

@Stateless
public class StatistiqueBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    public long compterParStatut(StatutOffre statut) {
        TypedQuery<Long> q = em.createQuery(
            "SELECT COUNT(o) FROM OffreStage o WHERE o.statut = :statut", Long.class);
        q.setParameter("statut", statut);
        return q.getSingleResult();
    }

    public long getNombreStagesActifs() {
        TypedQuery<Long> q = em.createQuery(
            "SELECT COUNT(o) FROM OffreStage o WHERE o.statut = :statut", Long.class);
        q.setParameter("statut", StatutOffre.STAGE_EN_COURS);
        return q.getSingleResult();
    }

    public List<OffreStage> getSansSuperviseur() {
        TypedQuery<OffreStage> q = em.createQuery(
            "SELECT o FROM OffreStage o WHERE o.superviseur IS NULL ORDER BY o.dateSoumission DESC",
            OffreStage.class);
        return new ArrayList<>(q.getResultList());
    }

    public List<Superviseur> getAllSuperviseurs() {
        TypedQuery<Superviseur> q = em.createQuery(
            "SELECT s FROM Superviseur s ORDER BY s.utilisateur.nom", Superviseur.class);
        return new ArrayList<>(q.getResultList());
    }
}
