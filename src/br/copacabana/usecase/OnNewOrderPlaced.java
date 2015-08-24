package br.copacabana.usecase;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.copacabana.RetrieveCommand;
import br.copacabana.lab.NotifyUser;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.usecase.beans.MealOrderSimpleSerializer;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class OnNewOrderPlaced extends RetrieveCommand {
	protected static final Logger log = Logger.getLogger("copacabana.Monitors");

	@Override
	public void execute() throws Exception {
		OrderManager cm = new OrderManager();
		log.fine("New order placed " + getId());
		MealOrder mo = cm.get(KeyFactory.stringToKey((String) getId()));
		CentralManager centralManager = new CentralManager();
		JsonObject json = new JsonObject();
		try {
			NotifyUser.sendMessage("Rest_" + KeyFactory.keyToString(mo.getRestaurant()), json.toString());
		} catch (Exception e) {
			log.log(Level.SEVERE, "Erro ao notificar restaurante!", e);
		}
		if (centralManager.isRestaurantManagedByCentral(mo.getRestaurant())) {
			Central central = centralManager.getRestaurantCentral();

			json.add("restId", new JsonPrimitive(KeyFactory.keyToString(mo.getRestaurant())));
			MealOrderSimpleSerializer mos = new MealOrderSimpleSerializer();
			json.add("mealOrder", mos.serialize(mo, null, null));
			try {
				NotifyUser.sendMessage(KeyFactory.keyToString(central.getId()), json.toString());
			} catch (Exception e) {
				log.log(Level.SEVERE, "Erro ao notificar central!", e);
			}
		}
		try {			
			List<MealOrder> list = new ArrayList<MealOrder>();
			list.add(mo);
			json.add("restId", new JsonPrimitive(KeyFactory.keyToString(mo.getRestaurant())));
			MealOrderSimpleSerializer mos = new MealOrderSimpleSerializer();
			json.add("mealOrder", mos.serialize(mo, null, null));
			NotifyUser.sendMessage("backoffice", json.toString());
			
			if (MonitorCriticalPendingRequestsCommand.getRestaurantAlertDelay(mo.getRestaurant()) <= 0) {				
				String msg = MonitorPendingRequestsCommand.formatHtmlEmail(list, new RestaurantManager());
				MonitorPendingRequestsCommand.notifyUs("Há novo pedido: " + mo.getId().getId(), msg);
			}else{
				log.info("Alerta foi postergado");
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Erro ao notificar administradores!", e);
		}

	}
}
