<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Erreur</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animations.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
    <style>
        body { padding-top: 80px; padding-left: 0; display: flex; justify-content: center; align-items: center; min-height: calc(100vh - 80px); margin: 0; }
        .box { background: #fff; padding: 2rem; border-radius: 8px; text-align: center; box-shadow: 0 1px 4px rgba(0,0,0,0.1); max-width: 600px; color: #333; }
        h1 { color: #c0392b; }
        a { color: #1a3c6e; text-decoration: underline; }
        .error-details { background: #f8f9fa; padding: 1rem; border-radius: 4px; margin: 1rem 0; text-align: left; font-size: 0.9rem; }
    </style>
</head>
<body>
    <%@ include file="include/navbar.jsp" %>
    <div class="box">
        <h1>Une erreur est survenue</h1>
        <c:if test="${not empty requestScope.messageErreur}">
            <p><c:out value="${requestScope.messageErreur}"/></p>
        </c:if>
        <c:if test="${not empty requestScope.erreur}">
            <div class="error-details">
                <strong>Détails :</strong><br/>
                <c:out value="${requestScope.erreur}"/>
            </div>
        </c:if>
        <c:if test="${not empty exception}">
            <div class="error-details">
                <strong>Exception :</strong><br/>
                <c:out value="${exception.message}"/>
            </div>
        </c:if>
        <p><a href="${pageContext.request.contextPath}/dashboard/etudiant">Retour au tableau de bord</a> | <a href="${pageContext.request.contextPath}/login?action=logout">Se déconnecter</a></p>
    </div>
    <script src="${pageContext.request.contextPath}/js/navbar.js"></script>
    <script src="${pageContext.request.contextPath}/js/animations.js"></script>
    <script src="${pageContext.request.contextPath}/js/utils.js"></script>
</body>
</html>
