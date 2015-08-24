package br.copacabana.usecase;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Logger;

import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;
import br.copacabana.MailSender;
import br.copacabana.OrderDispatcher;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class MonitorCriticalPendingRequestsCommand extends RetrieveCommand implements Command {
	protected static final Logger log = Logger.getLogger("copacabana.CommandsCritical");

	public static Integer getRestaurantAlertDelay(Key restId) {
		ConfigurationManager confManager = new ConfigurationManager();
		Configuration timing = confManager.get("delay_" + KeyFactory.keyToString(restId));
		if (timing != null) {
			try {
				return Integer.parseInt(timing.getValue());
			} catch (NumberFormatException e) {
				return -1;
			}
		}
		return -1;
	}

	@Override
	public void execute(Manager manager) throws Exception {

		OrderDispatcher od = new OrderDispatcher();
		if (od.hasAnyOrders()) {
			OrderManager mMan = new OrderManager();
			Map<String, Object> m = new HashMap<String, Object>();
			List<MealOrder> a = new ArrayList<MealOrder>();
			m.put("status", MealOrderStatus.NEW);
			a.addAll(mMan.list("listPendingMealOrders", m));
			log.info("Total peding: " + a.size());
			if (!a.isEmpty()) {

				Calendar now = Calendar.getInstance();
				List<MealOrder> mealsToSend = new ArrayList<MealOrder>();
				for (Iterator iterator = a.iterator(); iterator.hasNext();) {
					MealOrder mealOrder = (MealOrder) iterator.next();
					Integer delay = getRestaurantAlertDelay(mealOrder.getRestaurant());
					log.info("Delay é de " + delay);
					if (delay != null && delay > 0) {
						log.info("Ordered time é " + mealOrder.getOrderedTime().getTime());
						log.info("Agora        é " + mealOrder.getOrderedTime().getTime());
						log.info("delay        é " + (now.getTimeInMillis() - (1000 * delay)));
						log.info("condi        é " + (mealOrder.getOrderedTime().getTime() < (now.getTimeInMillis() - (1000 * delay))));
						if (mealOrder.getOrderedTime().getTime() < (now.getTimeInMillis() - (1000 * delay))) {
							mealsToSend.add(mealOrder);
						}
					} else {
						mealsToSend.add(mealOrder);
					}
				}
				log.info("Meals to send está vazio? " + mealsToSend.isEmpty());

				if (!mealsToSend.isEmpty()) {
					String subject = "ComendoBem: Alerta pedidos ";
					if (mealsToSend.size() == 1) {
						subject = "ComendoBem: Alerta pedidos " + a.get(0).getId().getId();
					}
					String msg = MonitorPendingRequestsCommand.formatHtmlEmail(mealsToSend, new RestaurantManager());
					MonitorPendingRequestsCommand.notifyUs(subject, msg);

					log.info("Alert email was successfully sent");
				}
			} else {
				this.entity = "Não há pedidos em estado crítico";
			}
		}

	}

	public static String formatHtmlEmail(List<MealOrder> a, RestaurantManager rm) {
		StringBuilder sb = new StringBuilder();
		sb.append("Pedidos em espera:<br>");
		java.text.SimpleDateFormat sdf = new SimpleDateFormat("kk:mm", new Locale("pt", "BR"));
		sdf.setTimeZone(TimeController.getDefaultTimeZone());

		int i = 1;
		for (Iterator iterator = a.iterator(); iterator.hasNext();) {
			MealOrder mealOrder = (MealOrder) iterator.next();
			sb.append(i);
			sb.append(": ");
			sb.append(sdf.format(mealOrder.getLastStatusUpdateTime()));
			sb.append("<br>");
			sb.append("Cliente: ").append(mealOrder.getClientName());
			sb.append("<br>");
			Restaurant rest = rm.find(mealOrder.getRestaurant(), Restaurant.class);
			sb.append("Restaurante: ").append(rest.getName());
			sb.append("<br>");
			sb.append("Tel Restaurante: ").append(rest.getContact().getPhone());
			sb.append("<br>");
			sb.append("Ordered: ").append(sdf.format(mealOrder.getOrderedTime()));
			sb.append("<br>");
			sb.append("Status: ").append(mealOrder.getStatus());
			sb.append("<br>");
			sb.append("<hr>");
			i++;
		}

		return sb.toString();
	}

	public static void notifyUs(String sub, String msg) {
		try {
			MailSender ms = new MailSender();
			String[] others = new String[] { "agnaldo@comendobem.com.br", "monitor@comendobem.com.br", "flavio.alves@copacabanatech.com" };
			for (int i = 0; i < others.length; i++) {
				String to = others[i];
				ms.sendEmail("rafael.coutinho@gmail.com", "Monitor do ComendoBem", to, "", to, "Admin ComendoBem", sub, msg);
			}

		} catch (Exception e) {
			// TODO: handle exception
		}
	}

}
