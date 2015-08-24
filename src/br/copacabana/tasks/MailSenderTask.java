package br.copacabana.tasks;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Invitation;
import br.com.copacabana.cb.entities.InvitationState;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.UserBeanManager;
import br.copacabana.usecase.invitation.InvitationManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class MailSenderTask extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.Servlet");

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		this.doGet(req, resp);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			br.copacabana.MailSender ms = new br.copacabana.MailSender();
			ConfigurationManager cm = new ConfigurationManager();
			Configuration confEmail = cm.find("contactEmail", Configuration.class);
			String systemEmail = "contato@comendobem.com.br";
			if (confEmail != null) {
				systemEmail = confEmail.getValue();
			}
			if (req.getParameter("type") != null) {
				String type = req.getParameter("type");

				if ("syserror".equals(type)) {
					ms.sendFromSystemEmail(systemEmail, "Erro no sistema", req.getParameter("msg"));
				} else if ("invite".equals(type)) {
					InvitationManager invMan = new InvitationManager();
					Invitation invitation = invMan.getInvitation(Long.parseLong(req.getParameter("id")));

					String kind = invitation.getFrom().getKind();
					String name = "";
					UserBean user = null;
					if (kind.equals("CLIENT")) {
						Client c = new ClientManager().get(invitation.getFrom());
						name = c.getName();
						user = c.getUser();
					} else if (kind.equals("RESTAURANT")) {
						Restaurant c = new RestaurantManager().get(invitation.getFrom());
						name = c.getName();
						user = c.getUser();
					}
					String msg = this.prepareInvitationMsg(invitation, name, user.getLogin());
					String subject = this.prepareInvitationSubject(invitation, name);
					ms.sendEmail(systemEmail, name, user.getLogin(), name, invitation.getEmail(), invitation.getName(), subject, msg);
					invitation.setStatus(InvitationState.SENT);
					invMan.persist(invitation);

				} else if ("confirmEmail".equals(type)) {
					Key clientKey = KeyFactory.stringToKey(req.getParameter("id"));
					Client c = new ClientManager().get(clientKey);
					StringBuilder sb = new StringBuilder();
					ResourceBundle bundle = ResourceBundle.getBundle("messages");
					String subj = bundle.getString("confirmEmail.email.subject");
					String body = bundle.getString("confirmEmail.email.body");
					Object[] params = new Object[4];
					params[0] = c.getName();
					params[1] = "http://www.comendobem.com.br/confirmaEmail.do?cid=" + c.getIdStr();					
					body=MessageFormat.format(body, params);
					ms.sendEmail(systemEmail, "Site ComendoBem",systemEmail,"Site ComendoBem",c.getUser().getLogin(), c.getName(), subj, body);

				}else if("directMail".equals(type)){
					String to = req.getParameter("to");
					String toName = req.getParameter("toName");
					String from = req.getParameter("from");
					String fromName = req.getParameter("fromName");
					String subj = req.getParameter("subject");
					String body = req.getParameter("text");
					ms.sendEmail(from, fromName,from,fromName,to, toName, subj, body);
				}else if("pwdReminder".equals(type)){
					UserBean user = new UserBeanManager().get(KeyFactory.stringToKey(req.getParameter("user")));
					String token = req.getParameter("token");
					String prAuthId = req.getParameter("i");
					String msg = this.preparePwdReminderMsg(user, token, prAuthId);
					String subject = "Re-gerar senha ComendoBem";
					String from = "contato@comendobem.com.br";
					String alias = "ComendoBem senha";					
					ms.sendEmail(from, alias,from,alias,user.getLogin(), user.getLogin(), subject, msg);					
				}

			} else {
				String to = req.getParameter("to");
				String from = req.getParameter("from");
				String msg = req.getParameter("msg");
				String sub = req.getParameter("sub");
				ms.sendEmail(from, from, from, from, to, to, sub, msg);
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to execute mail task", e);
		}

	}
	private String preparePwdReminderMsg(UserBean u, String token, String prAuthId) {
		StringBuilder sb = new StringBuilder();
		ResourceBundle bundle = ResourceBundle.getBundle("messages");
		String str = bundle.getString("email.password.regen");
		Object[] params = new Object[3];
		
		params[0] = "";
		params[1] = token;
		params[2] = prAuthId;
		sb.append(MessageFormat.format(str, params));
		return sb.toString();
	}
	private String prepareInvitationSubject(Invitation invitation, String senderName) {
		StringBuilder sb = new StringBuilder("Convite de ").append(senderName).append(" para o ComendoBem");
		return sb.toString();
	}

	private String prepareInvitationMsg(Invitation invitation, String name, String senderEmail) {
		StringBuilder sb = new StringBuilder();
		ResourceBundle bundle = ResourceBundle.getBundle("messages");
		String header = bundle.getString("invitation.email.header");
		String body = bundle.getString("invitation.email.body");
		Object[] params = new Object[4];
		params[3] = invitation.getName();
		params[0] = name;
		params[1] = senderEmail;
		params[2] = "http://www.comendobem.com.br/convite/confirma/?convite=" + invitation.getId();
		sb.append(header);
		sb.append(MessageFormat.format(body, params));

		return sb.toString();
	}

}
