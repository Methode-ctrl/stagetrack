package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.entity.Entreprise;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/entreprises")
public class EntrepriseServlet extends HttpServlet {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Entreprise> entreprises = em.createQuery(
                    "SELECT e FROM Entreprise e ORDER BY e.nom", Entreprise.class)
                    .getResultList();
            req.setAttribute("entreprises", entreprises);
            req.getRequestDispatcher("/WEB-INF/views/gestion-entreprises.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String action = req.getParameter("action");

            switch (action) {
                case "creer": {
                    Entreprise entreprise = new Entreprise(
                            req.getParameter("nom"),
                            req.getParameter("adresse"),
                            req.getParameter("telephone"),
                            req.getParameter("email"),
                            req.getParameter("secteur"),
                            req.getParameter("representant"));
                    em.persist(entreprise);
                    break;
                }
                case "modifier": {
                    Long id = Long.valueOf(req.getParameter("id"));
                    Entreprise entreprise = em.find(Entreprise.class, id);
                    if (entreprise == null) throw new IllegalArgumentException("Entreprise introuvable");
                    entreprise.setNom(req.getParameter("nom"));
                    entreprise.setAdresse(req.getParameter("adresse"));
                    entreprise.setTelephone(req.getParameter("telephone"));
                    entreprise.setEmail(req.getParameter("email"));
                    entreprise.setSecteur(req.getParameter("secteur"));
                    entreprise.setRepresentant(req.getParameter("representant"));
                    em.merge(entreprise);
                    break;
                }
                case "supprimer": {
                    Long id = Long.valueOf(req.getParameter("id"));
                    Entreprise entreprise = em.find(Entreprise.class, id);
                    if (entreprise != null) em.remove(entreprise);
                    break;
                }
                default:
                    break;
            }
            resp.sendRedirect(req.getContextPath() + "/entreprises");
        } catch (Exception e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}