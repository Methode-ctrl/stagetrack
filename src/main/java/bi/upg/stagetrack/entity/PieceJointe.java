package bi.upg.stagetrack.entity;

import java.time.LocalDate;
import bi.upg.stagetrack.enums.TypePiece;
import jakarta.persistence.*;

/**
 * Entité représentant une pièce jointe liée à une offre de stage.
 */
@Entity
@Table(name = "piece_jointe")
public class PieceJointe {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "nom_fichier", nullable = false)
    private String nomFichier;

    @Enumerated(EnumType.STRING)
    @Column(name = "type_piece", nullable = false)
    private TypePiece typePiece;

    @Column(name = "date_ajout", nullable = false)
    private LocalDate dateAjout;

    @ManyToOne
    @JoinColumn(name = "offre_stage_id", nullable = false)
    private OffreStage offreStage;

    // Getters et setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNomFichier() { return nomFichier; }
    public void setNomFichier(String nomFichier) { this.nomFichier = nomFichier; }

    public TypePiece getTypePiece() { return typePiece; }
    public void setTypePiece(TypePiece typePiece) { this.typePiece = typePiece; }

    public LocalDate getDateAjout() { return dateAjout; }
    public void setDateAjout(LocalDate dateAjout) { this.dateAjout = dateAjout; }

    public OffreStage getOffreStage() { return offreStage; }
    public void setOffreStage(OffreStage offreStage) { this.offreStage = offreStage; }
}
