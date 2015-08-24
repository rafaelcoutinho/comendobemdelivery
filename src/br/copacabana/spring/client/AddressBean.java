package br.copacabana.spring.client;

import java.util.Set;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Neighborhood;

import com.google.appengine.api.datastore.KeyFactory;

public class AddressBean {
	private Address address;

	public AddressBean(Address add) {
		this.address = add;
	}

	public String getAddressKey() {
		return KeyFactory.keyToString(address.getId());
	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}
	public String getNeighborhoodId() {
		return KeyFactory.keyToString(address.getNeighborhood().getId());
	}
	public Set<Neighborhood> getNeighborhoodList() {
		return address.getNeighborhood().getCity().getNeighborhoods();
	}
	
}
