package br.copacabana.spring.client;

import java.util.ArrayList;
import java.util.List;

import br.com.copacabana.cb.entities.Client;

public class ClientAddressBean {
	Client client;
	List<AddressBean> addresses = new ArrayList<AddressBean>();

	public ClientAddressBean(Client client) {
		this.client = client;

	}

	public Client getClient() {
		return client;
	}

	public void setClient(Client client) {
		this.client = client;
	}

	public List<AddressBean> getAddresses() {
		return addresses;
	}

	public void addAddress(AddressBean address) {
		this.addresses.add(address);
	}

	public void setAddress(List<AddressBean> address) {
		this.addresses = address;
	}

}
