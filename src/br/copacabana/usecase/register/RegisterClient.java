package br.copacabana.usecase.register;

import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.ContactInfo;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class RegisterClient implements Command, ReturnValueCommand, SessionCommand {
	protected static final Logger log = Logger.getLogger("copacabana.Controllers");
	private HttpSession session;
	private String name;
	private Long invitationId;

	private UserBean user = new UserBean();
	private ContactInfo contact = new ContactInfo();
	private Boolean receiveNewsletter = Boolean.TRUE;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	@Override
	public Object getEntity() {
		return createdClient;
	}

	Client createdClient;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		Client c = new Client();
		c.setName(name);
		c.setReceiveNewsletter(receiveNewsletter);
		c.setUser(user);
		c.setContact(contact);
		String referredFrom = (String) session.getAttribute("refererInfo");
		c.setReferredFrom(referredFrom);
		ClientManager cman = new ClientManager();
		c = cman.create(c);
		
		onNewClientRegistered(c.getUser().getLogin(), invitationId);
		createdClient = c;
	}
	public static void onNewClientRegistered(String email, Long invitationId){
		onNewClientRegistered(email, invitationId, Boolean.FALSE, null);
	}
	public static void onNewClientRegistered(String email, Long invitationId,Boolean isFacebook, String inviter){
			
		
		try {
			Queue queue = QueueFactory.getDefaultQueue();
			TaskOptions task = TaskOptions.Builder.withUrl("/tasks/newRegisteredClient.do").param("login", email).method(Method.POST);
			if(invitationId!=null){
				task.param("invitationId", invitationId.toString());
			}
			if(inviter!=null){
				task.param("inviter", inviter);
			}
			if(isFacebook!=null){
				task.param("thruFacebook", isFacebook.toString());
			}
			queue.add(task);
			
		} catch (Exception e) {
			log.log(Level.SEVERE, "Could not add to the new client queue", e);
		}

	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public UserBean getUser() {
		return user;
	}

	public void setUser(UserBean user) {
		this.user = user;
	}

	public ContactInfo getContact() {
		return contact;
	}

	public void setContact(ContactInfo contact) {
		this.contact = contact;
	}

	public Boolean getReceiveNewsletter() {
		return receiveNewsletter;
	}

	public void setReceiveNewsletter(Boolean receiveNewsletter) {
		this.receiveNewsletter = receiveNewsletter;
	}

	public Long getInvitationId() {
		return invitationId;
	}

	public void setInvitationId(Long invitationId) {
		this.invitationId = invitationId;
	}

}
