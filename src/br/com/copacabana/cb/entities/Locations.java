package br.com.copacabana.cb.entities;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity(name = "Locations")
@NamedQueries( { 
	@NamedQuery(name = "getAllLocations", query = "SELECT f FROM Locations f"), 
	@NamedQuery(name = "getUnassignedLocations", query = "SELECT f FROM Locations f where neighborhood is null"), 
	@NamedQuery(name = "getLocationBasedOnCoords", query = "SELECT f FROM Locations f where x=:x and y=:y and neighborhood=null"),
	@NamedQuery(name = "getLocationWitNeighBasedOnCoords", query = "SELECT f FROM Locations f where x=:x and y=:y and neighborhood<>null"),
	@NamedQuery(name = "getLocationBasedOnFormattedAddress", query = "SELECT f FROM Locations f where formattedAddress=:formattedAddress and neighborhood <> null") ,
	@NamedQuery(name = "getLocationByFormattedAddress", query = "SELECT f FROM Locations f where formattedAddress=:formattedAddress ") })
public class Locations {
	public Locations(float x, float y, String formattedAddress) {
		super();
		this.x = x;
		this.y = y;
		this.formattedAddress = formattedAddress;
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private float x;
	@Expose
	private float y;
	@Expose
	@Temporal(TemporalType.DATE)
	private Date date=new Date();
	@Expose
	private String formattedAddress;	
	@Expose
	private Key neighborhood;

	public Locations() {
		super();
	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public float getX() {
		return x;
	}

	public void setX(float x) {
		this.x = x;
	}

	public float getY() {
		return y;
	}

	public void setY(float y) {
		this.y = y;
	}

	public String getFormattedAddress() {
		return formattedAddress;
	}

	public void setFormattedAddress(String formattedAddress) {
		this.formattedAddress = formattedAddress;
	}

	public Key getNeighborhood() {
		return neighborhood;
	}

	public void setNeighborhood(Key neighborhood) {
		this.neighborhood = neighborhood;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}
}
