package br.copacabana.spring.central;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.Payment;
import br.com.copacabana.cb.entities.Payment.PaymentType;

public class ConsolidatedBillBean {
	private Central central;
	private Date start;
	private Date end;
	private List<RestaurantOrdersBean> ordersByRestaurant = new ArrayList<RestaurantOrdersBean>();

	public ConsolidatedBillBean(Central central, Date start, Date end) {
		super();
		this.central = central;
		this.start = start;
		this.end = end;
	}

	public Central getCentral() {
		return central;
	}

	public void setCentral(Central central) {
		this.central = central;
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

	Integer totals = 0;

	private Map<PaymentType, Integer[]> byPayment = new HashMap<Payment.PaymentType, Integer[]>();

	public void addRestaurantOrders(RestaurantOrdersBean r) {
		totals += r.getTotals();
		byPayment.putAll(r.getByPayment());
		this.ordersByRestaurant.add(r);
	}

	public List<RestaurantOrdersBean> getOrdersByRestaurant() {
		return ordersByRestaurant;
	}

	public void setOrdersByRestaurant(List<RestaurantOrdersBean> ordersByRestaurant) {
		this.ordersByRestaurant = ordersByRestaurant;
	}

	public Integer getTotals() {
		return totals;
	}

	public void setTotals(Integer totals) {
		this.totals = totals;
	}

	public Map<PaymentType, Integer[]> getByPayment() {
		return byPayment;
	}

	public void setByPayment(Map<PaymentType, Integer[]> byPayment) {
		this.byPayment = byPayment;
	}
}
