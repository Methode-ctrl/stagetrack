package bi.upg.stagetrack.entity;

import bi.upg.stagetrack.enums.TypePiece;
import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "piece_jointe")
public class PieceJointe implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "nom_fichier", nullable = false, length = 255)
    private String nomFichier;

    @Column(name = "type_piece", nullable = false)
    @Enumerated(EnumType.STRING)
    private TypePiece typePiece;

    @Column(name = "chemin", length = 500)
    private String chemin;

    @Column(name = "date_ajout")
    private LocalDateTime dateAjout;

    @ManyToOne
    @JoinColumn(name = "offre_stage_id", nullable = false)
    private OffreStage offreStage;

    public PieceJointe() {}

    public PieceJointe(String nomFichier, TypePiece typePiece, OffreStage offreStage) {
        this.nomFichier = nomFichier;
        this.typePiece = typePiece;
        this.offreStage = offreStage;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNomFichier() { return nomFichier; }
    public void setNomFichier(String nomFichier) { this.nomFichier = nomFichier; }

    public TypePiece getTypePiece() { return typePiece; }
    public void setTypePiece(TypePiece typePiece) { this.typePiece = typePiece; }

    public String getChemin() { return chemin; }
    public void setChemin(String chemin) { this.chemin = chemin; }

    public LocalDateTime getDateAjout() { return dateAjout; }
    public void setDateAjout(LocalDateTime dateAjout) { this.dateAjout = dateAjout; }

    public OffreStage getOffreStage() { return offreStage; }
    public void setOffreStage(OffreStage offreStage) { this.offreStage = offreStage; }
}
