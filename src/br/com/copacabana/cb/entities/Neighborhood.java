package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( { @NamedQuery(name = "getNeighborhood", query = "SELECT n FROM Neighborhood n"), 
	@NamedQuery(name = "getNeighborhoodOrdered", query = "SELECT n FROM Neighborhood n ORDER BY n.id"), 
	@NamedQuery(name = "getNeighborhoodByName", query = "SELECT n FROM Neighborhood n WHERE n.name = :name"),
	@NamedQuery(name = "getNeighborhoodLikeName", query = "SELECT n FROM Neighborhood n WHERE n.name like :name"),
	@NamedQuery(name = "getNeighborhoodLikeNameInCity", query = "SELECT n FROM Neighborhood n WHERE n.name like :name and n.city=:city"),
	@NamedQuery(name = "getNeighborhoodByZip", query = "SELECT n FROM Neighborhood n WHERE n.zip = :zip"), 
	@NamedQuery(name = "searchNeighborhoodByName", query = "SELECT n FROM Neighborhood n WHERE n.name like :name"), 
	@NamedQuery(name = "searchNeighborhoodByZip", query = "SELECT n FROM Neighborhood n WHERE n.zip like :zip"), 
	@NamedQuery(name = "searchNeighborhoodByCity", query = "SELECT n FROM Neighborhood n WHERE n.city = :city order by name") })
public class Neighborhood implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;

	@Expose
	@Basic
	private String name;
	@Expose
	@Basic
	private String zip;
	@Expose
	@Basic
	private String mapReferenceImageUrl;
	@OneToMany(mappedBy = "neighborhood",cascade=CascadeType.ALL)
	//@Column(name = "addresses", insertable = true, updatable = true)
	private Set<Address> addresses = new HashSet<Address>();

	// @ManyToOne(fetch=FetchType.EAGER)
	// @Embedded
	@Expose
	private City city;

	public Neighborhood() {
		super();
		// TODO Auto-generated constructor stub
	}

	public Neighborhood(String name, String zip, City city) {
		super();
		this.name = name;
		this.zip = zip;
		this.city = city;
	}

	public City getCity() {
		return city;
	}

	public void setCity(City city) {
		this.city = city;
	}

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getZip() {
		return zip;
	}

	public void setZip(String zip) {
		this.zip = zip;
	}

	public void addAddress(Address add) {
		if(this.addresses==null){
			this.addresses=new HashSet<Address>();
		}
		this.addresses.add(add);
	}

	public String getMapReferenceImageUrl() {
		return mapReferenceImageUrl;
	}

	public void setMapReferenceImageUrl(String mapReferenceImageUrl) {
		this.mapReferenceImageUrl = mapReferenceImageUrl;
	}

	public Set<Address> getAddresses() {
		return addresses;
	}
	public void removeAddress(Address add) {
		this.addresses.remove(add);
	}
	public String getIdStr(){
		return KeyFactory.keyToString(this.id);
	}

}
