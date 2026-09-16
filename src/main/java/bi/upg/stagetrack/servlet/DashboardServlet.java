package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.NoteBean;
import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.ejb.RapportStageBean;
import bi.upg.stagetrack.ejb.StatistiqueBean;
import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.Note;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.enums.StatutOffre;
import bi.upg.stagetrack.util.WebUtil;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard/*")
public class DashboardServlet extends HttpServlet {

    @EJB
    private OffreStageBean offreBean;

    @EJB
    private StatistiqueBean statistiqueBean;

    @EJB
    private NoteBean noteBean;

    @EJB
    private RapportStageBean rapportBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("utilisateur") == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
            String path = req.getPathInfo();
            Role role = utilisateur.getRole();
            req.setAttribute("dateJour", new Date());

            if (path == null || "/".equals(path)) {
                switch (role) {
                    case ETUDIANT:
                        resp.sendRedirect(req.getContextPath() + "/dashboard/etudiant");
                        break;
                    case SUPERVISEUR:
                        resp.sendRedirect(req.getContextPath() + "/dashboard/superviseur");
                        break;
                    default:
                        resp.sendRedirect(req.getContextPath() + "/dashboard/admin");
                }
                return;
            }

            if ((path.startsWith("/etudiant") && role != Role.ETUDIANT)
                    || (path.startsWith("/superviseur") && role != Role.SUPERVISEUR)
                    || (path.startsWith("/admin") && role != Role.ADMIN)) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
                return;
            }

            switch (role) {
                case ETUDIANT:
                    Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                    List<OffreStage> mesOffres = etudiant != null
                            ? offreBean.listerParEtudiant(etudiant.getId())
                            : List.of();
                    OffreStage offreCourante = mesOffres.isEmpty() ? null : mesOffres.get(0);
                    Note noteCourante = noteBean.trouverNoteParOffre(
                            offreCourante != null ? offreCourante.getId() : null);

                    Map<Long, Note> notesParOffre = new HashMap<>();
                    Map<Long, String> motifParOffre = new HashMap<>();
                    for (OffreStage o : mesOffres) {
                        if (o.getStatut() == StatutOffre.NOTE_ATTRIBUEE || o.getStatut() == StatutOffre.ARCHIVE) {
                            Note n = noteBean.trouverNoteParOffre(o.getId());
                            if (n != null) {
                                notesParOffre.put(o.getId(), n);
                            }
                        }
                        if (o.getStatut() == StatutOffre.EN_CORRECTION) {
                            String m = rapportBean.trouverCommentaireCorrection(o.getId());
                            if (m != null) {
                                motifParOffre.put(o.getId(), m);
                            }
                        }
                    }

                    req.setAttribute("offres", mesOffres);
                    req.setAttribute("offre", offreCourante);
                    req.setAttribute("etudiant", etudiant);
                    req.setAttribute("note", noteCourante);
                    req.setAttribute("notesParOffre", notesParOffre);
                    req.setAttribute("motifParOffre", motifParOffre);
                    req.getRequestDispatcher("/WEB-INF/views/dashboard-etudiant.jsp").forward(req, resp);
                    break;

                case SUPERVISEUR:
                    Superviseur superviseur = offreBean.findSuperviseurByUtilisateurId(utilisateur.getId());
                    List<OffreStage> offresSuivi = superviseur != null
                            ? offreBean.listerParSuperviseur(superviseur)
                            : List.of();
                    long nbRapportsEnAttente = offresSuivi.stream()
                            .filter(o -> "RAPPORT_SOUMIS".equals(o.getStatut().name()))
                            .count();
                    long nbDossiersIncomplets = offresSuivi.stream()
                            .filter(o -> "DOSSIER_INCOMPLET".equals(o.getStatut().name())
                                    || "EN_CORRECTION".equals(o.getStatut().name()))
                            .count();
                    req.setAttribute("offres", offresSuivi);
                    req.setAttribute("superviseur", superviseur);
                    req.setAttribute("nbRapportsEnAttente", nbRapportsEnAttente);
                    req.setAttribute("nbDossiersIncomplets", nbDossiersIncomplets);
                    req.getRequestDispatcher("/WEB-INF/views/dashboard-superviseur.jsp").forward(req, resp);
                    break;

                default:
                    List<OffreStage> toutes = offreBean.listerToutes();
                    List<OffreStage> sansSuperviseur = statistiqueBean.getSansSuperviseur();
                    req.setAttribute("totalStagesActifs", statistiqueBean.getNombreStagesActifs());
                    req.setAttribute("offresSansSuperviseur", sansSuperviseur);
                    req.setAttribute("superviseurs", statistiqueBean.getAllSuperviseurs());
                    req.setAttribute("offres", toutes);
                    req.setAttribute("sansSuperviseur", sansSuperviseur);
                    req.setAttribute("nbTotal", Long.valueOf(toutes.size()));
                    req.setAttribute("nbEnCours", statistiqueBean.compterParStatut(bi.upg.stagetrack.enums.StatutOffre.STAGE_EN_COURS));
                    req.setAttribute("nbSoumises", statistiqueBean.compterParStatut(bi.upg.stagetrack.enums.StatutOffre.OFFRE_SOUMISE));
                    req.setAttribute("nbArchives", statistiqueBean.compterParStatut(bi.upg.stagetrack.enums.StatutOffre.ARCHIVE));
                    req.getRequestDispatcher("/WEB-INF/views/dashboard-admin.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erreur", WebUtil.messageReel(e));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}