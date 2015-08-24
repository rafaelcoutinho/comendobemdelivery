package br.com.copacabana.cb.entities;

import javax.persistence.Entity;

import com.google.gson.annotations.Expose;

@Entity
public class PaymentInCash extends Payment {
	@Expose
	private Double amountInCash;

	public PaymentInCash() {
		super();
		this.type = PaymentType.INCASH;
	}

	public Double getAmountInCash() {
		return amountInCash; 
	}

	public void setAmountInCash(Double totalPaid) {
		this.amountInCash = totalPaid;
	}

}
