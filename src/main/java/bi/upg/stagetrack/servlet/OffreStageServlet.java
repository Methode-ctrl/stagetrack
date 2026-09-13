package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.entity.*;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.enums.TypePiece;
import bi.upg.stagetrack.util.WebUtil;
import jakarta.ejb.EJB;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/offres")
public class OffreStageServlet extends HttpServlet {

    @EJB
    private OffreStageBean offreBean;

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

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
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    req.getRequestDispatcher("/WEB-INF/views/offre-etape1.jsp").forward(req, resp);
                    break;

                case "etape2":
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    req.getRequestDispatcher("/WEB-INF/views/offre-etape2.jsp").forward(req, resp);
                    break;

                case "etape3":
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    req.getRequestDispatcher("/WEB-INF/views/offre-etape3.jsp").forward(req, resp);
                    break;

                case "detail": {
                    if (!verifierRole(req, resp, Role.ADMIN, Role.SUPERVISEUR)) return;
                    Long id = Long.valueOf(req.getParameter("id"));
                    OffreStage offre = offreBean.listerToutes().stream()
                            .filter(o -> o.getId().equals(id))
                            .findFirst().orElse(null);
                    req.setAttribute("offre", offre);
                    req.getRequestDispatcher("/WEB-INF/views/detail-offre.jsp").forward(req, resp);
                    break;
                }

                case "affecter":
                    if (!verifierRole(req, resp, Role.ADMIN)) return;
                    req.setAttribute("superviseurs", offreBean.getSuperviseursDisponibles());
                    req.setAttribute("offresSansSuperviseur", offreBean.listerSansSuperviseur());
                    req.getRequestDispatcher("/WEB-INF/views/affecter-superviseur.jsp").forward(req, resp);
                    break;

                case "mon-stage": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
                    Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                    req.setAttribute("pageTitle", "Mes stages");
                    req.setAttribute("offres", etudiant != null
                            ? offreBean.listerParEtudiant(etudiant.getId())
                            : List.of());
                    req.getRequestDispatcher("/WEB-INF/views/liste-offres.jsp").forward(req, resp);
                    break;
                }

                case "convention": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
                    Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                    Convention convention = null;
                    if (etudiant != null) {
                        List<OffreStage> mes = offreBean.listerParEtudiant(etudiant.getId());
                        if (!mes.isEmpty()) {
                            TypedQuery<Convention> q = em.createQuery(
                                "SELECT c FROM Convention c WHERE c.offreStage.id = :oid", Convention.class);
                            q.setParameter("oid", mes.get(0).getId());
                            convention = q.getResultList().stream().findFirst().orElse(null);
                        }
                    }
                    req.setAttribute("convention", convention);
                    req.getRequestDispatcher("/WEB-INF/views/convention.jsp").forward(req, resp);
                    break;
                }

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
                case "soumettre": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
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

                case "soumettre-etape1": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    String adresse = req.getParameter("adresse");
                    String ville = req.getParameter("ville");
                    Entreprise entreprise = offreBean.creerOuTrouverEntreprise(
                            req.getParameter("nomEntreprise"),
                            (adresse != null && !adresse.isBlank() ? adresse + ", " : "") + ville,
                            req.getParameter("telephone"),
                            req.getParameter("emailContact"),
                            req.getParameter("secteur"),
                            req.getParameter("nomResponsable"));
                    session.setAttribute("entrepriseSoumise", entreprise.getId());
                    resp.sendRedirect(req.getContextPath() + "/offres?action=etape2");
                    break;
                }

                case "soumettre-etape2": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    session.setAttribute("titreSoumis", req.getParameter("intitulePoste"));
                    String description = req.getParameter("description");
                    if (req.getParameter("tachesPrevues") != null && !req.getParameter("tachesPrevues").isBlank()) {
                        description = (description == null ? "" : description)
                                + "\n\nTâches prévues :\n" + req.getParameter("tachesPrevues");
                    }
                    session.setAttribute("descriptionSoumise", description);
                    session.setAttribute("dateDebutSoumise", req.getParameter("dateDebut"));
                    session.setAttribute("dureeSoumise", req.getParameter("dureeEnMois"));
                    resp.sendRedirect(req.getContextPath() + "/offres?action=etape3");
                    break;
                }

                case "soumettre-etape3": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
                    Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                    if (etudiant == null) {
                        throw new IllegalStateException("Profil étudiant introuvable.");
                    }

                    Long entrepriseId = (Long) session.getAttribute("entrepriseSoumise");
                    Entreprise entreprise = em.find(Entreprise.class, entrepriseId);
                    if (entreprise == null) {
                        throw new IllegalStateException("Entreprise introuvable, recommencez la soumission.");
                    }

                    OffreStage offre = new OffreStage();
                    offre.setTitre((String) session.getAttribute("titreSoumis"));
                    offre.setDescription((String) session.getAttribute("descriptionSoumise"));
                    String dateDebut = (String) session.getAttribute("dateDebutSoumise");
                    if (dateDebut != null && !dateDebut.isBlank()) {
                        offre.setDateDebut(LocalDate.parse(dateDebut));
                    }
                    offre.setDureeEnMois(Integer.valueOf((String) session.getAttribute("dureeSoumise")));
                    offre.setEtudiant(etudiant);
                    offre.setEntreprise(entreprise);

                    offreBean.soumettreOffre(offre);

                    String nomLettre = req.getParameter("nomFichierLettre");
                    String nomCv = req.getParameter("nomFichierCV");
                    if (nomLettre != null && !nomLettre.isBlank()) {
                        PieceJointe lettre = new PieceJointe(nomLettre, TypePiece.LETTRE_ACCEPTATION, offre);
                        lettre.setDateAjout(LocalDateTime.now());
                        em.persist(lettre);
                    }
                    if (nomCv != null && !nomCv.isBlank()) {
                        PieceJointe cv = new PieceJointe(nomCv, TypePiece.CV, offre);
                        cv.setDateAjout(LocalDateTime.now());
                        em.persist(cv);
                    }

                    session.removeAttribute("entrepriseSoumise");
                    session.removeAttribute("titreSoumis");
                    session.removeAttribute("descriptionSoumise");
                    session.removeAttribute("dateDebutSoumise");
                    session.removeAttribute("dureeSoumise");
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;
                }

                case "ouvrir":
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    offreBean.ouvrirDossier(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "valider":
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    offreBean.validerOffre(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "corriger":
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    offreBean.demanderCorrection(
                            Long.valueOf(req.getParameter("id")),
                            req.getParameter("motif"));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "demarrer":
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    offreBean.demarrerStage(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "pause":
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    offreBean.mettreEnPause(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "reprendre":
                    if (!verifierRole(req, resp, Role.SUPERVISEUR)) return;
                    offreBean.reprendreStage(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "archiver":
                    if (!verifierRole(req, resp, Role.ADMIN)) return;
                    offreBean.archiverDossier(Long.valueOf(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;

                case "affecterSuperviseur":
                    if (!verifierRole(req, resp, Role.ADMIN)) return;
                    offreBean.affecterSuperviseur(
                            Long.valueOf(req.getParameter("offreId")),
                            Long.valueOf(req.getParameter("superviseurId")));
                    resp.sendRedirect(req.getContextPath() + "/offres?action=affecter");
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/offres");
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

    private Entreprise emFind(Long id) {
        return offreBean.trouverEntreprise(id);
    }
}