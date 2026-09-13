package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.GestionBean;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.util.WebUtil;
import jakarta.ejb.EJB;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/utilisateurs")
public class UtilisateurServlet extends HttpServlet {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @EJB
    private GestionBean gestionBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            if (!WebUtil.exigerRole(req, resp, Role.ADMIN)) return;
            List<Utilisateur> utilisateurs = em.createQuery(
                    "SELECT u FROM Utilisateur u ORDER BY u.role, u.nom", Utilisateur.class)
                    .getResultList();
            req.setAttribute("utilisateurs", utilisateurs);
            req.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("erreur", WebUtil.messageReel(e));
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
                    gestionBean.creerUtilisateur(
                            req.getParameter("nom"),
                            req.getParameter("prenom"),
                            req.getParameter("email"),
                            req.getParameter("motDePasse"),
                            Role.valueOf(req.getParameter("role")),
                            req.getParameter("matricule"),
                            req.getParameter("filiere"),
                            req.getParameter("promotion"),
                            req.getParameter("grade"),
                            req.getParameter("specialite"));
                    break;
                }
                case "supprimer": {
                    gestionBean.supprimerUtilisateur(Long.valueOf(req.getParameter("id")));
                    break;
                }
                case "modifierMotDePasse": {
                    gestionBean.modifierMotDePasse(
                            Long.valueOf(req.getParameter("id")), req.getParameter("motDePasse"));
                    break;
                }
                default:
                    break;
            }
            resp.sendRedirect(req.getContextPath() + "/utilisateurs");
        } catch (Exception e) {
            req.setAttribute("erreur", WebUtil.messageReel(e));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}