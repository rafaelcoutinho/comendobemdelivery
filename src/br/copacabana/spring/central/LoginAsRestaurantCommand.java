package br.copacabana.spring.central;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.AuthenticationController;
import br.copacabana.GsonSerializable;
import br.copacabana.RetrieveCommand;
import br.copacabana.marshllers.RestaurantMonitorBeanSerializer;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.UserBeanManager;
import br.copacabana.usecase.beans.MealOrderSimpleSerializer;

import com.google.appengine.api.datastore.Key;

public class LoginAsRestaurantCommand extends RetrieveCommand<String> implements  SessionCommand, GsonSerializable {
	private HttpSession session;
	private Key key;
	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	@Override
	public void execute(Manager manager) throws Exception {

		Key currCentral = Authentication.getLoggedUserKey(session);
		CentralManager centralManager = new CentralManager();
		if (centralManager.isRestaurantManagedByCentral(key) && centralManager.getRestaurantCentral().getId().equals(currCentral)) {
			RestaurantManager rm = new RestaurantManager();
			Restaurant r = rm.getRestaurant(key);
			UserBeanManager uman = new UserBeanManager();
			UserBean ub = r.getUser();
			Authentication auth = new Authentication(null);
			auth.authenticate(ub.getLogin(), ub.getPassword(), false, false);
			AuthenticationController.setSessionValues(auth, session);
			log.info("Authenticado como: " + r.getName());

		}
		this.entity = "";
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(MealOrder.class, new MealOrderSimpleSerializer());
		m.put(RestaurantMonitorBean.class, new RestaurantMonitorBeanSerializer(man));
		return m;
	}

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	public Key getKey() {
		return key;
	}

	public void setKey(Key key) {
		this.key = key;
	}
}
