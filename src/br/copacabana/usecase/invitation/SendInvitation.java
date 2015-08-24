package br.copacabana.usecase.invitation;

import java.io.IOException;
import java.util.logging.Logger;

import javax.persistence.NoResultException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.datanucleus.store.query.QueryNotUniqueException;

import br.com.copacabana.cb.entities.Invitation;
import br.copacabana.Authentication;
import br.copacabana.exception.DataNotFoundException;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.UserBeanManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class SendInvitation extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.Servlet");
	private static final long serialVersionUID = -1728741555294038514L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			String[] mails = req.getParameterValues("toEmail");
			String[] names = req.getParameterValues("toName");
			UserBeanManager uman = new UserBeanManager();
			InvitationManager invMan = new InvitationManager();
			StringBuilder sb = new StringBuilder();
			Key userId = Authentication.getLoggedUserKey(req.getSession());
			for (int i = 0; i < mails.length; i++) {
				String receiverMail = mails[i];
				String receiverName = names[i];
		
				// It only makes sense if receiver's mail is valid.
				if (isValid(receiverMail)) {
					Invitation invitation = null;
					boolean mustCreate = true;
					
					try {
						if (uman.getByLogin(receiverMail) != null) {
							sb.append(receiverMail + " j&aacute; est&aacute; cadastrado no ComendoBem.<Br>");
						}
					} catch (DataNotFoundException e) { // Ready to go, send the														// mail

						
						try {
							invitation = invMan.getMyInvitationByInviteeEmail(receiverMail, userId);
							if (invitation != null) {
								mustCreate = false;
							}
						} catch (NoResultException ee) {

						}catch (QueryNotUniqueException e2) {
							log.severe("Errado, mais de um convite pro mesmo cara");
							continue;
						}
						if (mustCreate) {
							log.info("Creating invitation ");
							invitation = invMan.createInvitation(userId, receiverMail, receiverName);
						}
						log.info("Sending invitation email");
						Queue queue = QueueFactory.getQueue("mailer");
						queue.add(TaskOptions.Builder.withUrl("/task/sendMail").param("id", invitation.getId().toString()).param("type", "invite").method(Method.GET));
					}
				}
				req.setCharacterEncoding("UTF-8");
				req.setAttribute("msgs", sb.toString());
				resp.setContentType("text/html; charset=UTF-8");

				req.getRequestDispatcher("/meusConvidados").forward(req, resp);
			}

		} catch (JsonException e) {
			e.printStackTrace();
			resp.sendError(HttpServletResponse.SC_FORBIDDEN);
		}
	}

	/**
	 * Validate string (not null, not empty).
	 * 
	 * @param name
	 *            String to be validated.
	 * @return true if not null nor empty.
	 */
	private boolean isValid(String name) {
		return (null != name && !name.isEmpty());
	}
}
