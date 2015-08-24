package br.copacabana.usecase;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.Restaurant.SiteStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.Command;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;
import com.google.gson.JsonObject;

public class ChangeRestDelayCommand implements Command, ReturnValueCommand, SessionCommand {

	private String currentDelay;
	private String status = "fail";
	private HttpSession session = null;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		Key restId = Authentication.getLoggedUserKey(session);
		if (restId == null) {
			throw new JsonException("Must be authenticated");
		}
		RestaurantManager restMan = new RestaurantManager();
		Restaurant r = restMan.getRestaurant(restId);
		if (currentDelay.equals(SiteStatus.TEMPUNAVAILABLE.name())) {
			r.setSiteStatus(SiteStatus.TEMPUNAVAILABLE);
		} else {
			if (r.getSiteStatus().equals(SiteStatus.TEMPUNAVAILABLE)) {
				r.setSiteStatus(SiteStatus.ACTIVE);
			}
			r.setCurrentDelay(currentDelay);
		}

		restMan.persist(r);
		JsonObject json = Authentication.getLoggedUser(session);
		json.add("entity", Authentication.getRestJsonData(r));
		session.setAttribute("loggedUser", json.toString());
		status = "ok";
	}

	@Override
	public Object getEntity() {
		return status;
	}

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	public String getCurrentDelay() {
		return currentDelay;
	}

	public void setCurrentDelay(String currentDelay) {
		this.currentDelay = currentDelay;
	}

}
