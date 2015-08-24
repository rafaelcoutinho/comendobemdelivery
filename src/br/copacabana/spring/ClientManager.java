package br.copacabana.spring;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.LoyaltyPoints;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Payment.PaymentType;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.exception.DataNotFoundException;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;

public class ClientManager extends AbstractJPAManager<Client> {

	public Client get(Key k) {
		return this.find(k, Client.class);
	}

	public Client getByLogin(String login) throws DataNotFoundException {
		Map<String, Object> m = new HashMap<String, Object>();

		UserBean ub = new UserBeanManager().getByLogin(login);
		m.put("login", ub);
		java.util.List<Client> l = this.list("getClientByLogin", m);
		if (l == null || l.isEmpty()) {
			throw new DataNotFoundException("There is no client with login=" + login + "");
		}
		return l.get(0);
	}

	@Override
	public Client create(Client r) throws Exception {
		UserBeanManager um = new UserBeanManager();
		um.checkIfUniqueLogin(r.getUser());

		return super.create(r);
	}

	@Override
	public String getDefaultQueryName() {

		return "getClient";
	}

	@Override
	protected Class getEntityClass() {
		return Client.class;
	}

	public LoyaltyPoints persistLoyaltyPoints(LoyaltyPoints points) {
		points.updateTotal();
		Datastore.getPersistanceManager().getTransaction().begin();
		if (points.getId() == null) {
			Datastore.getPersistanceManager().persist(points);
		} else {
			Datastore.getPersistanceManager().merge(points);
		}
		Datastore.getPersistanceManager().getTransaction().commit();
		return points;
	}

	public LoyaltyPoints getLoyaltyForMonth(Client c, int month, int year) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("allLoyaltyForMonth");
		q.setParameter("month", month);
		q.setParameter("year", year);
		return (LoyaltyPoints) q.getSingleResult();
	}

	public LoyaltyPoints getLoyaltyForCurrentMonth(Client c) {
		int month = TimeController.getDefaultCalendar().get(Calendar.MONTH);
		int year = TimeController.getDefaultCalendar().get(Calendar.YEAR);
		Query q = Datastore.getPersistanceManager().createNamedQuery("allUserLoyaltyForMonth");
		q.setParameter("month", month);
		q.setParameter("year", year);
		q.setParameter("client", c.getId());
		return (LoyaltyPoints) q.getSingleResult();
	}

	public List<LoyaltyPoints> getLoyaltyUntilMonth(Client c, int month, int year) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("allUserLoyaltyBeforeMonth");
		q.setParameter("month", month);
		q.setParameter("client", c.getId());
		q.setParameter("year", year);
		return q.getResultList();
	}

	public List<LoyaltyPoints> getLoyaltyBecoreCurrentMonth(Client c) {
		int month = TimeController.getDefaultCalendar().get(Calendar.MONTH);
		int year = TimeController.getDefaultCalendar().get(Calendar.YEAR);
		return getLoyaltyUntilMonth(c, month, year);
	}

	public List<LoyaltyPoints> listCurrentMonthLoyaltyPoints() {
		int month = TimeController.getDefaultCalendar().get(Calendar.MONTH);
		int year = TimeController.getDefaultCalendar().get(Calendar.YEAR);
		return listMonthLoyaltyPoints(month, year);
	}

	public List<LoyaltyPoints> listMonthLoyaltyPoints(int month, int year) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("allLoyaltyForMonth");
		q.setParameter("month", month);
		q.setParameter("year", year);
		return q.getResultList();
	}

	public Integer getOnlineOrdersLast30Days(Client c) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getLastDaysOrders");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DAY_OF_YEAR, -31);
		q.setParameter("since", cal.getTime());
		q.setParameter("client", c);
		List<MealOrder> list = q.getResultList();
		Integer totalAmount = 0;
		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
			MealOrder mealOrder = (MealOrder) iterator.next();
			if (PaymentType.PAYPAL.equals(mealOrder.getPayment().getType())) {
				totalAmount += mealOrder.getTotalAmountInCents();
			}
		}
		return totalAmount;

	}

}
