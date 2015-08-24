package br.com.copacabana.cb.entities;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Key;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
@NamedQueries({ @NamedQuery(name = "allRestaurantClients", query = "SELECT c FROM RestaurantClient c order by registeredOn"),
	@NamedQuery(name = "getAllRestClients", query = "SELECT c FROM RestaurantClient c where c.fromRests.contains(:restId)"), 
	@NamedQuery(name = "getAllRestClientsWithPhone", query = "SELECT c FROM RestaurantClient c where c.fromRests.contains(:restId) and c.phones.contains(:phone)")

})
public class RestaurantClient extends Client {
	private String tempEmail;
	private Set<Key> fromRests = new HashSet<Key>();
	private Set<String> phones = new HashSet<String>();

	public void addRest(Key k) {
		this.fromRests.add(k);
	}

	public void addPhone(String k) {
		this.phones.add(k);
	}

	public Set<Key> getFromRests() {
		return fromRests;
	}

	public void setFromRests(Set<Key> fromRests) {
		this.fromRests = fromRests;
	}

	public Set<String> getPhones() {
		return phones;
	}

	public void setPhones(Set<String> phones) {
		this.phones = phones;
	}
	public String getMainPhone(){
		return phones.iterator().next();
	}

	public String getTempEmail() {
		return tempEmail;
	}

	public void setTempEmail(String tempEmail) {
		this.tempEmail = tempEmail;
	}
	
	public String getEmail(){
		return this.tempEmail;
	}
}
