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

    .lg-wrap {
      min-height: 100vh;
      display: grid;
      grid-template-columns: 1.05fr 1fr;
      background: var(--bg-primary);
    }

    /* ============ Validation du panneau marque ============ */
    .lg-side {
      position: relative;
      display: flex;
      flex-direction: column;
      justify-content: center;
      padding: 60px;
      overflow: hidden;
      background-image: radial-gradient(circle at 20% 15%, rgba(124, 58, 237, 0.22), transparent 45%),
                        radial-gradient(circle at 85% 90%, rgba(139, 92, 246, 0.18), transparent 45%);
    }

    .lg-side::before {
      content: "";
      position: absolute;
      inset: 0;
      background-image: linear-gradient(rgba(124, 58, 237, 0.07) 1px, transparent 1px),
                        linear-gradient(90deg, rgba(124, 58, 237, 0.07) 1px, transparent 1px);
      background-size: 46px 46px;
      -webkit-mask-image: radial-gradient(circle at 50% 45%, black, transparent 75%);
      mask-image: radial-gradient(circle at 50% 45%, black, transparent 75%);
    }

    .lg-side::after {
      content: "";
      position: absolute;
      width: 420px;
      height: 420px;
      border-radius: 50%;
      background: radial-gradient(circle, rgba(139, 92, 246, 0.25), transparent 65%);
      top: -120px;
      right: -120px;
      filter: blur(8px);
    }

    .lg-side > * {
      position: relative;
      z-index: 1;
    }

    .lg-logo-badge {
      width: 84px;
      height: 84px;
      border-radius: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 42px;
      background: linear-gradient(135deg, var(--purple-500), var(--purple-600));
      box-shadow: 0 16px 40px rgba(124, 58, 237, 0.45), inset 0 1px 0 rgba(255, 255, 255, 0.15);
      margin-bottom: 28px;
    }

    .lg-side h1 {
      font-size: 40px;
      font-weight: 800;
      letter-spacing: -0.03em;
      margin-bottom: 10px;
    }

    .lg-side .lg-tagline {
      font-size: 16px;
      color: var(--text-secondary);
      margin-bottom: 44px;
    }

    .lg-feature {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 14px 0;
      color: var(--text-secondary);
      font-size: 14px;
    }

    .lg-feature + .lg-feature {
      border-top: 1px solid var(--border-color);
    }

    .lg-feature-icon {
      flex-shrink: 0;
      width: 38px;
      height: 38px;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: rgba(124, 58, 237, 0.16);
      color: var(--purple-400);
    }

    /* ============ Panneau formulaire ============ */
    .lg-main {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 48px 28px;
      background: var(--bg-card);
    }

    .lg-card {
      width: 100%;
      max-width: 400px;
    }

    .lg-card-title {
      font-size: 28px;
      font-weight: 800;
      letter-spacing: -0.02em;
      margin-bottom: 6px;
    }

    .lg-card-subtitle {
      color: var(--text-secondary);
      font-size: 14px;
      margin-bottom: 30px;
    }

    .lg-field {
      position: relative;
      margin-bottom: 20px;
    }

    .lg-field-icon {
      position: absolute;
      left: 16px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 20px;
      color: var(--text-muted);
      pointer-events: none;
      transition: color 0.2s ease;
    }

    .lg-field:focus-within .lg-field-icon {
      color: var(--purple-400);
    }

    .lg-field .form-label {
      font-size: 13px;
      margin-bottom: 10px;
    }

    .lg-field .form-control {
      padding: 15px 16px 15px 48px;
      font-size: 15px;
      border-radius: 14px;
      border-width: 1px;
      transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .lg-field .form-control:hover {
      border-color: var(--purple-500);
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
      transition: color 0.2s ease, background 0.2s ease;
    }

    .lg-password-toggle:hover {
      color: var(--purple-400);
      background: rgba(124, 58, 237, 0.12);
    }

    .lg-password-toggle svg {
      width: 19px;
      height: 19px;
    }

    .lg-options {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin: 4px 0 24px;
    }

    .lg-remember {
      display: inline-flex;
      align-items: center;
      gap: 9px;
      color: var(--text-secondary);
      font-size: 13px;
      cursor: pointer;
      user-select: none;
    }

    .lg-remember input {
      width: 16px;
      height: 16px;
      accent-color: var(--purple-600);
      cursor: pointer;
    }

    .lg-forgot {
      font-size: 13px;
      font-weight: 600;
      color: var(--purple-400);
      transition: color 0.2s ease;
    }

    .lg-forgot:hover {
      color: var(--purple-500);
    }

    .lg-submit {
      border-radius: 999px;
      padding: 16px 28px;
      font-size: 16px;
      width: 100%;
    }

    .lg-footer {
      text-align: center;
      color: var(--text-muted);
      font-size: 12px;
      margin-top: 30px;
    }

    @media (max-width: 900px) {
      .lg-wrap {
        grid-template-columns: 1fr;
      }

      .lg-side {
        display: none;
      }

      .lg-main {
        min-height: 100vh;
      }
    }

    @media (max-width: 480px) {
      .lg-main {
        padding: 36px 20px;
      }

      .lg-card-title {
        font-size: 24px;
      }
    }
  </style>
</head>
<body>
  <div class="lg-wrap">
    <aside class="lg-side">
      <div class="lg-logo-badge">🎓</div>
      <h1>StageTrack</h1>
      <p class="lg-tagline">Université Polytechnique de <span class="gradient" style="background:linear-gradient(135deg,var(--purple-400),var(--purple-600));-webkit-background-clip:text;background-clip:text;-webkit-text-fill-color:transparent;font-weight:700;">Gitega</span></p>

      <div class="lg-feature">
        <span class="lg-feature-icon">
          <svg viewBox="0 0 24 24" width="19" height="19" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
        </span>
        <span>Pilotez votre dossier de stage de A à Z dans un seul espace</span>
      </div>
      <div class="lg-feature">
        <span class="lg-feature-icon">
          <svg viewBox="0 0 24 24" width="19" height="19" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12a9 9 0 1 1-9-9"/><path d="M21 3l-9 9"/><path d="M15 3h6v6"/></svg>
        </span>
        <span>Suivi en temps réel : soumission, validation, convention</span>
      </div>
      <div class="lg-feature">
        <span class="lg-feature-icon">
          <svg viewBox="0 0 24 24" width="19" height="19" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 17h.01"/><path d="M2.1 7.9A8.2 8.2 0 0 1 12 3.5a8.2 8.2 0 0 1 10 4.4"/><path d="M2 12a4.3 4.3 0 0 1 7.1-3.4a4.3 4.3 0 0 1 5.6.2"/><path d="M4.5 16.2a3 3 0 0 1 4-2.4"/><path d="M22 13a4 4 0 0 1-3-3.9"/></svg>
        </span>
        <span>Rapports de stage, commentaires de correction et note finale</span>
      </div>
    </aside>

    <main class="lg-main">
      <div class="lg-card">
        <h2 class="lg-card-title">Bienvenue&nbsp;👋</h2>
        <p class="lg-card-subtitle">Connectez-vous pour accéder à votre espace.</p>

        <c:if test="${not empty erreur}">
          <div class="alert alert-error mb-3">${erreur}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login" autocomplete="on">
          <div class="lg-field form-group" style="margin-bottom:20px;">
            <label class="form-label" for="email">Adresse e-mail</label>
            <span class="lg-field-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="4" width="20" height="16" rx="2"/><path d="m22 7-10 6L2 7"/></svg>
            </span>
            <input class="form-control" type="email" id="email" name="email" placeholder="vous@exemple.com"
                   required autofocus autocomplete="email"/>
          </div>

          <div class="lg-field form-group" style="margin-bottom:20px;">
            <label class="form-label" for="motDePasse">Mot de passe</label>
            <span class="lg-field-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            </span>
            <input class="form-control" type="password" id="motDePasse" name="motDePasse"
                   placeholder="••••••••" required autocomplete="current-password"/>
            <button type="button" class="lg-password-toggle" id="lgTogglePass" aria-label="Afficher le mot de passe">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
          </div>

          <div class="lg-options">
            <label class="lg-remember">
              <input type="checkbox" name="seSouvenir" id="seSouvenir"/>
              <span>Se souvenir de moi</span>
            </label>
            <a class="lg-forgot" href="#">Mot de passe oublié&nbsp;?</a>
          </div>

          <button type="submit" class="btn btn-primary btn-lg btn-block lg-submit">
            Se connecter
          </button>
        </form>

        <p class="lg-footer">Projet académique — BAC3 Génie Logiciel © 2026</p>
      </div>
    </main>
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