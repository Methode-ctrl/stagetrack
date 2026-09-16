package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.entity.*;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.enums.StatutOffre;
import bi.upg.stagetrack.enums.TypePiece;
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

@WebServlet("/offres")
public class OffreStageServlet extends HttpServlet {

    private static final int TAILLE_PAGE = 8;

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
            Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");

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
                    OffreStage offre = offreBean.trouverOffre(id);
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
                    Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                    Convention convention = null;
                    if (etudiant != null) {
                        List<OffreStage> mes = offreBean.listerParEtudiant(etudiant.getId());
                        if (!mes.isEmpty()) {
                            convention = offreBean.trouverConventionParOffre(mes.get(0).getId());
                        }
                    }
                    req.setAttribute("convention", convention);
                    req.getRequestDispatcher("/WEB-INF/views/convention.jsp").forward(req, resp);
                    break;
                }

                default:
                    List<OffreStage> offres;
                    List<OffreStage> toutesOffres;
                    if (Role.ETUDIANT.equals(utilisateur.getRole())) {
                        Etudiant etudiant = offreBean.findEtudiantByUtilisateurId(utilisateur.getId());
                        toutesOffres = etudiant != null ? offreBean.listerParEtudiant(etudiant.getId()) : List.of();
                    } else {
                        toutesOffres = offreBean.listerToutes();
                    }

                    String statutFiltre = req.getParameter("statut");
                    if (statutFiltre != null && !statutFiltre.isBlank()) {
                        try {
                            StatutOffre st = StatutOffre.valueOf(statutFiltre);
                            offres = toutesOffres.stream()
                                    .filter(o -> o.getStatut() == st)
                                    .toList();
                        } catch (IllegalArgumentException e) {
                            offres = toutesOffres;
                        }
                    } else {
                        offres = toutesOffres;
                    }

                    int page = 1;
                    try {
                        page = Math.max(1, Integer.parseInt(req.getParameter("page")));
                    } catch (NumberFormatException ignored) {
                    }
                    int total = offres.size();
                    int totalPages = Math.max(1, (int) Math.ceil((double) total / TAILLE_PAGE));
                    page = Math.min(page, totalPages);
                    int debut = (page - 1) * TAILLE_PAGE;
                    List<OffreStage> pageOffres = total > debut
                            ? offres.subList(debut, Math.min(debut + TAILLE_PAGE, total))
                            : List.of();

                    req.setAttribute("offres", pageOffres);
                    req.setAttribute("page", page);
                    req.setAttribute("totalPages", totalPages);
                    req.setAttribute("total", total);
                    req.setAttribute("taillePage", TAILLE_PAGE);
                    req.setAttribute("statutSelectionne", statutFiltre);
                    req.getRequestDispatcher("/WEB-INF/views/liste-offres.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("erreurs", List.of(WebUtil.messageReel(e)));
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

                    List<String> erreurs = validerOffre(req);
                    if (!erreurs.isEmpty()) {
                        req.setAttribute("erreurs", erreurs);
                        req.getRequestDispatcher("/WEB-INF/views/offre-etape1.jsp").forward(req, resp);
                        return;
                    }

                    Long entrepriseId = Long.valueOf(req.getParameter("entrepriseId"));
                    Entreprise entreprise = offreBean.trouverEntreprise(entrepriseId);

                    OffreStage offre = new OffreStage();
                    offre.setTitre(req.getParameter("titre"));
                    offre.setDescription(req.getParameter("description"));
                    offre.setDateDebut(java.time.LocalDate.parse(req.getParameter("dateDebut")));
                    offre.setDateFin(java.time.LocalDate.parse(req.getParameter("dateFin")));
                    offre.setDureeEnMois(Integer.valueOf(req.getParameter("dureeEnMois")));
                    offre.setEtudiant(etudiant);
                    offre.setEntreprise(entreprise);

                    offreBean.soumettreOffre(offre);
                    resp.sendRedirect(req.getContextPath() + "/offres");
                    break;
                }

                case "soumettre-etape1": {
                    if (!verifierRole(req, resp, Role.ETUDIANT)) return;
                    List<String> erreurs = new ArrayList<>();
                    if (isBlank(req.getParameter("nomEntreprise"))) {
                        erreurs.add("Le nom de l'entreprise est obligatoire.");
                    }
                    if (!erreurs.isEmpty()) {
                        req.setAttribute("erreurs", erreurs);
                        req.getRequestDispatcher("/WEB-INF/views/offre-etape1.jsp").forward(req, resp);
                        return;
                    }
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
                    List<String> erreurs = new ArrayList<>();
                    if (isBlank(req.getParameter("intitulePoste"))) {
                        erreurs.add("L'intitulé du poste est obligatoire.");
                    }
                    if (isBlank(req.getParameter("dateDebut"))) {
                        erreurs.add("La date de début est obligatoire.");
                    }
                    if (isBlank(req.getParameter("dureeEnMois"))) {
                        erreurs.add("La durée du stage est obligatoire.");
                    }
                    if (!erreurs.isEmpty()) {
                        req.setAttribute("erreurs", erreurs);
                        req.getRequestDispatcher("/WEB-INF/views/offre-etape2.jsp").forward(req, resp);
                        return;
                    }
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
                    Entreprise entreprise = offreBean.trouverEntreprise(entrepriseId);
                    if (entreprise == null) {
                        throw new IllegalStateException("Entreprise introuvable, recommencez la soumission.");
                    }

                    OffreStage offre = new OffreStage();
                    offre.setTitre((String) session.getAttribute("titreSoumis"));
                    offre.setDescription((String) session.getAttribute("descriptionSoumise"));
                    String dateDebut = (String) session.getAttribute("dateDebutSoumise");
                    if (dateDebut != null && !dateDebut.isBlank()) {
                        offre.setDateDebut(java.time.LocalDate.parse(dateDebut));
                    }
                    offre.setDureeEnMois(Integer.valueOf((String) session.getAttribute("dureeSoumise")));
                    offre.setEtudiant(etudiant);
                    offre.setEntreprise(entreprise);

                    offreBean.soumettreOffre(offre);

                    String nomLettre = req.getParameter("nomFichierLettre");
                    String nomCv = req.getParameter("nomFichierCV");
                    if (nomLettre != null && !nomLettre.isBlank()) {
                        offreBean.ajouterPieceJointe(offre,
                                new PieceJointe(nomLettre, TypePiece.LETTRE_ACCEPTATION, offre));
                    }
                    if (nomCv != null && !nomCv.isBlank()) {
                        offreBean.ajouterPieceJointe(offre,
                                new PieceJointe(nomCv, TypePiece.CV, offre));
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
            req.setAttribute("erreurs", List.of(WebUtil.messageReel(e)));
            req.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(req, resp);
        }
    }

    private List<String> validerOffre(HttpServletRequest req) {
        List<String> erreurs = new ArrayList<>();
        if (isBlank(req.getParameter("titre"))) erreurs.add("Le titre de l'offre est obligatoire.");
        if (isBlank(req.getParameter("dateDebut"))) erreurs.add("La date de début est obligatoire.");
        if (isBlank(req.getParameter("dateFin"))) erreurs.add("La date de fin est obligatoire.");
        if (isBlank(req.getParameter("dureeEnMois"))) erreurs.add("La durée du stage est obligatoire.");
        return erreurs;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private boolean verifierRole(HttpServletRequest req, HttpServletResponse resp, Role... roles)
            throws IOException {
        if (WebUtil.aLeRole(req, roles)) {
            return true;
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard");
        return false;
    }
}