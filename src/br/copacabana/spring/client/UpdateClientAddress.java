package br.copacabana.spring.client;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;

public class UpdateClientAddress extends RetrieveCommand implements SessionCommand {
	private Address __address = new Address();
	private Key __neighId;

	private HttpSession session;
	
	@Override
	public void execute(Manager manager) throws Exception {
		Key userK = Authentication.getLoggedUserKey(session);

		ClientManager cm = (ClientManager)manager;
		System.out.println("cm: "+cm+" "+cm.hashCode());		
		System.out.println("em: "+cm.getEntityManagerBean().getEntityManager()+" "+cm.getEntityManagerBean().getEntityManager().hashCode());
		
		Client c = cm.get(userK);
		if (__address.getId() == null) {
			__address=createNewAddress(c, __address, __neighId, cm.getEntityManagerBean().getEntityManager());
			c.getAddresses().add(__address.getId());
		} else {
			AddressManager addman = new AddressManager();
			Address existingOne = addman.getAddress(__address.getId());
			if (!existingOne.getNeighborhood().getId().equals(__neighId)) {
				// xiii vou ter q criar um novo endereço.
				Key addToRemoveKey = __address.getId();
				c.getAddresses().remove(__address.getId());
				
				Address novo = new Address();
				novo.setAdditionalInfo(__address.getAdditionalInfo());
				novo.setNumber(__address.getNumber());
				novo.setStreet(__address.getStreet());
				novo.setPhone(__address.getPhone());
				novo = createNewAddress(c, novo, __neighId, cm.getEntityManagerBean().getEntityManager());						
				c.getAddresses().add(novo.getId());
				
				addman.initiateAddressDeletion(addToRemoveKey);

			} else {
				EntityManager em = cm.getEntityManagerBean().getEntityManager();
				em.getTransaction().begin();
				existingOne = em.find(Address.class, __address.getId());
				existingOne.setAdditionalInfo(__address.getAdditionalInfo());
				existingOne.setNumber(__address.getNumber());
				existingOne.setStreet(__address.getStreet());
				existingOne.setPhone(__address.getPhone());
				em.merge(existingOne);
				em.flush();
				em.getTransaction().commit();
				
				
			}

		}
		cm.update(c);
		this.entity = ""+Math.random();
	}

	private Address createNewAddress(Client c, Address _address2, Key _neighId2, EntityManager em) throws Exception {
		em.getTransaction().begin();
		Neighborhood n = em.find(Neighborhood.class, _neighId2);
		_address2.setNeighborhood(n);
		n.addAddress(_address2);
		em.merge(n);
		em.flush();		
		em.getTransaction().commit();
		return _address2;
		
	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	public Address getAddress() {
		return __address;
	}

	public void setAddress(Address address) {
		this.__address = address;
	}

	public HttpSession getSession() {
		return session;
	}

	public Key getNeighId() {
		return __neighId;
	}

	public void setNeighId(Key neighId) {
		this.__neighId = neighId;
	}

}
