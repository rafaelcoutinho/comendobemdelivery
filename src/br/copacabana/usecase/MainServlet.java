package br.copacabana.usecase;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import br.copacabana.Authentication;
import br.copacabana.spring.JsonException;

import com.google.appengine.api.datastore.Key;

public abstract class MainServlet extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.Servlet");
	protected String jspUrl;
	protected Boolean mustRedirect = Boolean.FALSE;

	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.jspUrl = config.getInitParameter("jspPage");
		if (config.getInitParameter("mustRedirect") != null) {
			mustRedirect = Boolean.valueOf(config.getInitParameter("mustRedirect"));
		}
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		if (this.isClientProtected()) {
			if (Authentication.isUserLoggedIn(req.getSession()) == false) {
				resp.sendError(HttpServletResponse.SC_FORBIDDEN);
				return;
			}
		}
		doInternalGet(req, resp);
		if (mustRedirect) {
			resp.sendRedirect(jspUrl);
		} else {
			req.getRequestDispatcher(jspUrl).forward(req, resp);
		}
	}

	protected abstract void doInternalGet(HttpServletRequest req, HttpServletResponse resp);

	protected boolean isClientProtected() {
		return false;
	}

	protected Key getLoggedClient(HttpSession session) {
		try {
			Key userId = Authentication.getLoggedUserKey(session);
			return userId;
		} catch (JsonException e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "cant get logged user ", e);
			throw new IllegalStateException("cant get logged user ");
		}
	}
}
