package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Basic;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;

import org.datanucleus.jpa.annotations.Extension;

import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( { @NamedQuery(name = "getStates", query = "SELECT s FROM State s"), 
	@NamedQuery(name = "getStateByName", query = "SELECT s FROM State s WHERE s.name = :name"), 
	@NamedQuery(name = "getStateOrdered", query = "SELECT s FROM State s ORDER BY s.id") })
public class State implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Long id;
	@Expose
	@Basic(fetch = FetchType.EAGER)
	private String name;
	@OneToMany(mappedBy = "state", fetch = FetchType.EAGER)
	@Extension(vendorName = "datanucleus", key = "cacheable", value = "none")
	private List<City> cities;

	public State(String string) {
		this.name = string;
	}
	public State() {
		
	}

	public List<City> getCities() {
		return cities;
	}

	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public void setCities(List<City> cities) {
		this.cities = cities;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setName(String name) {
		this.name = name;
	}
}
