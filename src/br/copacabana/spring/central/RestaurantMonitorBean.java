package br.copacabana.spring.central;

import java.util.ArrayList;
import java.util.List;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;

import com.google.appengine.api.datastore.KeyFactory;

public class RestaurantMonitorBean implements Comparable<RestaurantMonitorBean>{
	private Restaurant restaurant;
	private List<MealOrder> newOrders = new ArrayList<MealOrder>();
	private List<MealOrder> onGoingOrders = new ArrayList<MealOrder>();
	boolean selected = false;

	public Restaurant getRestaurant() {
		return restaurant;
	}
	
	public String getRestaurantKey() {
		return KeyFactory.keyToString(restaurant.getId());
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

	public List<MealOrder> getNewOrders() {
		return newOrders;
	}

	public void setNewOrders(List<MealOrder> newOrders) {
		this.newOrders = newOrders;
	}

	public List<MealOrder> getOnGoingOrders() {
		return onGoingOrders;
	}

	public void setOnGoingOrders(List<MealOrder> onGoingOrders) {
		this.onGoingOrders = onGoingOrders;
	}

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	
	@Override
	public int compareTo(RestaurantMonitorBean o) {
		if(this.getNewOrders().size()==o.getNewOrders().size()){
			return o.getOnGoingOrders().size()-this.getOnGoingOrders().size();
		}else{		
			return o.getNewOrders().size()-this.getNewOrders().size();
		}
		
		
	}

}
