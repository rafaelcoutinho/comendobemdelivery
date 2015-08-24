package br.copacabana;

import java.util.HashMap;
import java.util.Map;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.WorkingHours;
import br.com.copacabana.cb.entities.WorkingHours.DayOfWeek;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class GetWorkingHoursCommand extends RetrieveCommand<Map<DayOfWeek,WorkingHours>> {
	
	@Override
	public void execute(Manager manager) throws Exception {
		RestaurantManager r = (RestaurantManager) manager;
		Key k =KeyFactory.stringToKey(this.getId().toString());
		Restaurant rest=r.find(k, Restaurant.class);
		Map<DayOfWeek,WorkingHours> map = new HashMap<DayOfWeek, WorkingHours>(8);
		map.put(rest.getMon().getDay(), rest.getMon());
		map.put(rest.getSun().getDay(), rest.getSun());
		map.put(rest.getTue().getDay(), rest.getTue());
		map.put(rest.getWed().getDay(), rest.getWed());
		map.put(rest.getThu().getDay(), rest.getThu());
		map.put(rest.getFri().getDay(), rest.getFri());
		map.put(rest.getSat().getDay(), rest.getSat());
		map.put(rest.getHoli().getDay(), rest.getHoli());
		
		
		this.entity=map;
	}
}
