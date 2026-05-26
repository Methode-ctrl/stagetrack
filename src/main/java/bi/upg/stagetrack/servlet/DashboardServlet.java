package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.ejb.StatistiqueBean;
import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.StatutOffre;
import bi.upg.stagetrack.enums.StatutRapport;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/dashboard/*")
public class DashboardServlet extends HttpServlet {

    @Inject
    private StatistiqueBean statistiqueBean;

    @Inject
    private OffreStageBean offreStageBean;

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            pathInfo = "/";
        }

        try {
            switch (pathInfo) {
                case "/admin":
                    afficherDashboardAdmin(request, response);
                    break;
                case "/superviseur":
                    afficherDashboardSuperviseur(request, response);
                    break;
                case "/etudiant":
                    afficherDashboardEtudiant(request, response, utilisateur);
                    break;
                default:
                    String role = (String) session.getAttribute("role");
                    response.sendRedirect(request.getContextPath()
                            + "/dashboard/" + role.toLowerCase());
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur",
                    "Erreur lors du chargement du dashboard: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    private void afficherDashboardAdmin(HttpServletRequest request,
                                        HttpServletResponse response)
            throws ServletException, IOException {

        long nbSoumises = statistiqueBean.compterParStatut(StatutOffre.OFFRE_SOUMISE);
        long nbEnCours = statistiqueBean.getNombreStagesActifs();
        long nbArchives = statistiqueBean.compterParStatut(StatutOffre.ARCHIVE);
        long nbTotal = em.createQuery("SELECT COUNT(o) FROM OffreStage o", Long.class)
                .getSingleResult();

        List<StatutOffre> statutsRapportsSoumis = new ArrayList<>();
        statutsRapportsSoumis.add(StatutOffre.RAPPORT_SOUMIS);
        statutsRapportsSoumis.add(StatutOffre.EN_CORRECTION);
        long nbRapportsAEvaluer = em.createQuery(
                "SELECT COUNT(o) FROM OffreStage o WHERE o.statut IN :statuts",
                Long.class)
                .setParameter("statuts", statutsRapportsSoumis)
                .getSingleResult();

        List<StatutOffre> statutsAArchiver = new ArrayList<>();
        statutsAArchiver.add(StatutOffre.NOTE_ATTRIBUEE);
        long nbAArchiver = em.createQuery(
                "SELECT COUNT(o) FROM OffreStage o WHERE o.statut IN :statuts",
                Long.class)
                .setParameter("statuts", statutsAArchiver)
                .getSingleResult();

        long nbSansSuperviseur = em.createQuery(
                "SELECT COUNT(o) FROM OffreStage o WHERE o.superviseur IS NULL",
                Long.class)
                .getSingleResult();

        request.setAttribute("nbTotal", nbTotal);
        request.setAttribute("nbSoumises", nbSoumises);
        request.setAttribute("nbEnCours", nbEnCours);
        request.setAttribute("nbArchives", nbArchives);
        request.setAttribute("nbRapportsAEvaluer", nbRapportsAEvaluer);
        request.setAttribute("nbAArchiver", nbAArchiver);
        request.setAttribute("nbSansSuperviseur", nbSansSuperviseur);
        request.setAttribute("offres", offreStageBean.listerToutes());

        List<Superviseur> superviseurs = em.createQuery(
                "SELECT s FROM Superviseur s JOIN s.utilisateur u " +
                "WHERE u.actif = true ORDER BY u.nom",
                Superviseur.class)
                .getResultList();
        request.setAttribute("superviseurs", superviseurs);

        request.getRequestDispatcher("/WEB-INF/views/dashboard-admin.jsp")
                .forward(request, response);
    }

    /**
     * Charge le dashboard du superviseur avec uniquement ses offres affectees.
     * Les filtres rapides utilisent toujours des ArrayList pour les clauses IN.
     */
    private void afficherDashboardSuperviseur(HttpServletRequest request,
                                              HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");

        List<Superviseur> sups = em.createQuery(
                "SELECT s FROM Superviseur s WHERE s.utilisateur.id = :uid",
                Superviseur.class)
                .setParameter("uid", utilisateur.getId())
                .getResultList();

        if (sups.isEmpty()) {
            request.setAttribute("messageErreur",
                    "Profil superviseur non trouve pour cet utilisateur.");
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp")
                    .forward(request, response);
            return;
        }

        Superviseur superviseur = sups.get(0);

        String succes = request.getParameter("succes");
        if ("note_attribuee".equals(succes)) {
            request.setAttribute("succes", "La note finale a ete attribuee avec succes.");
        }

        String filtre = request.getParameter("filtre");
        if (filtre == null || filtre.isEmpty()) {
            filtre = "tous";
        }

        List<OffreStage> offres;
        switch (filtre) {
            case "a-examiner": {
                List<StatutOffre> statuts = new ArrayList<>();
                statuts.add(StatutOffre.OFFRE_SOUMISE);
                statuts.add(StatutOffre.EN_VALIDATION);
                offres = offreStageBean.listerParSuperviseurEtStatuts(superviseur.getId(), statuts);
                break;
            }
            case "en-cours": {
                List<StatutOffre> statuts = new ArrayList<>();
                statuts.add(StatutOffre.VALIDEE);
                statuts.add(StatutOffre.STAGE_EN_COURS);
                statuts.add(StatutOffre.PAUSE);
                offres = offreStageBean.listerParSuperviseurEtStatuts(superviseur.getId(), statuts);
                break;
            }
            case "rapports": {
                List<StatutOffre> statuts = new ArrayList<>();
                statuts.add(StatutOffre.RAPPORT_SOUMIS);
                statuts.add(StatutOffre.EN_CORRECTION);
                offres = offreStageBean.listerParSuperviseurEtStatuts(superviseur.getId(), statuts);
                break;
            }
            case "termines": {
                List<StatutOffre> statuts = new ArrayList<>();
                statuts.add(StatutOffre.RAPPORT_VALIDE);
                statuts.add(StatutOffre.NOTE_ATTRIBUEE);
                statuts.add(StatutOffre.ARCHIVE);
                offres = offreStageBean.listerParSuperviseurEtStatuts(superviseur.getId(), statuts);
                break;
            }
            default:
                offres = em.createQuery(
                        "SELECT o FROM OffreStage o WHERE o.superviseur.id = :sid " +
                        "ORDER BY o.dateSoumission DESC",
                        OffreStage.class)
                        .setParameter("sid", superviseur.getId())
                        .getResultList();
                filtre = "tous";
                break;
        }

        List<StatutRapport> statutsRapport = new ArrayList<>();
        statutsRapport.add(StatutRapport.SOUMIS);
        statutsRapport.add(StatutRapport.EN_CORRECTION);
        long nbRapports = em.createQuery(
                "SELECT COUNT(r) FROM RapportStage r " +
                "WHERE r.offreStage.superviseur.id = :sid AND r.statut IN :statuts",
                Long.class)
                .setParameter("sid", superviseur.getId())
                .setParameter("statuts", statutsRapport)
                .getSingleResult();

        List<StatutOffre> statutsIncomplets = new ArrayList<>();
        statutsIncomplets.add(StatutOffre.DOSSIER_INCOMPLET);
        long nbIncomplets = em.createQuery(
                "SELECT COUNT(o) FROM OffreStage o " +
                "WHERE o.superviseur.id = :sid AND o.statut IN :statuts",
                Long.class)
                .setParameter("sid", superviseur.getId())
                .setParameter("statuts", statutsIncomplets)
                .getSingleResult();

        List<StatutOffre> statutsAExaminer = new ArrayList<>();
        statutsAExaminer.add(StatutOffre.OFFRE_SOUMISE);
        statutsAExaminer.add(StatutOffre.EN_VALIDATION);
        long nbAExaminer = em.createQuery(
                "SELECT COUNT(o) FROM OffreStage o " +
                "WHERE o.superviseur.id = :sid AND o.statut IN :statuts",
                Long.class)
                .setParameter("sid", superviseur.getId())
                .setParameter("statuts", statutsAExaminer)
                .getSingleResult();

        long nbEtudiantsAffectes = em.createQuery(
                "SELECT COUNT(DISTINCT o.etudiant.id) FROM OffreStage o WHERE o.superviseur.id = :sid",
                Long.class)
                .setParameter("sid", superviseur.getId())
                .getSingleResult();

        request.setAttribute("superviseur", superviseur);
        request.setAttribute("offres", offres);
        request.setAttribute("nbRapportsEnAttente", nbRapports);
        request.setAttribute("nbDossiersIncomplets", nbIncomplets);
        request.setAttribute("nbDossiersAExaminer", nbAExaminer);
        request.setAttribute("nbEtudiantsAffectes", nbEtudiantsAffectes);
        request.setAttribute("filtreActif", filtre);

        request.getRequestDispatcher("/WEB-INF/views/dashboard-superviseur.jsp")
                .forward(request, response);
    }

    private void afficherDashboardEtudiant(HttpServletRequest request,
                                           HttpServletResponse response,
                                           Utilisateur utilisateur)
            throws ServletException, IOException {

        List<Etudiant> etudiants = em.createQuery(
                "SELECT e FROM Etudiant e WHERE e.utilisateur.id = :uid",
                Etudiant.class)
                .setParameter("uid", utilisateur.getId())
                .getResultList();

        if (etudiants.isEmpty()) {
            request.setAttribute("utilisateur", utilisateur);
            request.setAttribute("offres", new ArrayList<>());
            request.getRequestDispatcher("/WEB-INF/views/dashboard-etudiant.jsp")
                    .forward(request, response);
            return;
        }

        Etudiant etudiant = etudiants.get(0);
        request.setAttribute("etudiant", etudiant);

        String succes = request.getParameter("succes");
        if ("offre_soumise".equals(succes)) {
            request.setAttribute("succes", "Votre offre de stage a ete soumise avec succes !");
        } else if ("rapport_soumis".equals(succes)) {
            request.setAttribute("succes", "Votre rapport a ete soumis avec succes !");
        }

        List<OffreStage> offres = em.createQuery(
                "SELECT o FROM OffreStage o WHERE o.etudiant.id = :eid " +
                "ORDER BY o.dateSoumission DESC",
                OffreStage.class)
                .setParameter("eid", etudiant.getId())
                .getResultList();

        request.setAttribute("offres", offres);

        if (!offres.isEmpty()) {
            OffreStage offre = offres.get(0);
            request.setAttribute("offre", offre);
            if (offre.getRapport() != null) {
                request.setAttribute("rapport", offre.getRapport());
                if (offre.getRapport().getNote() != null) {
                    request.setAttribute("note", offre.getRapport().getNote());
                }
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/dashboard-etudiant.jsp")
                .forward(request, response);
    }
}
