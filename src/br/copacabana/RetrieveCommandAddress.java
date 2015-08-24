package br.copacabana;

import java.util.logging.Level;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.AddressManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

/**
 * Executes the logic of load an entity from the persistent layer.
 * 
 * @author Rafael Coutinho
 */
public class RetrieveCommandAddress extends RetrieveCommand<br.com.copacabana.cb.entities.Address> {

	public void execute(Manager manager) throws Exception {

		try {
			Key k = KeyFactory.stringToKey(getId().toString());
			entity = new AddressManager().get(k);	
			entity.getNeighborhood().getName();
			entity.getNeighborhood().getCity().getName();
		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to retrieve address with id:{0}. {1}", new Object[] { getId(), e });
			throw e;
		}

	}
}
