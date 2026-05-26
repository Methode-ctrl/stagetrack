package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.RapportStageBean;
import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.enums.StatutOffre;
import bi.upg.stagetrack.enums.StatutRapport;
import bi.upg.stagetrack.entity.Utilisateur;
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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet gérant la soumission et l'évaluation des rapports de stage.
 * Formulaire en 2 étapes pour l'étudiant, évaluation par le superviseur.
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
        if (action == null) action = "";

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (action) {
                case "new":
                case "soumettre-etape1":
                    // Vérifier que l'étudiant a bien un stage en cours
                    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
                    OffreStage offreEnCours = trouverOffreEnCours(u.getId());
                    if (offreEnCours == null) {
                        request.setAttribute("messageErreur",
                            "Vous devez avoir un stage en cours pour soumettre un rapport. " +
                            "Votre stage doit être au statut 'En cours'.");
                        request.getRequestDispatcher("/WEB-INF/views/erreur.jsp")
                               .forward(request, response);
                        return;
                    }
                    // Stocker l'offreId en session pour étape 2
                    session.setAttribute("offreId", offreEnCours.getId());
                    request.getRequestDispatcher("/WEB-INF/views/rapport-etape1.jsp")
                           .forward(request, response);
                    break;

                case "etape2":
                case "soumettre-etape2":
                    // Vérifier que l'étape 1 a été remplie
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
        if (action == null) action = "";

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (action) {
                case "soumettre-etape1":
                    // Stocker les données de l'étape 1 en session
                    String titre = request.getParameter("titre");
                    String resume = request.getParameter("resume");
                    String competences = request.getParameter("competences");

                    // Validation
                    List<String> erreurs = new ArrayList<>();
                    if (titre == null || titre.trim().isEmpty())
                        erreurs.add("Le titre du rapport est obligatoire");
                    if (resume == null || resume.trim().isEmpty())
                        erreurs.add("Le résumé est obligatoire");

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
                    break;

                case "soumettre-etape2":
                    soumettreFinal(request, response, session);
                    break;

                case "valider":
                    Long rapportIdV = Long.parseLong(request.getParameter("rapportId"));
                    rapportStageBean.validerRapport(rapportIdV);
                    response.sendRedirect(request.getContextPath() + "/dashboard/superviseur");
                    break;

                case "correction":
                    Long rapportIdC = Long.parseLong(request.getParameter("rapportId"));
                    String commentaire = request.getParameter("commentaire");
                    rapportStageBean.demanderCorrection(rapportIdC, commentaire);
                    response.sendRedirect(request.getContextPath() + "/dashboard/superviseur");
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    private void soumettreFinal(HttpServletRequest request,
                                HttpServletResponse response,
                                HttpSession session)
            throws ServletException, IOException {

        String nomFichierPdf = request.getParameter("nomFichierPdf");
        String nomFichierAnnexe = request.getParameter("nomFichierAnnexe");

        // Validation
        List<String> erreurs = new ArrayList<>();
        if (nomFichierPdf == null || nomFichierPdf.trim().isEmpty())
            erreurs.add("Le nom du fichier rapport PDF est obligatoire");
        else if (!nomFichierPdf.toLowerCase().endsWith(".pdf"))
            erreurs.add("Le rapport doit être un fichier .pdf");

        if (!erreurs.isEmpty()) {
            request.setAttribute("erreurs", erreurs);
            request.getRequestDispatcher("/WEB-INF/views/rapport-etape2.jsp")
                   .forward(request, response);
            return;
        }

        // Récupérer l'offreId depuis la session
        Long offreId = (Long) session.getAttribute("offreId");
        if (offreId == null) {
            // Essayer depuis le paramètre de la requête
            String offreIdParam = request.getParameter("offreId");
            if (offreIdParam != null && !offreIdParam.isEmpty()) {
                offreId = Long.parseLong(offreIdParam);
            }
        }

        if (offreId == null) {
            request.setAttribute("messageErreur",
                "Session expirée. Veuillez recommencer la soumission du rapport.");
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp")
                   .forward(request, response);
            return;
        }

        // Construire le rapport
        RapportStage rapport = new RapportStage();
        rapport.setTitre((String) session.getAttribute("rapportTemp_titre"));
        rapport.setResume((String) session.getAttribute("rapportTemp_resume"));
        rapport.setCompetencesAcquises((String) session.getAttribute("rapportTemp_competences"));
        rapport.setNomFichierPdf(nomFichierPdf.trim());
        if (nomFichierAnnexe != null && !nomFichierAnnexe.trim().isEmpty()) {
            rapport.setNomFichierAnnexe(nomFichierAnnexe.trim());
        }

        // Soumettre via EJB
        rapportStageBean.soumettreRapport(rapport, offreId);

        // Nettoyer la session
        session.removeAttribute("rapportTemp_titre");
        session.removeAttribute("rapportTemp_resume");
        session.removeAttribute("rapportTemp_competences");
        session.removeAttribute("offreId");

        response.sendRedirect(request.getContextPath() + "/dashboard/etudiant?succes=rapport_soumis");
    }

    /**
     * Trouve l'offre de stage en cours ou en correction pour un étudiant.
     */
    private OffreStage trouverOffreEnCours(Long utilisateurId) {
        List<StatutOffre> statuts = new ArrayList<>();
        statuts.add(StatutOffre.STAGE_EN_COURS);
        statuts.add(StatutOffre.EN_CORRECTION);
        statuts.add(StatutOffre.PAUSE);

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
