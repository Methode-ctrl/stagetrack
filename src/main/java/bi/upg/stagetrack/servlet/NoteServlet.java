package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.NoteBean;
import bi.upg.stagetrack.ejb.RapportStageBean;
import bi.upg.stagetrack.entity.Note;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.util.WebUtil;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/notes")
public class NoteServlet extends HttpServlet {

    @EJB
    private NoteBean noteBean;

    @EJB
    private RapportStageBean rapportBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            if (!WebUtil.exigerRole(req, resp, Role.ADMIN, Role.SUPERVISEUR)) return;
            String action = req.getParameter("action") != null ? req.getParameter("action") : "liste";

            if ("noter".equals(action)) {
                Long rapportId = Long.valueOf(req.getParameter("rapportId"));
                RapportStage rapport = rapportBean.trouverRapport(rapportId);
                req.setAttribute("rapport", rapport);
                req.getRequestDispatcher("/WEB-INF/views/noter-rapport.jsp").forward(req, resp);
            } else {
                List<RapportStage> rapportsValides = new java.util.ArrayList<>(rapportBean.listerTous());
                rapportsValides.removeIf(r -> !"VALIDE".equals(r.getStatut().name()));
                req.setAttribute("rapports", rapportsValides);
                req.getRequestDispatcher("/WEB-INF/views/liste-notes.jsp").forward(req, resp);
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
            if (!WebUtil.exigerRole(req, resp, Role.ADMIN, Role.SUPERVISEUR)) return;
            long rapportId = Long.parseLong(req.getParameter("rapportId"));
            double noteStage = Double.parseDouble(req.getParameter("noteStage"));
            double noteRapport = Double.parseDouble(req.getParameter("noteRapport"));
            double notePresence = Double.parseDouble(req.getParameter("notePresence"));
            String appreciation = req.getParameter("appreciation");

            Note note = noteBean.attribuerNote(rapportId, noteStage, noteRapport, notePresence, appreciation);
            req.setAttribute("note", note);
            req.getRequestDispatcher("/WEB-INF/views/resultat-note.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("erreur", WebUtil.messageReel(e));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }
}