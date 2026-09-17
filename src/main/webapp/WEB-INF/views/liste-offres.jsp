<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="${sessionScope.role == 'ETUDIANT' ? 'Mes stages' : 'Liste des stages'}"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>

    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">
          <c:choose>
            <c:when test="${sessionScope.role == 'ETUDIANT'}">Mes stages</c:when>
            <c:otherwise>Tous les stages</c:otherwise>
          </c:choose>
        </span>
        <div class="topbar-spacer"></div>
        <div class="topbar-actions">
          <c:if test="${sessionScope.role == 'ETUDIANT'}">
            <a class="btn btn-primary btn-sm"
               href="${pageContext.request.contextPath}/offres?action=nouvelle">+ Déposer une demande</a>
          </c:if>
          <c:if test="${sessionScope.role != 'ETUDIANT'}">
            <select class="form-control" id="filtreStatut" style="width:auto;"
                    onchange="var f=new URLSearchParams(window.location.search); f.set('statut', this.value); f.delete('page'); window.location.search=f.toString();">
              <option value="">Tous les statuts</option>
              <option value="OFFRE_SOUMISE" <c:if test="${statutSelectionne == 'OFFRE_SOUMISE'}">selected</c:if>>Offre soumise</option>
              <option value="EN_VALIDATION" <c:if test="${statutSelectionne == 'EN_VALIDATION'}">selected</c:if>>En validation</option>
              <option value="DOSSIER_INCOMPLET" <c:if test="${statutSelectionne == 'DOSSIER_INCOMPLET'}">selected</c:if>>Dossier incomplet</option>
              <option value="VALIDEE" <c:if test="${statutSelectionne == 'VALIDEE'}">selected</c:if>>Validée</option>
              <option value="STAGE_EN_COURS" <c:if test="${statutSelectionne == 'STAGE_EN_COURS'}">selected</c:if>>Stage en cours</option>
              <option value="PAUSE" <c:if test="${statutSelectionne == 'PAUSE'}">selected</c:if>>En pause</option>
              <option value="RAPPORT_SOUMIS" <c:if test="${statutSelectionne == 'RAPPORT_SOUMIS'}">selected</c:if>>Rapport soumis</option>
              <option value="EN_CORRECTION" <c:if test="${statutSelectionne == 'EN_CORRECTION'}">selected</c:if>>En correction</option>
              <option value="RAPPORT_VALIDE" <c:if test="${statutSelectionne == 'RAPPORT_VALIDE'}">selected</c:if>>Rapport validé</option>
              <option value="NOTE_ATTRIBUEE" <c:if test="${statutSelectionne == 'NOTE_ATTRIBUEE'}">selected</c:if>>Noté</option>
              <option value="ARCHIVE" <c:if test="${statutSelectionne == 'ARCHIVE'}">selected</c:if>>Archivé</option>
            </select>
          </c:if>
          <input class="form-control w-search" id="filtreRecherche" type="search"
                 placeholder="Rechercher…"/>
        </div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>📋 <span class="hero-gradient">
            <c:choose>
              <c:when test="${sessionScope.role == 'ETUDIANT'}">Mes stages</c:when>
              <c:otherwise>Tous les stages</c:otherwise>
            </c:choose>
          </span></h1>
          <p>
            <c:choose>
              <c:when test="${sessionScope.role == 'ETUDIANT'}">Retrouvez vos demandes de stage et leur statut de suivi.</c:when>
              <c:otherwise>Filtrez par étudiant, entreprise, poste ou statut.</c:otherwise>
            </c:choose>
          </p>
        </div>

        <c:choose>
          <c:when test="${empty offres}">
            <div class="empty-state">
              <div class="empty-icon">🗂️</div>
              <h3>Aucun stage enregistré</h3>
              <p>Les dossiers soumis apparaîtront ici.</p>
              <c:if test="${sessionScope.role == 'ETUDIANT'}">
                <a class="btn btn-primary mt-2"
                   href="${pageContext.request.contextPath}/offres?action=nouvelle">＋ Déposer votre première demande</a>
              </c:if>
            </div>
          </c:when>
          <c:otherwise>
            <div class="table-container">
              <table class="table" id="tableOffres">
                <thead>
                  <tr>
                    <th>Étudiant</th>
                    <th>Entreprise</th>
                    <th>Poste</th>
                    <th>Superviseur</th>
                    <th>Statut</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${offres}" var="offre">
                    <tr>
                      <td>
                        <strong><c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/></strong>
                      </td>
                      <td><c:out value="${offre.entreprise.nom}"/></td>
                      <td class="cell-secondary"><c:out value="${offre.titre}"/></td>
                      <td class="cell-secondary">
                        <c:choose>
                          <c:when test="${not empty offre.superviseur}">
                            <c:out value="${offre.superviseur.utilisateur.prenom}"/> <c:out value="${offre.superviseur.utilisateur.nom}"/>
                          </c:when>
                          <c:otherwise><span class="text-warning">Non affecté</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td><span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span></td>
                      <td class="text-right">
                        <a class="btn btn-secondary btn-sm"
                           href="${pageContext.request.contextPath}/offres?action=detail&amp;id=${offre.id}">
                          Voir le détail →
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
            <c:if test="${totalPages > 1}">
              <div class="card-footer text-center mt-3">
                <span class="text-secondary">
                  Affichage de <c:out value="${(page - 1) * taillePage + 1}"/> à
                  <c:out value="${page * taillePage > total ? total : page * taillePage}"/> sur
                  <c:out value="${total}"/> dossier(s)
                </span>
                <div class="inline-flex gap-1 mt-2">
                  <c:forEach begin="1" end="${totalPages}" var="p">
                    <c:url var="urlPage" value="/offres">
                      <c:param name="page" value="${p}"/>
                      <c:if test="${not empty statutSelectionne}">
                        <c:param name="statut" value="${statutSelectionne}"/>
                      </c:if>
                    </c:url>
                    <a class="btn btn-sm <c:choose><c:when test="${p == page}">btn-primary</c:when><c:otherwise>btn-secondary</c:otherwise></c:choose>"
                       href="<c:out value="${urlPage}"/>">
                      <c:out value="${p}"/>
                    </a>
                  </c:forEach>
                </div>
              </div>
            </c:if>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
  <script>
    document.getElementById('filtreRecherche').addEventListener('input', function () {
      var terme = this.value.toLowerCase();
      document.querySelectorAll('#tableOffres tbody tr').forEach(function (row) {
        row.style.display = row.textContent.toLowerCase().includes(terme) ? '' : 'none';
      });
    });
  </script>
</body>
</html>