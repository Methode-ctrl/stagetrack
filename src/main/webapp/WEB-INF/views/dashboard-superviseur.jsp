<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Tableau de bord"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>

    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Supervision</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>Bonjour Dr. <span class="hero-gradient"><c:out value="${sessionScope.utilisateur.prenom}"/></span> 👋</h1>
          <p>Vue d'ensemble de vos étudiants — <fmt:formatDate value="${dateJour}" pattern="EEEE d MMMM yyyy" var="date"/><c:out value="${date}"/></p>
        </div>

        <c:set var="nbEtudiants" value="${offres.size()}"/>
        <c:set var="nbStagesEnCours" value="0"/>
        <c:set var="nbRapportsATraiter" value="0"/>
        <c:forEach items="${offres}" var="o">
          <c:if test="${o.statut == 'STAGE_EN_COURS' || o.statut == 'PAUSE'}">
            <c:set var="nbStagesEnCours" value="${nbStagesEnCours + 1}"/>
          </c:if>
          <c:if test="${o.statut == 'RAPPORT_SOUMIS' || o.statut == 'EN_CORRECTION' || o.statut == 'RAPPORT_VALIDE'}">
            <c:set var="nbRapportsATraiter" value="${nbRapportsATraiter + 1}"/>
          </c:if>
        </c:forEach>

        <div class="stats-grid">
          <div class="stat-card stat-card-purple">
            <span class="stat-icon">👨‍🎓</span>
            <div class="stat-value"><c:out value="${nbEtudiants}"/></div>
            <div class="stat-label">Étudiants suivis</div>
          </div>
          <div class="stat-card stat-card-green">
            <span class="stat-icon">🚀</span>
            <div class="stat-value"><c:out value="${nbStagesEnCours}"/></div>
            <div class="stat-label">Stages en cours</div>
          </div>
          <div class="stat-card stat-card-orange">
            <span class="stat-icon">📥</span>
            <div class="stat-value"><c:out value="${nbRapportsEnAttente}"/></div>
            <div class="stat-label">Rapports à évaluer</div>
          </div>
          <div class="stat-card stat-card-pink">
            <span class="stat-icon">⚠️</span>
            <div class="stat-value"><c:out value="${nbDossiersIncomplets}"/></div>
            <div class="stat-label">Dossiers à corriger</div>
          </div>
        </div>

        <c:if test="${nbRapportsATraiter > 0}">
          <div class="card mb-4">
            <div class="card-header">
              <h3 class="card-title">📥 À traiter</h3>
              <span class="badge badge-warning"><c:out value="${nbRapportsATraiter}"/> action(s)</span>
            </div>
            <div class="card-body">
              <c:forEach items="${offres}" var="offre">
                <c:if test="${offre.statut == 'RAPPORT_SOUMIS' || offre.statut == 'EN_CORRECTION' || offre.statut == 'RAPPORT_VALIDE'}">
                  <div class="order-item mb-2">
                    <div class="order-avatar orange">📥</div>
                    <div class="order-body">
                      <div class="order-name">
                        <c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/>
                        <span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span>
                      </div>
                      <div class="order-meta"><c:out value="${offre.entreprise.nom}"/> · <c:out value="${offre.titre}"/></div>
                    </div>
                    <c:choose>
                      <c:when test="${offre.statut == 'RAPPORT_VALIDE'}">
                        <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/notes">
                          Noter →
                        </a>
                      </c:when>
                      <c:otherwise>
                        <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/rapports?offreId=${offre.id}">
                          Évaluer →
                        </a>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </c:if>
              </c:forEach>
            </div>
          </div>
        </c:if>

        <div class="card">
          <div class="card-header">
            <h3 class="card-title">🎓 Mes étudiants</h3>
            <span class="badge badge-purple"><c:out value="${offres.size()}"/> dossier(s)</span>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty offres}">
                <div class="empty-state">
                  <div class="empty-icon">👨‍🎓</div>
                  <h3>Aucun étudiant assigné</h3>
                  <p>Les étudiants vous étant affectés apparaîtront ici.</p>
                </div>
              </c:when>
              <c:otherwise>
                <div class="table-container">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Étudiant</th>
                        <th>Entreprise</th>
                        <th>Poste</th>
                        <th>Statut</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${offres}" var="offre">
                        <tr>
                          <td><strong><c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/></strong></td>
                          <td><c:out value="${offre.entreprise.nom}"/></td>
                          <td class="cell-secondary"><c:out value="${offre.titre}"/></td>
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
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>

    <aside class="right-panel">
      <div class="page-content">
        <div class="card">
          <div class="card-header"><h3 class="card-title">🕘 Derniers dossiers</h3></div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty offres}">
                <p class="text-muted">Aucun dossier pour le moment.</p>
              </c:when>
              <c:otherwise>
                <div class="order-list">
                  <c:forEach items="${offres}" var="offre" end="6">
                    <a class="order-item" href="${pageContext.request.contextPath}/offres?action=detail&amp;id=${offre.id}">
                      <div class="order-avatar green">👨‍🎓</div>
                      <div class="order-body">
                        <div class="order-name"><c:out value="${offre.etudiant.utilisateur.prenom}"/> <c:out value="${offre.etudiant.utilisateur.nom}"/></div>
                        <div class="order-meta"><c:out value="${offre.entreprise.nom}"/> · <c:out value="${offre.titre}"/></div>
                      </div>
                      <span class="badge badge-<c:out value="${offre.statut}"/>"><c:out value="${offre.statut}"/></span>
                    </a>
                  </c:forEach>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </aside>
  </div>

  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>