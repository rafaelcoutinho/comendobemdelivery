package br.copacabana;

import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;

import javax.cache.Cache;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.datanucleus.sco.backed.ArrayList;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.validation.BindException;
import org.springframework.validation.Errors;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.LoginSession;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.Restaurant.SiteStatus;
import br.com.copacabana.cb.entities.State;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.WarnMessage;
import br.com.copacabana.cb.entities.WorkingHours;
import br.com.copacabana.cb.entities.mgr.WarnMessageManager;
import br.copacabana.Authentication.AuthStatus;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.UserBeanManager;
import br.copacabana.spring.pe.CityPropertyEditor;
import br.copacabana.spring.pe.FoodCategoryPropertyEditor;
import br.copacabana.spring.pe.KeyPropertyEditor;
import br.copacabana.spring.pe.KeyWrapperPropertyEditor;
import br.copacabana.spring.pe.NeighborPropertyEditor;
import br.copacabana.spring.pe.SimplePropertyEditor;
import br.copacabana.spring.pe.StatePropertyEditor;
import br.copacabana.usecase.SessionMonitor;
import br.copacabana.usecase.beans.ClientOrdersResponseBean;
import br.copacabana.usecase.beans.GetClientOrders;
import br.copacabana.usecase.control.UserActionManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

/**
 * @author Rafael Coutinho
 */
public class AuthenticationController extends PersistController {
	// protected String objectClass;
	//
	// public String getObjectClass() {
	// return objectClass;
	// }
	//
	// public void setObjectClass(String objectClass) {
	// this.objectClass = objectClass;
	// }
	private Boolean base64 = Boolean.FALSE;

	@SuppressWarnings("unchecked")
	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
		try {
			logger.debug("initBinder");
			super.initBinder(request, binder);
			// binder.registerCustomEditor(State.class, new
			// StatePropertyEditor(manager));
			binder.registerCustomEditor(City.class, new CityPropertyEditor(manager));
			binder.registerCustomEditor(State.class, new StatePropertyEditor(manager));
			binder.registerCustomEditor(FoodCategory.class, new FoodCategoryPropertyEditor(manager));
			binder.registerCustomEditor(Neighborhood.class, new NeighborPropertyEditor(manager));
			binder.registerCustomEditor(Restaurant.class, new SimplePropertyEditor<Restaurant>(manager, Restaurant.class));
			binder.registerCustomEditor(WorkingHours.class, new SimplePropertyEditor<WorkingHours>(manager, WorkingHours.class));
			binder.registerCustomEditor(KeyWrapper.class, new KeyWrapperPropertyEditor(manager));
			binder.registerCustomEditor(Key.class, new KeyPropertyEditor());
			binder.registerCustomEditor(ArrayList.class, new CustomCollectionEditor(List.class, false));
			binder.registerCustomEditor(HashSet.class, new CustomCollectionEditor(Set.class, false));

		} catch (Throwable e) {
			// TODO: handle exception
			e.printStackTrace();
			throw new JsonException(e.getMessage());

		}
	}

	@Override
	protected ModelAndView showForm(HttpServletRequest request, HttpServletResponse response, BindException errors) throws Exception {
		errors.printStackTrace();
		return super.showForm(request, response, errors);
	}

	// reestabelecer o form
	@SuppressWarnings("unchecked")
	protected Object formBackingObject(HttpServletRequest request) throws Exception {
		return new UserBean();
	}

	@Override
	protected Map<String, Object> referenceData(HttpServletRequest request, Object command, Errors errors) throws Exception {
		return new HashMap<String, Object>();
	}

	@Override
	protected void onBind(HttpServletRequest request, Object command, BindException errors) throws Exception {
		try {
			super.onBind(request, command, errors);
		} catch (Exception e) {
			e.printStackTrace();
			throw new JsonException(e.getMessage());
		}
	}

	@Override
	protected void onBind(HttpServletRequest request, Object command) throws Exception {

		try {
			super.onBind(request, command);
		} catch (Exception e) {
			e.printStackTrace();
			throw new JsonException(e.getMessage());
		}
	}

	private String getConfValue(String key) {
		Configuration weeklyHighlightImageAlt = new ConfigurationManager().get(key);
		if (weeklyHighlightImageAlt == null) {
			logger.error("Cannot find " + key + "configuration");
			return "";
		}
		return weeklyHighlightImageAlt.getValue();
	}

	@Override
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object object, BindException errors) throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();

		try {
			Authentication auth = new Authentication();
			UserBean user = (UserBean) object;
			if (auth instanceof SessionCommand) {
				((SessionCommand) auth).setSession(request.getSession());
			}
			AuthStatus authStatus = AuthStatus.FAILED;
			String isFacebookAuthentication = request.getParameter("isFacebook");

			if (isFacebookAuthentication != null && "true".equals(isFacebookAuthentication)) {
				authStatus = auth.facebookBasedAuthentication(request, request.getSession());
			} else {
				String isNew = request.getParameter("isMD5");
				Boolean isMd5 = Boolean.FALSE;
				if (isNew != null && isNew.equals("true")) {
					isMd5 = Boolean.TRUE;
				}
				if (auth.authenticate(user.getLogin(), user.getPassword(), base64, isMd5)) {
					authStatus = AuthStatus.OK;
				} else {
					if (!"true".equals(isFacebookAuthentication)) {
						try {
							UserBean ruser = new UserBeanManager().getByLogin(user.getLogin());
							if (ruser.getIsFacebook()) {
								if (ruser.getPassword() == null || ruser.getPassword().length() == 0) {
									authStatus = AuthStatus.OAUTH_FB;
								} else {
									// authStatus=AuthStatus.OAUTH_FB_WITH_PWD;//TODO
									// talvez no futuro usar outra msg dizendo q
									// ele pode tanto lembrar a senha qto usar o
									// facebook
								}
							}
						} catch (Exception e) {
							// TODO: handle exception
						}

					}
				}
			}

			JsonObject returnObj = new JsonObject();
			if (AuthStatus.OK.equals(authStatus) || AuthStatus.OKWITHREGISTRATION.equals(authStatus)) {

				returnObj.add("status", new JsonPrimitive(true));
				JsonObject sessionBean = setSessionValues(auth, request.getSession());
				model.put("sessionBean", sessionBean.toString());
				returnObj.add("sessionBean", sessionBean);
				model.put("user", user);
				if (auth.getUserType() == "client") {
					JsonObject moreInfo = new JsonObject();
					GetClientOrders gc = new GetClientOrders();
					gc.setSession(request.getSession());
					gc.execute(new OrderManager());

					if (((ClientOrdersResponseBean) gc.getEntity()) != null && ((ClientOrdersResponseBean) gc.getEntity()).getOrders().size() > 0) {
						moreInfo.add("pendingOrders", new JsonPrimitive(((ClientOrdersResponseBean) gc.getEntity()).getOrders().size()));
					} else {
						moreInfo.add("pendingOrders", new JsonPrimitive(0));

					}
					Cache cache = CacheController.getCache();
					if (cache.get("cbNews") == null) {
						cache.put("cbNews", getConfValue("cbNews"));
					}
					moreInfo.add("cbNews", new JsonPrimitive((String) cache.get("cbNews")));

					returnObj.add("moreInfo", moreInfo);
				}

			} else {
				returnObj.add("status", new JsonPrimitive(false));
				returnObj.add("authStatus", new JsonPrimitive(authStatus.name()));
				returnObj.add("sessionId", new JsonPrimitive(request.getSession().getId()));
			}

			model.put("json", returnObj.toString());
			return new ModelAndView(getSuccessView(), model);
		} catch (Exception e) {
			log.log(Level.SEVERE, "Error during authentication", e);
			throw new JsonException(e.getMessage());
		}

	}

	public static JsonObject setSessionValues(Authentication auth, HttpSession session) throws Exception {
		JsonObject sessionBean = auth.getJsonObject();
		session.setAttribute("loggedUser", sessionBean.toString());
		LoginSession ls = new LoginSession();
		if (auth.getUserType().equals("restaurant")) {
			Restaurant rest = (Restaurant) auth.getEntity();
			if (!SiteStatus.ACTIVE.equals(rest.getSiteStatus())) {
				if (SiteStatus.SOON.equals(rest.getSiteStatus())) {

				} else {
					session.setAttribute("restaurantNotActive", rest.getSiteStatus());
					if (rest.getSiteStatus() == null) {
						session.setAttribute("restaurantNotActive", SiteStatus.MUSTACCEPTTERMS);
					}
				}
			}
			ls.setBasicInfo(rest.getName());
			ls.setBasicInfo(rest.getName() + " " + rest.getUser().getLogin());
			ls.setLoggedKey(rest.getId());
			ls.setType("restaurant");
			session.setAttribute("userName", rest.getName());
			// check if rest is ERP client
			String erpClients = new ConfigurationManager().getConfigurationExtendedValue("erpClients");
			if (erpClients.contains(KeyFactory.keyToString(rest.getId()))) {
				session.setAttribute("isERPClient", true);
			}
		} else if (auth.getUserType().equals("client")) {
			Client rest = (Client) auth.getEntity();
			handleBlackList(rest, session);
			session.setAttribute("isFBUser", rest.getUser().getIsFacebook());
			ls.setBasicInfo(rest.getName() + " " + rest.getUser().getLogin());
			ls.setLoggedKey(rest.getId());
			ls.setType("client");
			if (Boolean.TRUE.equals(rest.getMustVerifyEmail())) {
				session.setAttribute("USER_MUST_VERIFY_EMAIL", rest.getMustVerifyEmail());
				WarnMessageManager wmm = new WarnMessageManager();
				WarnMessage msg = wmm.getOrCreateConfEmailByUser(rest.getUser().getId());
				session.setAttribute("ConfEmailWarnMessage", msg);
			}
			session.setAttribute("userName", rest.getName());

		} else if (auth.getUserType().equals("central")) {
			Central rest = (Central) auth.getEntity();
			ls.setBasicInfo(rest.getName() + " " + rest.getUser().getLogin());
			ls.setLoggedKey(rest.getId());
			ls.setType("central");
			session.setAttribute("userName", rest.getName());
		}

		ls.setLoggedIn(new Date());

		SessionMonitor.addLoggedIn(ls, session.getServletContext());

		session.setAttribute("loggedTime", Long.valueOf(new Date().getTime()));
		session.setAttribute("userType", auth.getUserType());
		return sessionBean;
	}

	private static void handleBlackList(Client rest, HttpSession session) {
		try {
			String largerConf = new ConfigurationManager().getConfigurationExtendedValue("blacklist");
			if (largerConf.contains("|"+rest.getUser().getIdStr() + "|")) {
				UserActionManager.blackListUserLoggedIn(rest, session);
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Erro ao tratar black list", e);
		}

	}

	public Boolean getBase64() {
		return base64;
	}

	public void setBase64(Boolean base64) {
		this.base64 = base64;
	}

}