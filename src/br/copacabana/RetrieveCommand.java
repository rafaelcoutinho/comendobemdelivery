package br.copacabana;

import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

/**
 * Executes the logic of load an entity from the persistent layer.
 * 
 * @author Rafael Coutinho
 */
public class RetrieveCommand<E> implements Command<E> {
	private Object id;

	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	public Object getId() {
		return id;
	}

	public void setId(Object id) {
		this.id = id;
	}

	protected E entity = null;

	public E getEntity() {
		return entity;
	}

	private String className;

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	protected void setEntity(Object entity) {
		this.entity = (E) entity;
	}

	public void execute() throws Exception {

		try {
			if (log.isLoggable(Level.FINE)) {
				log.log(Level.FINE, "Retrieve {0} with id {1}", new Object[] { className, id });
			}
			Key k = KeyFactory.stringToKey(id.toString());
			entity = (E) Datastore.getPersistanceManager().find(getClass().forName(className), id);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "error {0} ", e);
		} catch (Exception e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "Faled to retrieve ${0} with id {1} = {2]", new Object[] { className, id, e });
			throw e;
		}

	}

	@Override
	public void execute(Manager m) throws Exception {

		execute();

	}

}
