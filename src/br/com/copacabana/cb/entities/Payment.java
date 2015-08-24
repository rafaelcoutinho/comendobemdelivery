package br.com.copacabana.cb.entities;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "getPayment", query = "SELECT p FROM Payment p"), @NamedQuery(name = "getPaymentOrdered", query = "SELECT p FROM Payment p ORDER BY p.id"), @NamedQuery(name = "getPaymentByMealOrder", query = "SELECT p FROM Payment p WHERE p.mealOrder = :mealOrder"), @NamedQuery(name = "getPaymentByType", query = "SELECT p FROM Payment p WHERE p.type = :type"), @NamedQuery(name = "getPaymentByType", query = "SELECT p FROM Payment p WHERE p.confirmed = 'false'") })
public class Payment {
	public static enum PaymentType {
		INCASH, CHEQUE, PAYPAL, UNKNOWN, VISAMACHINE, VISADEBITMACHINE, MASTERMACHINE, MASTERDEBITMACHINE, AMEXMACHINE, VISAVOUCHERMACHINE, TRMACHINE, TRVOUCHER, VRSMART, TRSODEXHO
	};

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Key id;
	@Expose
	@Enumerated(EnumType.STRING)
	protected PaymentType type = PaymentType.UNKNOWN;
	@Expose
	private Double totalValue = 0.0;
	@Expose
	private Double amountInCash;
	@Expose
	private Double taxes = 0.0;

	private String token;
	private String payerId;
	private String confirmed = "false";
	private String paypayError = "";

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public PaymentType getType() {
		return type;
	}

	public void setType(PaymentType type) {
		this.type = type;
	}

	public Double getTotalValue() {
		return totalValue;
	}

	public void setTotalValue(Double totalValue) {
		this.totalValue = totalValue;
	}

	public Double getAmountInCash() {
		return amountInCash;
	}

	public void setAmountInCash(Double amountInCash) {
		this.amountInCash = amountInCash;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public String getPayerId() {
		return payerId;
	}

	public void setPayerId(String payerId) {
		this.payerId = payerId;
	}

	public Double getTaxes() {
		return taxes;
	}

	public void setTaxes(Double taxes) {
		this.taxes = taxes;
	}

	public String getConfirmed() {
		return confirmed;
	}

	public void setConfirmed(String confirmed) {
		this.confirmed = confirmed;
	}

	public String getPaypayError() {
		return paypayError;
	}

	public void setPaypayError(String paypayError) {
		this.paypayError = paypayError;
	}

}
