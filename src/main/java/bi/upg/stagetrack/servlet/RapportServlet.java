package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.RapportStageBean;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.StatutOffre;
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

/**
 * Servlet gerant la soumission des rapports de stage en deux etapes.
 */
@WebServlet("/rapports")
public class RapportServlet extends HttpServlet {

    @Inject
    private RapportStageBean rapportStageBean;

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (action) {
                case "new":
                case "soumettre-etape1":
                    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
                    OffreStage offreEnCours = trouverOffreSoumettable(utilisateur.getId());
                    if (offreEnCours == null) {
                        request.setAttribute("messageErreur",
                                "Vous devez avoir un stage en cours ou un rapport en correction.");
                        request.getRequestDispatcher("/WEB-INF/views/erreur.jsp")
                                .forward(request, response);
                        return;
                    }
                    session.setAttribute("offreId", offreEnCours.getId());
                    request.getRequestDispatcher("/WEB-INF/views/rapport-etape1.jsp")
                            .forward(request, response);
                    break;

                case "etape2":
                case "soumettre-etape2":
                    if (session.getAttribute("rapportTemp_titre") == null) {
                        response.sendRedirect(request.getContextPath() + "/rapports?action=new");
                        return;
                    }
                    request.getRequestDispatcher("/WEB-INF/views/rapport-etape2.jsp")
                            .forward(request, response);
                    break;

                case "evaluer":
                    String offreIdStr = request.getParameter("offreId");
                    if (offreIdStr != null) {
                        Long offreId = Long.parseLong(offreIdStr);
                        OffreStage offre = em.find(OffreStage.class, offreId);
                        request.setAttribute("offre", offre);
                        if (offre != null && offre.getRapport() != null) {
                            request.setAttribute("rapport", offre.getRapport());
                        }
                    }
                    request.getRequestDispatcher("/WEB-INF/views/evaluer-rapport.jsp")
                            .forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (action) {
                case "soumettre-etape1":
                    traiterEtape1(request, response, session);
                    break;

                case "soumettre-etape2":
                    soumettreFinal(request, response, session);
                    break;

                case "valider":
                    rapportStageBean.validerRapport(Long.parseLong(request.getParameter("rapportId")));
                    response.sendRedirect(request.getContextPath() + "/dashboard/superviseur");
                    break;

                case "correction":
                    rapportStageBean.demanderCorrection(
                            Long.parseLong(request.getParameter("rapportId")),
                            request.getParameter("commentaire"));
                    response.sendRedirect(request.getContextPath() + "/dashboard/superviseur");
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    private void traiterEtape1(HttpServletRequest request,
                               HttpServletResponse response,
                               HttpSession session)
            throws ServletException, IOException {

        String titre = request.getParameter("titre");
        String resume = request.getParameter("resume");
        String competences = request.getParameter("competences");

        List<String> erreurs = new ArrayList<>();
        if (titre == null || titre.trim().isEmpty()) {
            erreurs.add("Le titre du rapport est obligatoire");
        }
        if (resume == null || resume.trim().isEmpty()) {
            erreurs.add("Le resume est obligatoire");
        }

        if (!erreurs.isEmpty()) {
            request.setAttribute("erreurs", erreurs);
            request.getRequestDispatcher("/WEB-INF/views/rapport-etape1.jsp")
                    .forward(request, response);
            return;
        }

        session.setAttribute("rapportTemp_titre", titre.trim());
        session.setAttribute("rapportTemp_resume", resume.trim());
        session.setAttribute("rapportTemp_competences",
                competences != null ? competences.trim() : "");

        response.sendRedirect(request.getContextPath() + "/rapports?action=etape2");
    }

    private void soumettreFinal(HttpServletRequest request,
                                HttpServletResponse response,
                                HttpSession session)
            throws ServletException, IOException {

        String nomFichierPdf = request.getParameter("nomFichierPdf");
        String nomFichierAnnexe = request.getParameter("nomFichierAnnexe");

        List<String> erreurs = new ArrayList<>();
        if (nomFichierPdf == null || nomFichierPdf.trim().isEmpty()) {
            erreurs.add("Le nom du fichier rapport PDF est obligatoire");
        } else if (!nomFichierPdf.toLowerCase().endsWith(".pdf")) {
            erreurs.add("Le rapport doit etre un fichier .pdf");
        }

        if (!erreurs.isEmpty()) {
            request.setAttribute("erreurs", erreurs);
            request.getRequestDispatcher("/WEB-INF/views/rapport-etape2.jsp")
                    .forward(request, response);
            return;
        }

        Long offreId = (Long) session.getAttribute("offreId");
        if (offreId == null) {
            String offreIdParam = request.getParameter("offreId");
            if (offreIdParam != null && !offreIdParam.isEmpty()) {
                offreId = Long.parseLong(offreIdParam);
            }
        }

        if (offreId == null) {
            request.setAttribute("messageErreur",
                    "Session expiree. Veuillez recommencer la soumission du rapport.");
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp")
                    .forward(request, response);
            return;
        }

        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null) {
            request.setAttribute("messageErreur", "Offre de stage introuvable.");
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp")
                    .forward(request, response);
            return;
        }

        RapportStage rapport = new RapportStage();
        rapport.setTitre((String) session.getAttribute("rapportTemp_titre"));
        rapport.setResume((String) session.getAttribute("rapportTemp_resume"));
        rapport.setCompetencesAcquises((String) session.getAttribute("rapportTemp_competences"));
        rapport.setNomFichierPdf(nomFichierPdf.trim());
        if (nomFichierAnnexe != null && !nomFichierAnnexe.trim().isEmpty()) {
            rapport.setNomFichierAnnexe(nomFichierAnnexe.trim());
        }

        if (offre.getStatut() == StatutOffre.EN_CORRECTION) {
            rapportStageBean.resoumettreRapport(rapport, offreId);
        } else {
            rapportStageBean.soumettreRapport(rapport, offreId);
        }

        session.removeAttribute("rapportTemp_titre");
        session.removeAttribute("rapportTemp_resume");
        session.removeAttribute("rapportTemp_competences");
        session.removeAttribute("offreId");

        response.sendRedirect(request.getContextPath() + "/dashboard/etudiant?succes=rapport_soumis");
    }

    /**
     * Trouve l'offre qui autorise une soumission de rapport par l'etudiant.
     */
    private OffreStage trouverOffreSoumettable(Long utilisateurId) {
        List<StatutOffre> statuts = new ArrayList<>();
        statuts.add(StatutOffre.STAGE_EN_COURS);
        statuts.add(StatutOffre.EN_CORRECTION);

        List<OffreStage> offres = em.createQuery(
                "SELECT o FROM OffreStage o WHERE o.etudiant.utilisateur.id = :uid " +
                "AND o.statut IN :statuts ORDER BY o.dateSoumission DESC",
                OffreStage.class)
                .setParameter("uid", utilisateurId)
                .setParameter("statuts", statuts)
                .setMaxResults(1)
                .getResultList();

        return offres.isEmpty() ? null : offres.get(0);
    }
}
