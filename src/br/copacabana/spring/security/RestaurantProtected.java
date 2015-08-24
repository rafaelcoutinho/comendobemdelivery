package br.copacabana.spring.security;

import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.entities.Restaurant.SiteStatus;

public class RestaurantProtected implements org.springframework.web.servlet.HandlerInterceptor {
	protected static final Logger log = Logger.getLogger("copacabana.Security");

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3) throws Exception {

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3) throws Exception {

	}

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object obj) throws Exception {
		if ("restaurant".equals(req.getSession().getAttribute("userType")) || "central".equals(req.getSession().getAttribute("userType"))) {

			if (req.getSession().getAttribute("restaurantNotActive") != null) {
				log.log(Level.INFO, "Restaurant is not active, current status is {0}", req.getSession().getAttribute("restaurantNotActive"));
				if (SiteStatus.BLOCKED.equals(req.getSession().getAttribute("restaurantNotActive"))) {
					res.sendRedirect("/restauranteBloqueado.jsp");
				} else {
					if (!req.getRequestURI().contains("aceitarTermos.do")) {
						res.sendRedirect("/aceitarTermos.do");
						return false;
					}
					return true;
				}
			} else {
				return true;
			}
		}
		res.sendError(HttpServletResponse.SC_FORBIDDEN);
		return false;
	}
}
