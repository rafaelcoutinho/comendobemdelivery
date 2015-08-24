package br.copacabana;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.mgr.Manager;

import com.google.appengine.api.datastore.Key;

public class ListCommandFilteredBy extends ListCommand implements CacheableCommand {
	private String queryName;
	private String queryItemId;
	private Key key;
	private String staticParams;
	private String staticField;	
	private String queryItemClass;

	protected static final Logger logcache = Logger.getLogger("copacabana.Caches");
	

	public void execute(Manager manager) throws Exception {
		
//		Cache cache = CacheController.getCache();
//		if (cacheName != null) {
//			entity = (String) cache.get(cacheName);
//			if (logcache.isLoggable(Level.INFO)) {
//				if (entity != null) {
//					logcache.log(Level.INFO, "Cache hit for {0}:{1}!", new String[]{cacheName,KeyFactory.keyToString(key)});
//					
//				} else {
//					logcache.log(Level.INFO, "Cache miss for {0}:{1}!", new String[]{cacheName,KeyFactory.keyToString(key)});
//
//				}
//			}
//		}
		
		if (entity == null) {
			if (queryItemId != null && queryItemId.length() != 0) {
				Map<String, Object> m = new HashMap<String, Object>();
				m.put(queryItemId, getKey());
				if (queryItemClass == null) {
					m.put(queryItemId, getKey());
				} else {
					Object obj = manager.find(getKey(), Class.forName(queryItemClass));
					m.put(queryItemId, obj);
				}

				entity = (Collection) manager.list(queryName, m);

			} else {
				if (staticField != null && !staticField.equals("")) {
					String[] params = staticParams.split(",");
					Collection a = new ArrayList();
					Map<String, Object> m = new HashMap<String, Object>();
					m.put(staticField, params[0]);
					a.addAll((Collection) manager.list(queryName, m));
					for (int i = 1; i < params.length; i++) {
						m.put(staticField, params[i]);
						a.addAll((Collection) manager.list(queryName, m));
					}
					entity = a;
				} else {
					entity = (Collection) manager.list(queryName);
				}
			}
			
		}
		
//		if (cacheName != null) {
//			cache.put(cacheName, entity);
//		}
	}

	public void setQueryName(String queryName) {
		this.queryName = queryName;

	}

	public void setQueryItemId(String queryItemId) {
		this.queryItemId = queryItemId;

	}

	public Key getKey() {
		return key;
	}

	public void setKey(Key key) {
		this.key = key;
	}

	public String getQueryName() {
		return queryName;
	}

	public String getQueryItemId() {
		return queryItemId;
	}

	public String getStaticParams() {
		return staticParams;
	}

	public void setStaticParams(String staticParams) {
		this.staticParams = staticParams;
	}

	public String getStaticField() {
		return staticField;
	}

	public void setStaticField(String staticField) {
		this.staticField = staticField;
	}

	public String getCacheName() {
		return cacheName;
	}

	public void setCacheName(String cacheName) {
		this.cacheName = cacheName;
	}

	public String getQueryItemClass() {
		return queryItemClass;
	}

	public void setQueryItemClass(String queryItemClass) {
		this.queryItemClass = queryItemClass;
	}
}
