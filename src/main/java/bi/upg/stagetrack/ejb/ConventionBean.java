package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.Convention;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.enums.StatutOffre;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class ConventionBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    public Convention creerConvention(Long offreId) {
        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null) {
            throw new IllegalArgumentException("Offre introuvable");
        }
        Convention existante = trouverConventionParOffre(offreId);
        if (existante != null) {
            throw new IllegalArgumentException("Une convention existe déjà pour cette offre");
        }
        Convention convention = new Convention(offre, genererContenu(offre));
        convention.setDateGeneration(LocalDateTime.now());
        em.persist(convention);
        if (offre.getStatut() == StatutOffre.VALIDEE) {
            return convention;
        }
        return convention;
    }

    public Convention trouverConventionParOffre(Long offreId) {
        TypedQuery<Convention> q = em.createQuery(
            "SELECT c FROM Convention c WHERE c.offreStage.id = :oid", Convention.class);
        q.setParameter("oid", offreId);
        return q.getResultList().stream().findFirst().orElse(null);
    }

    public Convention trouverConvention(Long id) {
        return em.find(Convention.class, id);
    }

    public List<Convention> listerConventions() {
        return em.createQuery(
            "SELECT c FROM Convention c ORDER BY c.dateGeneration DESC", Convention.class)
            .getResultList();
    }

    public Convention changerStatut(Long id, String statut) {
        Convention convention = em.find(Convention.class, id);
        if (convention == null) {
            throw new IllegalArgumentException("Convention introuvable");
        }
        convention.setStatut(statut);
        return em.merge(convention);
    }

    public void supprimerConvention(Long id) {
        Convention convention = em.find(Convention.class, id);
        if (convention != null) {
            em.remove(convention);
        }
    }

    private String genererContenu(OffreStage offre) {
        String nomEtudiant = offre.getEtudiant().getUtilisateur().getNomComplet();
        String nomEntreprise = offre.getEntreprise() != null ? offre.getEntreprise().getNom() : "—";
        String titre = offre.getTitre() != null ? offre.getTitre() : "—";
        int duree = offre.getDureeEnMois() != null ? offre.getDureeEnMois() : 0;
        return "CONVENTION DE STAGE\n"
                + "Entre l'étudiant " + nomEtudiant + " et l'entreprise " + nomEntreprise + "\n"
                + "Objet : " + titre + "\n"
                + "Durée : " + duree + " mois\n"
                + "Rectorat de l'Université Polytechnique de Gitega";
    }
}