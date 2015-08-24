package br.com.copacabana.cb.entities;

import java.util.Date;
import java.util.TimeZone;

import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import br.com.copacabana.cb.KeyWrapper;

import com.google.appengine.api.datastore.Key;

@Entity
@NamedQueries( { @NamedQuery(name = "getExceptionWorkingHoursByDate", query = "SELECT w FROM ExceptionWorkingHours w WHERE w.date >= :date"),
	@NamedQuery(name = "getExceptionWorkingHours", query = "SELECT w FROM ExceptionWorkingHours w"),
@NamedQuery(name = "getExceptionWorkingHoursFromDateAndRestaurant", query = "SELECT w FROM ExceptionWorkingHours w WHERE w.date >= :date and w.restaurant.k=:restKey"), 
@NamedQuery(name = "getExceptionWorkingHoursByRestaurant", query = "SELECT w FROM ExceptionWorkingHours w WHERE  w.restaurant.k=:restKey") })
public class ExceptionWorkingHours {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Key id;
	private Date date;
	private int startingHour = 19;

	private int startingMinute = 00;

	private int closingHour = 22;

	private int closingMinute = 00;

	private TimeZone timezone = TimeZone.getDefault();

	private String description;
	private boolean opened;
	@Embedded
	private KeyWrapper<Restaurant> restaurant;

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean isOpened() {
		return opened;
	}

	public void setOpened(boolean opened) {
		this.opened = opened;
	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public KeyWrapper<Restaurant> getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(KeyWrapper<Restaurant> restaurant) {
		this.restaurant = restaurant;
	}

	public int getStartingHour() {
		return startingHour;
	}

	public void setStartingHour(int startingHour) {
		this.startingHour = startingHour;
	}

	public int getStartingMinute() {
		return startingMinute;
	}

	public void setStartingMinute(int startingMinute) {
		this.startingMinute = startingMinute;
	}

	public int getClosingHour() {
		return closingHour;
	}

	public void setClosingHour(int closingHour) {
		this.closingHour = closingHour;
	}

	public int getClosingMinute() {
		return closingMinute;
	}

	public void setClosingMinute(int closingMinute) {
		this.closingMinute = closingMinute;
	}

	public TimeZone getTimezone() {
		return timezone;
	}

	public void setTimezone(TimeZone timezone) {
		this.timezone = timezone;
	}

}
