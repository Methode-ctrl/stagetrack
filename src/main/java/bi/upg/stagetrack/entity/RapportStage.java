package bi.upg.stagetrack.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import bi.upg.stagetrack.enums.StatutRapport;

@Entity
@Table(name = "rapport_stage")
public class RapportStage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "titre")
    private String titre;

    @Column(name = "resume", columnDefinition = "TEXT")
    private String resume;

    @Column(name = "competences_acquises", columnDefinition = "TEXT")
    private String competencesAcquises;

    @Column(name = "nom_fichier_pdf")
    private String nomFichierPdf;

    @Column(name = "nom_fichier_annexe")
    private String nomFichierAnnexe;

    @Column(name = "date_soumission")
    private LocalDate dateSoumission;

    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatutRapport statut;

    @OneToOne
    @JoinColumn(name = "offre_stage_id", nullable = false)
    private OffreStage offreStage;

    @OneToOne(mappedBy = "rapportStage", cascade = CascadeType.ALL)
    private Note note;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getResume() { return resume; }
    public void setResume(String resume) { this.resume = resume; }

    public String getCompetencesAcquises() { return competencesAcquises; }
    public void setCompetencesAcquises(String competencesAcquises) { this.competencesAcquises = competencesAcquises; }

    public String getNomFichierPdf() { return nomFichierPdf; }
    public void setNomFichierPdf(String nomFichierPdf) { this.nomFichierPdf = nomFichierPdf; }

    public String getNomFichierAnnexe() { return nomFichierAnnexe; }
    public void setNomFichierAnnexe(String nomFichierAnnexe) { this.nomFichierAnnexe = nomFichierAnnexe; }

    public LocalDate getDateSoumission() { return dateSoumission; }
    public void setDateSoumission(LocalDate dateSoumission) { this.dateSoumission = dateSoumission; }

    public StatutRapport getStatut() { return statut; }
    public void setStatut(StatutRapport statut) { this.statut = statut; }

    public OffreStage getOffreStage() { return offreStage; }
    public void setOffreStage(OffreStage offreStage) { this.offreStage = offreStage; }

    public Note getNote() { return note; }
    public void setNote(Note note) { this.note = note; }
}
