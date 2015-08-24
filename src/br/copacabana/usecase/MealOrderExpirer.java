package br.copacabana.usecase;

import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.Payment.PaymentType;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.MailSender;
import br.copacabana.OrderDispatcher;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.xmpp.XmppController;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;

public class MealOrderExpirer extends RetrieveCommand {
	protected static final Logger log = Logger.getLogger("copacabana.Monitors");
	public static final String CLIENT_MSG = "O seu pedido no site ComendoBem de n&uacute;mero %s foi cancelado pois o restaurante n&atilde;o confirmou o pedido dentro do tempo m&aacute;ximo.<br> %s <br/>Por favor contacte o restaurante para maiores esclarecimentos.<br>Restaurante: %s<br/>Telefone:%s<br> Veja mais detalhes do seu pedido clicando <a href='www.comendobem.com.br/meusPedidos.do'>aqui</a><br>Atenciosamente,<br>Site ComendoBem<br><img src=\"http://www.comendobem.com/resources/img/logo.png\" width=\"100\" />";
	public static final String PAYPAY_APPEND = "A autoriza&ccedil;&atilde;o de pagamento online foi cancelada e nada foi cobrado.<br/>";
	public static final String CLIENT_SUBJECT = "Pedido atingiu tempo limite sem confirmação do restaurante.";
	public static final String REST_MSG = "Ol&aacute; %2$s,<br />Um pedido (#%s) venceu esperando sua confirma&ccedil;&atilde;o. <br />Caso esteja com problemas para usar o sistema do ComendoBem por favor nos contacte.<br />Para monitorar seus pedidos clique <a href=\"www.comendobem.com.br/pedidos.do\">aqui</a>.<br /><br />Atenciosamente,<br />Site ComendoBem<br /><img src=\"http://www.comendobem.com/resources/img/logo.png\" width=\"100\" />";
	public static final String REST_SUBJECT = "Pedido atingiu tempo limite sem sua confirmação.";

	@Override
	public void execute(Manager manager) throws Exception {
		OrderManager om = (OrderManager) manager;
		MealOrder mo = om.find(KeyFactory.stringToKey((String) getId()), MealOrder.class);
		if (MealOrderStatus.NEW.equals(mo.getStatus())) {
			if (log.isLoggable(Level.INFO)) {
				log.info("Expiring meal order: " + mo.getClient().getId().getId() + "." + mo.getId().getId());
			}
			mo.setStatus(MealOrderStatus.EXPIRED);
			om.persist(mo);
			new OrderDispatcher().removeOrder(mo);
			if (PaymentType.PAYPAL.equals(mo.getPayment().getType())) {
				// TODO Cancel paypal
			}
			if (log.isLoggable(Level.INFO)) {
				log.info("Notifying client");
			}
			notifyClient(om, mo);
			if (log.isLoggable(Level.INFO)) {
				log.info("Notifying restaurant about cancellation");
			}

			notifyRestaurant(om, mo);
			notifyRestaurantMonitor(om, mo);
		}

	}

	private void notifyRestaurantMonitor(OrderManager om, MealOrder mo) {

		JsonObject json = XmppController.getCancelledOrdersNotificationMsg(mo);
		RestaurantManager rm = new RestaurantManager();
		Restaurant r = rm.getRestaurant(mo.getRestaurant());
		XmppController.notifyRestaurant(r, json);
	}

	private void notifyRestaurant(OrderManager om, MealOrder mo) {
		MailSender ms = new MailSender();
		ConfigurationManager cm = new ConfigurationManager();
		String subject = cm.getConfigurationValue("expired.order.rest.email.subject");
		if (subject == null || subject.length() == 0) {
			subject = REST_SUBJECT;
		}
		String orderId = mo.getClient().getId().getId() + "." + mo.getId().getId();
		RestaurantManager rm = new RestaurantManager();
		Restaurant r = rm.getRestaurant(mo.getRestaurant());
		String[] params = new String[] { orderId, r.getName(), r.getContact().getPhone(), getId().toString() };
		String msg = cm.getConfigurationValue("expired.order.rest.email.msg");
		if (msg == null || msg.length() == 0) {
			msg = REST_MSG;

		}
		msg = String.format(msg, params);

		ms.sendFromSystemEmail(r.getContact().getEmail(), subject, msg);

	}

	public void notifyClient(OrderManager om, MealOrder mo) {
		MailSender ms = new MailSender();
		ConfigurationManager cm = new ConfigurationManager();
		String subject = cm.getConfigurationValue("expired.order.email.subject");
		if (subject == null || subject.length() == 0) {
			subject = CLIENT_SUBJECT;
		}
		String orderId = mo.getClient().getId().getId() + "." + mo.getId().getId();
		RestaurantManager rm = new RestaurantManager();
		Restaurant r = rm.getRestaurant(mo.getRestaurant());
		String[] params = new String[] { orderId, "", r.getName(), r.getContact().getPhone(), getId().toString() };
		String msg = cm.getConfigurationValue("expired.order.email.msg");
		String payPayAppend = cm.getConfigurationValue("expired.order.email.msg.paypal");
		if (msg == null || msg.length() == 0) {
			msg = CLIENT_MSG;
			if (PaymentType.PAYPAL.equals(mo.getPayment().getType())) {
				if (payPayAppend == null) {
					params[1] = PAYPAY_APPEND;
				}
			}
		}
		msg = String.format(msg, params);
		ms.sendFromSystemEmail(mo.getClient().getUser().getLogin(), subject, msg);

	}

}
