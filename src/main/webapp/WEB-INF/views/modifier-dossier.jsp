<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Corriger mon dossier"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Corriger mon dossier</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="javascript:history.back()">← Annuler</a>
      </div>

      <div class="page-content page-content-sm">
        <div class="hero">
          <h1>✏️ <span class="hero-gradient">Corriger mon dossier</span></h1>
          <p>Modifiez les informations demandées puis re-soumettez le dossier.</p>
        </div>

        <c:if test="${not empty offre.motifRejet}">
          <div class="alert alert-warning">
            📌 <strong>Motif de la correction :</strong> <c:out value="${offre.motifRejet}"/>
          </div>
        </c:if>

        <c:if test="${not empty erreurs}">
          <div class="alert alert-error">
            <c:forEach items="${erreurs}" var="err">
              <p class="mb-1"><c:out value="${err}"/></p>
            </c:forEach>
          </div>
        </c:if>

        <c:set var="adresseComplete" value="${offre.entreprise.adresse}"/>
        <c:set var="villePrefill" value="${fn:substringAfter(adresseComplete, ', ')}"/>
        <c:set var="adressePrefill" value="${fn:substringBefore(adresseComplete, ', ')}"/>
        <c:if test="${empty villePrefill && not empty adresseComplete}">
          <c:set var="villePrefill" value="${adresseComplete}"/>
          <c:set var="adressePrefill" value=""/>
        </c:if>

        <div class="card">
          <div class="card-header"><h3 class="card-title">🏢 Informations entreprise</h3></div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/offres?action=resoumettre">
              <input type="hidden" name="id" value="<c:out value="${offre.id}"/>"/>

              <div class="grid-2">
                <div class="form-group">
                  <label class="form-label">Nom de l'entreprise <span class="required">*</span></label>
                  <input class="form-control" name="nomEntreprise" required
                         value="<c:out value="${offre.entreprise.nom}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Secteur d'activité <span class="required">*</span></label>
                  <input class="form-control" name="secteur" required
                         value="<c:out value="${offre.entreprise.secteur}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Ville <span class="required">*</span></label>
                  <input class="form-control" name="ville" required value="<c:out value="${villePrefill}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Adresse</label>
                  <input class="form-control" name="adresse" value="<c:out value="${adressePrefill}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Nom du responsable <span class="required">*</span></label>
                  <input class="form-control" name="nomResponsable" required
                         value="<c:out value="${offre.entreprise.nomResponsable}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">E-mail contact <span class="required">*</span></label>
                  <input class="form-control" type="email" name="emailContact" required
                         value="<c:out value="${offre.entreprise.emailContact}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Téléphone</label>
                  <input class="form-control" name="telephone" value="<c:out value="${offre.entreprise.telephone}"/>"/>
                </div>
              </div>

              <div class="divider"></div>

              <h3 class="card-title mb-2">💼 Informations du stage</h3>

              <div class="grid-2">
                <div class="form-group">
                  <label class="form-label">Intitulé du poste <span class="required">*</span></label>
                  <input class="form-control" name="intitulePoste" required
                         value="<c:out value="${offre.titre}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Durée (mois) <span class="required">*</span></label>
                  <input class="form-control" type="number" min="1" max="12" name="dureeEnMois" required
                         value="<c:out value="${offre.dureeEnMois}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Date de début <span class="required">*</span></label>
                  <input class="form-control" type="date" name="dateDebut" required
                         value="<c:out value="${offre.dateDebut}"/>"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Date de fin <span class="required">*</span></label>
                  <input class="form-control" type="date" name="dateFin" required
                         value="<c:out value="${offre.dateFin}"/>"/>
                </div>
              </div>

              <div class="form-group">
                <label class="form-label">Description</label>
                <textarea class="form-control" name="description" rows="4"><c:out value="${offre.description}"/></textarea>
              </div>

              <div class="form-group">
                <label class="form-label">Tâches prévues</label>
                <textarea class="form-control" name="tachesPrevues" rows="3"
                          placeholder="Décrivez les tâches que vous effectuerez…"></textarea>
              </div>

              <button type="submit" class="btn btn-primary btn-lg mt-3">✅ Re-soumettre le dossier</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
</body>
</html>