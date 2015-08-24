package br.copacabana.usecase;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.PlateStatus;
import br.com.copacabana.cb.entities.TurnType;
import br.com.copacabana.cb.entities.WorkingHours.DayOfWeek;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.GsonSerializable;
import br.copacabana.ListCommandFilteredBy;
import br.copacabana.marshllers.PlateWrapperSerializer;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;

public class ListRestaurantPlates extends ListCommandFilteredBy implements GsonSerializable {
	private Key key;

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(Plate.class, new PlateWrapperSerializer());
		return m;
	}

	@Override
	public void execute(Manager manager) throws Exception {
		Set<Plate> plates = new RestaurantManager().get(key).getPlates();
		DayOfWeek today = TimeController.getDayOfWeek();
		if (today.equals(DayOfWeek.SATURDAY) || today.equals(DayOfWeek.SUNDAY)) {
			for (Iterator iterator = plates.iterator(); iterator.hasNext();) {
				Plate plate = (Plate) iterator.next();
				if(plate.getAvailableTurn().equals(TurnType.LUNCH)){
					plate.setStatus(PlateStatus.UNAVAILABLE);
				}
			}
		}
		this.entity = plates;
	}

	public Key getKey() {
		return key;
	}

	public void setKey(Key key) {
		this.key = key;
	}
}
