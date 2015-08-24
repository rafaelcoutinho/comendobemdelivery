package br.copacabana.xmpp;

import java.io.IOException;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.persistence.NoResultException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.XMPPUser;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.copacabana.OrderDispatcher;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.UserBeanManager;
import br.copacabana.usecase.beans.GetPendingRestaurantOrders;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.xmpp.JID;
import com.google.appengine.api.xmpp.Message;
import com.google.appengine.api.xmpp.XMPPService;
import com.google.appengine.api.xmpp.XMPPServiceFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;

public class XMPPReceiverServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2642649531572317584L;
	protected static final Logger log = Logger.getLogger("copacabana.XMPP");

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
		XMPPService xmpp = XMPPServiceFactory.getXMPPService();
		Message message = xmpp.parseMessage(req);

		JID fromJid = message.getFromJid();
		String body = message.getBody();
		try {
			JsonObject json = new JsonParser().parse(body).getAsJsonObject();
			String type = json.get("type").getAsString();
			log.log(Level.FINEST, "json" + json.toString());
			if ("RECHECK".equals(type)) {
				log.log(Level.FINEST, "client is rechecking");
				String username = json.get("username").getAsString();
				UserBeanManager ubm = new UserBeanManager();
				UserBean ub = ubm.getByLogin(username);

				if (ub.isRestaurant()) {
					RestaurantManager rman = new RestaurantManager();
					Restaurant r = rman.getRestaurantByUserBean(ub);
					if (new OrderDispatcher().hasNewOrders(r)) {
						GetPendingRestaurantOrders getPendingCommand = new GetPendingRestaurantOrders();
						OrderManager oman = new OrderManager();
						getPendingCommand.setKey(r.getId());
						getPendingCommand.execute(oman);
						MealOrder mo = (MealOrder) ((List) getPendingCommand.getEntity()).get(0);
						JsonObject jsonRet = XmppController.getNewRequestsMsg(mo);
						XmppController.notifyRestaurant(r, jsonRet);
					} else {
						JsonObject jsonRet = XmppController.getNoMoreRequestsMsg();
						jsonRet.add("verbosity", new JsonPrimitive(true));
						XmppController.notifyRestaurant(r, jsonRet);
					}
				} else if (ub.isCentral()) {
					CentralManager cm = new CentralManager();
					Central c = cm.getCentralByUserBean(ub);
					// might be a central
					OrderDispatcher odispatcher = new OrderDispatcher();
					OrderManager oman = new OrderManager();
					boolean hasNewOrders = false;
					MealOrder mo = null;
					for (Iterator<Key> iterator = c.getRestaurants().iterator(); iterator.hasNext();) {
						Key restId = (Key) iterator.next();
						if (odispatcher.hasNewOrders(restId)) {
							List<MealOrder> orders = oman.getNewOrdersForRestaurant(restId);
							if (orders != null && !orders.isEmpty()) {
								hasNewOrders = true;
								mo = (MealOrder) orders.get(0);
								break;
							}
						}

					}
					if (hasNewOrders) {
						JsonObject jsonRet = XmppController.getNewRequestsMsg(mo);
						XmppController.notifyCentral(c, jsonRet);
					} else {
						JsonObject jsonRet = XmppController.getNoMoreRequestsMsg();
						jsonRet.add("verbosity", new JsonPrimitive(true));
						XmppController.notifyCentral(c, jsonRet);
					}

				}
			} else if ("ACK".equals(type)) {
				log.log(Level.FINEST, "client has acknoledged msg");
			} else if ("PONG".equals(type)) {
				log.log(Level.FINEST, "client has replied to ping");
				String username = json.get("username").getAsString();
				updateLastUseFor(username);
			} else if ("PING".equals(type)) {
				log.log(Level.FINEST, "client has pinged");
				UserBeanManager ubm = new UserBeanManager();
				String username = json.get("username").getAsString();
				log.log(Level.FINEST, "client {0} has pinged", username);
				UserBean ub = ubm.getByLogin(username);
				JsonObject jsonObj = XmppController.getPongMsg();
				if (ub.isRestaurant()) {
					RestaurantManager rman = new RestaurantManager();
					Restaurant r = rman.getRestaurantByUserBean(ub);
					XmppController.notifyRestaurant(r, jsonObj);
				} else if (ub.isCentral()) {
					CentralManager cm = new CentralManager();
					Central c = cm.getCentralByUserBean(ub);
					XmppController.notifyCentral(c, jsonObj);
				} else {
					log.log(Level.SEVERE, "Failed to process XMPP Msg. Could not find restaurant/client with login: {0}", body);
					throw new NoResultException("Login " + body + " not found");
				}
				updateLastUseFor(username);
			} else {
				log.log(Level.FINEST, "forwarding msg to dev. body: ", body);
				XmppController.sendMessage("rafael.coutinho@jabber.org", "chat from " + fromJid.getId() + " dizendo '" + body);
			}

		} catch (NoResultException e) {
			log.log(Level.SEVERE, "Failed to process XMPP Msg. Could not find restaurant with login: {0}", body);
		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to process XMPP Msg", e);
		}
	}

	private void updateLastUseFor(String username) throws Exception {
		UserBean ub = new UserBeanManager().getByLogin(username);

		List<XMPPUser> byUserId = XmppController.getAllXMPP4UserBean(ub);
		if (byUserId == null || byUserId.size() == 0) {
			log.log(Level.SEVERE, "Received a pong from a restaurant but no user was associated to it. {0}", new Object[] { username });
		}
		for (Iterator<XMPPUser> iterator = byUserId.iterator(); iterator.hasNext();) {
			XMPPUser xmppUser = (XMPPUser) iterator.next();
			xmppUser.setLastUse(new Date());
			new XmppController().persist(xmppUser);
		}
	}
}
