package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.ejb.StatistiqueBean;
import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard/*")
public class DashboardServlet extends HttpServlet {

    @EJB
    private OffreStageBean offreBean;

    @EJB
    private StatistiqueBean statistiqueBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("utilisateur") == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
            String path = req.getPathInfo();
            Role role = utilisateur.getRole();

            if (path == null || "/".equals(path)) {
                switch (role) {
                    case ETUDIANT:
                        resp.sendRedirect(req.getContextPath() + "/dashboard/etudiant");
                        break;
                    case SUPERVISEUR:
                        resp.sendRedirect(req.getContextPath() + "/dashboard/superviseur");
                        break;
                    default:
                        resp.sendRedirect(req.getContextPath() + "/dashboard/admin");
                }
                return;
            }

            switch (role) {
                case ETUDIANT:
                    Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                    List<OffreStage> mesOffres = etudiant != null
                            ? offreBean.listerParEtudiant(etudiant.getId())
                            : List.of();
                    req.setAttribute("offres", mesOffres);
                    req.setAttribute("etudiant", etudiant);
                    req.getRequestDispatcher("/WEB-INF/views/dashboard-etudiant.jsp").forward(req, resp);
                    break;

                case SUPERVISEUR:
                    Superviseur superviseur = offreBean.findSuperviseurByUtilisateurId(utilisateur.getId());
                    List<OffreStage> offresSuivi = superviseur != null
                            ? offreBean.listerParSuperviseur(superviseur)
                            : List.of();
                    req.setAttribute("offres", offresSuivi);
                    req.setAttribute("superviseur", superviseur);
                    req.getRequestDispatcher("/WEB-INF/views/dashboard-superviseur.jsp").forward(req, resp);
                    break;

                default:
                    req.setAttribute("totalStagesActifs", statistiqueBean.getNombreStagesActifs());
                    req.setAttribute("offresSansSuperviseur", statistiqueBean.getSansSuperviseur());
                    req.setAttribute("superviseurs", statistiqueBean.getAllSuperviseurs());
                    req.getRequestDispatcher("/WEB-INF/views/dashboard-admin.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}