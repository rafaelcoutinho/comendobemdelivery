package br.copacabana.spring;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.persistence.Query;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.ContactInfo;
import br.com.copacabana.cb.entities.RestaurantClient;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

public class RestaurantClientManager extends AbstractJPAManager<RestaurantClient> {

	@Override
	public String getDefaultQueryName() {
		return "allRestaurantClients";
	}

	@Override
	protected Class getEntityClass() {
		return RestaurantClient.class;
	}
	
	public List<RestaurantClient> getRestaurantClients(Key restId) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getAllRestClients");
		q.setParameter("restId", restId);
		return q.getResultList();
	}
	
	
	public List<RestaurantClient> getRestaurantClients(Key restId,String phone) {		
		Query q = Datastore.getPersistanceManager().createNamedQuery("getAllRestClientsWithPhone");
		q.setParameter("phone", phone);
		q.setParameter("restId", restId);
		
		return q.getResultList();
	}
	
	public List<Client> getClientsByAddressPhone(String phone){
		Query q = Datastore.getPersistanceManager().createNamedQuery("getAddressByPhone");
		q.setParameter("phone", phone);
		List<Address> clist= q.getResultList();
		List<Client> clients = new ArrayList<Client>();
		for (Iterator<Address> iterator = clist.iterator(); iterator.hasNext();) {
			Address address = (Address) iterator.next();
			Query q2 = Datastore.getPersistanceManager().createNamedQuery("getClientByAddresses");
			q2.setParameter("address", address.getId());			
			clients.addAll(q2.getResultList());
		}
		return clients;
	}

	public List<Client> getSiteClientsWithPhone(String phone){
		Query q = Datastore.getPersistanceManager().createNamedQuery("getContactInfoByPhone");
		q.setParameter("phone", phone);
		List<ContactInfo> clist= q.getResultList();
		List<Client> clients = new ArrayList<Client>();
		for (Iterator iterator = clist.iterator(); iterator.hasNext();) {
			ContactInfo contactInfo = (ContactInfo) iterator.next();
			Query q2 = Datastore.getPersistanceManager().createNamedQuery("getClientByContact");
			q2.setParameter("contact", contactInfo);			
			clients.addAll(q2.getResultList());
		}
		return clients;
	}

}

