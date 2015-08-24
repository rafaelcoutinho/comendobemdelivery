package br.copacabana.usecase;

import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.XMPPUser;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.Command;
import br.copacabana.ReturnValueCommand;
import br.copacabana.commands.IPableCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.UserBeanManager;
import br.copacabana.xmpp.XmppController;

import com.google.appengine.api.xmpp.JID;
import com.google.appengine.api.xmpp.Message;
import com.google.appengine.api.xmpp.MessageBuilder;
import com.google.appengine.api.xmpp.SendResponse;
import com.google.appengine.api.xmpp.XMPPService;
import com.google.appengine.api.xmpp.XMPPServiceFactory;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.ibm.icu.util.Calendar;

public class XMPPUserProvider implements Command, ReturnValueCommand, SessionCommand, IPableCommand {
	private String token;
	private String username;
	private String isMD5;
	private String version;
	private String ip;
	private HttpSession session;
	private JsonObject response;
	protected static final Logger log = Logger.getLogger("copacabana.XMPP");

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {

		UserBeanManager uMan = new UserBeanManager();
		Authentication auth = new Authentication();
		if (auth.tokenBasedAuthentication(username, token, ServerClientMonitors.getSeed(), isMD5, session)) {
			UserBean ub = auth.getAuthenticatedUser();

			XMPPUser xuser = getAvailableXMPPUser(ub, ip);
			JsonObject json = new JsonObject();
			if (xuser == null) {
				json.add("status", new JsonPrimitive("nouseravailable"));

				if (log.isLoggable(Level.INFO)) {
					log.log(Level.SEVERE, "No XMPP user available, ip that tried was {0} and user was {1}", new String[] { ip, ub.getLogin() });
				}
			} else {

				updateXMPPUser(xuser, ip, ub, version);
				json.add("status", new JsonPrimitive("ok"));
				JsonObject accessjson = new JsonObject();
				accessjson.add("username", new JsonPrimitive(xuser.getUserId()));
				accessjson.add("password", new JsonPrimitive(xuser.getUserPassword()));

				List newOrders = ServerClientMonitors.loadAllRestNewOrders(auth, new OrderManager());
				JsonObject hasNewOrders = new JsonObject();
				hasNewOrders.add("total", new JsonPrimitive(newOrders.size()));
				if (newOrders.size() > 0) {
					JsonArray orders = new JsonArray();
					for (Iterator<MealOrder> iterator = newOrders.iterator(); iterator.hasNext();) {
						MealOrder mo = (MealOrder) iterator.next();
						JsonObject moitem = new JsonObject();
						moitem.add("id", new JsonPrimitive(mo.getClient().getId().getId() + "." + mo.getId().getId()));
						orders.add(moitem);
					}
					hasNewOrders.add("orders", orders);
				}
				accessjson.add("hasNewOrders", hasNewOrders);

				json.add("data", accessjson);
			}
			response = json;

		} else {
			JsonObject json = new JsonObject();
			json.add("status", new JsonPrimitive("failed"));
			response = json;
		}

	}

	public static boolean isOnline(String user) {
		if (1 == 1) {
			// TODO still need to find a way to handle it
			return false;
		}
		JID jid = new JID(user);
		XMPPService xmpp = XMPPServiceFactory.getXMPPService();

		Message msg = new MessageBuilder().withRecipientJids(jid).withBody("{'type':99}").build();

		boolean messageSent = false;

		SendResponse status = null;
		if (xmpp.getPresence(jid).isAvailable()) {
			status = xmpp.sendMessage(msg);
			messageSent = (status.getStatusMap().get(jid) == SendResponse.Status.SUCCESS);

			if (messageSent) {
				if (log.isLoggable(Level.FINE)) {
					log.log(Level.FINE, "user is online {0} ", user);
				}
				return true;
			} else {
				if (log.isLoggable(Level.FINE)) {
					log.log(Level.FINE, "user is OFFline {0} ", user);
				}
				return false;
			}
		}
		if (log.isLoggable(Level.INFO)) {
			log.log(Level.INFO, "user is OFFline {0}  ", user);
		}
		if (log.isLoggable(Level.FINE)) {
			log.log(Level.FINE, "Failed to send");
			// Send an email message instead...
			System.err.println("Failed to send");
			for (Iterator iterator = status.getStatusMap().keySet().iterator(); iterator.hasNext();) {
				JID type = (JID) iterator.next();
				log.log(Level.FINE, "Type : {0}", type);
				log.log(Level.FINE, "Status : {0}", status.getStatusMap().get(type).name());

			}
		}
		return false;

	}

	private void updateXMPPUser(XMPPUser xuser, String ip2, UserBean ub, String version) {
		XmppController xmpMan = new XmppController();
		xuser.setIp(ip2);
		xuser.setLastUse(new Date());
		xuser.setAssociatedUserBeanId(ub.getId());
		xuser.setClientVersion(version);
		try {
			xmpMan.persist(xuser);
		} catch (Exception e) {
			log.log(Level.SEVERE, "Erro ao atualizar xmpp no banco do usuario {0} ip {1} exce {2}", new Object[] { ub.getLogin(), ip2, e });
			log.log(Level.SEVERE, "Exception", e);
		}
	}

	private XMPPUser getAvailableXMPPUser(UserBean ub, String ip2) {

		// get list of existing available users from the same user bean
		List<XMPPUser> byUserId = XmppController.getAllXMPP4UserBean(ub);
		if (byUserId.isEmpty()) {
			if (log.isLoggable(Level.FINE)) {
				log.log(Level.FINE, "Não há nenhum xmpp que foi associados a esse userbean {0}", ub.getLogin());
			}
			return getAnyAvailableXMPPUser();
		} else {
			if (log.isLoggable(Level.FINE)) {
				log.log(Level.FINE, "Há associações com este usuario {0} checando por ip {1}", new String[] { ub.getLogin(), ip });
			}
			XMPPUser oldest = null;
			for (Iterator<XMPPUser> iterator = byUserId.iterator(); iterator.hasNext();) {
				XMPPUser xmppUser = (XMPPUser) iterator.next();
				if (oldest == null) {
					oldest = xmppUser;
				} else {
					if (oldest.getLastUse().after(xmppUser.getLastUse())) {
						oldest = xmppUser;
					}
				}
				if (xmppUser.getIp().equals(ip)) {
					if (log.isLoggable(Level.FINE)) {
						log.log(Level.FINE, "Encontrada associaçao antiga com ip {0}, retornando {1}.", new String[] { ip, xmppUser.getUserId() });
					}
					return xmppUser;
				}
			}
			if (log.isLoggable(Level.FINE)) {
				log.log(Level.FINE, "Nenhuma associacao encontrada com ip {0}, retornando a mais antiga das associaçoes {1}.", new String[] { ip, oldest.getUserId() });
			}
			return oldest;
		}
	}

	private XMPPUser getAnyAvailableXMPPUser() {
		List<XMPPUser> alllist = new XmppController().list("getXmppUserByLastUse");
		if (log.isLoggable(Level.FINE)) {
			log.log(Level.FINE, "Procurando um xmpp user livre dentre {0}", alllist.size());
		}

		for (Iterator iterator = alllist.iterator(); iterator.hasNext();) {
			XMPPUser xmppUser = (XMPPUser) iterator.next();

			if (xmppUser.getLastUse() == null) {
				log.log(Level.FINE, "XMPP user livre: {0} nunca usado", xmppUser.getUserId());
				return xmppUser;
			}
			Calendar c = Calendar.getInstance();
			c.add(Calendar.DAY_OF_YEAR, -1);
			if (xmppUser.getLastUse().before(c.getTime())) {
				if (log.isLoggable(Level.FINE)) {
					log.log(Level.FINE, "XMPP user livre: {0} muito tempo sem uso", xmppUser.getUserId());
				}
				return xmppUser;
			}
			// if (!isOnline(xmppUser.getUserId())) {
			// if (log.isLoggable(Level.FINE)) {
			// log.log(Level.FINE, "XMPP user livre: {0}",
			// xmppUser.getUserId());
			// }
			// return xmppUser;
			// }

		}
		log.log(Level.SEVERE, "Nenhum XMPP  livre!!");
		return null;
	}

	@Override
	public Object getEntity() {
		return response;
	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getIsMD5() {
		return isMD5;
	}

	public void setIsMD5(String isMD5) {
		this.isMD5 = isMD5;
	}

	@Override
	public void setIp(String ip) {
		this.ip = ip;

	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

}