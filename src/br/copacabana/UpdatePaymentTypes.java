package br.copacabana;

import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;

public class UpdatePaymentTypes implements Command, SessionCommand {
	private Set<String> acceptablePayments = new HashSet<String>();

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		JsonObject loggedUser = Authentication.getLoggedUser(session);
		String id = ((JsonObject) loggedUser.get("entity")).get("id").getAsString();
		String entityType = loggedUser.get("userType").getAsString();
		UserBean currentUser;
		if (entityType.equals("restaurant")) {
			RestaurantManager rman = new RestaurantManager();
			Restaurant r = (Restaurant) rman.get(KeyFactory.stringToKey(id));
			r.setAcceptablePayments(acceptablePayments);
			rman.persist(r);
			// System.out.println(acceptablePayments);
		}

	}

	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	public Set<String> getAcceptablePayments() {
		return acceptablePayments;
	}

	public void setAcceptablePayments(Set<String> acceptablePayments) {
		this.acceptablePayments = acceptablePayments;
	}
}
