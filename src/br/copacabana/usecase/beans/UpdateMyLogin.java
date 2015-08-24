package br.copacabana.usecase.beans;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.UserBean;
import br.copacabana.Authentication;
import br.copacabana.AuthenticationController;
import br.copacabana.RetrieveCommand;
import br.copacabana.exception.DataNotFoundException;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class UpdateMyLogin extends RetrieveCommand<String> implements SessionCommand {
	HttpSession session;
	String email;
	String user;
	Boolean update;

	@Override
	public void execute() throws Exception {
		Key clientId = Authentication.getLoggedUserKey(session);
		ClientManager cm = new ClientManager();
		Client c = cm.get(clientId);
		if (update == false) {
			try {
				cm.getByLogin(email);
				log.severe("User has 2 accounts, one with facebook and another without it");
				this.entity = "fail";
				return;
			} catch (DataNotFoundException e) {

			}
		}
		
		UserBean ub = c.getUser();
		ub.setLogin(email);
		Datastore.getPersistanceManager().getTransaction().begin();
		cm.persist(c);
		Datastore.getPersistanceManager().getTransaction().commit();
		Authentication auth = new Authentication();
		auth.setUserType("client");
		auth.setSession(session);
		JsonObject fbuser = new JsonParser().parse(user).getAsJsonObject();
		auth.handleFBUserData(fbuser, false);
		AuthenticationController.setSessionValues(auth, session);
		session.removeAttribute("USER_MUST_VERIFY_EMAIL");
		session.removeAttribute("ConfEmailWarnMessage");
		this.entity = "ok";
		

	}

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Boolean getUpdate() {
		return update;
	}

	public void setUpdate(Boolean update) {
		this.update = update;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

}
