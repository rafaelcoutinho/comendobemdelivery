package br.copacabana.usecase.invitation;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Invitation;
import br.com.copacabana.cb.entities.InvitationState;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.UserBeanManager;

public class ConfirmInvitation extends HttpServlet {
	protected static final Logger log = Logger.getLogger("fisher.Servlets");
	/**
	 * 
	 */
	private static final long serialVersionUID = -1728741555294038514L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		UserBeanManager manager = new UserBeanManager();
		InvitationManager invMan = new InvitationManager();
		Long inviteId = Long.parseLong(req.getParameter("convite"));
		Invitation invitation = invMan.get(inviteId);
		req.setCharacterEncoding("UTF-8");
		resp.setContentType("text/html; charset=UTF-8");
		if (invitation.getStatus().equals(InvitationState.EXPIRED) || invitation.getStatus().equals(InvitationState.CONFIRMED)) {
			req.getRequestDispatcher("/WEB-INF/jsp/user/conviteJaUtilizado.jsp").include(req, resp);
		} else {
			invitation.setStatus(InvitationState.VISITED);
			try {
				invMan.persist(invitation);
			} catch (Exception e) {
				e.printStackTrace();
			}
			if (invitation.getFrom().getKind().equals("CLIENT")) {
				ClientManager cm = new ClientManager();
				Client c = cm.get(invitation.getFrom());
				req.setAttribute("inviter", c);
			}

			req.setAttribute("invitation", invitation);

			req.getRequestDispatcher("/WEB-INF/jsp/user/registroFromConvite.jsp").include(req, resp);
		}

	}

}
