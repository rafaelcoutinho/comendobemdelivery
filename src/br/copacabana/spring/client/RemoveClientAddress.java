package br.copacabana.spring.client;

import java.util.List;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class RemoveClientAddress extends RetrieveCommand implements SessionCommand {
	private Key addKey;
	private HttpSession session;

	@Override
	public void execute(Manager manager) throws Exception {
		try {
			Key userK = Authentication.getLoggedUserKey(session);

			ClientManager cm = new ClientManager();
			Client c = cm.get(userK);
			List<Key> list = c.getAddresses();
			list.remove(addKey);
			c.setAddresses(list);
			// TODO maybe it's better to leave the address forever here.
			// because it is linked to the order (else we would need to create
			// one
			// address for each order.
			// manager.delete(manager.find(addKey, Address.class));
			cm.update(c);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	public Key getAddKey() {
		return addKey;
	}

	public void setAddKey(Key addKey) {
		this.addKey = addKey;
	}

}
