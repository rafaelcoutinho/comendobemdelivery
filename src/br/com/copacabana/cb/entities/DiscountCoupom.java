package br.com.copacabana.cb.entities;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "allDiscounts", query = "SELECT m FROM DiscountCoupom m"),

})
public class DiscountCoupom {
	public DiscountCoupom() {
		Calendar c = Calendar.getInstance(TimeController.getDefaultTimeZone());
		c.setTime(this.getCreate());
		Integer second = c.get(Calendar.SECOND);
		String hexString = Integer.toHexString(second);
		if (hexString.length() == 1) {
			hexString = "0" + hexString;
		}
		this.crc = hexString;
	}

	@Id
	@Expose
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Expose
	@Enumerated(EnumType.STRING)
	private DiscountStatus status = DiscountStatus.NOT_USED;
	@Expose
	private DiscountType type = DiscountType.VALUE;

	@Temporal(TemporalType.DATE)
	@Expose
	private Date create = new Date();
	@Temporal(TemporalType.DATE)
	@Expose
	private Date expireDate = new Date();
	@Expose
	@Temporal(TemporalType.DATE)
	private Date used = new Date();
	@Expose
	private Integer value = 0;

	private String crc;

	@Expose
	private Key associtedUser;

	private List<Key> validRestaurants = new ArrayList<Key>();

	public DiscountStatus getStatus() {
		return status;
	}

	public void setStatus(DiscountStatus status) {
		this.status = status;
	}

	public DiscountType getType() {
		return type;
	}

	public void setType(DiscountType type) {
		this.type = type;
	}

	public Date getCreate() {
		return create;
	}

	public void setCreate(Date create) {
		this.create = create;
	}

	public Date getExpireDate() {
		return expireDate;
	}

	public void setExpireDate(Date expireDate) {
		this.expireDate = expireDate;
	}

	public Date getUsed() {
		return used;
	}

	public void setUsed(Date used) {
		this.used = used;
	}

	public Integer getValue() {
		return value;
	}

	public void setValue(Integer value) {
		this.value = value;
	}

	public Key getAssocitedUser() {
		return associtedUser;
	}

	public void setAssocitedUser(Key associtedUser) {
		this.associtedUser = associtedUser;
	}

	public String getCode() {
		return id + getCrc();
	}

	public String getCrc() {
		return crc;
	}

	public List<Key> getValidRestaurants() {
		return validRestaurants;
	}

	public void setValidRestaurants(List<Key> validRestaurants) {
		this.validRestaurants = validRestaurants;
	}

}
