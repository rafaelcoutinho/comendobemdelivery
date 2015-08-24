package br.copacabana.usecase.beans;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.GsonSerializable;
import br.copacabana.OrderDispatcher;
import br.copacabana.RetrieveCommand;
import br.copacabana.ReturnValueCommand;
import br.copacabana.lab.NotifyUser;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.xmpp.XmppController;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class UpdateOrderStatus extends RetrieveCommand implements SessionCommand, GsonSerializable, ReturnValueCommand {
	protected static final Logger log = Logger.getLogger("copacabana.Commands");
	private String id = "";
	private String key = "";
	private String reason = "";
	private String status = "";
	private String delay = "";
	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	int counter = 0;

	@Override
	// TODO validate the status changes.
	public void execute() throws JsonException {
		if (log.isLoggable(Level.FINE)) {
			log.log(Level.FINE, "orderstatus\nid={0}\nkey={1}\nstatus={2}\nreason={3}", new String[] { id, key, status, reason });
		}
		// don't know why in productions Google engine the ID isn't passed to
		// this command class.
		if (id == null || id.length() == 0) {
			id = key;
		}

		// Key userKey = Authentication.getLoggedUserKey(session);
		OrderManager om = new OrderManager();
		Key moKey = KeyFactory.stringToKey(id);
		MealOrder mo = om.find(moKey, MealOrder.class);
		validateWorkFlow(mo, MealOrderStatus.valueOf(status));
		if (MealOrderStatus.PREPARING.equals(MealOrderStatus.valueOf(status))) {}
		try {
			if (MealOrderStatus.NEW.equals(mo.getStatus()) || MealOrderStatus.VISUALIZEDBYRESTAURANT.equals(mo.getStatus())) {
				new OrderDispatcher().removeOrder(mo);
				try {

					RestaurantManager restMan = new RestaurantManager();
					Restaurant rest = restMan.find(mo.getRestaurant(), Restaurant.class);
					JsonObject json = XmppController.getNoMoreRequestsMsg();
					XmppController.notifyRestaurant(rest, json);
					log.log(Level.FINE, "notifying restaurant {0}", rest.getName());
				} catch (Exception e) {
					e.printStackTrace();
					log.log(Level.SEVERE, "Failed to notify clients {0}", e);
				}
				if (MealOrderStatus.CANCELLED.equals(MealOrderStatus.valueOf(status))) {
					Queue queue = QueueFactory.getDefaultQueue();
					queue.add(TaskOptions.Builder.withUrl("/tasks/onOrderCancelled.do").param("id", KeyFactory.keyToString(mo.getId())).method(Method.GET));
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (MealOrderStatus.PREPARING.equals(MealOrderStatus.valueOf(status))) {
			// if (mo.getRetrieveAtRestaurant()) {
			if (delay != null && delay.length() > 0) {
				mo.setPrepareForeCast(delay);
			}
		}

		mo.setStatus(MealOrderStatus.valueOf(status));
		mo.setReason(reason);
		try {
			Datastore.getPersistanceManager().getTransaction().begin();
			om.persist(mo);
			Datastore.getPersistanceManager().getTransaction().commit();
			mo = om.get(mo.getId());

		} catch (Exception e) {

			log.log(Level.SEVERE, "Cannot persist order: {0}", e);
			log.log(Level.SEVERE, "orderstatus\nid={0}\nkey={1}\nstatus={2}\nreason={3}", new String[] { id, key, status, reason });
			// log.severe("id=" + id);
			// log.info("key=" + key);
			// log.severe("status=" + status);
			// log.severe("reason=" + reason);

			throw new JsonException("Cannot persist order");
		}
		if (MealOrderStatus.DELIVERED.equals(MealOrderStatus.valueOf(status))) {
			Queue queue = QueueFactory.getDefaultQueue();
			queue.add(TaskOptions.Builder.withUrl("/tasks/onOrderDelivered.do").param("id", KeyFactory.keyToString(mo.getId())).method(Method.GET));
		}

		this.entity = mo;
		try {
			if (mo.getClient().getId().getKind().equals("CLIENT")) {
				// notify client
				JsonObject json = new JsonObject();
				json.add("mealId", new JsonPrimitive(KeyFactory.keyToString(mo.getId())));
				json.add("newStatus", new JsonPrimitive(mo.getStatus().name()));
				NotifyUser.sendMessage("Client_" + KeyFactory.keyToString(mo.getClient().getId()), json.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "Failed to notify client", e);
		}

	}

	public static void main(String[] args) {
		MealOrder mo = new MealOrder();
		mo.setStatus(MealOrderStatus.VISUALIZEDBYRESTAURANT);
		try {
			new UpdateOrderStatus().validateWorkFlow(mo, MealOrderStatus.PREPARING);
		} catch (JsonException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * must validate if the workflow status change is correct.
	 * 
	 * @param mo
	 * @param status2
	 * @throws JsonException
	 */
	static Map<MealOrderStatus, Set<MealOrderStatus>> statusWorkflow = new HashMap<MealOrderStatus, Set<MealOrderStatus>>();
	static {
		HashSet<MealOrderStatus> fromNew = new HashSet<MealOrderStatus>();
		fromNew.add(MealOrderStatus.EXPIRED);
		fromNew.add(MealOrderStatus.VISUALIZEDBYRESTAURANT);
		statusWorkflow.put(MealOrderStatus.NEW, (HashSet<MealOrderStatus>) fromNew.clone());
		fromNew = null;
		HashSet<MealOrderStatus> fromVisualized = new HashSet<MealOrderStatus>();
		fromVisualized.add(MealOrderStatus.PREPARING);
		fromVisualized.add(MealOrderStatus.CANCELLED);
		statusWorkflow.put(MealOrderStatus.VISUALIZEDBYRESTAURANT, (HashSet<MealOrderStatus>) fromVisualized.clone());
		fromVisualized = null;

		HashSet<MealOrderStatus> fromPreparing = new HashSet<MealOrderStatus>();
		fromPreparing.add(MealOrderStatus.INTRANSIT);
		fromPreparing.add(MealOrderStatus.WAITING_CUSTOMER);
		statusWorkflow.put(MealOrderStatus.PREPARING, (HashSet<MealOrderStatus>) fromPreparing.clone());
		fromPreparing = null;

		HashSet<MealOrderStatus> fromIntransit = new HashSet<MealOrderStatus>();
		fromIntransit.add(MealOrderStatus.DELIVERED);
		statusWorkflow.put(MealOrderStatus.INTRANSIT, fromIntransit);

		HashSet<MealOrderStatus> fromWaiting = new HashSet<MealOrderStatus>();
		fromWaiting.add(MealOrderStatus.DELIVERED);
		statusWorkflow.put(MealOrderStatus.WAITING_CUSTOMER, fromWaiting);

		HashSet<MealOrderStatus> fromDelivered = new HashSet<MealOrderStatus>();
		fromDelivered.add(MealOrderStatus.EVALUATED);
		statusWorkflow.put(MealOrderStatus.DELIVERED, fromDelivered);

		statusWorkflow.put(MealOrderStatus.CANCELLED, new HashSet<MealOrderStatus>(0));
		statusWorkflow.put(MealOrderStatus.EVALUATED, new HashSet<MealOrderStatus>(0));
		statusWorkflow.put(MealOrderStatus.EXPIRED, new HashSet<MealOrderStatus>(0));

	}

	private void validateWorkFlow(MealOrder mo, MealOrderStatus status) throws JsonException {
		if (!statusWorkflow.get(mo.getStatus()).contains(status)) {
			log.log(Level.SEVERE, "Cannot change status from {0} to {1}", new String[] { mo.getStatus().name(), status.name() });
			throw new JsonException("Cannot change status from " + mo.getStatus().name() + " to " + status.name(), ErrorCode.INCORRECTSTATUSWORKFLOW);
		} else {
			log.log(Level.INFO, "Status change is allowed from {0} to {1}", new String[] { mo.getStatus().name(), status.name() });
		}
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(MealOrder.class, new MealOrderSimpleSerializer());
		return m;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	// private void confirmPaypalAuthorization(MealOrder mo, PayPalProperties
	// ppp) throws IOException {
	// StringBuffer sb = new StringBuffer();
	// sb.append("METHOD=DoExpressCheckoutPayment");
	// sb.append("&");
	// sb.append("TOKEN=");
	// sb.append(mo.getPayment().getToken());
	// sb.append("&");
	// sb.append("PAYERID=");
	// sb.append(mo.getPayment().getPayerId());
	// sb.append("&");
	// sb.append("PAYMENTACTION=Authorization");
	// sb.append("&");
	// sb.append("AMT=");
	// sb.append(mo.getTotalAmountInCents());
	// sb.append("&");
	// sb.append("CURRENCYCODE=");
	// sb.append(ppp.getCurrencyCode().name());
	// sb.append("&");
	// sb.append("PWD=");
	// sb.append(ppp.getPassword());
	// sb.append("&");
	// sb.append("SOURCE=PAYPAL_JAVA_SDK_61");
	// sb.append("&");
	//
	// sb.append("SIGNATURE=");
	// sb.append(ppp.getSignature());
	// sb.append("&");
	// sb.append("USER=");
	// sb.append(ppp.getUser());
	// sb.append("&");
	// sb.append("VERSION=61.0");
	// URL url = new URL(ppp.getUrl());
	//
	// HttpURLConnection connection = (HttpURLConnection) url.openConnection();
	// connection.setDoOutput(true);
	// connection.setRequestMethod("POST");
	// log.log(Level.SEVERE, "Requset params: {0}", sb.toString());
	// OutputStreamWriter writer = new
	// OutputStreamWriter(connection.getOutputStream());
	// writer.write(sb.toString());
	// writer.close();
	// BufferedReader reader = new BufferedReader(new
	// InputStreamReader(connection.getInputStream()));
	// String line;
	// StringBuffer sbresponse = new StringBuffer();
	// while ((line = reader.readLine()) != null) {
	// sbresponse.append(line);
	// }
	//
	// Map<String, String> responseMap =
	// SubmitOrderController.parseResponse(sbresponse.toString());
	// String strAck = responseMap.get("ACK");
	// if (strAck != null && !(strAck.equals("Success") ||
	// strAck.equals("SuccessWithWarning"))) {
	// log.log(Level.SEVERE, "Failed to retrieve paypal: " + strAck);
	// log.log(Level.SEVERE, "Requset URL: {0}", url.getHost());
	// log.log(Level.SEVERE, "Requset params: {0}", sb.toString());
	// log.log(Level.SEVERE, "Response string {0}", sbresponse);
	// log.log(Level.SEVERE, "L_SHORTMESSAGE0: {0}",
	// responseMap.get("L_SHORTMESSAGE0"));
	// log.log(Level.SEVERE, "L_LONGMESSAGE0: {0}",
	// responseMap.get("L_LONGMESSAGE0"));
	// log.log(Level.SEVERE, "L_SEVERITYCODE0: {0}",
	// responseMap.get("L_SEVERITYCODE0"));
	// log.log(Level.SEVERE, "L_ERRORCODE0: {0}",
	// responseMap.get("L_ERRORCODE0"));
	//
	// // return sbresponse.toString();
	// } else {
	// log.log(Level.INFO, "Ok paypal paid!");
	//
	// }
	// }

	public String getDelay() {
		return delay;
	}

	public void setDelay(String delay) {
		this.delay = delay;
	}

}
