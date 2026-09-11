package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.entity.*;
import bi.upg.stagetrack.enums.Role;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/offres")
public class OffreStageServlet extends HttpServlet {

    @EJB
    private OffreStageBean offreBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            if (session == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String action = req.getParameter("action") != null ? req.getParameter("action") : "liste";

            switch (action) {
                case "nouvelle":
                    req.getRequestDispatcher("/WEB-INF/views/offre-etape1.jsp").forward(req, resp);
                    break;

                case "etape2":
                    req.getRequestDispatcher("/WEB-INF/views/offre-etape2.jsp").forward(req, resp);
                    break;

                case "etape3":
                    req.getRequestDispatcher("/WEB-INF/views/offre-etape3.jsp").forward(req, resp);
                    break;

                case "detail": {
                    Long id = Long.valueOf(req.getParameter("id"));
                    OffreStage offre = offreBean.listerToutes().stream()
                            .filter(o -> o.getId().equals(id))
                            .findFirst().orElse(null);
                    req.setAttribute("offre", offre);
                    req.getRequestDispatcher("/WEB-INF/views/detail-offre.jsp").forward(req, resp);
                    break;
                }

                case "affecter":
                    req.setAttribute("superviseurs", offreBean.getSuperviseursDisponibles());
                    req.setAttribute("offresSansSuperviseur", offreBean.listerSansSuperviseur());
                    req.getRequestDispatcher("/WEB-INF/views/affecter-superviseur.jsp").forward(req, resp);
                    break;

                default:
                    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
                    List<OffreStage> offres;
                    if (Role.ETUDIANT.equals(utilisateur.getRole())) {
                        Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                        offres = etudiant != null ? offreBean.listerParEtudiant(etudiant.getId()) : List.of();
                    } else {
                        offres = offreBean.listerToutes();
                    }
                    req.setAttribute("offres", offres);
                    req.getRequestDispatcher("/WEB-INF/views/liste-offres.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("utilisateur") == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String action = req.getParameter("action");

            switch (action) {
                case "soumettre": {
                    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
                    Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                    if (etudiant == null) {
                        throw new IllegalStateException("Profil étudiant introuvable.");
                    }

                    Long entrepriseId = Long.valueOf(req.getParameter("entrepriseId"));
                    Entreprise entreprise = emFind(entrepriseId);

                    OffreStage offre = new OffreStage();
                    offre.setTitre(req.getParameter("titre"));
                    offre.setDescription(req.getParameter("description"));
                    offre.setDateDebut(LocalDate.parse(req.getParameter("dateDebut")));
                    offre.setDateFin(LocalDate.parse(req.getParameter("dateFin")));
                    offre.setDureeEnMois(Integer.valueOf(req.getParameter("dureeEnMois")));
                    offre.setEtudiant(etudiant);
                    offre.setEntreprise(entreprise);

                    offreBean.soumettreOffre(offre);
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;
                }

                case "ouvrir":
                    offreBean.ouvrirDossier(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "valider":
                    offreBean.validerOffre(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "corriger":
                    offreBean.demanderCorrection(
                            Long.valueOf(req.getParameter("id")),
                            req.getParameter("motif"));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "demarrer":
                    offreBean.demarrerStage(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "pause":
                    offreBean.mettreEnPause(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "reprendre":
                    offreBean.reprendreStage(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "archiver":
                    offreBean.archiverDossier(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "affecterSuperviseur":
                    offreBean.affecterSuperviseur(
                            Long.valueOf(req.getParameter("offreId")),
                            Long.valueOf(req.getParameter("superviseurId")));
                    resp.sendRedirect(req.getContextPath() + "/offres?action=affecter");
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/offres");
            }
        } catch (Exception e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }

    private Entreprise emFind(Long id) {
        return offreBean.trouverEntreprise(id);
    }
}