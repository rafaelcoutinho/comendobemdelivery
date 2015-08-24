package br.copacabana;

import java.util.ArrayList;
import java.util.List;

import javax.cache.Cache;

import br.com.copacabana.cb.entities.mgr.Manager;

/**
 * Executes the logic of load an entity from the persistent layer.
 * 
 * @author Rafael Coutinho
 */
public class ListCommand<Collection> extends RetrieveCommand<Collection> implements CacheableCommand {
	protected String cacheName;
	private Manager manager;
	public void execute(Manager manager) throws Exception {
		this.manager=manager;
		this.execute();
	}
	public void execute() throws Exception {
		Cache cache = CacheController.getCache();
		if (cacheName != null) {
			entity = (Collection) cache.get(cacheName);
		}
		if (entity == null) {
			entity = (Collection) manager.list();

			if (cacheName != null) {
				List cachelist = new ArrayList();
				cachelist.addAll((java.util.Collection) entity);
				cache.put(cacheName, cachelist);
			}
		}

	}

	@Override
	public void setCache(String session) {
		this.cacheName = session;

	}

}
