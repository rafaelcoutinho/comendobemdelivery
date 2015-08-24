package br.copacabana.usecase;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.Command;
import br.copacabana.GsonSerializable;
import br.copacabana.RetrieveCommand;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.usecase.beans.MealOrderSimpleSerializer;
import br.copacabana.util.TimeController;

import com.google.gson.JsonObject;

public class OrdersByDateRange extends RetrieveCommand implements Command, SessionCommand, ReturnValueCommand, GsonSerializable {

	private Date start;
	private Date end;
	private String[] status;
	private HttpSession session;

	private static TimeZone defaultTZ = TimeController.getDefaultTimeZone();
	private static Locale brazilLocale = new Locale("pt", "br");

	@Override
	public void execute() throws Exception {
		OrderManager mman = new OrderManager();
		Map<String, Object> m = new HashMap<String, Object>();
		JsonObject sessionBean = Authentication.getLoggedUser(session);
		String userType = sessionBean.get("userType").getAsString();
		List l = new ArrayList();
		if (start == null || end == null) {
			Calendar now = java.util.Calendar.getInstance(defaultTZ, brazilLocale);
			now.set(Calendar.HOUR_OF_DAY, 0);
			now.set(Calendar.MINUTE, 0);
			start = now.getTime();
			Calendar endCalendar = java.util.Calendar.getInstance(defaultTZ, brazilLocale);
			endCalendar.set(Calendar.HOUR_OF_DAY, 23);
			endCalendar.set(Calendar.MINUTE, 59);
			end = endCalendar.getTime();

		}
		if (userType.equals("restaurant")) {
			m.put("restaurant", Authentication.getLoggedUserKey(session));
			m.put("start", start);
			m.put("end", end);

			for (int i = 0; i < status.length; i++) {
				MealOrderStatus moStatus = MealOrderStatus.valueOf(status[i]);
				m.put("status", moStatus);
				l.addAll(mman.list("listRestMealsByDateRange", m));
			}
		} else {
			m.put("client", Authentication.getLoggedUserKey(session));
			m.put("start", start);
			m.put("end", end);

			for (int i = 0; i < status.length; i++) {
				MealOrderStatus moStatus = MealOrderStatus.valueOf(status[i]);
				m.put("status", moStatus);
				l.addAll(mman.list("listClientMealsByDateRange", m));
			}

		}

		this.entity = l;

	}

	public Date getStart() {
		return start;
	}

	public void setStart(Date start) {
		this.start = start;
	}

	public Date getEnd() {
		return end;
	}

	public void setEnd(Date end) {
		this.end = end;
	}

	public String[] getStatus() {
		return status;
	}

	public void setStatus(String[] status) {
		this.status = status;
	}

	@Override
	public Map<Class, Object> getGsonAdapters(Manager man) {
		Map<Class, Object> m = new HashMap<Class, Object>();
		m.put(MealOrder.class, new MealOrderSimpleSerializer());
		return m;
	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}
}
