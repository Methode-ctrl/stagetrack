<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Gestion des utilisateurs"/>
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
        <div class="card-header"><span class="card-title">➕ Créer un utilisateur</span></div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/utilisateurs" novalidate>
            <input type="hidden" name="action" value="save">
            <div class="form-row">
              <div class="form-group">
                <label class="form-label required" for="nom">Nom</label>
                <input type="text" id="nom" name="nom" class="form-control" required maxlength="100">
              </div>
              <div class="form-group">
                <label class="form-label required" for="prenom">Prénom</label>
                <input type="text" id="prenom" name="prenom" class="form-control" required maxlength="100">
              </div>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label class="form-label required" for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control" required>
              </div>
              <div class="form-group">
                <label class="form-label required" for="motDePasse">Mot de passe</label>
                <input type="password" id="motDePasse" name="motDePasse" class="form-control" required minlength="6">
              </div>
            </div>
            <div class="form-group" style="max-width:220px;">
              <label class="form-label required" for="role">Rôle</label>
              <select id="role" name="role" class="form-control" required>
                <option value="">-- Sélectionnez --</option>
                <option value="ETUDIANT">Étudiant</option>
                <option value="SUPERVISEUR">Superviseur</option>
                <option value="ADMIN">Administrateur</option>
              </select>
            </div>
            <button type="submit" class="btn btn-primary">➕ Créer l'utilisateur</button>
          </form>
        </div>
      </div>

      <!-- Liste -->
      <h2 class="section-title mb-3">Tous les utilisateurs</h2>
      <div class="table-wrapper scroll-reveal">
        <table class="table">
          <thead>
            <tr><th>Nom</th><th>Prénom</th><th>Email</th><th>Rôle</th><th>Statut</th><th>Actions</th></tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty utilisateurs}">
                <tr><td colspan="6" class="table-empty">Aucun utilisateur</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach items="${utilisateurs}" var="u">
                  <tr>
                    <td><c:out value="${u.nom}"/></td>
                    <td><c:out value="${u.prenom}"/></td>
                    <td><c:out value="${u.email}"/></td>
                    <td><span class="badge badge-role-${u.role}" style="background:#DBEAFE;color:#1D4ED8;"><c:out value="${u.role}"/></span></td>
                    <td>
                      <c:choose>
                        <c:when test="${u.actif}"><span class="badge" style="background:#D1FAE5;color:#065F46;">Actif</span></c:when>
                        <c:otherwise><span class="badge" style="background:#FEE2E2;color:#991B1B;">Inactif</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td style="display:flex;gap:0.5rem;">
                      <form method="post" action="${pageContext.request.contextPath}/utilisateurs">
                        <input type="hidden" name="action" value="toggle">
                        <input type="hidden" name="id" value="${u.id}">
                        <c:choose>
                          <c:when test="${u.actif}">
                            <button type="submit" class="btn btn-danger btn-sm" data-confirm="Désactiver cet utilisateur ?">🚫 Désactiver</button>
                          </c:when>
                          <c:otherwise>
                            <button type="submit" class="btn btn-success btn-sm">✅ Activer</button>
                          </c:otherwise>
                        </c:choose>
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
