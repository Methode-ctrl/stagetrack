package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.util.PasswordUtil;
import jakarta.annotation.Resource;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.UserTransaction;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/utilisateurs")
public class UtilisateurServlet extends HttpServlet {

    @Inject
    private OffreStageBean offreStageBean;

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager entityManager;

    @Resource
    private UserTransaction userTransaction;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("new".equals(action)) {
                request.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(request, response);
                return;
            }

            if ("edit".equals(action)) {
                Long id = Long.parseLong(request.getParameter("id"));
                Utilisateur utilisateur = entityManager.find(Utilisateur.class, id);
                request.setAttribute("utilisateur", utilisateur);
                request.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(request, response);
                return;
            }

            List<Utilisateur> utilisateurs = entityManager.createQuery(
                    "SELECT u FROM Utilisateur u ORDER BY u.nom, u.prenom",
                    Utilisateur.class)
                .getResultList();
            request.setAttribute("utilisateurs", utilisateurs);
            request.getRequestDispatcher("/WEB-INF/views/gestion-utilisateurs.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors du chargement: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            userTransaction.begin();

            String action = request.getParameter("action");
            if ("save".equals(action)) {
                enregistrerUtilisateur(request);
            } else if ("delete".equals(action)) {
                Long id = Long.parseLong(request.getParameter("id"));
                Utilisateur utilisateur = entityManager.find(Utilisateur.class, id);
                if (utilisateur != null) {
                    utilisateur.setActif(false);
                    entityManager.merge(utilisateur);
                }
            } else if ("toggle".equals(action)) {
                Long id = Long.parseLong(request.getParameter("id"));
                Utilisateur utilisateur = entityManager.find(Utilisateur.class, id);
                if (utilisateur != null) {
                    utilisateur.setActif(!utilisateur.isActif());
                    entityManager.merge(utilisateur);
                }
            }

            userTransaction.commit();
            response.sendRedirect(request.getContextPath() + "/utilisateurs");
        } catch (Exception e) {
            try {
                userTransaction.rollback();
            } catch (Exception rollbackException) {
                rollbackException.printStackTrace();
            }
            e.printStackTrace();
            request.setAttribute("erreur", "Erreur lors de l'operation: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    private void enregistrerUtilisateur(HttpServletRequest request) {
        String idStr = request.getParameter("id");
        Utilisateur utilisateur;
        boolean creation = idStr == null || idStr.isEmpty();

        if (creation) {
            utilisateur = new Utilisateur();
            utilisateur.setDateCreation(LocalDate.now());
            utilisateur.setActif(true);
        } else {
            Long id = Long.parseLong(idStr);
            utilisateur = entityManager.find(Utilisateur.class, id);
        }

        utilisateur.setNom(request.getParameter("nom"));
        utilisateur.setPrenom(request.getParameter("prenom"));
        utilisateur.setEmail(request.getParameter("email"));

        String motDePasse = request.getParameter("motDePasse");
        if (motDePasse != null && !motDePasse.isEmpty()) {
            utilisateur.setMotDePasse(PasswordUtil.hash(motDePasse));
        }

        String roleStr = request.getParameter("role");
        if (roleStr != null && !roleStr.isEmpty()) {
            utilisateur.setRole(Role.valueOf(roleStr));
        }

        if (creation) {
            entityManager.persist(utilisateur);
            entityManager.flush();
            creerProfilEtudiantSiNecessaire(utilisateur);
        } else {
            entityManager.merge(utilisateur);
        }
    }

    private void creerProfilEtudiantSiNecessaire(Utilisateur utilisateur) {
        if (utilisateur == null || utilisateur.getId() == null || utilisateur.getRole() != Role.ETUDIANT) {
            return;
        }

        Long total = entityManager.createQuery(
                "SELECT COUNT(e) FROM Etudiant e WHERE e.utilisateur.id = :utilisateurId",
                Long.class)
            .setParameter("utilisateurId", utilisateur.getId())
            .getSingleResult();

        if (total > 0) {
            return;
        }

        offreStageBean.findEtudiantByUtilisateurId(utilisateur.getId());
    }
}
