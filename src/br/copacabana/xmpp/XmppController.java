package br.copacabana.xmpp;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.XMPPUser;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.copacabana.util.TimeController;

import com.google.appengine.api.xmpp.JID;
import com.google.appengine.api.xmpp.Message;
import com.google.appengine.api.xmpp.MessageBuilder;
import com.google.appengine.api.xmpp.SendResponse;
import com.google.appengine.api.xmpp.XMPPService;
import com.google.appengine.api.xmpp.XMPPServiceFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class XmppController extends AbstractJPAManager<XMPPUser> {
	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	private static final int NO_REQUESTS = 1;
	private static final int NEW_REQUEST = 0;

	private static final int CANCELLED_REQUESTS = 5;

	private static final int PING = 99;

	private static final int PONG = 98;
	private static final boolean USE_GMAIL = false;

	public static boolean sendMessage(String to, String msgStr) {

		String msgBody = msgStr;
		if (USE_GMAIL) {
			JsonObject json = new JsonObject();
			json.add("toToken", new JsonPrimitive(to));
			json.add("payload", new JsonPrimitive(msgStr));
			log.fine("sending msg to " + to);
			to = "rafael.coutinho@gmail.com";
			msgBody = json.toString();
		}
		JID jid = new JID(to);

		Message msg = new MessageBuilder().withRecipientJids(jid).withBody(msgBody).build();

		boolean messageSent = false;
		XMPPService xmpp = XMPPServiceFactory.getXMPPService();
		SendResponse status = null;
		// if (xmpp.getPresence(jid).isAvailable()) {
		status = xmpp.sendMessage(msg);
		messageSent = (status.getStatusMap().get(jid) == SendResponse.Status.SUCCESS);

		// }

		if (!messageSent) {
			// Send an email message instead...
			System.err.println("Failed to send");
			log.severe("failed to send");
			return false;
		} else {
			return true;
		}

	}

	public static List<XMPPUser> getAllXMPP4UserBean(UserBean ub) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("userBeanId", ub.getId());
		List<XMPPUser> byUserId = new XmppController().list("getXmppUserByUserBeanId", m);
		return byUserId;
	}

	public static boolean notifyRestaurant(Restaurant rest, JsonObject msg) {
		boolean notified = false;
		Set<XMPPUser> byUserId = new HashSet<XMPPUser>();
		List<XMPPUser> forrest = getAllXMPP4UserBean(rest.getUser());
		byUserId.addAll(forrest);
		CentralManager cm = new CentralManager();
		if (cm.isRestaurantManagedByCentral(rest.getId())) {
			byUserId.addAll(getAllXMPP4UserBean(cm.getRestaurantCentral().getUser()));
		}
		log.log(Level.FINE, "Number of users for this restaurant are {0}, user id : {1}", new String[] { byUserId.size() + "", "" + rest.getUser().getId().getId() });

		for (Iterator iterator = byUserId.iterator(); iterator.hasNext();) {
			XMPPUser xmppUser = (XMPPUser) iterator.next();
			if (sendMessage(xmppUser.getUserId(), msg.toString())) {
				log.fine("Msg Sent!");
				notified = true;
			} else {
				log.severe("Failed to send msg");
			}
		}
		return notified;
	}
	public static boolean notifyCentral(Central central, JsonObject msg) {
		boolean notified = false;
		
		List<XMPPUser> forrest =getAllXMPP4UserBean(central.getUser()); 
		
		log.log(Level.FINE, "Number of users for this cenral are {0}, user id : {1}", new String[] { forrest.size() + "", "" + central.getUser().getId().getId() });

		for (Iterator iterator = forrest.iterator(); iterator.hasNext();) {
			XMPPUser xmppUser = (XMPPUser) iterator.next();
			if (sendMessage(xmppUser.getUserId(), msg.toString())) {
				log.fine("Msg Sent!");
				notified = true;
			} else {
				log.severe("Failed to send msg");
			}
		}
		return notified;
	}

	public static JsonObject getCancelledOrdersNotificationMsg(MealOrder mo) {
		JsonObject json = new JsonObject();
		json.add("type", new JsonPrimitive(CANCELLED_REQUESTS));
		return json;
	}

	public static JsonObject getNoMoreRequestsMsg() {
		JsonObject json = new JsonObject();
		json.add("type", new JsonPrimitive(NO_REQUESTS));
		return json;
	}

	public static JsonObject getPingMsg() {
		JsonObject json = new JsonObject();
		json.add("type", new JsonPrimitive(PING));
		return json;
	}

	public static JsonObject getPongMsg() {
		JsonObject json = new JsonObject();
		json.add("type", new JsonPrimitive(PONG));
		JsonObject data = new JsonObject();
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy kk:mm:ss");
		sdf.setTimeZone(TimeController.getDefaultTimeZone());
		String date = sdf.format(new Date());
		data.add("timestamp", new JsonPrimitive(date));
		json.add("data", data);
		return json;
	}

	private static SimpleDateFormat sdf = new SimpleDateFormat("kk:mm:ss dd/MM/yyyy");

	public static JsonObject getNewRequestsMsg(MealOrder mo) {
		JsonObject json = new JsonObject();
		json.add("type", new JsonPrimitive(NEW_REQUEST));
		JsonObject data = new JsonObject();
		try {
			sdf.setTimeZone(TimeController.getDefaultTimeZone());
			data.add("client", new JsonPrimitive(mo.getClientName()));
			data.add("orderedTime", new JsonPrimitive(sdf.format(mo.getOrderedTime())));
			data.add("notificationSent", new JsonPrimitive(sdf.format(new Date())));

		} catch (Exception e) {
			// TODO: handle exception
		}
		data.add("id", new JsonPrimitive(mo.getClient().getId().getId() + "." + mo.getId().getId()));
		json.add("data", data);
		return json;
	}

	@Override
	public String getDefaultQueryName() {
		// TODO Auto-generated method stub
		return "getXmpp";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return XMPPUser.class;
	}

}
