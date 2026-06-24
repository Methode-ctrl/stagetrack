package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.entity.Convention;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.Superviseur;
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

/**
 * Servlet gerant la generation et l'affichage des conventions de stage.
 */
@WebServlet("/conventions")
public class ConventionServlet extends HttpServlet {

    @Inject
    private OffreStageBean offreStageBean;

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        String role = (String) session.getAttribute("role");

        try {
            switch (action) {
                case "generer":
                    genererConvention(request, response, utilisateur, role);
                    break;
                case "voir":
                    afficherConventionParId(request, response, utilisateur, role);
                    break;
                default:
                    afficherConventionParOffre(request, response, utilisateur, role);
                    break;
            }
        } catch (SecurityException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur", "Erreur lors du chargement de la convention: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("generer".equals(action)) {
            doGet(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    private void genererConvention(HttpServletRequest request,
                                   HttpServletResponse response,
                                   Utilisateur utilisateur,
                                   String role)
            throws IOException {

        if (!"SUPERVISEUR".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        Superviseur superviseur = offreStageBean.findSuperviseurByUtilisateurId(utilisateur.getId());
        if (superviseur == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Profil superviseur introuvable");
            return;
        }

        Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
        Convention convention = offreStageBean.genererConventionSiAbsente(offreId, superviseur.getId());
        response.sendRedirect(request.getContextPath() + "/conventions?action=voir&id=" + convention.getId());
    }

    private void afficherConventionParId(HttpServletRequest request,
                                         HttpServletResponse response,
                                         Utilisateur utilisateur,
                                         String role)
            throws ServletException, IOException {

        Long conventionId = lireLongObligatoire(request.getParameter("id"), "id");
        Convention convention = em.find(Convention.class, conventionId);
        if (convention == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        OffreStage offre = convention.getOffreStage();
        verifierAccesOffre(offre, utilisateur, role);

        request.setAttribute("convention", convention);
        request.setAttribute("offre", offre);
        request.getRequestDispatcher("/WEB-INF/views/convention.jsp").forward(request, response);
    }

    private void afficherConventionParOffre(HttpServletRequest request,
                                            HttpServletResponse response,
                                            Utilisateur utilisateur,
                                            String role)
            throws ServletException, IOException {

        String offreIdStr = request.getParameter("offreId");
        if (offreIdStr == null || offreIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        Long offreId = lireLongObligatoire(offreIdStr, "offreId");
        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null || offre.getConvention() == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        verifierAccesOffre(offre, utilisateur, role);

        request.setAttribute("convention", offre.getConvention());
        request.setAttribute("offre", offre);
        request.getRequestDispatcher("/WEB-INF/views/convention.jsp").forward(request, response);
    }

    private void verifierAccesOffre(OffreStage offre,
                                    Utilisateur utilisateur,
                                    String role) {

        if ("ADMIN".equals(role)) {
            return;
        }

        if ("SUPERVISEUR".equals(role)) {
            Superviseur superviseur = offreStageBean.findSuperviseurByUtilisateurId(utilisateur.getId());
            if (superviseur == null
                    || offre.getSuperviseur() == null
                    || !superviseur.getId().equals(offre.getSuperviseur().getId())) {
                throw new SecurityException("Acces non autorise a cette convention");
            }
            return;
        }

        if ("ETUDIANT".equals(role)) {
            if (offre.getEtudiant() == null
                    || offre.getEtudiant().getUtilisateur() == null
                    || !utilisateur.getId().equals(offre.getEtudiant().getUtilisateur().getId())) {
                throw new SecurityException("Acces non autorise a cette convention");
            }
            return;
        }

        throw new SecurityException("Acces non autorise");
    }

    private Long lireLongObligatoire(String valeur, String nomParametre) {
        if (valeur == null || valeur.trim().isEmpty()) {
            throw new IllegalArgumentException("Le parametre " + nomParametre + " est obligatoire");
        }
        return Long.parseLong(valeur.trim());
    }
}
