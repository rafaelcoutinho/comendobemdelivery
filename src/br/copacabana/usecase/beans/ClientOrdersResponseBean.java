package br.copacabana.usecase.beans;

import java.util.ArrayList;
import java.util.List;

import br.com.copacabana.cb.entities.MealOrder;

import com.google.gson.annotations.Expose;

public class ClientOrdersResponseBean {
	@Expose
	private List<MealOrder> orders = new ArrayList<MealOrder>();
	@Expose
	private List<MealOrder> recentOrders = new ArrayList<MealOrder>();
	@Expose
	private String[] orderStatus = new String[0];

	public List<MealOrder> getOrders() {
		return orders;
	}

	public void setOrders(List<MealOrder> allMeals) {
		this.orders = allMeals;
	}

	public List<MealOrder> getRecentOrders() {
		return recentOrders;
	}

	public void setRecentOrders(List<MealOrder> recentMeals) {
		this.recentOrders = recentMeals;
	}

	public String[] getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(String[] orderStatus) {
		this.orderStatus = orderStatus;
	}

}
