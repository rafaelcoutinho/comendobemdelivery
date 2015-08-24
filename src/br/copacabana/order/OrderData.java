package br.copacabana.order;

import java.util.ArrayList;
import java.util.List;

import br.com.copacabana.cb.entities.Address;

public class OrderData {
	List<PlateData> plates = new ArrayList<PlateData>();
	RestData restData;
	Address clientAddress;

	public RestData getRestData() {
		return restData;
	}

	public void setRestData(RestData restData) {
		this.restData = restData;
	}

	public Address getClientAddress() {
		return clientAddress;
	}

	public void setClientAddress(Address clientAddress) {
		this.clientAddress = clientAddress;
	}

	public List<PlateData> getPlates() {
		return plates;
	}

	public void setPlates(List<PlateData> plates) {
		this.plates = plates;
	}

	
}
