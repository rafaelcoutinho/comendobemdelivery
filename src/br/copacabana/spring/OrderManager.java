package br.copacabana.spring;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Feedback;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderLogEntry;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.com.copacabana.cb.entities.mgr.DiscountManager;
import br.copacabana.OrderDispatcher;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.util.TimeController;
import br.copacabana.xmpp.XmppController;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;
import com.google.gson.JsonObject;

public class OrderManager extends AbstractJPAManager<MealOrder> {

	public String getDefaultQueryName() {

		return "getMealOrder";
	}

	public Feedback getMealOrderFeedback(Key orderId) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("feedbackByMeal");
		q.setParameter("orderId", orderId);
		return (Feedback) q.getSingleResult();
	}
	public MealOrder getMealOrderByDiscount(String code) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getMealOrderByDiscount");
		q.setParameter("code", code);
		return (MealOrder) q.getSingleResult();
	}

	public List<Feedback> getAllFeedbacks() {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getFeedbacksOrderByDate");
		return q.getResultList();
	}
	public Integer getTodaysTotalOrders(Key restId) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getTotalTodaysOrders");
		q.setParameter("restaurant", restId);
		q.setParameter("since", TimeController.getTodayMidnight());
		return q.getResultList().size();
	}
	
	@Override
	public MealOrder create(MealOrder obj) throws Exception {
		obj.setDailyCounter(getTodaysTotalOrders(obj.getRestaurant())+1);
		return super.create(obj);
	}

	public List<Feedback> getFeedbackByPeriod(Date start, Date end) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("feedbackByPeriod");
		q.setParameter("start", start);
		q.setParameter("end", end);
		return q.getResultList();
	}

	public Feedback createFeedback(Key orderId) {
		try {
			getMealOrderFeedback(orderId);
			throw new IllegalStateException("already exist");
		} catch (NoResultException e) {
			Feedback f = new Feedback(orderId);
			Datastore.getPersistanceManager().persist(f);
			return f;
		}

	}

	public List<MealOrder> getAllPendingOrders() {
		Map<String, Object> m = new HashMap<String, Object>();

		// TODO need to findout how to do OR selects using google app

		List<MealOrder> inSite = new ArrayList<MealOrder>();
		m.put("status", MealOrderStatus.NEW);
		inSite.addAll(this.list("listPendingMealOrders", m));
		m.put("status", MealOrderStatus.VISUALIZEDBYRESTAURANT);
		inSite.addAll(this.list("listPendingMealOrders", m));
		return inSite;

	}
	public List<MealOrder> getAllNotDeliveredOrders() {
		Map<String, Object> m = new HashMap<String, Object>();

		// TODO need to findout how to do OR selects using google app

		List<MealOrder> inSite = new ArrayList<MealOrder>();
		m.put("status", MealOrderStatus.NEW);
		inSite.addAll(this.list("listPendingMealOrders", m));
		m.put("status", MealOrderStatus.VISUALIZEDBYRESTAURANT);
		inSite.addAll(this.list("listPendingMealOrders", m));
		m.put("status", MealOrderStatus.PREPARING);
		inSite.addAll(this.list("listPendingMealOrders", m));
		m.put("status", MealOrderStatus.INTRANSIT);
		inSite.addAll(this.list("listPendingMealOrders", m));
		return inSite;

	}
	public List<MealOrder> getNewOrdersForRestaurant(Key restKey) {
		Map<String, Object> m = new HashMap<String, Object>();
		List<MealOrder> inSite = new ArrayList<MealOrder>();
		m.put("restaurant", restKey);
		inSite.addAll(this.list("getNewOrdersForRestaurant", m));
		return inSite;
	}

	public List<MealOrder> getOnGoingOrdersForRestaurant(Key restKey) {
		Map<String, Object> m = new HashMap<String, Object>();
		List<MealOrder> inSite = new ArrayList<MealOrder>();
		m.put("restaurant", restKey);
		inSite.addAll(this.list("getOnGoingOrdersForRestaurant", m));
		return inSite;

	}

	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	public List<MealOrder> getClientOrdersInSite(Client c) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("client", c);
		List<MealOrder> inSite = new ArrayList<MealOrder>();
		m.put("status", MealOrderStatus.DELIVERED);
		inSite.addAll(this.list("listClientOrdersInSite", m));
		return inSite;
	}

	public List<MealOrder> getClientOrdersInRestaurant(Client c, Key restaurant) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("client", c);
		m.put("restaurantId", restaurant);
		m.put("status", MealOrderStatus.DELIVERED);
		List<MealOrder> inRestaurant = new ArrayList<MealOrder>();
		inRestaurant.addAll(this.list("listClientOrdersInRestaurant", m));
		return inRestaurant;

	}

	public void createMealOrder(Client c, MealOrder mo) throws Exception {
		log.log(Level.FINE, "Creating meal order");

		if (mo.getDiscountInfo() != null) {
			DiscountManager dm = new DiscountManager();
			dm.makeDiscountUsed(mo.getDiscountInfo().getCode());

		}

		mo.setClientRequestsOnRestaurant(this.getClientOrdersInRestaurant(c, mo.getRestaurant()).size());
		mo.setClientRequestsOnSite(this.getClientOrdersInSite(c).size());

		this.create(mo);
		log.log(Level.FINE, "Meal order created");
		try {
			Queue queue = QueueFactory.getDefaultQueue();
			queue.add(TaskOptions.Builder.withUrl("/tasks/onNewOrderPlaced.do").param("id", KeyFactory.keyToString(mo.getId())).method(Method.POST));

			new OrderDispatcher().placeOrder(mo);
			log.log(Level.FINE, "Dispatched order ");

			XmppController xmpMan = new XmppController();
			RestaurantManager restMan = new RestaurantManager();
			Restaurant rest = restMan.find(mo.getRestaurant(), Restaurant.class);
			log.log(Level.FINE, "Restaurant is {0} ", rest.getName());
			JsonObject json = XmppController.getNewRequestsMsg(mo);
			XmppController.notifyRestaurant(rest, json);
			// TODO maybe should put it in the task above

		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to complete notification {0}", e);
		}

	}

	public MealOrder get(Key id) {
		return find(id, MealOrder.class);

	}

	public List<MealOrder> getCompleteOrders(Key restKey, Date start, Date end) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("restaurant", restKey);
		m.put("start", start);
		m.put("end", end);
		return this.list("getCompleteOrders", m);

	}
	
	public List<MealOrder> getCompleteOnlineOrders(Key restKey, Date start, Date end) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("restaurant", restKey);
		m.put("start", start);
		m.put("end", end);
		return this.list("getCompleteOnlineOrders", m);

	}

	public void persist(Feedback f) {
		Datastore.getPersistanceManager().merge(f);

	}

	public Feedback getFeedback(Long feedbackId) {
		return Datastore.getPersistanceManager().find(Feedback.class, feedbackId);

	}

	public List<MealOrderLogEntry> getMealOrderHistory(MealOrder mo) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getMealOrderLogEntryByOrder");
		q.setParameter("order", mo);
		return q.getResultList();
	}

	@Override
	protected Class getEntityClass() {

		return MealOrder.class;
	}

	public List<MealOrder> listClientOrdersSince(Client c, Date since) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getClientOrdersSince");
		q.setParameter("client", c);
		q.setParameter("since", since);
		return q.getResultList();
	}

	public List<MealOrder> getCompletedOrdersRange(Date from, Date until) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getCompleteOrdersRange");
		q.setParameter("until", until);
		q.setParameter("from", from);
		return q.getResultList();
	}

	public List<MealOrder> getCompletedOrdersRangeByClient(Client client, Date from, Date until) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getCompleteOrdersRangeForClient");
		q.setParameter("client", client);
		q.setParameter("until", until);
		q.setParameter("from", from);
		return q.getResultList();
	}

}
