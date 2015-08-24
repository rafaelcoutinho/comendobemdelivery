package br.com.copacabana.cb.entities.mgr;

import java.util.List;
import java.util.logging.Level;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.OrdinarySell;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.tasks.MailSenderTask;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class OrdinarySellManager extends AbstractJPAManager<OrdinarySell> {

	@Override
	public String getDefaultQueryName() {

		return "getAllSells";
	}

	@Override
	protected Class getEntityClass() {
		return OrdinarySell.class;
	}

	public List<OrdinarySell> getRestaurantSells(Key restId) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("restSells");
		q.setParameter("restId", restId);
		return q.getResultList();
	}

	public List<OrdinarySell> getClientsBuys(Key clientId) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("clientBuys");
		q.setParameter("clientId", clientId);
		return q.getResultList();
	}

	public OrdinarySell executeBuy(OrdinarySell os) {
		Datastore.getPersistanceManager().getTransaction().begin();

		Datastore.getPersistanceManager().persist(os);

		Datastore.getPersistanceManager().getTransaction().commit();
try{
		// send email to client and restaurant
		Queue queue = QueueFactory.getQueue("mailer");
		queue.add(TaskOptions.Builder.withUrl("/task/sendMail")
				.param("to", os.getClient().getEmail())
				.param("from", "contato@comendobem.com.br")
				.param("msg", "Seu pedido de "+os.getItemSold().get(0).getQty()+" ingresso(s) foi processado. <br>Anote o número de seu pedido: "+os.getId()+"<br> Obrigado.")
				.param("sub", "Convites reservados para a Noite Italiana")
				.method(Method.POST));
		
		queue.add(TaskOptions.Builder.withUrl("/task/sendMail")
				.param("to", new ConfigurationManager().getConfigurationValue("seller.email"))
				.param("from", "contato@comendobem.com.br")
				.param("msg", "Um pedido novo  pedido de "+os.getItemSold().get(0).getQty()+" ingresso(s). <br># pedido: "+os.getId()+"<br>")
				.param("sub", "Novas reservas para a Noite Italiana")
				.method(Method.POST));
		} catch (Exception e) {
			log.log(Level.SEVERE,"cannot send emails",e);
		}
		
		return get(os.getId());

	}

	public OrdinarySell executeBuyWithDelivery(OrdinarySell os, Key refAddress) {
		AddressManager am = new AddressManager();
		Datastore.getPersistanceManager().getTransaction().begin();
		Address address = am.duplicate(refAddress);
		Datastore.getPersistanceManager().getTransaction().commit();
		os.setDeliveryAddress(address.getId());
		return executeBuy(os);

	}

}
