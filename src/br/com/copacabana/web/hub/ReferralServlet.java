package br.com.copacabana.web.hub;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ReferralServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7050862352799182051L;
	protected static final Logger log = Logger.getLogger("copacabana.Referer");
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String referer = req.getHeader("referer");		
		String host = req.getHeader("HOST");
		if (referer != null && referer.indexOf(host) == -1) { // coming from another site
			req.getSession().setAttribute("refererInfo", referer);
		}else{
			req.getSession().setAttribute("refererInfo", "unknown");
		}

		log.info("referer "+referer);
		
		req.getRequestDispatcher("/").forward(req, resp);
		
	}
}
