package br.com.copacabana.cb.entities;

import java.io.Serializable;

import javax.persistence.Embeddable;

import com.google.gson.annotations.Expose;

@Embeddable
public class DeliveryCost  implements Serializable{
	@Expose
	private Double cost = 0.0;
	@Expose
	private boolean isPercentage = false;
	@Expose
	private Double minimumOrderValue = 0.0;

	public Double getCost() {
		return cost;
	}

	public void setCost(Double cost) {
		this.cost = cost;
	}

	public boolean isPercentage() {
		return isPercentage;
	}

	public void setPercentage(boolean isPercentage) {
		this.isPercentage = isPercentage;
	}

	public Double getMinimumOrderValue() {
		return minimumOrderValue;
	}

	public void setMinimumOrderValue(Double minimumOrderValue) {
		this.minimumOrderValue = minimumOrderValue;
	}

}
