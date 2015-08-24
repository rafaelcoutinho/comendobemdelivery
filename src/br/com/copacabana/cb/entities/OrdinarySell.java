package br.com.copacabana.cb.entities;

import static javax.persistence.FetchType.EAGER;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import br.copacabana.spring.AddressManager;
import br.copacabana.spring.ClientManager;

import com.google.appengine.api.datastore.Key;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "getAllSells", query = "SELECT m FROM OrdinarySell m order by status,soldAt"),

@NamedQuery(name = "restSells", query = "SELECT m FROM OrdinarySell m where restId=:restId"), @NamedQuery(name = "clientBuys", query = "SELECT m FROM OrdinarySell m where clientId=:clientId")

})
public class OrdinarySell {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Long id;

	private Key clientId;
	@OneToMany(fetch = EAGER, cascade = CascadeType.ALL, mappedBy = "sell")
	private List<ItemSold> itemSold = new ArrayList<ItemSold>();

	@Enumerated(EnumType.ORDINAL)
	private SellStatus status = SellStatus.NEW;

	@OneToOne(targetEntity = Payment.class, cascade = CascadeType.ALL)
	private Payment payment = new Payment();

	private Key restId;

	private boolean toDelivery = false;
	private Key deliveryAddress;

	private String clientIp;
	private String cpf;
	@Temporal(TemporalType.DATE)
	private Date soldAt = new Date();

	private String extraInfo = new String();

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Client getClient() {
		return new ClientManager().get(this.clientId);
	}

	public Address getAddress() {
		return new AddressManager().get(this.getDeliveryAddress());
	}

	public Key getClientId() {
		return clientId;
	}

	public void setClientId(Key clientId) {
		this.clientId = clientId;
	}

	public List<ItemSold> getItemSold() {
		return itemSold;
	}

	public void setItemSold(List<ItemSold> itemSold) {
		this.itemSold = itemSold;
	}

	public void addItemSold(ItemSold itemSold) {
		this.itemSold.add(itemSold);
	}

	public SellStatus getStatus() {
		return status;
	}

	public void setStatus(SellStatus status) {
		this.status = status;
	}

	public Key getRestId() {
		return restId;
	}

	public void setRestId(Key restId) {
		this.restId = restId;
	}

	public Key getDeliveryAddress() {
		return deliveryAddress;
	}

	public void setDeliveryAddress(Key deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}

	public String getClientIp() {
		return clientIp;
	}

	public void setClientIp(String clientIp) {
		this.clientIp = clientIp;
	}

	public String getCpf() {
		return cpf;
	}

	public void setCpf(String cpf) {
		this.cpf = cpf;
	}

	public JsonObject getExtraInfo() {
		if (extraInfo != null) {
			return new JsonParser().parse(extraInfo).getAsJsonObject();
		}
		return new JsonObject();

	}

	public void setExtraInfo(JsonObject extraInfo) {
		this.extraInfo = extraInfo.toString();
	}

	public Payment getPayment() {
		return payment;
	}

	public void setPayment(Payment payment) {
		this.payment = payment;
	}

	public Date getSoldAt() {
		return soldAt;
	}

	public boolean isToDelivery() {
		return toDelivery;
	}

	public void setToDelivery(boolean toDelivery) {
		this.toDelivery = toDelivery;
	}

	public String getPrefDays() {
		JsonArray ja = (JsonArray) this.getExtraInfo().get("prefDays");
		String bui = "";
		for (int i = 0; i < ja.size(); i++) {
			bui += ja.get(i).getAsString() + ", ";
		}
		return bui;
	}

}
