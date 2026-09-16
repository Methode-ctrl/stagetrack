package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.ConventionBean;
import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.entity.Convention;
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

@WebServlet("/conventions")
public class ConventionServlet extends HttpServlet {

    @EJB
    private ConventionBean conventionBean;

    @EJB
    private OffreStageBean offreBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            if (!WebUtil.exigerRole(req, resp, Role.ADMIN)) return;
            String action = req.getParameter("action");
            if ("detail".equals(action)) {
                Long id = Long.valueOf(req.getParameter("id"));
                Convention convention = conventionBean.trouverConvention(id);
                req.setAttribute("convention", convention);
                req.getRequestDispatcher("/WEB-INF/views/convention.jsp").forward(req, resp);
            } else if ("creer".equals(action)) {
                req.setAttribute("offresSansConvention", offreBean.listerSansConvention());
                req.getRequestDispatcher("/WEB-INF/views/generer-convention.jsp").forward(req, resp);
            } else {
                List<Convention> conventions = conventionBean.listerConventions();
                req.setAttribute("conventions", conventions);
                req.getRequestDispatcher("/WEB-INF/views/liste-conventions.jsp").forward(req, resp);
            }
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
                    Long offreId = Long.valueOf(req.getParameter("offreId"));
                    conventionBean.creerConvention(offreId);
                    break;
                }
                case "changerStatut": {
                    conventionBean.changerStatut(
                            Long.valueOf(req.getParameter("id")),
                            req.getParameter("statut"));
                    break;
                }
                case "supprimer": {
                    conventionBean.supprimerConvention(Long.valueOf(req.getParameter("id")));
                    break;
                }
                default:
                    break;
            }
            resp.sendRedirect(req.getContextPath() + "/conventions");
        } catch (Exception e) {
            req.setAttribute("erreurs", List.of(WebUtil.messageReel(e)));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}