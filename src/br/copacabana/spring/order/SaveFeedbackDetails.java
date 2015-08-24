package br.copacabana.spring.order;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import br.com.copacabana.cb.entities.Feedback;
import br.com.copacabana.cb.entities.FeedbackStatus;
import br.com.copacabana.cb.entities.mgr.FormCommand;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.OrderManager;

public class SaveFeedbackDetails implements FormCommand {
	private Long feedbackId;
	private Short deliveryTime;
	private Short foodQuality;
	private Short restaurantInfo;
	private Short statusUpdate;
	private String comments;

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		OrderManager om = new OrderManager();
		Feedback f = om.getFeedback(feedbackId);
		f.setComment(comments);
		f.setDeliveryTime(deliveryTime);
		f.setFoodQuality(foodQuality);
		f.setRestaurantInfo(restaurantInfo);
		f.setStatusUpdate(statusUpdate);
		f.setStatus(FeedbackStatus.FULLY);
		om.persist(f);
	}

	@Override
	public Object getInitialObject(Manager manager) {
		return null;
	}

	@Override
	public Map<String, Object> getReferenceData(HttpServletRequest request, Manager manager) {
		return null;
	}

	public Long getFeedbackId() {
		return feedbackId;
	}

	public void setFeedbackId(Long feedbackId) {
		this.feedbackId = feedbackId;
	}

	public Short getDeliveryTime() {
		return deliveryTime;
	}

	public void setDeliveryTime(Short deliveryTime) {
		this.deliveryTime = deliveryTime;
	}

	public Short getFoodQuality() {
		return foodQuality;
	}

	public void setFoodQuality(Short foodQuality) {
		this.foodQuality = foodQuality;
	}

	public Short getRestaurantInfo() {
		return restaurantInfo;
	}

	public void setRestaurantInfo(Short restaurantInfo) {
		this.restaurantInfo = restaurantInfo;
	}

	public Short getStatusUpdate() {
		return statusUpdate;
	}

	public void setStatusUpdate(Short statusUpdate) {
		this.statusUpdate = statusUpdate;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

}
