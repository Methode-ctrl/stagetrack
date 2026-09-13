package bi.upg.stagetrack.util;

import bi.upg.stagetrack.entity.Utilisateur;
import bi.upg.stagetrack.enums.Role;
import jakarta.ejb.EJBException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public final class WebUtil {

    private WebUtil() {
    }

    public static boolean aLeRole(HttpServletRequest req, Role... roles) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }
        Utilisateur utilisateur = (Utilisateur) session.getAttribute("utilisateur");
        if (utilisateur == null) {
            return false;
        }
        for (Role role : roles) {
            if (utilisateur.getRole() == role) {
                return true;
            }
        }
        return false;
    }

    public static boolean exigerRole(HttpServletRequest req, HttpServletResponse resp, Role... roles)
            throws IOException {
        if (aLeRole(req, roles)) {
            return true;
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard");
        return false;
    }

    public static String messageReel(Throwable t) {
        Throwable cause = t;
        while (cause instanceof EJBException && cause.getCause() != null) {
            cause = cause.getCause();
        }
        return (cause.getMessage() != null ? cause.getMessage() : t.getMessage());
    }
}