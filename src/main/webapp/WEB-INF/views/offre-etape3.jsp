<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Soumettre une offre – Étape 3"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard" data-logout-url="${pageContext.request.contextPath}/login?action=logout">
  <%@ include file="include/sidebar.jsp" %>
  <main class="main-content">
    <div class="container">
      <div class="form-card">
        <div class="steps mb-4">
          <div class="step completed">
            <div class="step-circle">✓</div>
            <div class="step-label">Entreprise</div>
          </div>
          <div class="step completed">
            <div class="step-circle">✓</div>
            <div class="step-label">Stage</div>
          </div>
          <div class="step active">
            <div class="step-circle">3</div>
            <div class="step-label">Documents</div>
          </div>
        </div>

        <h2>Soumettre mon offre de stage – Étape 3/3</h2>
        <p class="text-secondary mb-3">Pièces justificatives et confirmation</p>

        <c:if test="${not empty erreurs}">
          <c:forEach items="${erreurs}" var="erreur">
            <div class="alert alert-error"><c:out value="${erreur}"/></div>
          </c:forEach>
        </c:if>

        <c:if test="${not empty sessionScope.offreTemp}">
          <div style="background:var(--color-surface-alt);border:1px solid var(--color-border);border-radius:var(--radius-md);padding:1rem;margin-bottom:1.5rem;">
            <p class="font-semibold mb-2">📋 Récapitulatif de votre dossier</p>
            <p class="text-sm text-secondary">Entreprise : <strong><c:out value="${sessionScope.offreTemp.entreprise.nom}"/></strong></p>
            <p class="text-sm text-secondary">Poste : <strong><c:out value="${sessionScope.offreTemp.intitulePoste}"/></strong></p>
            <p class="text-sm text-secondary">Date début : <strong><c:out value="${sessionScope.offreTemp.dateDebut}"/></strong></p>
            <p class="text-sm text-secondary">Durée : <strong><c:out value="${sessionScope.offreTemp.dureeEnMois}"/> mois</strong></p>
          </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/offres?action=soumettre-etape3" novalidate>

          <!-- LETTRE D'ACCEPTATION -->
          <div class="form-group">
            <label for="nomFichierLettre">
              📄 Nom du fichier – Lettre d'acceptation
              <span class="required">*</span>
            </label>
            <div class="doc-info-box">
              <p>📋 <strong>Comment faire :</strong></p>
              <ol>
                <li>Préparez votre lettre d'acceptation en PDF sur votre ordinateur</li>
                <li>Nommez votre fichier clairement (ex: lettre_bicbank_irakoze.pdf)</li>
                <li>Saisissez ci-dessous le nom exact de ce fichier</li>
                <li>Remettez le fichier physiquement à votre superviseur</li>
              </ol>
            </div>
            <input type="text"
                   id="nomFichierLettre"
                   name="nomFichierLettre"
                   class="form-control"
                   placeholder="lettre_acceptation_entreprise_nom.pdf"
                   value="${param.nomFichierLettre}"
                   required
                   maxlength="255"/>
            <small class="form-hint">⚠️ Indiquez le nom exact de votre fichier PDF (doit se terminer par .pdf)</small>
            <c:if test="${not empty erreurLettre}">
              <span class="field-error">${erreurLettre}</span>
            </c:if>
          </div>

          <!-- CV -->
          <div class="form-group">
            <label for="nomFichierCV">
              📄 Nom du fichier – CV
              <span class="required">*</span>
            </label>
            <input type="text"
                   id="nomFichierCV"
                   name="nomFichierCV"
                   class="form-control"
                   placeholder="cv_prenom_nom_2026.pdf"
                   value="${param.nomFichierCV}"
                   required
                   maxlength="255"/>
            <small class="form-hint">⚠️ Indiquez le nom exact de votre fichier CV (doit se terminer par .pdf)</small>
            <c:if test="${not empty erreurCV}">
              <span class="field-error">${erreurCV}</span>
            </c:if>
          </div>

          <!-- NOTICE GLOBALE -->
          <div class="notice-box notice-info">
            <span class="notice-icon">ℹ️</span>
            <div class="notice-content">
              <strong>Concernant les fichiers PDF</strong>
              <p>Dans ce système, vous indiquez uniquement le nom de vos fichiers.
              Vous devrez remettre les documents physiques (ou par email) directement à votre superviseur.</p>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label" for="commentaire">Commentaire / Motivation (optionnel)</label>
            <textarea id="commentaire" name="commentaire" class="form-control" rows="3"
                      placeholder="Expliquez pourquoi vous avez choisi ce stage..."><c:out value="${param.commentaire}"/></textarea>
          </div>
          <div class="form-group" style="display:flex;align-items:flex-start;gap:0.75rem;">
            <input type="checkbox" id="confirmation" name="confirmation" required style="margin-top:3px;width:auto;">
            <label for="confirmation" class="form-label" style="margin:0;font-weight:400;color:var(--color-text-secondary);">
              Je certifie que toutes les informations fournies sont exactes et que je possède bien ces documents.
            </label>
          </div>
          <div class="flex-between mt-4">
            <a href="${pageContext.request.contextPath}/offres?action=etape2" class="btn btn-secondary">← Précédent</a>
            <button type="submit" class="btn btn-primary">✅ Soumettre mon dossier</button>
          </div>
        </form>
      </div>
    </div>
  </main>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/sidebar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
