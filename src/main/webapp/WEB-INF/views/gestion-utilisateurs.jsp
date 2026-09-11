<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Gestion des utilisateurs"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Utilisateurs</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>👥 <span class="hero-gradient">Gestion des utilisateurs</span></h1>
          <p>Créez des comptes et gérez leurs accès.</p>
        </div>

        <c:if test="${not empty erreur}">
          <div class="alert alert-error">${erreur}</div>
        </c:if>
        <c:if test="${not empty succes}">
          <div class="alert alert-success">${succes}</div>
        </c:if>

        <div class="card mb-4">
          <div class="card-header"><h3 class="card-title">➕ Nouvel utilisateur</h3></div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/utilisateurs?action=creer">
              <div class="grid-2">
                <div class="form-group">
                  <label class="form-label">Prénom <span class="required">*</span></label>
                  <input class="form-control" name="prenom" required/>
                </div>
                <div class="form-group">
                  <label class="form-label">Nom <span class="required">*</span></label>
                  <input class="form-control" name="nom" required/>
                </div>
                <div class="form-group">
                  <label class="form-label">E-mail <span class="required">*</span></label>
                  <input class="form-control" type="email" name="email" required/>
                </div>
                <div class="form-group">
                  <label class="form-label">Mot de passe <span class="required">*</span></label>
                  <input class="form-control" type="password" name="motDePasse" required minlength="6"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Rôle <span class="required">*</span></label>
                  <select class="form-control" name="role" required>
                    <option value="ETUDIANT">Étudiant</option>
                    <option value="SUPERVISEUR">Superviseur</option>
                    <option value="ADMIN">Administrateur</option>
                  </select>
                </div>
              </div>
              <button type="submit" class="btn btn-primary">Créer le compte</button>
            </form>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <h3 class="card-title">📋 Liste des comptes</h3>
            <span class="badge badge-purple"><c:out value="${utilisateurs.size()}"/> comptes</span>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty utilisateurs}">
                <div class="empty-state">
                  <div class="empty-icon">👥</div>
                  <h3>Aucun utilisateur</h3>
                  <p>Créez le premier compte ci-dessus.</p>
                </div>
              </c:when>
              <c:otherwise>
                <div class="table-container">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Nom</th>
                        <th>E-mail</th>
                        <th>Rôle</th>
                        <th>Statut</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${utilisateurs}" var="user">
                        <tr>
                          <td>
                            <strong><c:out value="${user.prenom}"/> <c:out value="${user.nom}"/></strong>
                          </td>
                          <td class="cell-secondary"><c:out value="${user.email}"/></td>
                          <td><span class="badge badge-role-<c:out value="${user.role}"/>"><c:out value="${user.role}"/></span></td>
                          <td>
                            <c:choose>
                              <c:when test="${user.actif}">
                                <span class="badge" style="background:#064E3B; color:#34D399;">Actif</span>
                              </c:when>
                              <c:otherwise>
                                <span class="badge" style="background:#7F1D1D; color:#F87171;">Désactivé</span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <c:if test="${user.role != 'ADMIN' || sessionScope.utilisateur.id != user.id}">
                              <div class="inline-flex gap-1">
                                <form class="inline-form" method="post"
                                      action="${pageContext.request.contextPath}/utilisateurs?action=toggle-actif">
                                  <input type="hidden" name="userId" value="<c:out value="${user.id}"/>"/>
                                  <c:choose>
                                    <c:when test="${user.actif}">
                                      <button type="submit" class="btn btn-warning btn-sm"
                                              onclick="return confirm('Désactiver ce compte ?');">Désactiver</button>
                                    </c:when>
                                    <c:otherwise>
                                      <button type="submit" class="btn btn-success btn-sm">Activer</button>
                                    </c:otherwise>
                                  </c:choose>
                                </form>
                                <form class="inline-form" method="post"
                                      data-confirm="Supprimer définitivement cet utilisateur ?"
                                      action="${pageContext.request.contextPath}/utilisateurs?action=supprimer">
                                  <input type="hidden" name="userId" value="<c:out value="${user.id}"/>"/>
                                  <button type="submit" class="btn btn-danger btn-sm">🗑️</button>
                                </form>
                              </div>
                            </c:if>
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
  </div>
  <%@ include file="include/footer.jsp" %>
  <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
  <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>