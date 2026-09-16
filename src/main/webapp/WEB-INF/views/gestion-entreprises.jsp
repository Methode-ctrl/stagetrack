<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <c:set var="pageTitle" value="Gestion des entreprises"/>
  <%@ include file="include/head.jsp" %>
</head>
<body>
  <div class="app-layout">
    <%@ include file="include/navbar.jsp" %>
    <div class="main-area">
      <div class="topbar">
        <button type="button" class="hamburger" aria-label="Ouvrir le menu">☰</button>
        <span class="topbar-title">Entreprises</span>
        <div class="topbar-spacer"></div>
      </div>

      <div class="page-content">
        <div class="hero">
          <h1>🏢 <span class="hero-gradient">Gestion des entreprises</span></h1>
          <p>Enregistrez les entreprises partenaires du programme de stage.</p>
        </div>

        <c:if test="${not empty erreurs}">
          <div class="alert alert-error">
            <c:forEach items="${erreurs}" var="err"><p class="mb-1"><c:out value="${err}"/></p></c:forEach>
          </div>
        </c:if>
        <c:if test="${not empty erreur}">
          <div class="alert alert-error"><c:out value="${erreur}"/></div>
        </c:if>
        <c:if test="${not empty succes}">
          <div class="alert alert-success">${succes}</div>
        </c:if>

        <div class="card mb-4">
          <div class="card-header"><h3 class="card-title">➕ Nouvelle entreprise</h3></div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/entreprises?action=creer">
              <div class="grid-2">
                <div class="form-group">
                  <label class="form-label">Nom <span class="required">*</span></label>
                  <input class="form-control" name="nom" required/>
                </div>
                <div class="form-group">
                  <label class="form-label">Secteur d'activité <span class="required">*</span></label>
                  <input class="form-control" name="secteur" required/>
                </div>
                <div class="form-group">
                  <label class="form-label">Adresse</label>
                  <input class="form-control" name="adresse"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Nom du responsable</label>
                  <input class="form-control" name="representant"/>
                </div>
                <div class="form-group">
                  <label class="form-label">E-mail contact</label>
                  <input class="form-control" type="email" name="email"/>
                </div>
                <div class="form-group">
                  <label class="form-label">Téléphone</label>
                  <input class="form-control" name="telephone"/>
                </div>
              </div>
              <button type="submit" class="btn btn-primary">Enregistrer l'entreprise</button>
            </form>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <h3 class="card-title">📋 Liste des entreprises</h3>
            <span class="badge badge-purple"><c:out value="${entreprises.size()}"/> entreprises</span>
          </div>
          <div class="card-body">
            <c:choose>
              <c:when test="${empty entreprises}">
                <div class="empty-state">
                  <div class="empty-icon">🏢</div>
                  <h3>Aucune entreprise</h3>
                  <p>Enregistrez la première entreprise ci-dessus.</p>
                </div>
              </c:when>
              <c:otherwise>
                <div class="table-container">
                  <table class="table">
                    <thead>
                      <tr>
                        <th>Nom</th>
                        <th>Secteur</th>
                        <th>Adresse</th>
                        <th>Responsable</th>
                        <th>Contact</th>
                        <th></th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${entreprises}" var="entreprise">
                        <tr>
                          <td><strong><c:out value="${entreprise.nom}"/></strong></td>
                          <td class="cell-secondary"><c:out value="${entreprise.secteur}"/></td>
                          <td class="cell-secondary"><c:out value="${entreprise.adresse}"/></td>
                          <td class="cell-secondary"><c:out value="${entreprise.representant}"/></td>
                          <td class="cell-secondary"><c:out value="${entreprise.email}"/>
                            <c:if test="${not empty entreprise.telephone}"> · <c:out value="${entreprise.telephone}"/></c:if>
                          </td>
                          <td class="text-right">
                            <form class="inline-form" method="post"
                                  data-confirm="Supprimer cette entreprise ? Attention : les stages associés seront impactés."
                                  action="${pageContext.request.contextPath}/entreprises?action=supprimer">
                              <input type="hidden" name="id" value="<c:out value="${entreprise.id}"/>"/>
                              <button type="submit" class="btn btn-danger btn-sm">🗑️ Supprimer</button>
                            </form>
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