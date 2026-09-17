<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Évaluer le rapport"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Évaluation</span>
        <div class="topbar-spacer"></div>
        <a class="btn btn-secondary btn-sm" href="javascript:history.back()">← Retour</a>
      </div>

      <div class="page-content page-content-md">
        <div class="hero">
          <h1>📝 <span class="hero-gradient">Évaluer le rapport</span></h1>
          <p>Rapport : <c:out value="${rapport.titre}"/></p>
        </div>

        <c:if test="${not empty erreurs}">
          <div class="alert alert-error">
            <c:forEach items="${erreurs}" var="err"><p class="mb-1"><c:out value="${err}"/></p></c:forEach>
          </div>
        </c:if>
        <c:if test="${not empty erreur}">
          <div class="alert alert-error"><c:out value="${erreur}"/></div>
        </c:if>

        <div class="card mb-4">
          <div class="card-header"><h3 class="card-title">🎓 Étudiant</h3></div>
          <div class="card-body">
            <p class="mb-0"><strong><c:out value="${rapport.offreStage.etudiant.utilisateur.prenom}"/> <c:out value="${rapport.offreStage.etudiant.utilisateur.nom}"/></strong></p>
            <p class="text-secondary mt-0 mb-0">Stage : <c:out value="${rapport.offreStage.titre}"/> — <c:out value="${rapport.offreStage.entreprise.nom}"/></p>
          </div>
        </div>

        <div class="card mb-4">
          <div class="card-header"><h3 class="card-title">✅ Décision sur le rapport</h3></div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/rapports?action=valider">
              <input type="hidden" name="id" value="<c:out value="${rapport.id}"/>"/>
              <p class="text-secondary mt-0">
                Validez le rapport pour permettre l'attribution de la note finale.
              </p>
              <button type="submit" class="btn btn-success btn-lg">✅ Valider le rapport</button>
            </form>

            <div class="divider"></div>

            <details>
              <summary class="btn btn-warning btn-sm" style="display:inline-flex;">✏️ Demander une correction</summary>
              <form class="mt-2" method="post" action="${pageContext.request.contextPath}/rapports?action=corriger">
                <input type="hidden" name="id" value="<c:out value="${rapport.id}"/>"/>
                <div class="form-group">
                  <label class="form-label">Commentaire / motif <span class="required">*</span></label>
                  <textarea class="form-control" name="commentaire" rows="3" required
                            placeholder="Expliquez ce qui doit être corrigé…"></textarea>
                </div>
                <button type="submit" class="btn btn-warning">Envoyer la demande</button>
              </form>
            </details>
          </div>
        </div>
      </div>
    </div>
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>