package br.copacabana;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.marshllers.KeyWrapperSerializer;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.ClientManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class ListClientAddressesCommand extends RetrieveCommand<List<Address>> implements GsonSerializable {

	

	@Override
	public void execute() {
		// /JPAManager<Client> cpa = new
		// JPAManager<Client>(manager.getEntityManagerBean());
		Client c = (Client) new ClientManager().get(KeyFactory.stringToKey((String) getId()));

		AddressManager addMan = new AddressManager();
		entity = new ArrayList<Address>();
		for (Iterator iterator = c.getAddresses().iterator(); iterator.hasNext();) {
			Key type = (Key) iterator.next();
			Address add = addMan.get(type);
			add.getNeighborhood().getCity().getId();
			add.getNeighborhood().getCity().getName();
			add.getNeighborhood().getName();
			entity.add(add);

		}
		// TODO try to find a better way of eager loading the embedded entities
		// for (Iterator iterator = c.getAddresses().iterator();
		// iterator.hasNext();) {
		// Address type = (Address) iterator.next();
		// type.getNeighborhood().getK();
		// type.getCity().getK();
		// }
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(KeyWrapper.class, new KeyWrapperSerializer());
		return m;
	}
}
