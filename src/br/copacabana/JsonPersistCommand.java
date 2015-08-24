package br.copacabana;

import br.com.copacabana.cb.entities.mgr.Manager;

/**
 * @author Rafael Coutinho
 */
public class JsonPersistCommand<E> extends PersistCommand<E> {

	private E id;

	public JsonPersistCommand(E entity) {
		super(entity);

	}

	public void execute(Manager manager) throws Exception {

		entity = (E) manager.persist(entity);

	}

	public Object getEntity() {
		return entity;
	}

}
