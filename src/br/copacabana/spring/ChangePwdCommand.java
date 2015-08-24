package br.copacabana.spring;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class ChangePwdCommand extends RetrieveCommand implements SessionCommand {
	private HttpSession session;

	private String currentPwd;
	private String newPwd;

	public HttpSession getSession() {
		return session;
	}

	public void setSession(HttpSession session) {
		this.session = session;
	}

	@Override
	public void execute() throws Exception {

		Authentication.validatePassword(newPwd);
		JsonObject loggedUser = Authentication.getLoggedUser(session);
		String id = ((JsonObject) loggedUser.get("entity")).get("id").getAsString();
		String entityType = loggedUser.get("userType").getAsString();
		UserBean currentUser;
		if (entityType.equals("restaurant")) {
			RestaurantManager rm = new RestaurantManager();
			Restaurant r = rm.find(KeyFactory.stringToKey(id), Restaurant.class);
			currentUser = r.getUser();
			if (!currentUser.getPassword().equals(currentPwd)) {
				throw new JsonException("passwordDontMatch", JsonException.ErrorCode.OLDPWDDOESNTMATCH);
			}

			currentUser.setPassword(newPwd);
			r.setUser(currentUser);
			rm.update(r);

		} else if (entityType.equals("central")) {
			CentralManager rm = new CentralManager();
			Central r = rm.get(KeyFactory.stringToKey(id));
			currentUser = r.getUser();
			if (!currentUser.getPassword().equals(currentPwd)) {
				throw new JsonException("passwordDontMatch", JsonException.ErrorCode.OLDPWDDOESNTMATCH);
			}

			currentUser.setPassword(newPwd);
			r.setUser(currentUser);
			rm.update(r);

		} else {
			ClientManager cm = new ClientManager();
			Client r = cm.get(KeyFactory.stringToKey(id));
			currentUser = r.getUser();
			if (!currentUser.getPassword().equals(currentPwd)) {
				throw new JsonException("passwordDontMatch", JsonException.ErrorCode.OLDPWDDOESNTMATCH);
			}

			currentUser.setPassword(newPwd);
			r.setUser(currentUser);
			cm.update(r);

		}

	}

	public String getCurrentPwd() {
		return currentPwd;
	}

	public void setCurrentPwd(String currentPwd) {
		this.currentPwd = currentPwd;
	}

	public String getNewPwd() {
		return newPwd;
	}

	public void setNewPwd(String newPwd) {
		this.newPwd = newPwd;
	}

	@Override
	public Object getEntity() {
		JsonObject ob = new JsonObject();
		ob.add("changePwd", new JsonPrimitive(true));
		return ob;
	}

}
