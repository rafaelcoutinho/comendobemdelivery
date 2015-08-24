package br.copacabana.usecase;

import java.util.logging.Logger;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Payment.PaymentType;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.MailSender;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.KeyFactory;

public class OnOrderCancelled extends RetrieveCommand {
	public static final String CONF_KEY_EMAIL_SUBJECT = "order.cancelled.email.subject";

	public static final String CONF_KEY_EMAIL_MSG_PAYPAL = "expired.order.email.msg.paypal";

	public static final String CONF_KEY_EMAIL_MSG = "order.cancelled.email.msg";

	protected static final Logger log = Logger.getLogger("copacabana.Monitors");

	public static final String DEFAULT_MSG = "O seu pedido no site ComendoBem de n&uacute;mero %s foi cancelado pelo restaurante. <br>O motivo descrito pelo restaurante foi: %s <br/>%s<br/>Por favor contacte o restaurante para maiores esclarecimentos.<br>Restaurante: %s<br/>Telefone:%s<br> Veja mais detalhes do seu pedido clicando <a href='www.comendobem.com.br/meusPedidos.do'>aqui</a><br>Atenciosamente,<br>Site ComendoBem<br><img src=\"http://www.comendobem.com/resources/img/logo.png\" width=\"100\" />";
	public static final String PAYPAY_APPEND = "A autoriza&ccedil;&atilde;o de pagamento online foi cancelada e nada foi cobrado.<br/>";
	public static final String DEFAULT_SUBJECT = "Pedido foi cancelado pelo estabelecimento.";

	@Override
	public void execute(Manager manager) throws Exception {
		OrderManager oman = (OrderManager) manager;
		
		log.fine("Order cancelled " + getId());
		MealOrder mo = oman.get(KeyFactory.stringToKey((String) getId()));
		log.fine("Sending an email notifying client: " + mo.getClient().getUser().getLogin());

		MailSender ms = new MailSender();
		ConfigurationManager cm = new ConfigurationManager();
		String subject = cm.getConfigurationValue(CONF_KEY_EMAIL_SUBJECT);
		if (subject == null || subject.length() == 0) {
			subject = DEFAULT_SUBJECT;
		}
		String msg = cm.getConfigurationValue(CONF_KEY_EMAIL_MSG);
		if (msg == null || msg.length() == 0) {
			msg = DEFAULT_MSG;
		}
		String payPayAppend = cm.getConfigurationValue(CONF_KEY_EMAIL_MSG_PAYPAL);

		if (payPayAppend == null) {
			payPayAppend = PAYPAY_APPEND;
		}

		String orderId = mo.getClient().getId().getId() + "." + mo.getId().getId();
		RestaurantManager rman = new RestaurantManager();
		Restaurant r = rman.getRestaurant(mo.getRestaurant());
		String[] params = new String[] { orderId, mo.getReason(), "", r.getName(), r.getContact().getPhone(), getId().toString() };
		if (PaymentType.PAYPAL.equals(mo.getPayment().getType())) {
			params[2] = payPayAppend;
		}

		msg = String.format(msg, params);
		ms.sendFromSystemEmail(mo.getClient().getUser().getLogin(), subject, msg);

		try {
			MonitorPendingRequestsCommand.notifyUs("Houve um pedido cancelado!", msg);
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

}
