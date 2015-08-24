package br.copacabana;

import br.com.copacabana.cb.entities.mgr.Manager;

public class JsonDeleteCommand extends PersistCommand {

	

	public JsonDeleteCommand(Object entity) {
		super(entity);

	}

	@Override
	public void execute(Manager manager) throws Exception {		
		manager.delete(entity);

	}

}
