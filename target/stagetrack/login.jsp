<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StageTrack – Connexion</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animations.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/components.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pages.css">

</head>
<body class="page-login">
  <div class="login-wrapper">
    <div class="login-card">
      <div class="login-logo">
        <span class="login-logo-icon">🎓</span>
        <h1>StageTrack</h1>
        <p>Université Polytechnique de Gitega</p>
      </div>

      <c:if test="${not empty erreur}">
        <div class="alert alert-error"><c:out value="${erreur}"/></div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/login" novalidate>
        <div class="form-group">
          <label class="form-label required" for="email">Adresse email</label>
          <div class="input-icon-wrap">
            <span class="input-icon">✉️</span>
            <input type="email" id="email" name="email" class="form-control"
                   placeholder="votre@email.bi" required autofocus
                   value="${param.email}">
          </div>
        </div>
        <div class="form-group">
          <label class="form-label required" for="motDePasse">Mot de passe</label>
          <div class="input-icon-wrap">
            <span class="input-icon">🔒</span>
            <input type="password" id="motDePasse" name="motDePasse" class="form-control"
                   placeholder="••••••••" required>
            <button type="button" class="toggle-pw" id="togglePw" aria-label="Afficher le mot de passe">👁️</button>
          </div>
          <a href="#" class="forgot">Mot de passe oublié ?</a>
        </div>
        <button type="submit" class="btn btn-primary btn-block btn-lg">Se connecter</button>
      </form>
      <div class="login-footer">
        <p>UPG Gitega • Système de Gestion des Stages Étudiants</p>
      </div>
    </div>
  </div>
  <script>
    // Password toggle functionality
    document.addEventListener('DOMContentLoaded', function() {
      const toggleBtn = document.getElementById('togglePw');
      const passwordInput = document.getElementById('motDePasse');
      const emailInput = document.getElementById('email');

      if (toggleBtn) {
        toggleBtn.addEventListener('click', function(e) {
          e.preventDefault();
          const isPassword = passwordInput.type === 'password';
          passwordInput.type = isPassword ? 'text' : 'password';
          toggleBtn.textContent = isPassword ? '🙈' : '👁️';
          toggleBtn.setAttribute('aria-label', 
            isPassword ? 'Masquer le mot de passe' : 'Afficher le mot de passe');
          passwordInput.focus();
        });
      }

      // Focus animation on email for autofocus
      if (emailInput && !emailInput.value) {
        emailInput.focus();
      }

      // Form animation on load
      const loginCard = document.querySelector('.login-card');
      if (loginCard) {
        loginCard.style.opacity = '1';
      }
    });

    // Keyboard shortcut: Enter on password field submits form
    document.getElementById('motDePasse')?.addEventListener('keypress', function(e) {
      if (e.key === 'Enter') {
        document.querySelector('form').submit();
      }
    });
  </script>
</body>
</html>
