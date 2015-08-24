package br.copacabana;

import java.util.logging.Logger;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.ContactInfo;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.NeighborhoodManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.UserBeanManager;

public class CreateRestaurantCommand implements Command, ReturnValueCommand {

	private Restaurant restaurant = new Restaurant();
	private UserBean user = new UserBean();
	private Address address = new Address();
	private Neighborhood neighborhood = new Neighborhood();

	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		RestaurantManager restMan = new RestaurantManager();
		if (restaurant.getId() != null) {
			Restaurant r = restMan.get(restaurant.getId());
			r.setFormalName(restaurant.getFormalName());
			r.setFormalDocumentId(restaurant.getFormalDocumentId());
			r.setFormalName(restaurant.getFormalName());
			r.setName(restaurant.getName());
			r.setPersonInChargeName(restaurant.getPersonInChargeName());
			r.setUrl(restaurant.getUrl());
			r.setDescription(restaurant.getDescription());
			r.setContact(restaurant.getContact());
			NeighborhoodManager nman = new NeighborhoodManager();
			AddressManager addMan = new AddressManager();
			address.setNeighborhood(neighborhood);
			Address changedAddress = addMan.changeAddress(address);

			UserBeanManager uman = new UserBeanManager();
			UserBean ub = uman.find(user.getId(), UserBean.class);
			ub.setLogin(user.getLogin());
			uman.update(ub);
			r.setUser(ub);
			r.setAddress(changedAddress.getId());

			restMan.update(r);

		} else {
			
			AddressManager man = new AddressManager();
			address.setNeighborhood(neighborhood);
			man.createAddres(address);
			restaurant.setAddress(address.getId());
			restaurant.setUser(user);
			ContactInfo cinfo = new ContactInfo(user.getLogin());
			restaurant.setContact(cinfo);
			restMan.create(restaurant);

		}

	}

	public Restaurant getRestaurant() {
		return restaurant;
	}

	public void setRestaurant(Restaurant restaurant) {
		this.restaurant = restaurant;
	}

	public UserBean getUser() {
		return user;
	}

	public void setUser(UserBean user) {
		this.user = user;
	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	public Neighborhood getNeighborhood() {
		return neighborhood;
	}

	public void setNeighborhood(Neighborhood neighborhood) {
		this.neighborhood = neighborhood;
	}

	@Override
	public Object getEntity() {
		// TODO Auto-generated method stub
		return getRestaurant();
	}

}
