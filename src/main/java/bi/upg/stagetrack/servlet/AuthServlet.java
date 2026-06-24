package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.entity.Utilisateur;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        // Déconnexion
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Si déjà connecté → rediriger vers dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("role") != null) {
            String role = (String) session.getAttribute("role");
            response.sendRedirect(request.getContextPath()
                + "/dashboard/" + role.toLowerCase());
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");

        // Validation de base
        if (email == null || motDePasse == null
                || email.trim().isEmpty() || motDePasse.trim().isEmpty()) {
            request.setAttribute("erreur", "Email et mot de passe requis");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Recherche de l'utilisateur en base
        List<Utilisateur> results = em.createQuery(
            "SELECT u FROM Utilisateur u WHERE u.email = :email AND u.actif = true",
            Utilisateur.class)
            .setParameter("email", email.trim())
            .getResultList();

        if (!results.isEmpty()) {
            Utilisateur u = results.get(0);
            if (u.getMotDePasse().equals(motDePasse)) {
                // Authentification réussie
                HttpSession session = request.getSession(true);
                session.setAttribute("utilisateur", u);
                session.setAttribute("role",   u.getRole().name());
                session.setAttribute("nom",    u.getNom());
                session.setAttribute("prenom", u.getPrenom());

                // Redirection selon le rôle
                switch (u.getRole()) {
                    case ADMIN       -> response.sendRedirect(
                        request.getContextPath() + "/dashboard/admin");
                    case SUPERVISEUR -> response.sendRedirect(
                        request.getContextPath() + "/dashboard/superviseur");
                    case ETUDIANT    -> response.sendRedirect(
                        request.getContextPath() + "/dashboard/etudiant");
                }
                return;
            }
        }

        // Échec de l'authentification
        request.setAttribute("erreur", "Email ou mot de passe incorrect");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
