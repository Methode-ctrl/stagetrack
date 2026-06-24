package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.entity.Entreprise;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet gérant le CRUD sur les entreprises partenaires (réservé à l'admin).
 */
@WebServlet("/entreprises")
public class EntrepriseServlet extends HttpServlet {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("new".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/gestion-entreprises.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            Long id = Long.parseLong(request.getParameter("id"));
            Entreprise entreprise = entityManager.find(Entreprise.class, id);
            request.setAttribute("entreprise", entreprise);
            request.getRequestDispatcher("/WEB-INF/views/gestion-entreprises.jsp").forward(request, response);
        } else {
            // Lister toutes les entreprises
            List<Entreprise> entreprises = entityManager.createQuery(
                    "SELECT e FROM Entreprise e", Entreprise.class).getResultList();
            request.setAttribute("entreprises", entreprises);
            request.getRequestDispatcher("/WEB-INF/views/gestion-entreprises.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("save".equals(action)) {
            String idStr = request.getParameter("id");
            Entreprise entreprise;
            if (idStr != null && !idStr.isEmpty()) {
                // Mise à jour
                Long id = Long.parseLong(idStr);
                entreprise = entityManager.find(Entreprise.class, id);
            } else {
                // Création
                entreprise = new Entreprise();
            }
            entreprise.setNom(request.getParameter("nom"));
            entreprise.setSecteur(request.getParameter("secteur"));
            entreprise.setAdresse(request.getParameter("adresse"));
            entreprise.setVille(request.getParameter("ville"));
            entreprise.setNomResponsable(request.getParameter("nomResponsable"));
            entreprise.setEmailContact(request.getParameter("emailContact"));
            entreprise.setTelephone(request.getParameter("telephone"));

            if (entreprise.getId() == null) {
                entityManager.persist(entreprise);
            } else {
                entityManager.merge(entreprise);
            }
        } else if ("delete".equals(action)) {
            Long id = Long.parseLong(request.getParameter("id"));
            Entreprise entreprise = entityManager.find(Entreprise.class, id);
            if (entreprise != null) {
                entityManager.remove(entreprise);
            }
        }
        response.sendRedirect(request.getContextPath() + "/entreprises");
    }
}