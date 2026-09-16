package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.GestionBean;
import bi.upg.stagetrack.entity.Entreprise;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.util.WebUtil;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/entreprises")
public class EntrepriseServlet extends HttpServlet {

    @EJB
    private GestionBean gestionBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            if (!WebUtil.exigerRole(req, resp, Role.ADMIN)) return;
            List<Entreprise> entreprises = gestionBean.listerEntreprises();
            req.setAttribute("entreprises", entreprises);
            req.getRequestDispatcher("/WEB-INF/views/gestion-entreprises.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("erreurs", List.of(WebUtil.messageReel(e)));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            if (!WebUtil.exigerRole(req, resp, Role.ADMIN)) return;
            String action = req.getParameter("action");

            switch (action) {
                case "creer": {
                    gestionBean.creerEntreprise(
                            req.getParameter("nom"),
                            req.getParameter("adresse"),
                            req.getParameter("telephone"),
                            req.getParameter("email"),
                            req.getParameter("secteur"),
                            req.getParameter("representant"));
                    break;
                }
                case "modifier": {
                    gestionBean.modifierEntreprise(
                            Long.valueOf(req.getParameter("id")),
                            req.getParameter("nom"),
                            req.getParameter("adresse"),
                            req.getParameter("telephone"),
                            req.getParameter("email"),
                            req.getParameter("secteur"),
                            req.getParameter("representant"));
                    break;
                }
                case "supprimer": {
                    gestionBean.supprimerEntreprise(Long.valueOf(req.getParameter("id")));
                    break;
                }
                default:
                    break;
            }
            resp.sendRedirect(req.getContextPath() + "/entreprises");
        } catch (Exception e) {
            req.setAttribute("erreurs", List.of(WebUtil.messageReel(e)));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}