package br.copacabana;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.ClientManager;

import com.google.appengine.api.datastore.KeyFactory;

/**
 * Executes the logic of load an entity from the persistent layer.
 * 
 * @author Rafael Coutinho
 */
public class RetrieveClientCommand extends RetrieveCommand<Client> {
	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		ClientManager jpaman = new ClientManager();
		entity = (Client) jpaman.get(KeyFactory.stringToKey((String) this.getId()));

		this.setEntity(entity);

	}

}
