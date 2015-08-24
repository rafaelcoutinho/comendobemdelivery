package br.copacabana;

import java.util.Iterator;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.OrderedPlate;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class ViewOrderByCentral extends ViewOrderByRestaurant implements SessionCommand, GsonSerializable {

	@Override
	public void execute(Manager manager) throws Exception {

		super.execute(manager);

		MealOrder order = (MealOrder) entity;
		PlateManager pm = new PlateManager();

		for (Iterator<OrderedPlate> iterator = order.getPlates().iterator(); iterator.hasNext();) {
			OrderedPlate pp = (OrderedPlate) iterator.next();
			if (!pp.getIsCustom()) {
				try {
					if (!pp.getIsFraction()) {
						Plate plate = pm.getPlate(pp.getPlate());

						if (plate.getRestInternalCode() != null) {
							pp.setRestInternalCode(plate.getRestInternalCode());
						}
					} else {
						StringBuilder sb = new StringBuilder();
						for (Iterator iterator2 = pp.getFractionPlates().iterator(); iterator2.hasNext();) {
							Key key = (Key) iterator2.next();
							Plate plate = pm.getPlate(key);
							if (plate.getRestInternalCode() != null) {
								sb.append(plate.getRestInternalCode()).append(" - ");
							}
						}
						pp.setRestInternalCode(sb.toString());
					}
				} catch (Exception e) {
					log.warning("could not get plate internal code");
				}
			}
		}

		// if (Authentication.isUserLoggedIn(s)) {
		// if (order.getRestaurant().equals(Authentication.getLoggedUserKey(s)))
		// {
		// MealOrderStatus status = order.getStatus();
		// if (status.equals(MealOrderStatus.NEW)) {
		// order.setStatus(MealOrderStatus.VISUALIZEDBYRESTAURANT);
		// manager.update(order);
		// }
		// }
		// }
	}

}
