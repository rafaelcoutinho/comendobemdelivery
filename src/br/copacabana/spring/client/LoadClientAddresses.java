package br.copacabana.spring.client;

import java.util.Iterator;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class LoadClientAddresses extends RetrieveCommand<ClientAddressBean> implements SessionCommand {
	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		session = s;
	}

	@Override
	public void execute(Manager manager) throws Exception {
		Key userK = Authentication.getLoggedUserKey(session);
		ClientManager cm = (ClientManager) manager;
		Client client = cm.get(userK);
		AddressManager addManager = new AddressManager();

		ClientAddressBean clientAddressBean = new ClientAddressBean(client);
		for (Iterator<Key> iterator = client.getAddresses().iterator(); iterator.hasNext();) {
			Key addK = iterator.next();
			Address address = addManager.getAddress(addK);
			clientAddressBean.addAddress(new AddressBean(address));
		}
		System.out.println("Total enderecos " + client.getAddresses().size());
		this.entity = clientAddressBean;
	}
}
