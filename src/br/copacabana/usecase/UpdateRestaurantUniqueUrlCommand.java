package br.copacabana.usecase;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.com.copacabana.web.UniqueUrlFilter;
import br.copacabana.Authentication;
import br.copacabana.Command;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class UpdateRestaurantUniqueUrlCommand implements Command, ReturnValueCommand, SessionCommand {

	private String newUrlName;
	private String status = "fail";
	private HttpSession session = null;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		if (newUrlName == null || newUrlName.trim().length() == 0) {
			throw new JsonException("Must not be null");
		}
		newUrlName = newUrlName.trim();
		if (newUrlName.indexOf(' ') > -1) {
			throw new JsonException("Must not have spaces in it");
		}
		Key restId = Authentication.getLoggedUserKey(session);
		if (restId == null) {
			throw new JsonException("Must be authenticated");
		}
		RestaurantManager restMan = new RestaurantManager();
		String oldUrl = restMan.getRestaurant(restId).getUniqueUrlName();
		restMan.updateUniqueUrl(restId, newUrlName);
		UniqueUrlFilter.replace(oldUrl, newUrlName);
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

	public String getNewUrlName() {
		return newUrlName;
	}

	public void setNewUrlName(String newUrlName) {
		this.newUrlName = newUrlName;
	}
}
