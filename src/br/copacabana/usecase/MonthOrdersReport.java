package br.copacabana.usecase;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;
import br.copacabana.GsonSerializable;
import br.copacabana.RetrieveCommand;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.usecase.beans.MealOrderSimpleSerializer;

import com.google.appengine.api.datastore.Key;

public class MonthOrdersReport extends RetrieveCommand implements Command, ReturnValueCommand, GsonSerializable {
	private Key restaurant;
	private Date start;
	private Date end;
	private String[] status;

	@Override
	public void execute() throws Exception {
		OrderManager mman = new OrderManager();
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("restaurant", restaurant);
		m.put("start", start);
		m.put("end", end);
		List l = new ArrayList();
		for (int i = 0; i < status.length; i++) {
			MealOrderStatus moStatus = MealOrderStatus.valueOf(status[i]);
			m.put("status", moStatus);
			l.addAll(mman.list("listRestMealsFromMonth", m));
		}

		this.entity = l;

	}

	public Key getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Key restaurant) {
		this.restaurant = restaurant;
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
}
