package br.com.copacabana.cb.entities;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;
import com.ibm.icu.util.Calendar;

@Entity
@NamedQueries({

@NamedQuery(name = "allLoyaltyPoints", query = "SELECT c FROM LoyaltyPoints c"), @NamedQuery(name = "allUserLoyaltyForMonth", query = "SELECT c FROM LoyaltyPoints c where month=:month and year=:year and client=:client"), @NamedQuery(name = "allUserLoyaltyBeforeMonth", query = "SELECT c FROM LoyaltyPoints c where month<:month and year=:year and client=:client"), @NamedQuery(name = "allLoyaltyForMonth", query = "SELECT c FROM LoyaltyPoints c where month=:month and year=:year order by total desc"),

})
public class LoyaltyPoints {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	public LoyaltyPoints(Client c) {
		this.client = c.getId();
		month = TimeController.getDefaultCalendar().get(Calendar.MONTH);
		year = TimeController.getDefaultCalendar().get(Calendar.YEAR);
	}

	public LoyaltyPoints(Key c) {
		this.client = c;
		month = TimeController.getDefaultCalendar().get(Calendar.MONTH);
		year = TimeController.getDefaultCalendar().get(Calendar.YEAR);
	}

	private Key client;
	private Integer month = new Integer(0);
	private Integer year = new Integer(0);

	private Integer confirmedInvitations = 0;
	private Integer friendsOrders = 0;
	private Integer myOrders = 0;
	private Integer total = 0;

	private int perInvitation = 1;
	private int perOrder = 5;
	private int perFriendsOrder = 2;

	private boolean isArchived = false;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Key getClient() {
		return client;
	}

	public void setClient(Key client) {
		this.client = client;
	}

	public Integer getMonth() {
		return month;
	}

	public void setMonth(Integer month) {
		this.month = month;
	}

	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public Integer getConfirmedInvitations() {
		return confirmedInvitations;
	}

	public void setConfirmedInvitations(Integer confirmedInvitations) {
		this.confirmedInvitations = confirmedInvitations;
		this.updateTotal();
	}

	public Integer getFriendsOrders() {
		return friendsOrders;
	}

	public void setFriendsOrders(Integer friendsOrders) {
		this.friendsOrders = friendsOrders;
		this.updateTotal();
	}

	public Integer getMyOrders() {
		return myOrders;
	}

	public void setMyOrders(Integer myOrdres) {
		this.myOrders = myOrdres;
		this.updateTotal();
	}

	public int getPerInvitation() {
		return perInvitation;
	}

	public void setPerInvitation(int perInvitation) {
		this.perInvitation = perInvitation;
	}

	public int getPerOrder() {
		return perOrder;
	}

	public void setPerOrder(int perOrder) {
		this.perOrder = perOrder;
	}

	public int getPerFriendsOrder() {
		return perFriendsOrder;
	}

	public void setPerFriendsOrder(int perFriendsOrder) {
		this.perFriendsOrder = perFriendsOrder;
	}

	public boolean isArchived() {
		return isArchived;
	}

	public void setArchived(boolean isArchived) {
		this.isArchived = isArchived;
	}

	public int getTotal() {
		return total;
	}

	public void updateTotal() {
		total = (perFriendsOrder * friendsOrders) + (perOrder * myOrders) + (perInvitation * confirmedInvitations);
	}

}
