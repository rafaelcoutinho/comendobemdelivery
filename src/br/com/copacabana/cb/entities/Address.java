package br.com.copacabana.cb.entities;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries({ @NamedQuery(name = "addressByStreet", query = "SELECT a FROM Address a where street like :street"),
	@NamedQuery(name = "getAddress", query = "SELECT a FROM Address a"), 
	@NamedQuery(name = "getAddressOrdered", query = "SELECT a FROM Address a ORDER BY a.id"), 
	@NamedQuery(name = "getAddressByStreetname", query = "SELECT a FROM Address a WHERE a.streetname = :streetname"), 
	@NamedQuery(name = "getAddressByCity", query = "SELECT a FROM Address a WHERE a.city = :city"), 
	@NamedQuery(name = "getAddressByStreet", query = "SELECT a FROM Address a WHERE a.street = :street"), 
	@NamedQuery(name = "getAddressByNumber", query = "SELECT a FROM Address a WHERE a.number = :number"), 
	@NamedQuery(name = "getAddressByAdditionalInfo", query = "SELECT a FROM Address a WHERE a.additionalInfo = :additionalInfo"), 
	@NamedQuery(name = "getAddressByNeighborhood", query = "SELECT a FROM Address a WHERE a.neighborhood = :neighborhood"), 
	@NamedQuery(name = "getAddressByLandLinePhone", query = "SELECT a FROM Address a WHERE a.landLinePhone = :landLinePhone"),
	@NamedQuery(name = "getAddressByPhone", query = "SELECT a FROM Address a WHERE a.phone = :phone"),
	
	@NamedQuery(name = "getAddressByZipCode", query = "SELECT a FROM Address a WHERE a.zipCode = :zipCode"), 
	@NamedQuery(name = "getAddressByNeighborKey", query = "SELECT a FROM Address a WHERE a.neighborhood.id= :neighborhoodKey"), 
	@NamedQuery(name = "getAddressByNeighborX", query = "SELECT a FROM Address a WHERE a.neighborhood= :neighborhood"), 
	@NamedQuery(name = "getAddressByNeighbor2", query = "SELECT a FROM Address a where a.neighborhood.id =:keyPassed") })
public class Address implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5743638504589480469L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private String street;
	@Expose
	private String number;
	@Expose
	private String additionalInfo;
	@Expose
	private String zipCode;

	@Expose
	private String x = "0";

	@Expose
	private String y = "0";

	@Expose
	@ManyToOne(fetch = FetchType.EAGER, cascade = CascadeType.MERGE)
	private Neighborhood neighborhood;

	public Address(String street, String number, String additionalInfo, String zipCode) {
		super();

		this.street = street;
		this.number = number;
		this.additionalInfo = additionalInfo;
		this.zipCode = zipCode;

	}

	public Address() {
		super();
		// TODO Auto-generated constructor stub
	}

	// @Embedded
	// @AttributeOverrides({@AttributeOverride(name="k",
	// column=@Column(name="cityKey"))})
	// @Expose
	// private KeyWrapper<City> city = new KeyWrapper<City>();
	@Expose
	private String phone;

	public String getAdditionalInfo() {
		return additionalInfo;
	}

	public Key getId() {
		return id;
	}

	public String getPhone() {
		return phone;
	}

	public Neighborhood getNeighborhood() {
		return neighborhood;
	}

	public String getNumber() {
		return number;
	}

	public String getStreet() {
		return street;
	}

	public void setAdditionalInfo(String additionalInfo) {
		this.additionalInfo = additionalInfo;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public void setPhone(String landLinePhone) {
		this.phone = landLinePhone;
	}

	public void setNeighborhood(Neighborhood neighborhood) {
		this.neighborhood = neighborhood;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getZipCode() {
		return zipCode;
	}

	public void setZipCode(String zipCode) {
		this.zipCode = zipCode;
	}

	public String getX() {
		return x;
	}

	public void setX(String x) {
		this.x = x;
	}

	public String getY() {
		return y;
	}

	public void setY(String y) {
		this.y = y;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Address) {
			Address other = (Address) obj;
			if (this.getId() != null) {
				return this.getId().equals(other.getId());
			}
		}
		return false;
	}

	public String getIdStr() {
		return KeyFactory.keyToString(this.id);
	}

	public String getFormattedString() {
		StringBuilder sb = new StringBuilder();
		if (this.street != null) {
			sb.append(this.getStreet()).append(", ");
		}
		if (this.number != null) {
			sb.append(this.getNumber()).append(", ");
		}
		if (this.additionalInfo != null && this.additionalInfo.length() > 0) {
			sb.append(this.getAdditionalInfo()).append(", ");
		}
		if (this.getNeighborhood() != null) {
			sb.append(this.getNeighborhood().getName());
		}
		return sb.toString();
	}
}
