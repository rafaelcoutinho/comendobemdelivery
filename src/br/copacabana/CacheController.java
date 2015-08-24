package br.copacabana;

import java.util.Collections;
import java.util.HashMap;

import javax.cache.Cache;
import javax.cache.CacheException;
import javax.cache.CacheManager;

public class CacheController {
	private static Cache cache = null;

	public static synchronized Cache getCache() {
		if (cache == null) {

			try {
				cache = CacheManager.getInstance().getCacheFactory().createCache(Collections.emptyMap());
			} catch (CacheException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return cache;
	}

	public static void invalidateCache(String string, String keyToString) {
		Cache cache = CacheController.getCache();
		JsonViewItemFileReadStoreController.invalidateCacheValue(string, keyToString);

	}

	public static void clear() {

		CacheController.getCache().remove("AtomXML");
		CacheController.getCache().clear();
		// in order to keep the initial ones
		// check spring-servletXML for all the needed caches to init.
		// all the jsonCacheName names must be here too.
		CacheController.getCache().put("listNeighborsByCityItemFileReadStore", new HashMap<String, String>());
		CacheController.getCache().put("listRestaurantPlatesFast", new HashMap<String, String>());
		CacheController.getCache().put("listRestaurantHighlightPlatesFast", new HashMap<String, String>());

	}
}
