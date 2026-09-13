package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.entity.Utilisateur;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class AuthServlet extends HttpServlet {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String email = req.getParameter("email");
            String motDePasse = req.getParameter("motDePasse");

            TypedQuery<Utilisateur> q = em.createQuery(
                "SELECT u FROM Utilisateur u WHERE u.email = :email", Utilisateur.class);
            q.setParameter("email", email);
            List<Utilisateur> resultats = q.getResultList();

            if (resultats.isEmpty() || !resultats.get(0).getMotDePasse().equals(motDePasse)) {
                req.setAttribute("erreur", "Email ou mot de passe incorrect.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            Utilisateur utilisateur = resultats.get(0);
            HttpSession session = req.getSession(true);
            session.setAttribute("utilisateur", utilisateur);
            session.setAttribute("role", utilisateur.getRole().name());

            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (Exception e) {
            req.setAttribute("erreur", bi.upg.stagetrack.util.WebUtil.messageReel(e));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}