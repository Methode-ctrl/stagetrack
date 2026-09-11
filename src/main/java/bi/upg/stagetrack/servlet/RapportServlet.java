package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.RapportStageBean;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
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

@WebServlet("/rapports")
public class RapportServlet extends HttpServlet {

    @EJB
    private RapportStageBean rapportBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String action = req.getParameter("action") != null ? req.getParameter("action") : "liste";

            switch (action) {
                case "nouveau":
                case "resoumettre": {
                    Long offreId = Long.valueOf(req.getParameter("offreId"));
                    req.setAttribute("offreId", offreId);
                    req.getRequestDispatcher("/WEB-INF/views/rapport-etape1.jsp").forward(req, resp);
                    break;
                }
                case "etape2": {
                    req.getRequestDispatcher("/WEB-INF/views/rapport-etape2.jsp").forward(req, resp);
                    break;
                }
                case "evaluer": {
                    Long rapportId = Long.valueOf(req.getParameter("id"));
                    RapportStage rapport = trouverRapport(rapportId);
                    req.setAttribute("rapport", rapport);
                    req.getRequestDispatcher("/WEB-INF/views/evaluer-rapport.jsp").forward(req, resp);
                    break;
                }
                default: {
                    Long offreId = req.getParameter("offreId") != null
                            ? Long.valueOf(req.getParameter("offreId"))
                            : null;
                    List<RapportStage> rapports;
                    if (offreId != null) {
                        rapports = rapportBean.findByOffreId(offreId);
                    } else {
                        rapports = new ArrayList<>(rapportBean.listerTous());
                    }
                    req.setAttribute("rapports", rapports);
                    req.getRequestDispatcher("/WEB-INF/views/liste-rapports.jsp").forward(req, resp);
                }
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
                    Long offreId = Long.valueOf(req.getParameter("offreId"));
                    RapportStage rapport = new RapportStage();
                    rapport.setTitre(req.getParameter("titre"));
                    rapport.setCheminFichier(req.getParameter("cheminFichier"));
                    rapportBean.soumettreRapport(rapport, offreId);
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;
                }
                case "resoumettre": {
                    Long offreId = Long.valueOf(req.getParameter("offreId"));
                    RapportStage nouveau = new RapportStage();
                    nouveau.setTitre(req.getParameter("titre"));
                    nouveau.setCheminFichier(req.getParameter("cheminFichier"));
                    rapportBean.resoumettreRapport(offreId, nouveau);
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;
                }
                case "valider":
                    rapportBean.validerRapport(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/rapports");
                    break;
                case "corriger":
                    rapportBean.demanderCorrection(
                            Long.valueOf(req.getParameter("id")),
                            req.getParameter("commentaire"));
                    resp.sendRedirect(req.getContextPath() + "/rapports");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/rapports");
            }
        } catch (Exception e) {
            req.setAttribute("erreur", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }

    private RapportStage trouverRapport(Long id) {
        return rapportBean.trouverRapport(id);
    }
}