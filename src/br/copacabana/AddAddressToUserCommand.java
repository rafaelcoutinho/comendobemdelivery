package br.copacabana;

import java.util.List;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class AddAddressToUserCommand implements SessionCommand, Command, ReturnValueCommand {

	private Address address = new Address();
	private HttpSession session;
	public Key kk;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		Key userK = null;
		if (kk != null) {
			userK = kk;
		} else {
			userK = Authentication.getLoggedUserKey(session);
		}
		AddressManager addman = new AddressManager();
		if (address.getId() == null) {
			Address novo = addman.createAddres(address);			

			ClientManager cm = new ClientManager();
			Client c = cm.find(userK, Client.class);
			if(c.getContact().getPhone()==null||c.getContact().getPhone().length()==0){
				c.getContact().setPhone(novo.getPhone());
			}
			List<Key> list = c.getAddresses();

			list.add(novo.getId());
			cm.persist(c);
			this.address = novo;
		} else {			
			this.address = addman.changeAddress(address);
		}
		

	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	@Override
	public Object getEntity() {

		return getAddress();
	}

}
