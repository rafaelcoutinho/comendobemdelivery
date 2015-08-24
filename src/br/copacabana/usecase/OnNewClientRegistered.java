package br.copacabana.usecase;

import java.text.MessageFormat;
import java.util.Iterator;
import java.util.List;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Invitation;
import br.com.copacabana.cb.entities.InvitationState;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.MailSender;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.usecase.invitation.InvitationManager;
import br.copacabana.usecase.invitation.NewsletterManager;

import com.google.appengine.api.datastore.Key;

public class OnNewClientRegistered extends RetrieveCommand {
	protected static final Logger log = Logger.getLogger("copacabana.Monitors");
	public static final String CLIENT_SUBJECT = "Seja Bem-vindo ao ComendoBem";
	public static final String CLIENT_MSG = "Ol&aacute; %s,<br /><br />Seja Bem-vindo ao ComendoBem o site delivery mais gostoso da internet.<br />Obrigado por usar nosso servi&ccedil;o.<br /><br />Atenciosamente,<br />Equipe ComendoBem<br /><img src=\"http://www.comendobem.com/resources/img/logo.png\" width=\"100\" />";
	private String login;
	private Long invitationId;
	private Key inviter;
	private Boolean thruFacebook = Boolean.FALSE;
	@Override
	public void execute(Manager manager) throws Exception {
		ClientManager clientMan = (ClientManager) manager;
		MailSender ms = new MailSender();

		log.log(Level.FINE, "New client registered login {0}", login);

		ConfigurationManager cm = new ConfigurationManager();
		String subject = cm.getConfigurationValue("welcome.client.email.subject");
		if (subject == null || subject.length() == 0) {
			subject = CLIENT_SUBJECT;
		}

		ResourceBundle bundle = ResourceBundle.getBundle("messages");
		String body = bundle.getString("welcome.email.body");
		String partToConfirm = bundle.getString("welcome.email.part.confirm");
		
		Client c = clientMan.getByLogin(login);
		Object[] params = new Object[2];
		params[0] = c.getName();
		if(Boolean.TRUE.equals(thruFacebook)){
			params[1]="";
		}else{			
			params[1] = MessageFormat.format(partToConfirm, "http://www.comendobem.com.br/confirmaEmail.do?cid=" + c.getIdStr());
		}
		body = MessageFormat.format(body, params);

		ms.sendFromSystemEmail(login, subject, body);
		checkIfAnyInvitation(login);
		removeFromNotRegisteredUserNewsletter(login);
		
		InvitationManager invMan = new InvitationManager();
		if (invitationId != null) {			
			invMan.confirmInvitation(invitationId);
		}
		if(inviter!=null){
			Invitation invitation =  invMan.createInvitation(inviter, login, c.getName());
			invMan.confirmInvitation(invitation.getId());
			
		}

	}

	private void removeFromNotRegisteredUserNewsletter(String login2) {
		NewsletterManager nsman = new NewsletterManager();

		nsman.removeEntry(login2);

	}

	private void checkIfAnyInvitation(String login2) {
		InvitationManager invMan = new InvitationManager();
		List<Invitation> invitations = invMan.getNotConfirmedInvitationsToEmail(login2);
		for (Iterator iterator = invitations.iterator(); iterator.hasNext();) {
			Invitation invitation = (Invitation) iterator.next();
			invitation.setStatus(InvitationState.EXPIRED);
		}

	}

	public String getLogin() {
		return login;
	}

	public void setLogin(String login) {
		this.login = login;
	}

	public Long getInvitationId() {
		return invitationId;
	}

	public void setInvitationId(Long invitationId) {
		this.invitationId = invitationId;
	}

	public Key getInviter() {
		return inviter;
	}

	public void setInviter(Key inviter) {
		this.inviter = inviter;
	}

	public Boolean getThruFacebook() {
		return thruFacebook;
	}

	public void setThruFacebook(Boolean thruFacebook) {
		this.thruFacebook = thruFacebook;
	}

}
