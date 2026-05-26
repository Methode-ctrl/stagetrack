package bi.upg.stagetrack.ejb;

import bi.upg.stagetrack.entity.Convention;
import bi.upg.stagetrack.entity.Entreprise;
import bi.upg.stagetrack.entity.Etudiant;
import bi.upg.stagetrack.entity.OffreStage;
import bi.upg.stagetrack.entity.RapportStage;
import bi.upg.stagetrack.entity.Superviseur;
import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import bi.upg.stagetrack.enums.StatutOffre;
import bi.upg.stagetrack.enums.StatutRapport;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Session Bean gerant le cycle de vie des offres de stage.
 * Contient la logique metier de soumission, d'affectation et de suivi.
 */
@Stateless
public class OffreStageBean {

    @PersistenceContext(unitName = "stagetrack-pu")
    private EntityManager em;

    /**
     * Soumet une nouvelle offre de stage par un etudiant.
     * Les entites rattachees sont rechargees depuis la base pour rester managees.
     */
    @Transactional
    public void soumettreOffre(OffreStage offre) {
        if (offre == null) {
            throw new IllegalArgumentException("L'offre de stage est obligatoire");
        }

        if (offre.getEtudiant() != null && offre.getEtudiant().getId() != null) {
            Etudiant etudiantManage = em.find(Etudiant.class, offre.getEtudiant().getId());
            if (etudiantManage != null) {
                offre.setEtudiant(etudiantManage);
            }
        }

        if (offre.getEntreprise() != null && offre.getEntreprise().getId() != null) {
            Entreprise entrepriseManagee = em.find(Entreprise.class, offre.getEntreprise().getId());
            if (entrepriseManagee != null) {
                offre.setEntreprise(entrepriseManagee);
            }
        }

        if (offre.getSuperviseur() != null && offre.getSuperviseur().getId() != null) {
            Superviseur superviseurManage = em.find(Superviseur.class, offre.getSuperviseur().getId());
            if (superviseurManage != null) {
                offre.setSuperviseur(superviseurManage);
            }
        }

        offre.setStatut(StatutOffre.OFFRE_SOUMISE);
        offre.setDateSoumission(LocalDate.now());
        em.persist(offre);
    }

    /**
     * Superviseur ouvre un dossier.
     * Transition autorisee : OFFRE_SOUMISE -> EN_VALIDATION.
     */
    @Transactional
    public void ouvrirDossier(Long offreId, Long superviseurId) {
        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);
        verifierStatut(offre, StatutOffre.OFFRE_SOUMISE,
                "Seules les offres soumises peuvent etre ouvertes pour examen");
        offre.setStatut(StatutOffre.EN_VALIDATION);
    }

    /**
     * Superviseur demande des corrections sur le dossier.
     * Transition autorisee : EN_VALIDATION -> DOSSIER_INCOMPLET.
     */
    @Transactional
    public void demanderCorrection(Long offreId, Long superviseurId, String motif) {
        validerTexteObligatoire(motif,
                "Le motif est obligatoire et doit contenir au moins 10 caracteres");

        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);
        verifierStatut(offre, StatutOffre.EN_VALIDATION,
                "Seuls les dossiers en validation peuvent etre marques incomplets");
        offre.setCommentaireSuperviseur(motif.trim());
        offre.setStatut(StatutOffre.DOSSIER_INCOMPLET);
    }

    /**
     * Superviseur reouvre un dossier corrige par l'etudiant.
     * Transition autorisee : DOSSIER_INCOMPLET -> EN_VALIDATION.
     */
    @Transactional
    public void reouvrirDossier(Long offreId, Long superviseurId) {
        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);
        verifierStatut(offre, StatutOffre.DOSSIER_INCOMPLET,
                "Seuls les dossiers incomplets peuvent etre reouverts");
        offre.setCommentaireSuperviseur(null);
        offre.setStatut(StatutOffre.EN_VALIDATION);
    }

    /**
     * Superviseur valide le dossier.
     * Transition autorisee : EN_VALIDATION -> VALIDEE.
     */
    @Transactional
    public void validerOffre(Long offreId, Long superviseurId) {
        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);
        verifierStatut(offre, StatutOffre.EN_VALIDATION,
                "Seuls les dossiers en validation peuvent etre valides");
        offre.setCommentaireSuperviseur(null);
        offre.setStatut(StatutOffre.VALIDEE);
    }

    /**
     * Superviseur demarre le stage.
     * Transition autorisee : VALIDEE -> STAGE_EN_COURS.
     */
    @Transactional
    public void demarrerStage(Long offreId, Long superviseurId) {
        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);
        verifierStatut(offre, StatutOffre.VALIDEE,
                "Seuls les dossiers valides peuvent demarrer le stage");
        offre.setStatut(StatutOffre.STAGE_EN_COURS);
    }

    /**
     * Superviseur met le stage en pause.
     * Transition autorisee : STAGE_EN_COURS -> PAUSE.
     */
    @Transactional
    public void mettreEnPause(Long offreId, Long superviseurId, String raison) {
        validerTexteObligatoire(raison,
                "La raison de la pause est obligatoire et doit contenir au moins 10 caracteres");

        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);
        verifierStatut(offre, StatutOffre.STAGE_EN_COURS,
                "Seuls les stages en cours peuvent etre mis en pause");
        offre.setCommentaireSuperviseur(raison.trim());
        offre.setStatut(StatutOffre.PAUSE);
    }

    /**
     * Superviseur reprend un stage en pause.
     * Transition autorisee : PAUSE -> STAGE_EN_COURS.
     */
    @Transactional
    public void reprendreStage(Long offreId, Long superviseurId) {
        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);
        verifierStatut(offre, StatutOffre.PAUSE,
                "Seuls les stages en pause peuvent etre repris");
        offre.setCommentaireSuperviseur(null);
        offre.setStatut(StatutOffre.STAGE_EN_COURS);
    }

    /**
     * Superviseur demande des corrections sur le rapport.
     * Transition autorisee : RAPPORT_SOUMIS -> EN_CORRECTION.
     */
    @Transactional
    public void demanderCorrectionRapport(Long offreId, Long superviseurId, String commentaire) {
        validerTexteObligatoire(commentaire,
                "Le commentaire est obligatoire et doit contenir au moins 10 caracteres");

        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);
        verifierStatut(offre, StatutOffre.RAPPORT_SOUMIS,
                "Seuls les rapports soumis peuvent etre envoyes en correction");

        RapportStage rapport = chargerRapport(offre);
        if (rapport.getStatut() != StatutRapport.SOUMIS) {
            throw new IllegalStateException("Le rapport associe n'est pas au statut SOUMIS");
        }

        rapport.setStatut(StatutRapport.EN_CORRECTION);
        offre.setCommentaireSuperviseur(commentaire.trim());
        offre.setStatut(StatutOffre.EN_CORRECTION);
    }

    /**
     * Superviseur valide le rapport.
     * Transitions autorisees : RAPPORT_SOUMIS -> RAPPORT_VALIDE
     * et EN_CORRECTION -> RAPPORT_VALIDE.
     */
    @Transactional
    public void validerRapport(Long offreId, Long superviseurId) {
        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);

        boolean statutOffreValide = offre.getStatut() == StatutOffre.RAPPORT_SOUMIS
                || offre.getStatut() == StatutOffre.EN_CORRECTION;
        if (!statutOffreValide) {
            throw new IllegalStateException(
                    "Seuls les rapports soumis ou en correction peuvent etre valides");
        }

        RapportStage rapport = chargerRapport(offre);
        boolean statutRapportValide = rapport.getStatut() == StatutRapport.SOUMIS
                || rapport.getStatut() == StatutRapport.EN_CORRECTION;
        if (!statutRapportValide) {
            throw new IllegalStateException(
                    "Le rapport associe doit etre au statut SOUMIS ou EN_CORRECTION");
        }

        rapport.setStatut(StatutRapport.VALIDE);
        offre.setCommentaireSuperviseur(null);
        offre.setStatut(StatutOffre.RAPPORT_VALIDE);
    }

    /**
     * Admin archive un dossier.
     * Transition autorisee : NOTE_ATTRIBUEE -> ARCHIVE.
     */
    @Transactional
    public void archiver(Long offreId) {
        if (offreId == null) {
            throw new IllegalArgumentException("L'identifiant de l'offre est obligatoire");
        }

        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null) {
            throw new IllegalArgumentException("Offre de stage introuvable");
        }

        verifierStatut(offre, StatutOffre.NOTE_ATTRIBUEE,
                "Seuls les dossiers avec note attribuee peuvent etre archives");
        offre.setStatut(StatutOffre.ARCHIVE);
    }

    /**
     * Genere la convention de stage si elle n'existe pas deja.
     * Cette methode sert de point d'entree transactionnel pour le flux superviseur.
     */
    @Transactional
    public Convention genererConventionSiAbsente(Long offreId, Long superviseurId) {
        OffreStage offre = chargerOffrePourSuperviseur(offreId, superviseurId);

        if (offre.getConvention() != null) {
            return offre.getConvention();
        }

        boolean statutCompatible = offre.getStatut() == StatutOffre.VALIDEE
                || offre.getStatut() == StatutOffre.STAGE_EN_COURS
                || offre.getStatut() == StatutOffre.PAUSE;
        if (!statutCompatible) {
            throw new IllegalStateException(
                    "La convention ne peut etre generee qu'apres validation du dossier");
        }

        Convention convention = new Convention();
        convention.setNumeroConvention("CONV-" + LocalDate.now().getYear()
                + "-" + String.format("%03d", offre.getId()));
        convention.setDateGeneration(LocalDate.now());
        convention.setObjectifsPedagogiques("Stage de fin d'etudes - " + offre.getIntitulePoste());
        convention.setSigneeEtudiant(false);
        convention.setSigneeEntreprise(false);
        convention.setSigneeUniversite(false);
        convention.setOffreStage(offre);

        em.persist(convention);
        offre.setConvention(convention);
        return convention;
    }

    /**
     * Recherche toutes les offres par leur statut.
     */
    public List<OffreStage> listerParStatut(StatutOffre statut) {
        return em.createQuery(
                "SELECT o FROM OffreStage o WHERE o.statut = :statut ORDER BY o.dateSoumission DESC",
                OffreStage.class)
                .setParameter("statut", statut)
                .getResultList();
    }

    /**
     * Liste toutes les offres affectees a un superviseur.
     */
    public List<OffreStage> listerParSuperviseur(Long superviseurId) {
        if (superviseurId == null) {
            return new ArrayList<>();
        }

        return em.createQuery(
                "SELECT o FROM OffreStage o WHERE o.superviseur.id = :sid ORDER BY o.dateSoumission DESC",
                OffreStage.class)
                .setParameter("sid", superviseurId)
                .getResultList();
    }

    /**
     * Surcharge conservant la compatibilite avec le code existant.
     */
    public List<OffreStage> listerParSuperviseur(Superviseur superviseur) {
        if (superviseur == null) {
            return new ArrayList<>();
        }
        return listerParSuperviseur(superviseur.getId());
    }

    /**
     * Liste les offres d'un superviseur filtrees par statut.
     * Une ArrayList est creee avant le passage a JPQL pour rester compatible
     * avec EclipseLink.
     */
    public List<OffreStage> listerParSuperviseurEtStatuts(Long superviseurId, List<StatutOffre> statuts) {
        if (superviseurId == null) {
            return new ArrayList<>();
        }
        if (statuts == null || statuts.isEmpty()) {
            return listerParSuperviseur(superviseurId);
        }

        List<StatutOffre> statutsCompatibles = new ArrayList<>(statuts);
        return em.createQuery(
                "SELECT o FROM OffreStage o " +
                "WHERE o.superviseur.id = :sid AND o.statut IN :statuts " +
                "ORDER BY o.dateSoumission DESC",
                OffreStage.class)
                .setParameter("sid", superviseurId)
                .setParameter("statuts", statutsCompatibles)
                .getResultList();
    }

    /**
     * Recherche toutes les offres par etudiant.
     */
    public List<OffreStage> listerParEtudiant(Etudiant etudiant) {
        return em.createQuery(
                "SELECT o FROM OffreStage o WHERE o.etudiant = :etudiant ORDER BY o.dateSoumission DESC",
                OffreStage.class)
                .setParameter("etudiant", etudiant)
                .getResultList();
    }

    /**
     * Recherche une offre par son identifiant.
     */
    public Optional<OffreStage> findById(Long id) {
        return Optional.ofNullable(em.find(OffreStage.class, id));
    }

    /**
     * Recupere l'offre la plus recente d'un etudiant.
     */
    public OffreStage trouverOffrePlusRecenteEtudiant(Long etudiantId) {
        if (etudiantId == null) {
            return null;
        }

        List<OffreStage> offres = em.createQuery(
                "SELECT o FROM OffreStage o WHERE o.etudiant.id = :eid ORDER BY o.dateSoumission DESC",
                OffreStage.class)
                .setParameter("eid", etudiantId)
                .setMaxResults(1)
                .getResultList();

        return offres.isEmpty() ? null : offres.get(0);
    }

    /**
     * Retourne toutes les offres.
     */
    public List<OffreStage> listerToutes() {
        return em.createQuery(
                "SELECT o FROM OffreStage o ORDER BY o.dateSoumission DESC",
                OffreStage.class)
                .getResultList();
    }

    /**
     * Affecte un superviseur a une offre.
     */
    @Transactional
    public void affecterSuperviseur(Long offreId, Long superviseurId) {
        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null) {
            throw new IllegalArgumentException("Offre introuvable");
        }

        Superviseur superviseur = em.find(Superviseur.class, superviseurId);
        if (superviseur == null) {
            throw new IllegalArgumentException("Superviseur introuvable");
        }

        offre.setSuperviseur(superviseur);
    }

    /**
     * Trouve l'etudiant lie a un utilisateur.
     * Si le profil n'existe pas encore, il est cree automatiquement.
     */
    @Transactional
    public Etudiant findEtudiantByUtilisateurId(Long utilisateurId) {
        if (utilisateurId == null) {
            return null;
        }

        List<Etudiant> results = em.createQuery(
                "SELECT e FROM Etudiant e WHERE e.utilisateur.id = :uid",
                Etudiant.class)
                .setParameter("uid", utilisateurId)
                .getResultList();

        if (!results.isEmpty()) {
            return results.get(0);
        }

        Utilisateur utilisateur = em.find(Utilisateur.class, utilisateurId);
        if (utilisateur == null || utilisateur.getRole() != Role.ETUDIANT) {
            return null;
        }

        Etudiant etudiant = new Etudiant();
        etudiant.setUtilisateur(utilisateur);
        etudiant.setMatricule(String.format("AUTO-ETU-%05d", utilisateurId));
        etudiant.setFiliere("Genie Logiciel");
        etudiant.setPromotion("BAC3-GL");
        etudiant.setAnneeUniv(calculerAnneeUniversitaireParDefaut());
        etudiant.setTelephone(null);
        em.persist(etudiant);
        em.flush();
        return etudiant;
    }

    /**
     * Trouve l'objet Superviseur a partir de l'identifiant utilisateur.
     * Retourne null si aucun profil superviseur n'est trouve.
     */
    public Superviseur findSuperviseurByUtilisateurId(Long utilisateurId) {
        if (utilisateurId == null) {
            return null;
        }

        List<Superviseur> resultats = em.createQuery(
                "SELECT s FROM Superviseur s WHERE s.utilisateur.id = :uid",
                Superviseur.class)
                .setParameter("uid", utilisateurId)
                .getResultList();

        return resultats.isEmpty() ? null : resultats.get(0);
    }

    /**
     * Cree une entreprise si elle n'existe pas encore, sinon retourne l'existante.
     */
    @Transactional
    public Entreprise creerOuTrouverEntreprise(String nom, String secteur,
            String ville, String adresse, String nomResponsable,
            String emailContact, String telephone) {

        if (nom == null || nom.trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom de l'entreprise est obligatoire");
        }

        List<Entreprise> existantes = em.createQuery(
                "SELECT e FROM Entreprise e WHERE e.nom = :nom",
                Entreprise.class)
                .setParameter("nom", nom.trim())
                .getResultList();

        if (!existantes.isEmpty()) {
            return existantes.get(0);
        }

        Entreprise entreprise = new Entreprise();
        entreprise.setNom(nom.trim());
        entreprise.setSecteur(secteur);
        entreprise.setVille(ville);
        entreprise.setAdresse(adresse);
        entreprise.setNomResponsable(nomResponsable);
        entreprise.setEmailContact(emailContact);
        entreprise.setTelephone(telephone);

        em.persist(entreprise);
        return entreprise;
    }

    private OffreStage chargerOffrePourSuperviseur(Long offreId, Long superviseurId) {
        if (offreId == null) {
            throw new IllegalArgumentException("L'identifiant de l'offre est obligatoire");
        }
        if (superviseurId == null) {
            throw new SecurityException("Superviseur non authentifie");
        }

        OffreStage offre = em.find(OffreStage.class, offreId);
        if (offre == null) {
            throw new IllegalArgumentException("Offre de stage introuvable");
        }
        if (offre.getSuperviseur() == null || offre.getSuperviseur().getId() == null
                || !offre.getSuperviseur().getId().equals(superviseurId)) {
            throw new SecurityException("Acces non autorise a cette offre");
        }

        return offre;
    }

    private RapportStage chargerRapport(OffreStage offre) {
        if (offre.getRapport() == null) {
            throw new IllegalStateException("Aucun rapport de stage n'est associe a cette offre");
        }
        return offre.getRapport();
    }

    private void verifierStatut(OffreStage offre, StatutOffre statutAttendu, String messageErreur) {
        if (offre.getStatut() != statutAttendu) {
            throw new IllegalStateException(messageErreur);
        }
    }

    private void validerTexteObligatoire(String valeur, String messageErreur) {
        if (valeur == null || valeur.trim().length() < 10) {
            throw new IllegalArgumentException(messageErreur);
        }
    }

    private String calculerAnneeUniversitaireParDefaut() {
        int annee = LocalDate.now().getYear();
        int mois = LocalDate.now().getMonthValue();
        if (mois >= 9) {
            return annee + "-" + (annee + 1);
        }
        return (annee - 1) + "-" + annee;
    }
}
