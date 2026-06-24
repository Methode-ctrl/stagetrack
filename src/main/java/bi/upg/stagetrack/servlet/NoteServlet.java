package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.NoteBean;
import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.entity.Note;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.StatutOffre;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/notes")
public class NoteServlet extends HttpServlet {

    @Inject
    private NoteBean noteBean;

    @Inject
    private OffreStageBean offreStageBean;

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            Superviseur superviseur = chargerSuperviseurSession(session, response);
            if (superviseur == null) {
                return;
            }

            Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
            OffreStage offre = em.find(OffreStage.class, offreId);
            verifierAccesOffre(offre, superviseur.getId());

            request.setAttribute("offre", offre);
            if (offre != null && offre.getRapport() != null) {
                request.setAttribute("rapport", offre.getRapport());
            }
            request.getRequestDispatcher("/WEB-INF/views/evaluer-rapport.jsp")
                    .forward(request, response);
        } catch (SecurityException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur",
                    "Erreur lors de l'ouverture de l'evaluation: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if (!"attribuer".equals(action)) {
                response.sendRedirect(request.getContextPath() + "/dashboard/superviseur");
                return;
            }

            Superviseur superviseur = chargerSuperviseurSession(session, response);
            if (superviseur == null) {
                return;
            }

            Long rapportId = lireLongObligatoire(request.getParameter("rapportId"), "rapportId");
            RapportStage rapport = em.find(RapportStage.class, rapportId);
            if (rapport == null || rapport.getOffreStage() == null) {
                throw new IllegalArgumentException("Rapport introuvable");
            }

            OffreStage offre = rapport.getOffreStage();
            verifierAccesOffre(offre, superviseur.getId());
            if (offre.getStatut() != StatutOffre.RAPPORT_VALIDE) {
                throw new IllegalStateException("La note ne peut etre attribuee qu'apres validation du rapport");
            }

            double noteStage = Double.parseDouble(request.getParameter("noteStage"));
            double noteRapport = Double.parseDouble(request.getParameter("noteRapport"));
            double notePresentation = Double.parseDouble(request.getParameter("notePresentation"));
            String appreciation = request.getParameter("appreciation");

            Note note = new Note();
            note.setNoteStage(noteStage);
            note.setNoteRapport(noteRapport);
            note.setNotePresentation(notePresentation);
            note.setAppreciation(appreciation);

            noteBean.attribuerNote(note, rapportId);
            response.sendRedirect(request.getContextPath()
                    + "/dashboard/superviseur?succes=note_attribuee");
        } catch (SecurityException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur",
                    "Erreur lors de l'attribution de la note: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    private Superviseur chargerSuperviseurSession(HttpSession session,
                                                  HttpServletResponse response)
            throws IOException {

        String role = (String) session.getAttribute("role");
        if (!"SUPERVISEUR".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }

        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        Superviseur superviseur = offreStageBean.findSuperviseurByUtilisateurId(utilisateur.getId());
        if (superviseur == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Profil superviseur introuvable pour cette session");
            return null;
        }

        return superviseur;
    }

    private void verifierAccesOffre(OffreStage offre, Long superviseurId) {
        if (offre == null) {
            throw new IllegalArgumentException("Offre de stage introuvable");
        }
        if (offre.getSuperviseur() == null || offre.getSuperviseur().getId() == null
                || !offre.getSuperviseur().getId().equals(superviseurId)) {
            throw new SecurityException("Acces non autorise a cette offre");
        }
    }

    private Long lireLongObligatoire(String valeur, String nomChamp) {
        if (valeur == null || valeur.trim().isEmpty()) {
            throw new IllegalArgumentException("Le parametre " + nomChamp + " est obligatoire");
        }
        return Long.parseLong(valeur.trim());
    }
}
