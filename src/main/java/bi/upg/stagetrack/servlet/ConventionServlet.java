package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.entity.Convention;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/conventions")
public class ConventionServlet extends HttpServlet {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            if ("detail".equals(action)) {
                Long id = Long.valueOf(req.getParameter("id"));
                Convention convention = em.find(Convention.class, id);
                req.setAttribute("convention", convention);
                req.getRequestDispatcher("/WEB-INF/views/convention.jsp").forward(req, resp);
            } else {
                List<Convention> conventions = em.createQuery(
                        "SELECT c FROM Convention c ORDER BY c.dateGeneration DESC", Convention.class)
                        .getResultList();
                req.setAttribute("conventions", conventions);
                req.getRequestDispatcher("/WEB-INF/views/liste-conventions.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}