package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/utilisateurs")
public class UtilisateurServlet extends HttpServlet {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            List<Utilisateur> utilisateurs = em.createQuery(
                    "SELECT u FROM Utilisateur u ORDER BY u.role, u.nom", Utilisateur.class)
                    .getResultList();
            req.setAttribute("utilisateurs", utilisateurs);
            req.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(req, resp);
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
                    Utilisateur utilisateur = new Utilisateur(
                            req.getParameter("nom"),
                            req.getParameter("prenom"),
                            req.getParameter("email"),
                            req.getParameter("motDePasse"),
                            Role.valueOf(req.getParameter("role")));
                    utilisateur.setDateCreation(LocalDateTime.now());
                    em.persist(utilisateur);
                    em.flush();

                    String matricule = req.getParameter("matricule");
                    String filiere = req.getParameter("filiere");
                    String promotion = req.getParameter("promotion");
                    if (Role.ETUDIANT.equals(utilisateur.getRole())) {
                        Etudiant etudiant = new Etudiant(utilisateur, matricule, filiere, promotion);
                        em.persist(etudiant);
                    } else if (Role.SUPERVISEUR.equals(utilisateur.getRole())) {
                        Superviseur superviseur = new Superviseur(
                                utilisateur, req.getParameter("grade"), req.getParameter("specialite"));
                        em.persist(superviseur);
                    }
                    break;
                }
                case "supprimer": {
                    Long id = Long.valueOf(req.getParameter("id"));
                    Utilisateur utilisateur = em.find(Utilisateur.class, id);
                    if (utilisateur != null) em.remove(utilisateur);
                    break;
                }
                case "modifierMotDePasse": {
                    Long id = Long.valueOf(req.getParameter("id"));
                    Utilisateur utilisateur = em.find(Utilisateur.class, id);
                    if (utilisateur != null) {
                        utilisateur.setMotDePasse(req.getParameter("motDePasse"));
                        em.merge(utilisateur);
                    }
                    break;
                }
                default:
                    break;
            }
            resp.sendRedirect(req.getContextPath() + "/utilisateurs");
        } catch (Exception e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}