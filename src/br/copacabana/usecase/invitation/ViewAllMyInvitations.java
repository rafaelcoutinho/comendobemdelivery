package br.copacabana.usecase.invitation;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Invitation;
import br.copacabana.Authentication;
import br.copacabana.spring.JsonException;

import com.google.appengine.api.datastore.Key;

public class ViewAllMyInvitations extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1728741555294038514L;

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(req, resp);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			if(Authentication.isUserLoggedIn(req.getSession())==false){
				resp.sendError(HttpServletResponse.SC_FORBIDDEN);
				return;
			}
			Key userId = Authentication.getLoggedUserKey(req.getSession());
			InvitationManager invMan = new InvitationManager();
			List<Invitation> list = invMan.listAllInvitations(userId);
			req.setAttribute("invitations", list);
			req.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");
			req.getRequestDispatcher("/WEB-INF/jsp/user/myInvitations.jsp").include(req, resp);
		} catch (JsonException e) {
			req.setAttribute("error", "json");
		}

	}

}
