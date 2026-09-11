<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Connexion – StageTrack UPG</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
  <style>
    body {
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      padding: 20px;
    }

    .login-card {
      background: var(--bg-card);
      border: 1px solid var(--border-color);
      border-radius: 20px;
      padding: 40px;
      width: 100%;
      max-width: 420px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
      animation: fadeInUp 0.6s ease both;
    }

    .login-logo {
      text-align: center;
      font-size: 44px;
      margin-bottom: 8px;
    }

    .login-title {
      text-align: center;
      font-size: 26px;
      font-weight: 800;
      letter-spacing: -0.02em;
      margin-bottom: 4px;
    }

    .login-subtitle {
      text-align: center;
      color: var(--text-secondary);
      font-size: 13px;
      margin-bottom: 32px;
    }

    .login-subtitle .gradient {
      background: linear-gradient(135deg, var(--purple-400), var(--purple-600));
      -webkit-background-clip: text;
      background-clip: text;
      -webkit-text-fill-color: transparent;
      font-weight: 700;
    }

    .login-footer {
      text-align: center;
      color: var(--text-muted);
      font-size: 12px;
      margin-top: 24px;
    }
  </style>
</head>
<body>
  <div class="login-card">
    <div class="login-logo">🎓</div>
    <h1 class="login-title">StageTrack</h1>
    <p class="login-subtitle">Université Polytechnique de <span class="gradient">Gitega</span></p>

    <c:if test="${not empty erreur}">
      <div class="alert alert-error mb-3">${erreur}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/auth?action=login" autocomplete="on">
      <div class="form-group">
        <label class="form-label" for="email">Adresse e-mail</label>
        <input class="form-control" type="email" id="email" name="email" placeholder="vous@exemple.com"
               required autofocus autocomplete="email"/>
      </div>

      <div class="form-group">
        <label class="form-label" for="motDePasse">Mot de passe</label>
        <input class="form-control" type="password" id="motDePasse" name="motDePasse"
               placeholder="••••••••" required autocomplete="current-password"/>
      </div>

      <button type="submit" class="btn btn-primary btn-lg btn-block mt-2" style="border-radius:999px;">
        Se connecter
      </button>
    </form>

    <p class="login-footer">Projet académique — BAC3 Génie Logiciel © 2026</p>
  </div>
</body>
</html>