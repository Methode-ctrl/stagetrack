<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Convention de stage"/>
  <%@ include file="include/head.jsp" %>
</head>
<body class="page-dashboard">
  <%@ include file="include/navbar.jsp" %>
  <main class="main-content">
    <div class="container">
      <div class="convention-card scroll-reveal">

        <div class="convention-header">
          <span style="font-size:2.5rem;display:block;margin-bottom:0.5rem;">📑</span>
          <h2>Convention de Stage</h2>
          <p class="text-secondary">Université Polytechnique de Gitega</p>
          <c:if test="${not empty convention}">
            <p class="text-sm text-muted mt-1">N° <strong><c:out value="${convention.numeroConvention}"/></strong> – Générée le <c:out value="${convention.dateGeneration}"/></p>
          </c:if>
        </div>

        <c:if test="${not empty convention}">
          <div class="detail-field mb-3">
            <div class="detail-field-label">Objectifs pédagogiques</div>
            <div class="detail-field-value"><c:out value="${convention.objectifsPedagogiques}"/></div>
          </div>

          <c:if test="${not empty offre}">
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-bottom:1.5rem;">
              <div class="detail-field"><div class="detail-field-label">Étudiant</div><div class="detail-field-value"><c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/></div></div>
              <div class="detail-field"><div class="detail-field-label">Entreprise</div><div class="detail-field-value"><c:out value="${offre.entreprise.nom}"/></div></div>
              <div class="detail-field"><div class="detail-field-label">Poste</div><div class="detail-field-value"><c:out value="${offre.intitulePoste}"/></div></div>
              <div class="detail-field"><div class="detail-field-label">Durée</div><div class="detail-field-value"><c:out value="${offre.dureeEnMois}"/> mois à partir du <c:out value="${offre.dateDebut}"/></div></div>
            </div>
          </c:if>

          <h3 class="section-title mb-3">Signatures</h3>
          <div class="signature-grid">
            <div class="signature-box">
              <p class="font-semibold mb-1">Étudiant</p>
              <c:if test="${not empty offre}"><p class="text-sm text-secondary mb-2"><c:out value="${offre.etudiant.utilisateur.nom}"/></p></c:if>
              <c:choose>
                <c:when test="${convention.signeeEtudiant}"><span class="badge" style="background:#D1FAE5;color:#065F46;">✅ Signé</span></c:when>
                <c:otherwise><span class="badge" style="background:#FEF3C7;color:#D97706;">⏳ En attente</span></c:otherwise>
              </c:choose>
            </div>
            <div class="signature-box">
              <p class="font-semibold mb-1">Entreprise</p>
              <c:if test="${not empty offre}"><p class="text-sm text-secondary mb-2"><c:out value="${offre.entreprise.nom}"/></p></c:if>
              <c:choose>
                <c:when test="${convention.signeeEntreprise}"><span class="badge" style="background:#D1FAE5;color:#065F46;">✅ Signé</span></c:when>
                <c:otherwise><span class="badge" style="background:#FEF3C7;color:#D97706;">⏳ En attente</span></c:otherwise>
              </c:choose>
            </div>
            <div class="signature-box">
              <p class="font-semibold mb-1">Université</p>
              <p class="text-sm text-secondary mb-2">UPG</p>
              <c:choose>
                <c:when test="${convention.signeeUniversite}"><span class="badge" style="background:#D1FAE5;color:#065F46;">✅ Signé</span></c:when>
                <c:otherwise><span class="badge" style="background:#FEF3C7;color:#D97706;">⏳ En attente</span></c:otherwise>
              </c:choose>
            </div>
          </div>
        </c:if>

        <c:if test="${empty convention}">
          <div class="alert alert-info">Aucune convention générée pour ce stage.</div>
        </c:if>

        <div class="flex-between mt-4">
          <a href="${pageContext.request.contextPath}/dashboard/${sessionScope.role == 'ETUDIANT' ? 'etudiant' : 'admin'}" class="btn btn-secondary">← Retour</a>
          <c:if test="${not empty convention}">
            <button type="button" class="btn btn-primary" onclick="window.print()">⬇️ Télécharger la convention</button>
          </c:if>
        </div>

      </div>
    </div>
  </main>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/animations.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
