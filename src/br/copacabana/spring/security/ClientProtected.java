package br.copacabana.spring.security;

import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public class ClientProtected implements org.springframework.web.servlet.HandlerInterceptor {
	protected static final Logger log = Logger.getLogger("copacabana.Security");

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3) throws Exception {

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3) throws Exception {

	}

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object obj) throws Exception {
		if ("client".equals(req.getSession().getAttribute("userType"))) {
			return true;
		}
        res.sendError(HttpServletResponse.SC_FORBIDDEN);
		return false;
	}
}
