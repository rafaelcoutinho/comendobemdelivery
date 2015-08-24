package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( { @NamedQuery(name = "getCities", query = "SELECT c FROM City c"),
	@NamedQuery(name = "getCitiesOrderByName", query = "SELECT c FROM City c order by c.name"),
	@NamedQuery(name = "getCityByName", query = "SELECT c FROM City c WHERE c.name = :name"), 
	@NamedQuery(name = "getCityByState", query = "SELECT c FROM City c WHERE c.state = :state"), 
	@NamedQuery(name = "getCityOrdered", query = "SELECT c FROM City c ORDER BY c.id") })
public class City implements Serializable {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;
	@Expose
	private String name;

	@Expose
	@ManyToOne(cascade = CascadeType.ALL)
	private State state;

	@OneToMany(mappedBy = "city")
	@Column(name = "neighbors", insertable = true, updatable = true)
	private Set<Neighborhood> neighborhoods = new HashSet<Neighborhood>();

	public City() {
	}

	public City(String string, State s) {
		name = string;
		state = s;
	}

	public Key getId() {
		return id;
	}
	public String getIdStr() {
		return KeyFactory.keyToString(id);
	}

	public String getName() {
		return name;
	}

	public State getState() {
		return state;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setState(State state) {
		this.state = state;
	}

	public Set<Neighborhood> getNeighborhoods() {
		return neighborhoods;
	}

	public void setNeighborhoods(Set<Neighborhood> neighborhoods) {
		this.neighborhoods = neighborhoods;
	}

}
