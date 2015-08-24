package br.copacabana.spring.order;

import javax.persistence.NoResultException;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Feedback;
import br.com.copacabana.cb.entities.FeedbackStatus;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.OrderManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class CreateOrderFeedbackCommand extends RetrieveCommand {
	private String email;
	private String pedido;
	private Short nota;
	private String t;

	@Override
	public void execute(Manager manager) throws Exception {
		String[] str = pedido.split("\\.");

		Long clientIdLong = Long.parseLong(str[0]);
		Long mealIdLong = Long.parseLong(str[1]);
		Key mealId = null;
		Key clientId = null;
		if ("r".equals(t)) {
			clientId = KeyFactory.createKey("RESTAURANTCLIENT", clientIdLong);
		} else {
			clientId = KeyFactory.createKey("CLIENT", clientIdLong);
		}
		try {
			// this is needed cuz before the order of the ids was switched
			ClientManager cm = new ClientManager();
			Client c = cm.get(clientId);
			if (c == null) {
				Long aux = clientIdLong;
				clientIdLong = mealIdLong;
				mealIdLong = aux;
				clientId = KeyFactory.createKey("CLIENT", clientIdLong);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		mealId = KeyFactory.createKey(clientId, "MEALORDER", mealIdLong);
		OrderManager om = (OrderManager) manager;

		Feedback f = null;
		MealOrder mo = om.get(mealId);
		try {
			f = om.getMealOrderFeedback(mealId);// TODO maybe won't allow it
		} catch (NoResultException e) {
			f = om.createFeedback(mealId);
			f.setOverall(nota);
			f.setClient(mo.getClient().getId());
			f.setFromEmail(email);
			f.setStatus(FeedbackStatus.OVERALL);
			om.persist(f);
		}
		FeedbackBean fbean = new FeedbackBean(f, mo);
		this.entity = fbean;

	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPedido() {
		return pedido;
	}

	public void setPedido(String pedido) {
		this.pedido = pedido;
	}

	public Short getNota() {
		return nota;
	}

	public void setNota(Short overall) {
		this.nota = overall;
	}

	public String getT() {
		return t;
	}

	public void setT(String t) {
		this.t = t;
	}

}
