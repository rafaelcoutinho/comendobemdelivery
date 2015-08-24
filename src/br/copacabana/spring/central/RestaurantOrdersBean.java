package br.copacabana.spring.central;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.OrderType;
import br.com.copacabana.cb.entities.Payment;
import br.com.copacabana.cb.entities.Payment.PaymentType;
import br.com.copacabana.cb.entities.Restaurant;

public class RestaurantOrdersBean {
	private static final int NUMBER_OF_ORDERS = 2;
	private static final int COMISSION_IN_ORDER = 3;
	private static final int TOTAL_BY_PAYMENT_TYPE = 0;
	private static final int ONLINE_ORDERS = 4;
	
	private static final int NUMBER_OF_ONLINE_ORDERS = 5;
	private static final int ERP_ORDERS = 6;
	private static final int NUMBER_OF_ERP_ORDERS = 7;
	private Restaurant restaurant;
	private Date start;
	private Date end;
	private List<MealOrder> orders;

	public RestaurantOrdersBean(Restaurant restaurant, Date start, Date end) {
		super();
		this.restaurant = restaurant;
		this.start = start;
		this.end = end;
	}

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Restaurant restaurant) {
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

	public List<MealOrder> getOrders() {
		return orders;
	}

	public void setOrders(List<MealOrder> orders) {
		this.orders = orders;
		getTotals();

	}

	Integer totals = null;

	private Map<PaymentType, Integer[]> byPayment = new HashMap<Payment.PaymentType, Integer[]>();

	public Integer getTotals() {
		if (totals == null) {
			totals = 0;
			for (Iterator<MealOrder> iterator = orders.iterator(); iterator.hasNext();) {
				MealOrder order = (MealOrder) iterator.next();
				int totalInCents = order.getRestaurantAmountInCents();
				totals += totalInCents;
				Integer[] totalsByPayment = byPayment.get(order.getPayment().getType());
				if (totalsByPayment == null) {
					totalsByPayment = new Integer[] { 0, 0, 0, 0, 0, 0, 0,0 };
				}

				totalsByPayment[TOTAL_BY_PAYMENT_TYPE] += totalInCents;
				totalsByPayment[1] += order.getTotalAmountInCents();
				totalsByPayment[NUMBER_OF_ORDERS] ++;
				totalsByPayment[COMISSION_IN_ORDER] +=order.getConvenienceTaxInCents();
				if(order.getOrderType().equals(OrderType.ONLINE)){
					totalsByPayment[ONLINE_ORDERS] +=order.getTotalAmountInCents();
					totalsByPayment[NUMBER_OF_ONLINE_ORDERS] ++;
				}else{
					totalsByPayment[ERP_ORDERS] +=order.getTotalAmountInCents();
					totalsByPayment[NUMBER_OF_ERP_ORDERS] ++;
				}
				byPayment.put(order.getPayment().getType(), totalsByPayment);

			}
		}
		return totals;
	}

	public Map<PaymentType, Integer[]> getByPayment() {
		return byPayment;
	}

	public void setByPayment(Map<PaymentType, Integer[]> byPayment) {
		this.byPayment = byPayment;
	}

	public void setTotals(Integer totals) {
		this.totals = totals;
	}

}
