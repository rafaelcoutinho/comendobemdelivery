package br.copacabana.usecase;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.RestPlateHighlights;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.GsonSerializable;
import br.copacabana.RetrieveCommand;
import br.copacabana.marshllers.PlateWrapperSerializer;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.usecase.menu.RestMenuBean;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class ListRestaurantHighlightsPlates extends RetrieveCommand<RestMenuBean> implements GsonSerializable {

	Key key;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	public void execute() throws Exception {
		PlateManager plateManager = new PlateManager();
		log.info("Rest key: "+key);
		log.info("Rest key: "+KeyFactory.keyToString(key));
		RestPlateHighlights high = plateManager.getRestaurantPlateHighlighs(key);
		Map<String, Object> m = new HashMap<String, Object>();
		
		Restaurant r = new RestaurantManager().getRestaurant(key);
		log.info("Rest obj: "+r);
		log.info("Rest obj: "+r.getName());
		m.put("restaurant", r);
		List<Plate> ps = plateManager.list("getPlateByRestaurantOrderedByName", m);
		Key[] highPlates = high.getPlates().toArray(new Key[high.getPlates().size()]);
		RestMenuBean bean = new RestMenuBean(highPlates, ps);
		this.entity = bean;

	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(Plate.class, new PlateWrapperSerializer());
		return m;
	}

	public Key getKey() {
		return key;
	}

	public void setKey(Key key) {
		this.key = key;
	}

}
