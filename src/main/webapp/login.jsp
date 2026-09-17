<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr" data-theme="dark">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Connexion – StageTrack UPG</title>
  <script>
    (function () {
      try {
        var t = localStorage.getItem('stagetrack-theme');
        if (t === 'light' || t === 'dark') {
          document.documentElement.setAttribute('data-theme', t);
        }
      } catch (e) { /* stockage indisponible : on ignore */ }
    })();
  </script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animations.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css"/>
  <script src="${pageContext.request.contextPath}/js/theme.js"></script>
  <style>
    body {
      display: block;
      padding: 0;
      min-height: 100vh;
    }

    /* ============ Page de connexion ============ */
    .login-page {
      position: relative;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      overflow: hidden;
      background:
        radial-gradient(circle at 20% 10%, rgba(124, 58, 237, 0.2), transparent 40%),
        radial-gradient(circle at 90% 90%, rgba(139, 92, 246, 0.14), transparent 45%),
        var(--bg-primary);
    }

    .login-blob {
      position: absolute;
      border-radius: 50%;
      filter: blur(90px);
      opacity: 0.5;
      animation: blob-float 8s ease-in-out infinite;
      pointer-events: none;
    }

    .login-blob--1 {
      width: 340px;
      height: 340px;
      background: rgba(124, 58, 237, 0.5);
      top: -90px;
      left: -60px;
    }

    .login-blob--2 {
      width: 280px;
      height: 280px;
      background: rgba(139, 92, 246, 0.45);
      bottom: -70px;
      right: -40px;
      animation-delay: 3s;
    }

    @keyframes blob-float {
      0%, 100% { transform: translate(0, 0) scale(1); }
      50%      { transform: translate(20px, -25px) scale(1.08); }
    }

    [data-theme="light"] .login-blob {
      opacity: 0.35;
    }

    .login-card {
      position: relative;
      z-index: 1;
      width: 100%;
      max-width: 420px;
      background: var(--bg-card);
      border: 1px solid var(--border-color);
      border-radius: 24px;
      padding: 48px 44px 42px;
      box-shadow: var(--shadow-card);
      animation: fadeInUp 0.4s ease both;
    }

    .login-brand {
      width: 64px;
      height: 64px;
      border-radius: 18px;
      margin: 0 auto 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 30px;
      background: linear-gradient(135deg, var(--purple-500), var(--purple-600));
      box-shadow: var(--shadow-purple), inset 0 1px 0 rgba(255, 255, 255, 0.15);
    }

    .login-title {
      text-align: center;
      font-size: 24px;
      font-weight: 800;
      letter-spacing: -0.02em;
      color: var(--text-primary);
      margin-bottom: 6px;
    }

    .login-subtitle {
      text-align: center;
      font-size: 14px;
      color: var(--text-secondary);
      margin-bottom: 28px;
    }

    .login-field {
      position: relative;
      margin-bottom: 16px;
    }

    .login-field-icon {
      position: absolute;
      left: 15px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 20px;
      color: var(--text-muted);
      pointer-events: none;
      transition: color 0.25s ease;
    }

    .login-field:focus-within .login-field-icon {
      color: var(--purple-400);
    }

    .login-field .form-control {
      padding: 14px 16px 14px 46px;
      font-size: 15px;
      border-radius: 14px;
      transition: border-color 0.25s ease, box-shadow 0.25s ease;
    }

    .login-field .form-control:hover {
      border-color: rgba(139, 92, 246, 0.6);
    }

    .login-field .form-control:focus {
      border-color: var(--purple-500);
      box-shadow: 0 0 0 4px var(--purple-glow);
    }

    .login-password-toggle {
      position: absolute;
      right: 8px;
      top: 50%;
      transform: translateY(-50%);
      width: 36px;
      height: 36px;
      border: none;
      border-radius: 10px;
      background: transparent;
      color: var(--text-muted);
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: color 0.25s ease, background 0.25s ease;
    }

    .login-password-toggle:hover {
      color: var(--purple-400);
      background: var(--bg-hover);
    }

    .login-password-toggle svg {
      width: 19px;
      height: 19px;
    }

    .login-btn {
      border-radius: 999px;
      padding: 15px 28px;
      font-size: 15px;
      width: 100%;
      margin-top: 8px;
    }

    @media (max-width: 480px) {
      .login-card {
        padding: 32px 24px 28px;
      }

      .login-blob--1,
      .login-blob--2 {
        display: none;
      }
    }
  </style>
</head>
<body>
  <div class="login-page">
    <div class="login-blob login-blob--1" aria-hidden="true"></div>
    <div class="login-blob login-blob--2" aria-hidden="true"></div>

    <div class="login-card">
      <div class="login-brand" aria-hidden="true">🎓</div>
      <h1 class="login-title">StageTrack UPG</h1>
      <p class="login-subtitle">Espace de suivi des stages</p>

      <c:if test="${not empty erreurs}">
        <c:forEach items="${erreurs}" var="err">
          <div class="alert alert-error mb-2"><c:out value="${err}"/></div>
        </c:forEach>
      </c:if>
      <c:if test="${not empty erreur}">
        <div class="alert alert-error mb-3"><c:out value="${erreur}"/></div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/login" autocomplete="on">
        <div class="login-field form-group" style="margin-bottom:16px;">
          <span class="login-field-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/></svg>
          </span>
          <input class="form-control" type="email" id="email" name="email" placeholder="Adresse e-mail"
                 aria-label="Adresse e-mail" required autofocus autocomplete="email"/>
        </div>

        <div class="login-field form-group" style="margin-bottom:16px;">
          <span class="login-field-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          </span>
          <input class="form-control" type="password" id="motDePasse" name="motDePasse"
                 placeholder="Mot de passe" aria-label="Mot de passe" required autocomplete="current-password"/>
          <button type="button" class="login-password-toggle" id="lgTogglePass" aria-label="Afficher le mot de passe">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
          </button>
        </div>

        <button type="submit" class="btn btn-primary btn-lg btn-block login-btn">
          Se connecter
        </button>
      </form>
    </div>
  </div>

  <script>
    var toggle = document.getElementById('lgTogglePass');
    var input = document.getElementById('motDePasse');
    if (toggle && input) {
      toggle.addEventListener('click', function () {
        var show = input.type === 'password';
        input.type = show ? 'text' : 'password';
        toggle.setAttribute('aria-label', show ? 'Masquer le mot de passe' : 'Afficher le mot de passe');
      });
    }
  </script>
</body>
</html>