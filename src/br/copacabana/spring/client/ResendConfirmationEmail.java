package br.copacabana.spring.client;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Client;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class ResendConfirmationEmail extends RetrieveCommand<String> implements SessionCommand {
	private HttpSession session;

	@Override
	public void execute() throws Exception {
		Key clientKey = Authentication.getLoggedUserKey(session);
		Client client = new ClientManager().get(clientKey);
		Queue queue = QueueFactory.getQueue("mailer");
		
		queue.add(TaskOptions.Builder.withUrl("/task/sendMail").param("id", KeyFactory.keyToString(clientKey)).param("type", "confirmEmail").method(Method.GET));
		this.entity=client.getUser().getLogin();
		session.removeAttribute("USER_MUST_VERIFY_EMAIL");
		session.removeAttribute("ConfEmailWarnMessage");
	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}
}
