package br.copacabana.usecase.control;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.UserActionsLog;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class UserActionRegister extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.Controllers");

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String data = req.getParameter("data");
		String sessionId = req.getParameter("sessionId");
		String state = req.getParameter("state");
		String user = req.getParameter("user");
		String action = req.getParameter("action");
		String kind = "Unknown";
		if (user != null) {
			try {
				Key k = KeyFactory.stringToKey(user);
				kind = k.getKind();
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		UserActionsLog ual = new UserActionsLog(action, state, user, data, sessionId, kind);
		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().persist(ual);
		Datastore.getPersistanceManager().getTransaction().commit();
	}
}
