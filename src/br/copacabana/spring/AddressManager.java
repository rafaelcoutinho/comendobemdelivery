package br.copacabana.spring;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.mgr.AbstractJPAManager;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.taskqueue.Queue;
import com.google.appengine.api.taskqueue.QueueFactory;
import com.google.appengine.api.taskqueue.TaskOptions;
import com.google.appengine.api.taskqueue.TaskOptions.Method;

public class AddressManager extends AbstractJPAManager<Address> {

	@Override
	public String getDefaultQueryName() {
		return "getAddress";
	}

	public Address getAddress(Key address) {
		return this.find(address, Address.class);

	}

	public void initiateAddressDeletion(Key addToRemoveKey) {
		Queue queue = QueueFactory.getDefaultQueue();
		queue.add(TaskOptions.Builder.withUrl("/tasks/handleAddressDeletion.do").param("addKey", KeyFactory.keyToString(addToRemoveKey)).method(Method.POST));

	}

	@Override
	protected Class getEntityClass() {

		return Address.class;
	}

	public Address changeAddress(Address address) {
		Address existing = this.get(address.getId());
		Key existingNeigh = existing.getNeighborhood().getId();
		Key newNeigh = address.getNeighborhood().getId();
		boolean sameNeighborhood = existingNeigh.equals(newNeigh);

		if (!sameNeighborhood) {
			Datastore.getPersistanceManager().getTransaction().begin();
			Neighborhood n = Datastore.getPersistanceManager().find(Neighborhood.class, existingNeigh);
			n.getAddresses().remove(existing);
			Datastore.getPersistanceManager().remove(existing);
			Datastore.getPersistanceManager().getTransaction().commit();
			existing = new Address();
		}

		existing.setAdditionalInfo(address.getAdditionalInfo());
		existing.setNumber(address.getNumber());
		existing.setPhone(address.getPhone());
		existing.setStreet(address.getStreet());
		existing.setX(address.getX());
		existing.setY(address.getY());
		existing.setZipCode(address.getZipCode());
		existing.setNeighborhood(Datastore.getPersistanceManager().find(Neighborhood.class, address.getNeighborhood().getId()));
		if (!sameNeighborhood) {
			existing = createAddres(existing);
		} else {

			Datastore.getPersistanceManager().getTransaction().begin();
			Datastore.getPersistanceManager().merge(existing);
			Datastore.getPersistanceManager().getTransaction().commit();
		}

		return existing;
	}

	/**
	 * Address must contain its neighborhood
	 * 
	 * @param newAddress
	 * @return
	 */
	public Address createAddres(Address newAddress) {
		Datastore.getPersistanceManager().getTransaction().begin();
		Neighborhood n = Datastore.getPersistanceManager().find(Neighborhood.class, newAddress.getNeighborhood().getId());
		Datastore.getPersistanceManager().persist(newAddress);
		n.getAddresses().add(newAddress);
		Datastore.getPersistanceManager().merge(n);
		Datastore.getPersistanceManager().getTransaction().commit();
		return newAddress;
	}

	public Address duplicate(Key refAddress) {
		Address address = this.get(refAddress);
		Key existingNeigh = address.getNeighborhood().getId();
		Address clone = new Address();
		Neighborhood n = Datastore.getPersistanceManager().find(Neighborhood.class, existingNeigh);
		clone.setAdditionalInfo(address.getAdditionalInfo());
		clone.setNumber(address.getNumber());
		clone.setPhone(address.getPhone());
		clone.setStreet(address.getStreet());
		clone.setX(address.getX());
		clone.setY(address.getY());
		clone.setZipCode(address.getZipCode());
		clone.setNeighborhood(Datastore.getPersistanceManager().find(Neighborhood.class, address.getNeighborhood().getId()));		
		Datastore.getPersistanceManager().persist(clone);
		n.getAddresses().add(clone);
		Datastore.getPersistanceManager().merge(n);
		return clone;

	}

}
