<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Gestion des entreprises"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard">
  <%@ include file="include/navbar.jsp" %>
  <main class="main-content">
    <div class="container">

      <c:if test="${not empty succes}"><div class="alert alert-success"><c:out value="${succes}"/></div></c:if>
      <c:if test="${not empty erreur}"><div class="alert alert-error"><c:out value="${erreur}"/></div></c:if>

      <!-- Formulaire création -->
      <div class="card mb-4 scroll-reveal">
        <div class="card-header"><span class="card-title">➕ Ajouter une entreprise</span></div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/entreprises" novalidate>
            <input type="hidden" name="action" value="save">
            <div class="form-row">
              <div class="form-group">
                <label class="form-label required" for="nom">Nom de l'entreprise</label>
                <input type="text" id="nom" name="nom" class="form-control" required maxlength="150">
              </div>
              <div class="form-group">
                <label class="form-label required" for="secteur">Secteur d'activité</label>
                <input type="text" id="secteur" name="secteur" class="form-control" required maxlength="100">
              </div>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label class="form-label required" for="ville">Ville</label>
                <input type="text" id="ville" name="ville" class="form-control" required maxlength="100">
              </div>
              <div class="form-group">
                <label class="form-label" for="adresse">Adresse</label>
                <input type="text" id="adresse" name="adresse" class="form-control" maxlength="200">
              </div>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label class="form-label" for="nomResponsable">Nom du responsable</label>
                <input type="text" id="nomResponsable" name="nomResponsable" class="form-control" maxlength="150">
              </div>
              <div class="form-group">
                <label class="form-label" for="emailContact">Email contact</label>
                <input type="email" id="emailContact" name="emailContact" class="form-control">
              </div>
            </div>
            <div class="form-group" style="max-width:220px;">
              <label class="form-label" for="telephone">Téléphone</label>
              <input type="tel" id="telephone" name="telephone" class="form-control">
            </div>
            <button type="submit" class="btn btn-primary">➕ Ajouter l'entreprise</button>
          </form>
        </div>
      </div>

      <!-- Liste -->
      <h2 class="section-title mb-3">Entreprises partenaires</h2>
      <div class="table-wrapper scroll-reveal">
        <table class="table">
          <thead>
            <tr><th>Nom</th><th>Secteur</th><th>Ville</th><th>Responsable</th><th>Email</th><th>Actions</th></tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty entreprises}">
                <tr><td colspan="6" class="table-empty">Aucune entreprise enregistrée</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach items="${entreprises}" var="ent">
                  <tr>
                    <td><strong><c:out value="${ent.nom}"/></strong></td>
                    <td><c:out value="${ent.secteur}"/></td>
                    <td><c:out value="${ent.ville}"/></td>
                    <td><c:out value="${ent.nomResponsable}"/></td>
                    <td><c:out value="${ent.emailContact}"/></td>
                    <td style="display:flex;gap:0.5rem;">
                      <form method="post" action="${pageContext.request.contextPath}/entreprises">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${ent.id}">
                        <button type="submit" class="btn btn-danger btn-sm" data-confirm="Supprimer cette entreprise ?">🗑️ Supprimer</button>
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

    </div>
  </main>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
