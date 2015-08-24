package br.copacabana.usecase;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.logging.Level;
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
import br.copacabana.xmpp.XmppController;

public class MonitorPendingRequestsCommand extends RetrieveCommand implements Command {
	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	@Override
	public void execute(Manager manager) throws Exception {

		OrderDispatcher od = new OrderDispatcher();
		if (od.hasAnyOrders()) {
			OrderManager mMan = new OrderManager();
			Map<String, Object> m = new HashMap<String, Object>();
			List<MealOrder> a = new ArrayList<MealOrder>();
			m.put("status", MealOrderStatus.NEW);
			a.addAll(mMan.list("listPendingMealOrders", m));
			m.put("status", MealOrderStatus.VISUALIZEDBYRESTAURANT);
			a.addAll(mMan.list("listPendingMealOrders", m));
			m.put("status", MealOrderStatus.PREPARING);
			a.addAll(mMan.list("listPendingMealOrders", m));

			if (a.size() > 0) {
				String msg = formatHtmlEmail(a, new RestaurantManager());

				MailSender ms = new MailSender();
				ConfigurationManager cm = new ConfigurationManager();
				Configuration confEmail = cm.find("contactEmail", Configuration.class);
				String toEmail = "rafael.coutinho@gmail.com";
				if (confEmail != null) {
					toEmail = confEmail.getValue();
				}
				String subject = "ComendoBem: Monitoramento pedido ";
				if (a.size() == 1) {
					subject = "ComendoBem: Monitoramento pedido " + a.get(0).getId().getId();
				}

				log.info("monitorMsg:\n" + msg);
				ms.sendEmail("rafael.coutinho@gmail.com", "Monitor do ComendoBem", toEmail, "", toEmail, "Admin ComendoBem", subject, msg);

				log.info("SendContact email was successfully sent");
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
			XmppController.sendMessage("rafael.coutinho@jabber.org", msg);
			MailSender ms = new MailSender();
			String[] others = new String[] { "agnaldo@comendobem.com.br", "monitor@comendobem.com.br", "flavio.alves@copacabanatech.com" };
			for (int i = 0; i < others.length; i++) {
				String to = others[i];
				ms.sendEmail("rafael.coutinho@gmail.com", "Monitor do ComendoBem", to, "", to, "Admin ComendoBem", sub, msg);
			}

		} catch (Exception e) {
			log.log(Level.SEVERE, "Erro ao nos notificar", e);
		}
	}

}
