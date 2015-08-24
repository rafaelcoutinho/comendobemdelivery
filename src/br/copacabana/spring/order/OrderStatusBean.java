package br.copacabana.spring.order;

import java.util.List;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.MealOrderLogEntry;
import br.com.copacabana.cb.entities.Restaurant;

public class OrderStatusBean {
	MealOrder mo;
	List<MealOrderLogEntry> updates;
	Restaurant restaurant;

	public OrderStatusBean(MealOrder mo, List<MealOrderLogEntry> updates, Restaurant restaurant) {
		super();
		this.mo = mo;
		this.updates = updates;
		this.restaurant = restaurant;
	}

	public MealOrder getMo() {
		return mo;
	}

	public void setMo(MealOrder mo) {
		this.mo = mo;
	}

	public List<MealOrderLogEntry> getUpdates() {
		return updates;
	}

	public void setUpdates(List<MealOrderLogEntry> updates) {
		this.updates = updates;
	}

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}
}
