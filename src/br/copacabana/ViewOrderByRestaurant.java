package br.copacabana;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.marshllers.DateTimeSerializer;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class ViewOrderByRestaurant extends RetrieveCommand<MealOrder> implements SessionCommand, GsonSerializable {
	protected HttpSession s;

	@Override
	public void setSession(HttpSession s) {
		this.s = s;
	}

	private boolean isAdmin() {
		try {
			UserService userService = UserServiceFactory.getUserService();
			return userService.isUserAdmin();
		} catch (Exception e) {

		}
		return false;
	}

	@Override
	public void execute(Manager manager) throws Exception {

		super.execute(manager);

		MealOrder order = (MealOrder) entity;
		if (Authentication.isUserLoggedIn(s)) {
			if (order.getRestaurant().equals(Authentication.getLoggedUserKey(s))) {
				MealOrderStatus status = order.getStatus();
				if (status.equals(MealOrderStatus.NEW)) {
					order.setStatus(MealOrderStatus.VISUALIZEDBYRESTAURANT);
					manager.update(order);
				}
			}
		}
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(Date.class, new DateTimeSerializer());
		//m.put(MealOrder.class, new MealOrderSimpleSerializer());
		return m;

	}

}
