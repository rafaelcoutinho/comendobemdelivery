package br.copacabana.spring.order;

import br.com.copacabana.cb.entities.Feedback;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;

import com.google.appengine.api.datastore.KeyFactory;

public class FeedbackBean {
	MealOrder mealOrder = null;
	Feedback f = null;
	Restaurant restaurant = null;

	public FeedbackBean(Feedback f, MealOrder mo) {
		this.f = f;
		this.mealOrder = mo;
	}

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public MealOrder getMealOrder() {
		return mealOrder;
	}
	public String getMealOrderIdStr() {
		return KeyFactory.keyToString(mealOrder.getId());
	}

	public void setMealOrder(MealOrder mealOrder) {
		this.mealOrder = mealOrder;
	}

	public Feedback getF() {
		return f;
	}

	public void setF(Feedback f) {
		this.f = f;
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

}
