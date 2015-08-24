package br.copacabana.usecase;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;

import com.google.appengine.api.datastore.Key;

public class HandleAddressDeletionCommand extends RetrieveCommand {
	private Key addKey;

	@Override
	public void execute(Manager manager) throws Exception {
		System.err.println("Deveria apagar? " + addKey);
	}

	public Key getAddKey() {
		return addKey;
	}

	public void setAddKey(Key addKey) {
		this.addKey = addKey;
	}
}
