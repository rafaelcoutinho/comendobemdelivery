package br.com.copacabana.cb.entities;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( {
	@NamedQuery(name = "getMealOrderLogEntry", query = "SELECT n FROM MealOrderLogEntry n"),
	@NamedQuery(name = "getMealOrderLogEntryByOrder", query = "SELECT n FROM MealOrderLogEntry n where mealorder=:order")
	
})
public class MealOrderLogEntry {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Enumerated(EnumType.STRING)
	private MealOrderStatus fromStatus;
	@Enumerated(EnumType.STRING)
	private MealOrderStatus toStatus;

	@Temporal(TemporalType.DATE)
	private Date time = new Date();
	@Temporal(TemporalType.DATE)
	private Date lastStatusStatedtime = new Date();
	@ManyToOne
	private MealOrder mealorder;

	public MealOrderLogEntry(MealOrder mealOrder2, MealOrderStatus fromStatus, MealOrderStatus toStatus, Date lastStatusTime, Date now) {
		this.mealorder = mealOrder2;
		this.fromStatus = fromStatus;
		this.toStatus = toStatus;
		this.lastStatusStatedtime = lastStatusTime;
		this.time = now;

	}

	public MealOrderLogEntry() {

	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public MealOrderStatus getFromStatus() {
		return fromStatus;
	}

	public void setFromStatus(MealOrderStatus fromStatus) {
		this.fromStatus = fromStatus;
	}

	public MealOrderStatus getToStatus() {
		return toStatus;
	}

	public void setToStatus(MealOrderStatus toStatus) {
		this.toStatus = toStatus;
	}

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	public MealOrder getMealorder() {
		return mealorder;
	}

	public void setMealorder(MealOrder mealorder) {
		this.mealorder = mealorder;
	}

	public Date getLastStatusStatedtime() {
		return lastStatusStatedtime;
	}

	public void setLastStatusStatedtime(Date lastStatusStatedtime) {
		this.lastStatusStatedtime = lastStatusStatedtime;
	}

}
