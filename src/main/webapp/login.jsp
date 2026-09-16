<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Connexion – StageTrack UPG</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
  <style>
    body {
      display: block;
      padding: 0;
      min-height: 100vh;
    }

    /* ============ Connexion : formulaire centré ============ */
    .lg-wrap {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      background:
        radial-gradient(circle at 50% -20%, rgba(124, 58, 237, 0.25), transparent 55%),
        radial-gradient(circle at 85% 105%, rgba(139, 92, 246, 0.12), transparent 45%),
        var(--bg-primary);
    }

    .lg-card {
      width: 100%;
      max-width: 400px;
      background: var(--bg-card);
      border: 1px solid var(--border-color);
      border-radius: 22px;
      padding: 44px 40px 40px;
      box-shadow: 0 24px 60px rgba(0, 0, 0, 0.45);
      animation: fadeInUp 0.4s ease both;
    }

    .lg-brand {
      width: 64px;
      height: 64px;
      border-radius: 18px;
      margin: 0 auto 26px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 30px;
      background: linear-gradient(135deg, var(--purple-500), var(--purple-600));
      box-shadow: 0 12px 28px rgba(124, 58, 237, 0.4), inset 0 1px 0 rgba(255, 255, 255, 0.15);
    }

    .lg-field {
      position: relative;
      margin-bottom: 16px;
    }

    .lg-field-icon {
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

    .lg-field:focus-within .lg-field-icon {
      color: var(--purple-400);
    }

    .lg-field .form-control {
      padding: 14px 16px 14px 46px;
      font-size: 15px;
      border-radius: 14px;
      border-width: 1px;
      transition: border-color 0.25s ease, box-shadow 0.25s ease;
    }

    .lg-field .form-control:hover {
      border-color: rgba(139, 92, 246, 0.6);
    }

    .lg-field .form-control:focus {
      border-color: var(--purple-500);
      box-shadow: 0 0 0 4px rgba(124, 58, 237, 0.22);
    }

    .lg-password-toggle {
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

    .lg-password-toggle:hover {
      color: var(--purple-400);
      background: rgba(124, 58, 237, 0.12);
    }

    .lg-password-toggle svg {
      width: 19px;
      height: 19px;
    }

    .lg-submit {
      border-radius: 999px;
      padding: 15px 28px;
      font-size: 15px;
      width: 100%;
      margin-top: 8px;
    }

    @media (max-width: 480px) {
      .lg-card {
        padding: 32px 24px 28px;
      }
    }
  </style>
</head>
<body>
  <div class="lg-wrap">
    <div class="lg-card">
      <div class="lg-brand" aria-hidden="true">🎓</div>

      <c:if test="${not empty erreurs}">
        <c:forEach items="${erreurs}" var="err">
          <div class="alert alert-error mb-2"><c:out value="${err}"/></div>
        </c:forEach>
      </c:if>
      <c:if test="${not empty erreur}">
        <div class="alert alert-error mb-3"><c:out value="${erreur}"/></div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/login" autocomplete="on">
        <div class="lg-field form-group" style="margin-bottom:16px;">
          <span class="lg-field-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/></svg>
          </span>
          <input class="form-control" type="email" id="email" name="email" placeholder="Adresse e-mail"
                 aria-label="Adresse e-mail" required autofocus autocomplete="email"/>
        </div>

        <div class="lg-field form-group" style="margin-bottom:16px;">
          <span class="lg-field-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          </span>
          <input class="form-control" type="password" id="motDePasse" name="motDePasse"
                 placeholder="Mot de passe" aria-label="Mot de passe" required autocomplete="current-password"/>
          <button type="button" class="lg-password-toggle" id="lgTogglePass" aria-label="Afficher le mot de passe">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
          </button>
        </div>

        <button type="submit" class="btn btn-primary btn-lg btn-block lg-submit">
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