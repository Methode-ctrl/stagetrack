package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.ejb.RapportStageBean;
import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.enums.StatutRapport;
import bi.upg.stagetrack.util.WebUtil;
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
import java.util.Set;
import java.util.stream.Collectors;

@WebServlet("/rapports")
public class RapportServlet extends HttpServlet {

    @EJB
    private RapportStageBean rapportBean;

    @EJB
    private OffreStageBean offreBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String action = req.getParameter("action") != null ? req.getParameter("action") : "liste";

            switch (action) {
                case "nouveau":
                case "resoumettre":
                case "soumettre": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    Long offreId = Long.valueOf(req.getParameter("offreId"));
                    req.setAttribute("offreId", offreId);
                    req.getRequestDispatcher("/WEB-INF/views/rapport-etape1.jsp").forward(req, resp);
                    break;
                }
                case "etape2": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    req.getRequestDispatcher("/WEB-INF/views/rapport-etape2.jsp").forward(req, resp);
                    break;
                }
                case "mon-rapport":
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    resp.sendRedirect(req.getContextPath() + "/rapports");
                    return;
                case "evaluer": {
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    Long rapportId = Long.valueOf(req.getParameter("id"));
                    RapportStage rapport = trouverRapport(rapportId);
                    req.setAttribute("rapport", rapport);
                    req.getRequestDispatcher("/WEB-INF/views/evaluer-rapport.jsp").forward(req, resp);
                    break;
                }
                default: {
                    HttpSession session = req.getSession(false);
                    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
                    if (Role.ETUDIANT.equals(utilisateur.getRole())) {
                        Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                        List<OffreStage> mesOffres = etudiant != null
                                ? offreBean.listerParEtudiant(etudiant.getId())
                                : List.of();
                        Set<Long> mesOffreIds = mesOffres.stream()
                                .map(OffreStage::getId)
                                .collect(Collectors.toSet());
                        List<RapportStage> rapports = new ArrayList<>(rapportBean.listerTous());
                        rapports.removeIf(r -> r.getOffreStage() == null
                                || !mesOffreIds.contains(r.getOffreStage().getId()));
                        req.setAttribute("rapports", rapports);
                    } else {
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
                    }
                    req.getRequestDispatcher("/WEB-INF/views/liste-rapports.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) {
            req.setAttribute("erreur", WebUtil.messageReel(e));
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
                case "soumettre-etape1": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    session.setAttribute("titreRapportSoumis", req.getParameter("titre"));
                    session.setAttribute("resumeRapportSoumis", req.getParameter("resume"));
                    session.setAttribute("competencesRapportSoumis", req.getParameter("competences"));
                    Long offreId = Long.valueOf(req.getParameter("offreId"));
                    session.setAttribute("offreRapportSoumis", offreId);
                    resp.sendRedirect(req.getContextPath() + "/rapports?action=etape2");
                    break;
                }

                case "soumettre-etape2": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    Long offreId = (Long) session.getAttribute("offreRapportSoumis");
                    RapportStage rapport = new RapportStage();
                    String titre = (String) session.getAttribute("titreRapportSoumis");
                    String resume = (String) session.getAttribute("resumeRapportSoumis");
                    String competences = (String) session.getAttribute("competencesRapportSoumis");
                    String cheminFichier = req.getParameter("nomFichierPdf");
                    String annexe = req.getParameter("nomFichierAnnexe");
                    StringBuilder description = new StringBuilder();
                    if (resume != null && !resume.isBlank()) description.append(resume);
                    if (competences != null && !competences.isBlank()) {
                        if (description.length() > 0) description.append("\n\n");
                        description.append("Compétences : ").append(competences);
                    }
                    if (annexe != null && !annexe.isBlank()) {
                        if (description.length() > 0) description.append("\n");
                        description.append("Annexe : ").append(annexe);
                    }
                    rapport.setTitre(titre);
                    rapport.setCheminFichier(cheminFichier);

                    boolean relecture = rapportBean.findByOffreId(offreId).stream()
                            .anyMatch(r -> r.getStatut() == StatutRapport.EN_CORRECTION);
                    if (relecture) {
                        rapportBean.resoumettreRapport(offreId, rapport);
                    } else {
                        rapportBean.soumettreRapport(rapport, offreId);
                    }

                    session.removeAttribute("titreRapportSoumis");
                    session.removeAttribute("resumeRapportSoumis");
                    session.removeAttribute("competencesRapportSoumis");
                    session.removeAttribute("offreRapportSoumis");
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;
                }

                case "soumettre": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    Long offreId = Long.valueOf(req.getParameter("offreId"));
                    RapportStage rapport = new RapportStage();
                    rapport.setTitre(req.getParameter("titre"));
                    rapport.setCheminFichier(req.getParameter("cheminFichier"));
                    rapportBean.soumettreRapport(rapport, offreId);
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;
                }
                case "resoumettre": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    Long offreId = Long.valueOf(req.getParameter("offreId"));
                    RapportStage nouveau = new RapportStage();
                    nouveau.setTitre(req.getParameter("titre"));
                    nouveau.setCheminFichier(req.getParameter("cheminFichier"));
                    rapportBean.resoumettreRapport(offreId, nouveau);
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;
                }
                case "valider":
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    rapportBean.validerRapport(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/rapports");
                    break;
                case "corriger":
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    rapportBean.demanderCorrection(
                            Long.valueOf(req.getParameter("id")),
                            req.getParameter("commentaire"));
                    resp.sendRedirect(req.getContextPath() + "/rapports");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/rapports");
            }
        } catch (Exception e) {
            req.setAttribute("erreur", WebUtil.messageReel(e));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }

    private boolean verifierRole(HttpServletRequest req, HttpServletResponse resp, Role... roles)
            throws IOException {
        if (WebUtil.aLeRole(req, roles)) {
            return true;
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard");
        return false;
    }

    private RapportStage trouverRapport(Long id) {
        return rapportBean.trouverRapport(id);
    }
}