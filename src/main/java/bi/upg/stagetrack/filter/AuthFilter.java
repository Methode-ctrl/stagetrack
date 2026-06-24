package bi.upg.stagetrack.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filtre de sécurité vérifiant l'authentification sur toutes les URLs.
 * Autorise l'accès à /login et aux ressources statiques sans session.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  httpReq  = (HttpServletRequest)  request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        String uri  = httpReq.getRequestURI();
        String ctx  = httpReq.getContextPath();

        // ✅ URLs publiques — laisser passer sans vérification
        boolean isPublic =
            uri.equals(ctx + "/login")      ||
            uri.equals(ctx + "/login.jsp")  ||
            uri.equals(ctx + "/index.jsp")  ||
            uri.equals(ctx + "/")           ||
            uri.equals(ctx + "")            ||
            uri.startsWith(ctx + "/css/")   ||
            uri.startsWith(ctx + "/js/")    ||
            uri.startsWith(ctx + "/images/");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        // Vérifier la session
        HttpSession session = httpReq.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            httpResp.sendRedirect(ctx + "/login");
            return;
        }

        // Laisser passer — contrôle de rôle géré dans chaque Servlet
        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig fc) throws ServletException {}
    @Override public void destroy() {}
}
