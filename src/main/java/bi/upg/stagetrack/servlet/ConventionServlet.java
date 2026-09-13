package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.entity.Convention;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.util.WebUtil;
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
            if (!WebUtil.exigerRole(req, resp, Role.ADMIN)) return;
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
            req.setAttribute("erreur", WebUtil.messageReel(e));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}