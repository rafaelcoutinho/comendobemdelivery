package br.com.copacabana.cb.entities;

import static javax.persistence.FetchType.EAGER;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.jdo.annotations.Embedded;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "getMealOrder", query = "SELECT m FROM MealOrder m"), @NamedQuery(name = "listClientOrdersInSite", query = "SELECT m FROM MealOrder m WHERE m.client= :client and m.status=:status"),// ||
		// m.status='PREPARING'
		// ||//
		// m.status='INTRANSIT')"),
		@NamedQuery(name = "listAllClientOrdersInSite", query = "SELECT m FROM MealOrder m WHERE m.client= :client and m.status in ('DELIVERED')"), 
		@NamedQuery(name = "listClientOrdersInRestaurant", query = "SELECT m FROM MealOrder m WHERE m.client = :client and m.restaurant =:restaurantId and m.status=:status"), 
		@NamedQuery(name = "getPendingMealOrderByClientByStatus", query = "SELECT m FROM MealOrder m WHERE m.client = :client and status=:status order by m.status,m.orderedTime,m.lastStatusUpdateTime"), 
		@NamedQuery(name = "getMealOrderByStatusByRestaurant", query = "SELECT m FROM MealOrder m WHERE m.restaurant=:restaurant and m.status = :status order by m.orderedTime,m.lastStatusUpdateTime"),
		@NamedQuery(name = "listPendingMealOrders", query = "SELECT m FROM MealOrder m WHERE m.status=:status order by m.orderedTime,m.lastStatusUpdateTime,m.restaurant"), 
		@NamedQuery(name = "listRestMealsByDateRange", query = "SELECT m FROM MealOrder m WHERE m.restaurant=:restaurant and m.status = :status and m.lastStatusUpdateTime>=:start and m.lastStatusUpdateTime<:end order by m.lastStatusUpdateTime,m.orderedTime"), 
		@NamedQuery(name = "listClientMealsByDateRange", query = "SELECT m FROM MealOrder m WHERE m.client = :client and m.status = :status and m.lastStatusUpdateTime>=:start and m.lastStatusUpdateTime<:end order by m.lastStatusUpdateTime,m.orderedTime"), 
		@NamedQuery(name = "getLatestClientMealOrder", query = "SELECT m FROM MealOrder m WHERE m.client = :client and m.status = :status and m.lastStatusUpdateTime=(SELECT MAX(m.lastStatusUpdateTime) FROM MealOrder m) order by m.lastStatusUpdateTime desc,m.orderedTime desc"), 
		@NamedQuery(name = "listRestMealsFromMonth", query = "SELECT m FROM MealOrder m WHERE m.restaurant=:restaurant and m.status = :status and m.lastStatusUpdateTime>=:start and m.lastStatusUpdateTime<:end order by m.lastStatusUpdateTime,m.orderedTime"),
		@NamedQuery(name = "getClientOrdersSince", query = "SELECT m FROM MealOrder m WHERE m.client = :client and m.status in ('DELIVERED') and m.lastStatusUpdateTime>=:since"),
		@NamedQuery(name = "getCompleteOrdersRange", query = "SELECT m FROM MealOrder m WHERE m.status in ('DELIVERED') and m.lastStatusUpdateTime>=:from and m.lastStatusUpdateTime<=:until"),
		@NamedQuery(name = "getLastDaysOrders", query = "SELECT m FROM MealOrder m where m.client = :client and m.orderedTime>:since and m.status in ('NEW','VISUALIZEDBYRESTAURANT','DELIVERED','INTRANSIT','PREPARING','WAITING_CUSTOMER')"),
		@NamedQuery(name = "getCompleteOrdersRangeForClient", query = "SELECT m FROM MealOrder m WHERE m.client = :client and m.status ='DELIVERED' and m.lastStatusUpdateTime>=:from and m.lastStatusUpdateTime<=:until"), 
		@NamedQuery(name = "getTotalTodaysOrders", query = "SELECT m FROM MealOrder m where m.restaurant=:restaurant and m.orderedTime>:since"), 
		@NamedQuery(name = "getMealByPayment", query = "SELECT m FROM MealOrder m WHERE payment=:payment order by m.lastStatusUpdateTime,m.orderedTime"), 
		@NamedQuery(name = "listToExpireMealOrders", query = "SELECT m FROM MealOrder m WHERE status=:status and m.orderedTime<:time"), 
		@NamedQuery(name = "getNewOrdersForRestaurant", query = "SELECT m FROM MealOrder m WHERE m.restaurant=:restaurant and m.status in ('NEW','VISUALIZEDBYRESTAURANT') order by m.status,m.lastStatusUpdateTime, m.orderedTime"), 
		@NamedQuery(name = "getOnGoingOrdersForRestaurant", query = "SELECT m FROM MealOrder m WHERE m.restaurant=:restaurant and m.status in ('PREPARING','INTRANSIT','WAITING_CUSTOMER') order by m.status,m.lastStatusUpdateTime, m.orderedTime"), 
		@NamedQuery(name = "getCompleteOnlineOrders", query = "SELECT m FROM MealOrder m WHERE orderType='ONLINE' and m.restaurant=:restaurant and m.status in ('DELIVERED','EVALUATED') and m.lastStatusUpdateTime>=:start and m.lastStatusUpdateTime<:end order by m.lastStatusUpdateTime,m.orderedTime"), 
		@NamedQuery(name = "getCompleteOrders", query = "SELECT m FROM MealOrder m WHERE m.restaurant=:restaurant and m.status in ('DELIVERED','EVALUATED') and m.lastStatusUpdateTime>=:start and m.lastStatusUpdateTime<:end order by m.lastStatusUpdateTime,m.orderedTime"), 
		@NamedQuery(name = "getERPOrdersByOnlineClients", query = "SELECT m FROM MealOrder m WHERE ancestor is CLIENT and orderType='ONLINE'"), 
		@NamedQuery(name = "getMealOrderByDiscount", query = "SELECT m FROM MealOrder m WHERE discountInfo.code=:code")

})
public class MealOrder {

	@Expose
	private Key address;
	@Expose
	private Integer dailyCounter = 0;
	@Expose
	private Client client = new Client();
	@Enumerated(EnumType.STRING)
	private OrderType orderType = OrderType.ONLINE;

	@Expose
	private String cpf;

	private String clientIp;

	@Expose
	private Float x = new Float(0);
	@Expose
	private Float y = new Float(0);

	// in order to not loose information we need to store it redundantly
	@Expose
	private String clientName;

	@Expose
	private String clientPhone;
	@Expose
	private int clientRequestsOnRestaurant = 0;
	@Expose
	private int clientRequestsOnSite = 0;

	@Expose
	private Double deliveryCost = 0.0;
	@Expose
	private Integer deliveryCostInCents = 0;
	@Expose
	private Integer convenienceTaxInCents = 0;

	@Expose
	private Double convenienceTax = 0.0;
	@Expose
	@Embedded
	private DiscountInfo discountInfo;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	@Temporal(TemporalType.DATE)
	private Date lastStatusUpdateTime = new Date();

	@OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, mappedBy = "mealorder")
	private List<MealOrderLogEntry> log = new ArrayList<MealOrderLogEntry>();
	@Expose
	private String observation;
	@Expose
	private String prepareForeCast;

	@Expose
	@Temporal(TemporalType.DATE)
	private Date orderedTime = new Date();
	@OneToOne(targetEntity = Payment.class, cascade = CascadeType.ALL)
	@Expose
	private Payment payment = new Payment();
	@OneToMany(fetch = EAGER, cascade = CascadeType.ALL, mappedBy = "mealorder")
	@Expose
	private List<OrderedPlate> plates = new ArrayList<OrderedPlate>();
	@Expose
	private String reason = "N/A";

	@Expose
	private Key restaurant;

	@Expose
	private Boolean retrieveAtRestaurant = false;

	@Enumerated(EnumType.STRING)
	@Expose
	private MealOrderStatus status = MealOrderStatus.NEW;

	private Integer totalAmountInCents = 0;

	public Client getClient() {
		return client;
	}

	public String getClientName() {
		return clientName;
	}

	public String getClientPhone() {
		return clientPhone;
	}

	public int getClientRequestsOnRestaurant() {
		return clientRequestsOnRestaurant;
	}

	public int getClientRequestsOnSite() {
		return clientRequestsOnSite;
	}

	public Double getDeliveryCost() {
		return deliveryCost;
	}

	public Key getId() {
		return id;
	}

	public String getIdStr() {
		return KeyFactory.keyToString(id);
	}

	public Date getLastStatusUpdateTime() {
		return lastStatusUpdateTime;
	}

	public List<MealOrderLogEntry> getLog() {
		return log;
	}

	public String getObservation() {
		return observation;
	}

	public Date getOrderedTime() {
		return orderedTime;
	}

	public Payment getPayment() {
		return payment;
	}

	public List<OrderedPlate> getPlates() {
		return plates;
	}

	public String getReason() {
		return reason;
	}

	public MealOrderStatus getStatus() {
		return status;
	}

	public void setClient(Client client) {
		this.client = client;
		this.setClientName(client.getName());
		this.setClientPhone(client.getContact().getPhone());

	}

	public void setClientName(String clientName) {
		this.clientName = clientName;
	}

	public void setClientPhone(String clientPhone) {
		this.clientPhone = clientPhone;
	}

	public void setClientRequestsOnRestaurant(int clientRequestsOnRestaurant) {
		this.clientRequestsOnRestaurant = clientRequestsOnRestaurant;
	}

	public void setClientRequestsOnSite(int clientRequestsOnSite) {
		this.clientRequestsOnSite = clientRequestsOnSite;
	}

	public void setDeliveryCost(Double deliveryCost) {
		this.deliveryCost = deliveryCost;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public void setLastStatusUpdateTime(Date lastStatusUpdateTime) {
		this.lastStatusUpdateTime = lastStatusUpdateTime;
	}

	public void setLog(List<MealOrderLogEntry> log) {
		this.log = log;
	}

	public void setObservation(String observation) {
		this.observation = observation;
	}

	public void setOrderedTime(Date orderedTime) {
		this.orderedTime = orderedTime;
	}

	public void setPayment(Payment payment) {
		this.payment = payment;
	}

	public void setPlates(List<OrderedPlate> plates) {
		this.plates = plates;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public void setStatus(MealOrderStatus status) {
		if (!status.equals(this.status)) {
			this.log.add(new MealOrderLogEntry(this, this.status, status, (Date) lastStatusUpdateTime.clone(), new Date()));
			lastStatusUpdateTime = new Date();
		}
		this.status = status;
	}

	public Key getAddress() {
		return address;
	}

	public void setAddress(Key address) {
		this.address = address;
	}

	public Key getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Key restaurant) {
		this.restaurant = restaurant;
	}

	public Double getConvenienceTax() {
		return convenienceTax;
	}

	public void setConvenienceTax(Double convenienceTax) {
		this.convenienceTax = convenienceTax;
	}

	public Boolean getRetrieveAtRestaurant() {
		return retrieveAtRestaurant;
	}

	public void setRetrieveAtRestaurant(Boolean retrieveAtRestaurant) {
		this.retrieveAtRestaurant = retrieveAtRestaurant;
	}

	public String getCpf() {
		return cpf;
	}

	public void setCpf(String cpf) {
		this.cpf = cpf;
	}

	public String getClientIp() {
		return clientIp;
	}

	public void setClientIp(String clientIp) {
		this.clientIp = clientIp;
	}

	public Float getX() {
		return x;
	}

	public void setX(Float x) {
		this.x = x;
	}

	public Float getY() {
		return y;
	}

	public void setY(Float y) {
		this.y = y;
	}

	public String getPrepareForeCast() {
		return prepareForeCast;
	}

	public void setPrepareForeCast(String prepareForeCast) {
		this.prepareForeCast = prepareForeCast;
	}

	public Integer getTotalAmountInCents() {
		return totalAmountInCents;
	}

	public Integer getRestaurantAmountInCents() {
		return totalAmountInCents - convenienceTaxInCents;
	}

	public Integer getDeliveryCostInCents() {
		return deliveryCostInCents;
	}

	public void setDeliveryCostInCents(Integer deliveryCostInCents) {
		this.deliveryCostInCents = deliveryCostInCents;

	}

	public Integer getConvenienceTaxInCents() {

		return convenienceTaxInCents;
	}

	public void setConvenienceTaxInCents(Integer convenienceTaxInCents) {
		this.convenienceTaxInCents = convenienceTaxInCents;

	}

	public void setTotalAmountInCents(Integer totalAmountInCents) {
		this.totalAmountInCents = totalAmountInCents;
	}

	public DiscountInfo getDiscountInfo() {
		return discountInfo;
	}

	public String getXlatedId() {
		return this.getClient().getId().getId() + "." + this.getId().getId();
	}

	public void setDiscountInfo(DiscountInfo discountInfo) {
		this.discountInfo = discountInfo;
	}
	public Integer getAmountLessTaxes(){
		Integer totalAmt = new Integer(0);
		for (Iterator<OrderedPlate> iterator = this.getPlates().iterator(); iterator.hasNext();) {
			OrderedPlate plate = (OrderedPlate) iterator.next();
			totalAmt += plate.getQty() * plate.getPriceInCents();
		}
		Integer delCost = this.getDeliveryCostInCents();
		totalAmt += delCost;

		this.getPayment().setTaxes(0.0);
		

		if (this.getDiscountInfo() != null && this.getDiscountInfo().getValue() != null && this.getDiscountInfo().getValue() > 0) {
			totalAmt = totalAmt - this.getDiscountInfo().getValue();
		}
		if (totalAmt < 0) {
			totalAmt = 0;
		}
		return totalAmt;
	}
	public void updateTotals() {

		Integer totalAmt = new Integer(0);
		for (Iterator<OrderedPlate> iterator = this.getPlates().iterator(); iterator.hasNext();) {
			OrderedPlate plate = (OrderedPlate) iterator.next();
			totalAmt += plate.getQty() * plate.getPriceInCents();
		}
		Integer delCost = this.getDeliveryCostInCents();
		totalAmt += delCost;

		this.getPayment().setTaxes(0.0);
		totalAmt += getConvenienceTaxInCents();

		if (this.getDiscountInfo() != null && this.getDiscountInfo().getValue() != null && this.getDiscountInfo().getValue() > 0) {
			totalAmt = totalAmt - this.getDiscountInfo().getValue();
		}
		if (totalAmt < 0) {
			totalAmt = 0;
		}
		this.setTotalAmountInCents(totalAmt);

	}

	public Integer getDailyCounter() {
		return dailyCounter;
	}

	public void setDailyCounter(Integer dailyCounter) {
		this.dailyCounter = dailyCounter;
	}

	public OrderType getOrderType() {
		return orderType;
	}

	public void setOrderType(OrderType orderType) {
		this.orderType = orderType;
	}

	@Expose
	private Boolean askForId = false;

	public void setMustAskForId() {
		askForId = true;

	}

	public Boolean getAskForId() {
		return askForId;
	}

}
