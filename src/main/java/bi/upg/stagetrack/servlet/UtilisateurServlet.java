package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.GestionBean;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.util.WebUtil;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/utilisateurs")
public class UtilisateurServlet extends HttpServlet {

    @EJB
    private GestionBean gestionBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            if (!WebUtil.exigerRole(req, resp, Role.ADMIN)) return;
            String action = req.getParameter("action");
            if ("modifier".equals(action)) {
                Long id = Long.valueOf(req.getParameter("id"));
                Utilisateur user = gestionBean.listerUtilisateurs().stream()
                        .filter(u -> u.getId().equals(id))
                        .findFirst().orElse(null);
                req.setAttribute("utilisateurModif", user);
            }
            List<Utilisateur> utilisateurs = gestionBean.listerUtilisateurs();
            req.setAttribute("utilisateurs", utilisateurs);
            req.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(req, resp);
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
                    List<String> erreurs = validerUtilisateur(req, false);
                    if (!erreurs.isEmpty()) {
                        req.setAttribute("erreurs", erreurs);
                        req.setAttribute("utilisateurs", gestionBean.listerUtilisateurs());
                        req.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(req, resp);
                        return;
                    }
                    try {
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
                    } catch (IllegalArgumentException e) {
                        req.setAttribute("erreurs", List.of(e.getMessage()));
                        req.setAttribute("utilisateurs", gestionBean.listerUtilisateurs());
                        req.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(req, resp);
                        return;
                    }
                    break;
                }
                case "modifier": {
                    List<String> erreurs = validerUtilisateur(req, true);
                    if (!erreurs.isEmpty()) {
                        req.setAttribute("erreurs", erreurs);
                        req.setAttribute("utilisateurs", gestionBean.listerUtilisateurs());
                        req.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(req, resp);
                        return;
                    }
                    gestionBean.modifierUtilisateur(
                            Long.valueOf(req.getParameter("id")),
                            req.getParameter("nom"),
                            req.getParameter("prenom"),
                            req.getParameter("email"),
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
            req.setAttribute("erreurs", List.of(WebUtil.messageReel(e)));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }

    private List<String> validerUtilisateur(HttpServletRequest req, boolean ignorerMotDePasse) {
        List<String> erreurs = new ArrayList<>();
        if (isBlank(req.getParameter("nom"))) erreurs.add("Le nom est obligatoire.");
        if (isBlank(req.getParameter("prenom"))) erreurs.add("Le prénom est obligatoire.");
        if (isBlank(req.getParameter("email"))) erreurs.add("L'adresse e-mail est obligatoire.");
        if (!ignorerMotDePasse && isBlank(req.getParameter("motDePasse"))) {
            erreurs.add("Le mot de passe est obligatoire.");
        }
        if (req.getParameter("role") == null || List.of("ADMIN", "SUPERVISEUR", "ETUDIANT")
                .stream().noneMatch(r -> r.equals(req.getParameter("role")))) {
            erreurs.add("Le rôle est invalide.");
        }
        return erreurs;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}