package br.copacabana.usecase.erp;

import javax.servlet.http.HttpServletRequest;

import br.com.copacabana.cb.entities.Address;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.NeighborhoodManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class JSPUtils {
	public static Address getAddress(HttpServletRequest request) {
		Address address = new Address();
		String street = (String) request.getSession().getAttribute("address.street");
		String num = (String) request.getSession().getAttribute("address.number");
		String phone = (String) request.getSession().getAttribute("address.phone");
		String add = (String) request.getSession().getAttribute("address.additionalInfo");
		Key neigh = KeyFactory.stringToKey((String) request.getSession().getAttribute("address.neighborhood"));
		address.setAdditionalInfo(add);
		address.setStreet(street);
		address.setPhone(phone);
		address.setNumber(num);
		address.setNeighborhood(new NeighborhoodManager().get(neigh));
		address = new AddressManager().createAddres(address);
		return address;
	}
}
