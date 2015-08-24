package br.copacabana;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.PwdResetAuthorization;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.com.copacabana.cb.entities.mgr.PasswordManager;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.UserBeanManager;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class StartPasswordRegen implements Command, SessionCommand {
	String email = "";
	HttpSession session;

	public void execute() throws Exception {
		UserBeanManager um = new UserBeanManager();
		UserBean u = um.getByLogin(email);
		// GENERATE one here

		PasswordManager pm = new PasswordManager();
		PwdResetAuthorization pra = new PwdResetAuthorization(u.getId());
		Datastore.getPersistanceManager().getTransaction().begin();
		pm.persist(pra);
		Datastore.getPersistanceManager().getTransaction().commit();

		String token = pm.getAuthorizationToken(pra);
		Queue queue = QueueFactory.getQueue("mailer");
		queue.add(TaskOptions.Builder.withUrl("/task/sendMail").param("type", "pwdReminder").param("token", token).param("i", pra.getId().toString()).param("user", KeyFactory.keyToString(u.getId())).method(Method.GET));
		

	}

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
