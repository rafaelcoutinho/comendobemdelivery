package br.copacabana.spring.security;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import br.copacabana.Authentication;
import br.copacabana.Authentication.AuthStatus;
import br.copacabana.AuthenticationController;
import br.copacabana.spring.UserBeanManager;

public class FacebookAuth implements org.springframework.web.servlet.HandlerInterceptor, Filter {
	protected static final Logger log = Logger.getLogger("copacabana.Security");

	@Override
	public void afterCompletion(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, Exception arg3) throws Exception {

	}

	@Override
	public void postHandle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, ModelAndView arg3) throws Exception {

	}

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object obj) throws Exception {
		checkFBAuthentication(req);
		return true;
	}

	private void checkFBAuthentication(HttpServletRequest req) {
		try {
			if (req.getSession().getAttribute("userType") == null) {
				for (int i = 0; i < req.getCookies().length; i++) {
					Cookie c = req.getCookies()[i];
					if (c.getName().startsWith("fbs_")) {
						// user is logged in using FB but session vars are not
						// set
						// yet
						log.fine("setting session data from facebook cookie");
						UserBeanManager ub = new UserBeanManager();
						Authentication auth = new Authentication(null);
						AuthStatus state = auth.getUserFromCookie(c, false);
						if (AuthStatus.OK.equals(state)) {
							AuthenticationController.setSessionValues(auth, req.getSession());
						}
					}

				}
			}
		} catch (Exception e) {
			// TODO: handle exception
		}

	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest arg0, ServletResponse arg1, FilterChain arg2) throws IOException, ServletException {
		checkFBAuthentication((HttpServletRequest) arg0);
		arg2.doFilter(arg0, arg1);

	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub

	}
}
