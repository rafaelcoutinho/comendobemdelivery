package br.copacabana;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.raw.filter.Datastore;

/**
 * @author Rafael Coutinho
 */
public class PersistCommand<E> implements Command<E> {
	protected E entity = null;
	private Object id;

	public PersistCommand(E entity) {
		this.entity = entity;
	}

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {

		Datastore.getPersistanceManager().persist(entity);

	}

	public void setEntity(E entity) {
		this.entity = entity;
	}

	public Object getId() {
		// TODO Auto-generated method stub
		return entity;
	}

}
