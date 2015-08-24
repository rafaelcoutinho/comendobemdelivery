package br.copacabana;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.binary.Base64;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.ContactInfo;
import br.com.copacabana.cb.entities.Person.Gender;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.com.copacabana.cb.entities.mgr.JPAManager;
import br.copacabana.exception.DataNotFoundException;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.UserBeanManager;
import br.copacabana.usecase.register.RegisterClient;
import br.copacabana.util.HttpUtils;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;

public class Authentication implements SessionCommand {

	public Authentication(JPAManager<UserBean> manager) {
		System.err.println("old constructor");
	}

	public Authentication() {

	}

	protected static final Logger log = Logger
			.getLogger("br.copacabana.AuthenticationController");
	private UserBean user;

	public static StringBuilder getMD5Digets(String str)
			throws NoSuchAlgorithmException {
		byte[] hashMsg = MessageDigest.getInstance("MD5")
				.digest(str.getBytes());
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < hashMsg.length; i++) {
			int byteValue = hashMsg[i];

			if (byteValue < 0) {
				byteValue += 256;
			}
			String hex = Integer.toHexString(byteValue);
			if (hex.length() == 1) {
				hex = "0" + hex;
			}
			sb.append(hex);

		}
		return sb;
	}

	public boolean authenticate(String username, String password,
			Boolean isBase64, Boolean isMd5) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", username);
		java.util.List<UserBean> l = new UserBeanManager().list(
				UserBean.Queries.getUserByLogin.name(), m);

		if (!l.isEmpty()) {
			user = l.get(0);
			String actualPwd = user.getPassword();
			if (isBase64) {
				actualPwd = actualPwd + "|" + session.getId();
				// used for non ssl logins
				actualPwd = new String(Base64.encodeBase64(
						actualPwd.getBytes(), false));
			}

			if (isMd5) {
				try {
					actualPwd = getMD5Digets(actualPwd).toString();
				} catch (NoSuchAlgorithmException e) {
					e.printStackTrace();
					log.severe("NoSuchAlgorithmException!!!");
					return false;
				}
			}

			if (actualPwd.equals(password)) {
				return true;
			} else {
				return false;
			}
		}
		return false;
	}

	public boolean tokenBaseAuthenticate(String username, String token,
			String seed, Boolean isMd5) {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", username);
		java.util.List<UserBean> l = new UserBeanManager().list(
				UserBean.Queries.getUserByLogin.name(), m);

		if (!l.isEmpty()) {
			user = l.get(0);
			String actualPwd = user.getPassword();
			String serverToken = seed + "|" + actualPwd;
			serverToken = new String(Base64.encodeBase64(
					serverToken.getBytes(), false));

			if (isMd5.booleanValue()) {
				try {
					serverToken = getMD5Digets(serverToken).toString();
				} catch (NoSuchAlgorithmException e) {
					log.severe("NoSuchAlgorithmException!!");
				}
			}

			if (serverToken.equals(token)) {
				return true;
			} else {
				return false;
			}
		}
		return false;
	}

	public UserBean getAuthenticatedUser() {

		return user;
	}

	private String userType;

	public Object getEntity() throws java.lang.Exception {
		String kind = user.getId().getParent().getKind();
		if ("CLIENT".equals(kind)) {
			ClientManager cm = new ClientManager();
			Client c = cm.getByLogin(user.getLogin());
			userType = "client";
			return c;
		} else if ("RESTAURANT".equals(kind)) {
			RestaurantManager rm = new RestaurantManager();
			Restaurant r = rm.getRestaurantByUserBean(user);
			userType = "restaurant";
			return r;
		} else if ("CENTRAL".equals(kind)) {
			CentralManager centralManager = new CentralManager();
			Central c = centralManager.getCentralByUserBean(user);
			userType = "central";
			return c;
		} else {
			log.log(Level.SEVERE, "User kind is unknown {0}", user.getId());
			throw new Exception("UserBean type is unknown");
		}

	}

	public static boolean validatePassword(String newPwd) throws JsonException {
		if (newPwd == null || newPwd.length() == 0) {
			throw new JsonException("emptyPwd",
					JsonException.ErrorCode.EMPTYPWD);

		}
		return true;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}

	public static boolean isUserLoggedIn(HttpSession session) {
		String sessionBean = (String) session.getAttribute("loggedUser");
		if (sessionBean == null) {
			return false;
		}
		JsonParser p = new JsonParser();
		JsonObject loggedUser = (JsonObject) p.parse(sessionBean);
		if (loggedUser.isJsonNull()) {
			return false;
		}
		return true;
	}

	public static Key getLoggedUserKey(HttpSession session)
			throws JsonException {
		JsonObject json = getLoggedUser(session);
		String kstr = json.get("entity").getAsJsonObject().get("id")
				.getAsString();
		return KeyFactory.stringToKey(kstr);
	}

	public enum AuthStatus {
		OK, OKWITHREGISTRATION, FAILED, MUSTRETRY, OAUTH_FB
	}

	private final String fbUrl = "https://graph.facebook.com/me?";

	public AuthStatus facebookBasedAuthentication(HttpServletRequest request,
			HttpSession session) throws Exception {
		try {
			if (request.getParameter("fbuser") != null) {
				return getUserFromRequest(request, true);
			} else {
				if (request.getParameter("accessToken") != null) {

				} else {
					for (int i = 0; i < request.getCookies().length; i++) {
						Cookie cookie = request.getCookies()[i];
						if (cookie.getName().startsWith("fbs_")) {
							return getUserFromCookie(cookie, true);
						}
					}
				}
			}
		} catch (IOException e) {
			log.log(Level.SEVERE, "Failted IO to FB authenticate ", e);
			return AuthStatus.MUSTRETRY;
		}

		return AuthStatus.FAILED;

	}

	private JsonObject facebookData;

	public AuthStatus getUserFromCookie(Cookie cookie, boolean createIfNewUser)
			throws IOException, Exception {

		String content = HttpUtils.getHttpContent(fbUrl + cookie.getValue());
		facebookData = new JsonParser().parse(content).getAsJsonObject();

		return handleFBUserData(facebookData, createIfNewUser);

	}

	public AuthStatus getUserFromRequest(HttpServletRequest req,
			boolean createIfNewUser) throws IOException, Exception {

		facebookData = new JsonParser().parse(req.getParameter("fbuser"))
				.getAsJsonObject();

		return handleFBUserData(facebookData, createIfNewUser);

	}

	public AuthStatus handleFBUserData(JsonObject facebookData,
			boolean createIfNewUser) throws IOException, Exception {
		return handleFBUserData(facebookData, createIfNewUser, true);
	}

	public AuthStatus innnerHandleFBUserData(String email) throws IOException,
			Exception {
		JsonObject json = new JsonObject();
		json.add("email", new JsonPrimitive(email));
		return handleFBUserData(json, false, false);
	}

	public AuthStatus handleFBUserData(JsonObject facebookData,
			boolean createIfNewUser, boolean update) throws IOException,
			Exception {
		UserBeanManager um = new UserBeanManager();
		try {
			this.user = um.getByLogin(facebookData.get("email").getAsString());
			boolean clientWasUpdated = false;
			if (this.user.getIsFacebook() == null
					|| this.user.getIsFacebook() == false) {
				this.user.setIsFacebook(true);
				this.user.setFacebookId(facebookData.get("id").getAsString());
				Datastore.getPersistanceManager().getTransaction().begin();
				um.persist(this.user);
				Datastore.getPersistanceManager().getTransaction().commit();
				this.user = um.getByLogin(facebookData.get("email")
						.getAsString());
			}

			ClientManager cm = new ClientManager();
			Client client = cm.getByLogin(facebookData.get("email")
					.getAsString());
			if (update) {
				if (client.getBirthday() == null) {
					String bstr = facebookData.get("birthday").getAsString();
					if (bstr != null) {
						SimpleDateFormat sdf = new SimpleDateFormat(
								"dd/MM/yyyy", TimeController.getDefaultLocale());
						sdf.setTimeZone(TimeController.getDefaultTimeZone());
						client.setBirthday(sdf.parse(bstr));
						clientWasUpdated = true;
					}
				}
				if (facebookData.get("gender") != null
						&& facebookData.get("gender").getAsString()
								.equals("female")) {
					client.setGender(Gender.FEMALE);
					clientWasUpdated = true;
				}
				if (Boolean.TRUE.equals(client.getMustVerifyEmail())) {
					client.setMustVerifyEmail(Boolean.FALSE);
					clientWasUpdated = true;
				}
			}
			if (clientWasUpdated) {
				Datastore.getPersistanceManager().getTransaction().begin();
				cm.persist(client);
				Datastore.getPersistanceManager().getTransaction().commit();
			}

			return AuthStatus.OK;
		} catch (DataNotFoundException e) {
			if (createIfNewUser == true) {
				log.info("Must create user account");
				this.user = new UserBean();
				this.user.setLogin(facebookData.get("email").getAsString());
				this.user.setIsFacebook(true);
				this.user.setFacebookId(facebookData.get("id").getAsString());
				Client client = new Client();
				client.setName(facebookData.get("name").getAsString());
				ContactInfo ci = new ContactInfo();
				ci.setEmail(facebookData.get("email").getAsString());
				client.setContact(ci);
				client.setUser(this.user);

				String bstr = facebookData.get("birthday").getAsString();
				if (bstr != null) {
					SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy",
							TimeController.getDefaultLocale());
					sdf.setTimeZone(TimeController.getDefaultTimeZone());
					client.setBirthday(sdf.parse(bstr));
				}

				if (facebookData.get("gender") != null
						&& facebookData.get("gender").getAsString()
								.equals("female")) {
					client.setGender(Gender.FEMALE);
				}
				client.setReceiveNewsletter(true);
				ClientManager cman = new ClientManager();
				client.setMustVerifyEmail(Boolean.FALSE);
				cman.create(client);
				Long invitationId = null;
				if (facebookData.get("cb_inviter_id") != null
						&& !facebookData.get("cb_inviter_id").isJsonNull()) {
					try {
						String inviter = facebookData.get("cb_inviter_id")
								.getAsString();
						RegisterClient.onNewClientRegistered(
								facebookData.get("email").getAsString(),
								invitationId, Boolean.TRUE, inviter);
					} catch (Exception ee) {
						ee.printStackTrace();
					}

				} else {
					RegisterClient.onNewClientRegistered(
							facebookData.get("email").getAsString(),
							invitationId, Boolean.TRUE, null);
				}

				return AuthStatus.OKWITHREGISTRATION;
			}
		} catch (Exception e) {
			if (facebookData != null) {
				log.log(Level.SEVERE, "FB Data: " + facebookData.toString());
			}
			log.log(Level.SEVERE, "Erro handling fb data.", e);
			throw e;

		}
		return AuthStatus.FAILED;
	}

	public boolean tokenBasedAuthentication(String username, String token,
			String seed, String md5, HttpSession session) throws Exception {

		Boolean isMD5 = Boolean.FALSE;
		if (md5 != null && md5.equals("true")) {
			isMD5 = Boolean.TRUE;
		}
		if (this.tokenBaseAuthenticate(username, token, seed, isMD5)) {
			AuthenticationController.setSessionValues(this, session);
			return true;
		} else {
			return false;
		}
	}

	public static JsonObject getLoggedUser(HttpSession session)
			throws JsonException {
		JsonParser p = new JsonParser();
		String sessionBean = (String) session.getAttribute("loggedUser");
		if (sessionBean == null) {
			throw new JsonException("usernotlogged", ErrorCode.USERNOTLOGGEDIN);
		}
		JsonObject loggedUser = (JsonObject) p.parse(sessionBean);
		return loggedUser;
	}

	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	public JsonObject getJsonObject() throws Exception {
		JsonObject sessionBean = new JsonObject();
		sessionBean.add("user", new JsonPrimitive(user.getLogin()));
		Object obj = getEntity();
		sessionBean.add("userType", new JsonPrimitive(getUserType()));
		if (getUserType().equals("restaurant")) {
			sessionBean.add("entity", getRestJsonData((Restaurant) obj));
		} else if (getUserType().equals("client")) {
			Client client = (Client) obj;
			JsonObject entityBean = new JsonObject();
			entityBean.add("login", new JsonPrimitive(client.getUser()
					.getLogin()));
			entityBean.add("name", new JsonPrimitive(client.getName()));
			entityBean.add("id",
					new JsonPrimitive(KeyFactory.keyToString(client.getId())));
			sessionBean.add("entity", entityBean);

		} else if (getUserType().equals("central")) {
			Central client = (Central) obj;
			JsonObject entityBean = new JsonObject();
			entityBean.add("name", new JsonPrimitive(client.getName()));
			entityBean.add("id",
					new JsonPrimitive(KeyFactory.keyToString(client.getId())));
			sessionBean.add("entity", entityBean);

		}
		return sessionBean;
	}

	public static JsonObject getRestJsonData(Restaurant rest) {

		JsonObject entityBean = new JsonObject();
		entityBean.add("name", new JsonPrimitive(rest.getName()));
		if (rest.getCurrentDelay() == null) {
			entityBean.add("currentDelay", new JsonPrimitive("30"));
		} else {
			entityBean.add("currentDelay",
					new JsonPrimitive(rest.getCurrentDelay()));
		}
		entityBean.add("id",
				new JsonPrimitive(KeyFactory.keyToString(rest.getId())));

		return entityBean;
	}

	public JsonObject getFacebookData() {
		return facebookData;
	}

	public void setFacebookData(JsonObject facebookData) {
		this.facebookData = facebookData;
	}

}
