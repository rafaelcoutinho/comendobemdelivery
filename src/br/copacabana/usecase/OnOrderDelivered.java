package br.copacabana.usecase;

import java.text.MessageFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;
import java.util.logging.Logger;

import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.OrderType;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.RestaurantClient;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.com.copacabana.web.Constants;
import br.copacabana.MailSender;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantClientManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class OnOrderDelivered extends RetrieveCommand {
	protected static final Logger log = Logger.getLogger("copacabana.Monitors");

	@Override
	public void execute(Manager manager) throws Exception {
		OrderManager om = (OrderManager) manager;
		RestaurantManager rman = new RestaurantManager();
		MealOrder mo = om.find(KeyFactory.stringToKey((String) getId()), MealOrder.class);

		MailSender ms = new MailSender();

		// String id = "FeedBackEmail";
		// EmailContent email =
		// Datastore.getPersistanceManager().find(EmailContent.class, id);
		// String subject = null;
		// String msg = null;
		// if (email != null) {
		// subject = email.getSubject();
		// msg = email.getMsg().getValue();
		// }

		String orderIdXlated = mo.getClient().getId().getId() + "." + mo.getId().getId();
		SimpleDateFormat sdf = new SimpleDateFormat("dd 'de' MMMM 'às' kk:mm", TimeController.getDefaultLocale());
		sdf.setTimeZone(TimeController.getDefaultTimeZone());

		Restaurant r = rman.getRestaurant(mo.getRestaurant());

		String total = NumberFormat.getCurrencyInstance(TimeController.getDefaultLocale()).format(((double) mo.getTotalAmountInCents()) / 100.0);

		if (OrderType.ONLINE.equals(mo.getOrderType())) {
			String type = "c";
			String subject = ResourceBundle.getBundle("messages").getString("order.complete.subject");
			String msg = ResourceBundle.getBundle("messages").getString("order.complete.msg");
			String prefixurl = Constants.HOSTNAME + "pesquisaSatisfacao.do?pedido=" + orderIdXlated + "&email=true&t=" + type + "&nota=";
			List<String> params = new ArrayList<String>();
			params.add(mo.getClientName());
			params.add(orderIdXlated);
			params.add(sdf.format(mo.getOrderedTime()));
			params.add(r.getName());
			params.add(total);
			params.add(prefixurl + "5");
			params.add(prefixurl + "4");
			params.add(prefixurl + "2");
			params.add(prefixurl + "1");

			msg = MessageFormat.format(msg, params.toArray());

			ms.sendFromSystemEmail(mo.getClient().getUser().getLogin(), subject, msg);
			this.entity = "mail sent for order " + orderIdXlated;
			// only online orders can count for the loyalty point
			if (OrderType.ONLINE.equals(mo.getOrderType())) {
				Queue queue = QueueFactory.getQueue("loyalty");
				queue.add(TaskOptions.Builder.withUrl("/task/updateLoyaltyPoints.do").param("id", KeyFactory.keyToString(mo.getId())).method(Method.GET));
			}
		} else {
			String replyTo = "contato@comendobem.com.br";
			ConfigurationManager cm = new ConfigurationManager();
			Configuration confEmail = cm.find("contactEmail", Configuration.class);
			if (confEmail != null) {
				replyTo = confEmail.getValue();
			}
			if (mo.getClient().getId().getKind().equals("CLIENT")) {
				String type = "c";

				String subject = ResourceBundle.getBundle("messages").getString("order.complete.subject.erp");
				subject = MessageFormat.format(subject, r.getName());

				String msg = ResourceBundle.getBundle("messages").getString("order.complete.msg.erp.client");
				String prefixurl = Constants.HOSTNAME + "pesquisaSatisfacao.do?pedido=" + orderIdXlated + "&email=true&t=" + type + "&nota=";
				List<String> params = new ArrayList<String>();
				params.add(mo.getClientName());
				params.add(orderIdXlated);
				params.add(sdf.format(mo.getOrderedTime()));
				params.add(r.getName());
				params.add(total);
				params.add(prefixurl + "5");
				params.add(prefixurl + "4");
				params.add(prefixurl + "2");
				params.add(prefixurl + "1");

				msg = MessageFormat.format(msg, params.toArray());

				ms.sendEmail(replyTo, r.getName() + " via ComendoBem", replyTo, r.getName() + " via ComendoBem", mo.getClient().getUser().getLogin(), mo.getClientName(), subject, msg);

				this.entity = "mail sent for order " + orderIdXlated;

			} else {

				String type = "r";
				RestaurantClient resClient = new RestaurantClientManager().get(mo.getClient().getId());
				String tempEmail = resClient.getTempEmail();
				if (tempEmail != null && tempEmail.length() > 0) {

					String subject = ResourceBundle.getBundle("messages").getString("order.complete.subject.erp");
					subject = MessageFormat.format(subject, r.getName());

					String msg = ResourceBundle.getBundle("messages").getString("order.complete.msg.erp.notclient");
					String prefixurl = Constants.HOSTNAME + "pesquisaSatisfacao.do?pedido=" + orderIdXlated + "&email=true&t=" + type + "&nota=";
					List<String> params = new ArrayList<String>();
					params.add(mo.getClientName());
					params.add(orderIdXlated);
					params.add(sdf.format(mo.getOrderedTime()));
					params.add(r.getName());
					params.add(total);
					params.add(prefixurl + "5");
					params.add(prefixurl + "4");
					params.add(prefixurl + "2");
					params.add(prefixurl + "1");

					msg = MessageFormat.format(msg, params.toArray());

					ms.sendEmail(replyTo, r.getName() + " via ComendoBem", replyTo, r.getName() + " via ComendoBem",tempEmail, mo.getClientName(), subject, msg);
					this.entity = "mail sent for order " + orderIdXlated;
				}
			}
		}

	}

}
