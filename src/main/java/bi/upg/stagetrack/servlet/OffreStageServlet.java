package bi.upg.stagetrack.servlet;

import bi.upg.stagetrack.ejb.OffreStageBean;
import bi.upg.stagetrack.entity.Entreprise;
import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.PieceJointe;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.TypePiece;
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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet gerant le formulaire de soumission d'offre et les actions de suivi.
 * Les transitions superviseur sont protegees par le role et la proprietaire
 * reelle de l'offre.
 */
@WebServlet("/offres")
public class OffreStageServlet extends HttpServlet {

    @Inject
    private OffreStageBean offreStageBean;

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (action) {
                case "new":
                case "etape1":
                    request.getRequestDispatcher("/WEB-INF/views/offre-etape1.jsp")
                            .forward(request, response);
                    break;

                case "etape2":
                    if (session.getAttribute("offre_nomEntreprise") == null) {
                        response.sendRedirect(request.getContextPath() + "/offres?action=new");
                        return;
                    }
                    request.getRequestDispatcher("/WEB-INF/views/offre-etape2.jsp")
                            .forward(request, response);
                    break;

                case "etape3":
                    if (session.getAttribute("offre_intitulePoste") == null) {
                        response.sendRedirect(request.getContextPath() + "/offres?action=etape2");
                        return;
                    }
                    request.getRequestDispatcher("/WEB-INF/views/offre-etape3.jsp")
                            .forward(request, response);
                    break;

                case "detail":
                    afficherDetailOffre(request, response, session, null);
                    break;

                default:
                    afficherListeOffres(request, response, session);
                    break;
            }
        } catch (SecurityException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            switch (action) {
                case "soumettre-etape1":
                    session.setAttribute("offre_nomEntreprise", request.getParameter("entreprise.nom"));
                    session.setAttribute("offre_secteur", request.getParameter("entreprise.secteur"));
                    session.setAttribute("offre_adresse", request.getParameter("entreprise.adresse"));
                    session.setAttribute("offre_ville", request.getParameter("entreprise.ville"));
                    session.setAttribute("offre_nomResponsable", request.getParameter("entreprise.nomResponsable"));
                    session.setAttribute("offre_emailContact", request.getParameter("entreprise.emailContact"));
                    session.setAttribute("offre_telephone", request.getParameter("entreprise.telephone"));
                    response.sendRedirect(request.getContextPath() + "/offres?action=etape2");
                    break;

                case "soumettre-etape2":
                    session.setAttribute("offre_intitulePoste", request.getParameter("intitulePoste"));
                    session.setAttribute("offre_description", request.getParameter("description"));
                    session.setAttribute("offre_tachesPrevues", request.getParameter("tachesPrevues"));
                    session.setAttribute("offre_dateDebut", request.getParameter("dateDebut"));
                    session.setAttribute("offre_dureeEnMois", request.getParameter("dureeEnMois"));
                    response.sendRedirect(request.getContextPath() + "/offres?action=etape3");
                    break;

                case "soumettre-etape3":
                    soumettreOffre(request, response, session);
                    break;

                case "ouvrir": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Superviseur superviseur = chargerSuperviseurSession(session, response);
                    if (superviseur == null) {
                        return;
                    }

                    offreStageBean.ouvrirDossier(offreId, superviseur.getId());
                    response.sendRedirect(request.getContextPath() + "/offres?action=detail&id=" + offreId);
                    break;
                }

                case "valider": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Superviseur superviseur = chargerSuperviseurSession(session, response);
                    if (superviseur == null) {
                        return;
                    }

                    offreStageBean.validerOffre(offreId, superviseur.getId());
                    response.sendRedirect(request.getContextPath()
                            + "/offres?action=detail&id=" + offreId + "&succes=valide");
                    break;
                }

                case "incomplet": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Superviseur superviseur = chargerSuperviseurSession(session, response);
                    if (superviseur == null) {
                        return;
                    }

                    String motif = request.getParameter("motif");
                    if (!texteValide(motif)) {
                        request.setAttribute("erreur",
                                "Le motif est obligatoire et doit contenir au moins 10 caracteres.");
                        afficherDetailOffre(request, response, session, offreId);
                        return;
                    }

                    offreStageBean.demanderCorrection(offreId, superviseur.getId(), motif);
                    response.sendRedirect(request.getContextPath()
                            + "/offres?action=detail&id=" + offreId + "&succes=incomplet");
                    break;
                }

                case "demarrer": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Superviseur superviseur = chargerSuperviseurSession(session, response);
                    if (superviseur == null) {
                        return;
                    }

                    offreStageBean.demarrerStage(offreId, superviseur.getId());
                    response.sendRedirect(request.getContextPath()
                            + "/conventions?action=generer&offreId=" + offreId);
                    break;
                }

                case "pause": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Superviseur superviseur = chargerSuperviseurSession(session, response);
                    if (superviseur == null) {
                        return;
                    }

                    String raison = request.getParameter("raison");
                    if (!texteValide(raison)) {
                        request.setAttribute("erreur",
                                "La raison est obligatoire et doit contenir au moins 10 caracteres.");
                        afficherDetailOffre(request, response, session, offreId);
                        return;
                    }

                    offreStageBean.mettreEnPause(offreId, superviseur.getId(), raison);
                    response.sendRedirect(request.getContextPath()
                            + "/offres?action=detail&id=" + offreId + "&succes=pause");
                    break;
                }

                case "reprendre": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Superviseur superviseur = chargerSuperviseurSession(session, response);
                    if (superviseur == null) {
                        return;
                    }

                    offreStageBean.reprendreStage(offreId, superviseur.getId());
                    response.sendRedirect(request.getContextPath()
                            + "/offres?action=detail&id=" + offreId + "&succes=reprendre");
                    break;
                }

                case "corriger-rapport": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Superviseur superviseur = chargerSuperviseurSession(session, response);
                    if (superviseur == null) {
                        return;
                    }

                    String commentaire = request.getParameter("commentaire");
                    if (!texteValide(commentaire)) {
                        request.setAttribute("erreur",
                                "Le commentaire est obligatoire et doit contenir au moins 10 caracteres.");
                        afficherDetailOffre(request, response, session, offreId);
                        return;
                    }

                    offreStageBean.demanderCorrectionRapport(offreId, superviseur.getId(), commentaire);
                    response.sendRedirect(request.getContextPath()
                            + "/offres?action=detail&id=" + offreId + "&succes=rapport-correction");
                    break;
                }

                case "valider-rapport": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Superviseur superviseur = chargerSuperviseurSession(session, response);
                    if (superviseur == null) {
                        return;
                    }

                    offreStageBean.validerRapport(offreId, superviseur.getId());
                    response.sendRedirect(request.getContextPath()
                            + "/notes?action=evaluer&offreId=" + offreId);
                    break;
                }

                case "affecter": {
                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    Long superviseurId = lireLongObligatoire(request.getParameter("superviseurId"), "superviseurId");
                    offreStageBean.affecterSuperviseur(offreId, superviseurId);
                    response.sendRedirect(request.getContextPath() + "/dashboard/admin");
                    break;
                }

                case "archiver": {
                    String role = (String) session.getAttribute("role");
                    if (!"ADMIN".equals(role)) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN);
                        return;
                    }

                    Long offreId = lireLongObligatoire(request.getParameter("offreId"), "offreId");
                    offreStageBean.archiver(offreId);
                    response.sendRedirect(request.getContextPath() + "/dashboard/admin?succes=archive");
                    break;
                }

                default:
                    response.sendRedirect(request.getContextPath() + "/offres");
                    break;
            }
        } catch (SecurityException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("messageErreur", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
        }
    }

    private void afficherListeOffres(HttpServletRequest request,
                                     HttpServletResponse response,
                                     HttpSession session)
            throws ServletException, IOException {

        String role = (String) session.getAttribute("role");
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        String filtreStatut    = request.getParameter("statut");
        String filtreRecherche = request.getParameter("recherche");
        if (filtreStatut    != null && filtreStatut.trim().isEmpty())    filtreStatut    = null;
        if (filtreRecherche != null && filtreRecherche.trim().isEmpty()) filtreRecherche = null;

        List<OffreStage> offres;

        if ("ADMIN".equals(role)) {
            offres = offreStageBean.listerToutes();
        } else if ("SUPERVISEUR".equals(role)) {
            Superviseur superviseur = offreStageBean.findSuperviseurByUtilisateurId(utilisateur.getId());
            offres = superviseur == null
                    ? new ArrayList<>()
                    : offreStageBean.listerParSuperviseur(superviseur.getId());
        } else if ("ETUDIANT".equals(role)) {
            List<Etudiant> etudiants = em.createQuery(
                    "SELECT e FROM Etudiant e WHERE e.utilisateur.id = :uid",
                    Etudiant.class)
                    .setParameter("uid", utilisateur.getId())
                    .getResultList();

            if (etudiants.isEmpty()) {
                offres = new ArrayList<>();
            } else {
                offres = offreStageBean.listerParEtudiant(etudiants.get(0));
            }
        } else {
            offres = new ArrayList<>();
        }

        /* ---- Filtrage local par statut et recherche ---- */
        if (filtreStatut != null) {
            final String fs = filtreStatut;
            offres = offres.stream()
                    .filter(o -> o.getStatut() != null && o.getStatut().name().equals(fs))
                    .collect(java.util.stream.Collectors.toList());
        }

        if (filtreRecherche != null) {
            final String fr = filtreRecherche.toLowerCase().trim();
            offres = offres.stream().filter(o -> {
                if (o.getEtudiant() != null && o.getEtudiant().getUtilisateur() != null) {
                    String nom    = o.getEtudiant().getUtilisateur().getNom();
                    String prenom = o.getEtudiant().getUtilisateur().getPrenom();
                    String email  = o.getEtudiant().getUtilisateur().getEmail();
                    if ((nom    != null && nom.toLowerCase().contains(fr))
                     || (prenom != null && prenom.toLowerCase().contains(fr))
                     || (email  != null && email.toLowerCase().contains(fr))) {
                        return true;
                    }
                }
                if (o.getEntreprise() != null) {
                    String entNom = o.getEntreprise().getNom();
                    if (entNom != null && entNom.toLowerCase().contains(fr)) return true;
                }
                if (o.getIntitulePoste() != null && o.getIntitulePoste().toLowerCase().contains(fr)) {
                    return true;
                }
                return false;
            }).collect(java.util.stream.Collectors.toList());
        }

        request.setAttribute("offres", offres);
        request.getRequestDispatcher("/WEB-INF/views/liste-offres.jsp")
                .forward(request, response);
    }

    private void afficherDetailOffre(HttpServletRequest request,
                                     HttpServletResponse response,
                                     HttpSession session,
                                     Long offreIdForcee)
            throws ServletException, IOException {

        Long offreId = offreIdForcee;
        if (offreId == null) {
            offreId = lireLongObligatoire(request.getParameter("id"), "id");
        }

        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null) {
            request.setAttribute("messageErreur", "Offre de stage introuvable.");
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp").forward(request, response);
            return;
        }

        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        String role = (String) session.getAttribute("role");

        if ("SUPERVISEUR".equals(role)) {
            Superviseur superviseur = offreStageBean.findSuperviseurByUtilisateurId(utilisateur.getId());
            if (superviseur == null
                    || offre.getSuperviseur() == null
                    || !superviseur.getId().equals(offre.getSuperviseur().getId())) {
                throw new SecurityException("Acces non autorise a cette offre");
            }
        } else if ("ETUDIANT".equals(role)) {
            if (offre.getEtudiant() == null
                    || offre.getEtudiant().getUtilisateur() == null
                    || !utilisateur.getId().equals(offre.getEtudiant().getUtilisateur().getId())) {
                throw new SecurityException("Acces non autorise a cette offre");
            }
        }

        request.setAttribute("offre", offre);

        if ("ADMIN".equals(role)) {
            List<Superviseur> superviseurs = em.createQuery(
                    "SELECT s FROM Superviseur s JOIN s.utilisateur u WHERE u.actif = true ORDER BY u.nom",
                    Superviseur.class)
                    .getResultList();
            request.setAttribute("superviseurs", superviseurs);
        }

        if (request.getAttribute("succes") == null) {
            request.setAttribute("succes", traduireSucces(request.getParameter("succes")));
        }
        if (request.getAttribute("erreur") == null) {
            request.setAttribute("erreur", request.getParameter("erreur"));
        }

        request.getRequestDispatcher("/WEB-INF/views/detail-offre.jsp")
                .forward(request, response);
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

    private Long lireLongObligatoire(String valeur, String nomChamp) {
        if (valeur == null || valeur.trim().isEmpty()) {
            throw new IllegalArgumentException("Le parametre " + nomChamp + " est obligatoire");
        }
        return Long.parseLong(valeur.trim());
    }

    private boolean texteValide(String texte) {
        return texte != null && texte.trim().length() >= 10;
    }

    private String traduireSucces(String codeSucces) {
        if (codeSucces == null || codeSucces.isEmpty()) {
            return null;
        }

        switch (codeSucces) {
            case "valide":
                return "Le dossier a ete valide avec succes.";
            case "incomplet":
                return "La demande de correction a ete envoyee a l'etudiant.";
            case "pause":
                return "Le stage a ete mis en pause.";
            case "reprendre":
                return "Le stage a repris avec succes.";
            case "rapport-correction":
                return "Le rapport a ete retourne en correction.";
            default:
                return codeSucces;
        }
    }

    private void soumettreOffre(HttpServletRequest request,
                                HttpServletResponse response,
                                HttpSession session)
            throws ServletException, IOException {

        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateur == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String nomFichierLettre = request.getParameter("nomFichierLettre");
        String nomFichierCV = request.getParameter("nomFichierCV");
        List<String> erreurs = new ArrayList<>();

        if (nomFichierLettre == null || nomFichierLettre.trim().isEmpty()) {
            erreurs.add("Le fichier de lettre d'acceptation est obligatoire");
        }
        if (nomFichierCV == null || nomFichierCV.trim().isEmpty()) {
            erreurs.add("Le CV est obligatoire");
        }

        if (!erreurs.isEmpty()) {
            request.setAttribute("erreurs", erreurs);
            request.getRequestDispatcher("/WEB-INF/views/offre-etape3.jsp")
                    .forward(request, response);
            return;
        }

        Etudiant etudiant = offreStageBean.findEtudiantByUtilisateurId(utilisateur.getId());
        if (etudiant == null) {
            request.setAttribute("messageErreur",
                    "Profil etudiant introuvable. Contactez l'administration.");
            request.getRequestDispatcher("/WEB-INF/views/erreur.jsp")
                    .forward(request, response);
            return;
        }

        Entreprise entreprise = offreStageBean.creerOuTrouverEntreprise(
                (String) session.getAttribute("offre_nomEntreprise"),
                (String) session.getAttribute("offre_secteur"),
                (String) session.getAttribute("offre_ville"),
                (String) session.getAttribute("offre_adresse"),
                (String) session.getAttribute("offre_nomResponsable"),
                (String) session.getAttribute("offre_emailContact"),
                (String) session.getAttribute("offre_telephone"));

        OffreStage offre = new OffreStage();
        offre.setEtudiant(etudiant);
        offre.setEntreprise(entreprise);
        offre.setIntitulePoste((String) session.getAttribute("offre_intitulePoste"));
        offre.setDescription((String) session.getAttribute("offre_description"));
        offre.setTachesPrevues((String) session.getAttribute("offre_tachesPrevues"));
        offre.setDateDebut(LocalDate.parse((String) session.getAttribute("offre_dateDebut")));
        offre.setDureeEnMois(Integer.parseInt((String) session.getAttribute("offre_dureeEnMois")));

        List<PieceJointe> pieces = new ArrayList<>();

        PieceJointe lettre = new PieceJointe();
        lettre.setNomFichier(nomFichierLettre.trim());
        lettre.setTypePiece(TypePiece.LETTRE_ACCEPTATION);
        lettre.setDateAjout(LocalDate.now());
        lettre.setOffreStage(offre);
        pieces.add(lettre);

        PieceJointe cv = new PieceJointe();
        cv.setNomFichier(nomFichierCV.trim());
        cv.setTypePiece(TypePiece.CV);
        cv.setDateAjout(LocalDate.now());
        cv.setOffreStage(offre);
        pieces.add(cv);

        offre.setPiecesJointes(pieces);
        offreStageBean.soumettreOffre(offre);

        nettoyerSession(session);
        response.sendRedirect(request.getContextPath() + "/dashboard/etudiant?succes=offre_soumise");
    }

    private void nettoyerSession(HttpSession session) {
        String[] cles = {
            "offre_nomEntreprise", "offre_secteur", "offre_adresse",
            "offre_ville", "offre_nomResponsable", "offre_emailContact",
            "offre_telephone", "offre_intitulePoste", "offre_description",
            "offre_tachesPrevues", "offre_dateDebut", "offre_dureeEnMois"
        };

        for (String cle : cles) {
            session.removeAttribute(cle);
        }
    }
}
