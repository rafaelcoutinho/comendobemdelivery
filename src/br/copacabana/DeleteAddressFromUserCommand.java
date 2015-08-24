package br.copacabana;

import java.util.List;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class DeleteAddressFromUserCommand implements SessionCommand, Command {
	public DeleteAddressFromUserCommand() {

	}

	private String id;
	private String userId;
	private HttpSession session;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		try {
			Key userK = null;
			if (userId == null) {
				userK = Authentication.getLoggedUserKey(session);
			}
			ClientManager cm = new ClientManager();
			Client c = cm.get(userK);

			List<Key> list = c.getAddresses();

			Key addKey = KeyFactory.stringToKey(getId());
			list.remove(addKey);
			c.setAddresses(list);
			// TODO maybe it's better to leave the address forever here.
			// because it is linked to the order (else we would need to create
			// one address for each order.
			// manager.delete(manager.find(addKey, Address.class));
			cm.update(c);

		} catch (Exception e) {
			// rollback transaction??!
			e.printStackTrace();
		}

	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}
}
