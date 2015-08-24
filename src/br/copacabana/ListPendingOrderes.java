package br.copacabana;

import java.util.HashMap;
import java.util.Map;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.usecase.beans.MealOrderSimpleSerializer;

public class ListPendingOrderes extends ListCommandFilteredBy implements GsonSerializable {
	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(MealOrder.class, new MealOrderSimpleSerializer());
		return m;
	}
}
