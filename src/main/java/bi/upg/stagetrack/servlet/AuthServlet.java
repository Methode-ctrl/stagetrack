package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.GestionBean;
import bi.upg.stagetrack.entity.Utilisateur;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/login")
public class AuthServlet extends HttpServlet {

    @EJB
    private GestionBean gestionBean;

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

            List<String> erreurs = new ArrayList<>();
            if (email == null || email.isBlank()) {
                erreurs.add("L'adresse e-mail est obligatoire.");
            }
            if (motDePasse == null || motDePasse.isBlank()) {
                erreurs.add("Le mot de passe est obligatoire.");
            }
            if (!erreurs.isEmpty()) {
                req.setAttribute("erreurs", erreurs);
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            Utilisateur utilisateur = gestionBean.trouverUtilisateurParEmail(email);

            if (utilisateur == null || !utilisateur.getMotDePasse().equals(motDePasse)) {
                req.setAttribute("erreurs", List.of("Email ou mot de passe incorrect."));
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("utilisateur", utilisateur);
            session.setAttribute("role", utilisateur.getRole().name());

            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (Exception e) {
            req.setAttribute("erreurs", List.of(bi.upg.stagetrack.util.WebUtil.messageReel(e)));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}