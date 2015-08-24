package br.com.copacabana.cb.entities;

import java.util.Date;

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
@NamedQueries({ 
	@NamedQuery(name = "getFeedbacks", query = "SELECT f FROM Feedback f"), 
	@NamedQuery(name = "getFeedbacksOrderByDate", query = "SELECT f FROM Feedback f order by f.registered"), 
	@NamedQuery(name = "feedbackByMeal", query = "SELECT f FROM Feedback f where f.mealOrder=:orderId"), 
	@NamedQuery(name = "feedbackByPeriod", query = "SELECT f FROM Feedback f where f.registered>=:start and f.registered<:end order by f.registered"), })
public class Feedback {
	public Feedback(Key orderId) {
		this.mealOrder = orderId;
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Long id;

	private Key mealOrder;
	private Key client;

	private String comment;
	private Short overall = 0;
	private Short deliveryTime = 0;
	private Short statusUpdate = 0;
	private Short restaurantInfo = 0;
	private Short foodQuality = 0;
	private Boolean sentToRestaurant = Boolean.FALSE;
	private String fromEmail;

	private Date registered = new Date();
	@Enumerated(EnumType.STRING)
	private FeedbackStatus status = FeedbackStatus.NOTEVALUATED;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Key getMealOrder() {
		return mealOrder;
	}

	public void setMealOrder(Key mealOrder) {
		this.mealOrder = mealOrder;
	}

	public Key getClient() {
		return client;
	}

	public void setClient(Key client) {
		this.client = client;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public Short getOverall() {
		return overall;
	}

	public void setOverall(Short overall) {
		this.overall = overall;
	}

	public Short getDeliveryTime() {
		return deliveryTime;
	}

	public void setDeliveryTime(Short deliveryTime) {
		this.deliveryTime = deliveryTime;
	}

	public Short getStatusUpdate() {
		return statusUpdate;
	}

	public void setStatusUpdate(Short statusUpdate) {
		this.statusUpdate = statusUpdate;
	}

	public Short getRestaurantInfo() {
		return restaurantInfo;
	}

	public void setRestaurantInfo(Short restaurantInfo) {
		this.restaurantInfo = restaurantInfo;
	}

	public Short getFoodQuality() {
		return foodQuality;
	}

	public void setFoodQuality(Short foodQuality) {
		this.foodQuality = foodQuality;
	}

	public String getFromEmail() {
		return fromEmail;
	}

	public void setFromEmail(String fromEmail) {
		this.fromEmail = fromEmail;
	}

	public Date getRegistered() {
		return registered;
	}

	public void setRegistered(Date registered) {
		this.registered = registered;
	}

	public FeedbackStatus getStatus() {
		return status;
	}

	public void setStatus(FeedbackStatus status) {
		this.status = status;
	}

	public Boolean getSentToRestaurant() {
		return sentToRestaurant;
	}

	public void setSentToRestaurant(Boolean sentToRestaurant) {
		this.sentToRestaurant = sentToRestaurant;
	}

}
