package br.copacabana.raw.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.Neighborhood;
import br.copacabana.Authentication;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.NeighborhoodManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class UpdateClientAddress extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			Key userK = Authentication.getLoggedUserKey(req.getSession());

			Client c = Datastore.getPersistanceManager().find(Client.class, userK);
			String addressIdStr = req.getParameter("address.id");
			String neighStr = req.getParameter("neighId");
			Key neighId = KeyFactory.stringToKey(neighStr);
			NeighborhoodManager nm = new NeighborhoodManager();
			AddressManager addman = new AddressManager();
			if (addressIdStr == null || addressIdStr.length() == 0) {

				Address add = new Address();
				add.setAdditionalInfo(req.getParameter("address.additionalInfo"));
				add.setNumber(req.getParameter("address.number"));
				add.setPhone(req.getParameter("address.phone"));
				add.setStreet(req.getParameter("address.street"));
				add.setNeighborhood(nm.get(neighId));
				add = addman.createAddres(add);
				Datastore.getPersistanceManager().getTransaction().begin();
				c.getAddresses().add(add.getId());
				Datastore.getPersistanceManager().merge(c);
				Datastore.getPersistanceManager().getTransaction().commit();

			} else {
				Key addKey = KeyFactory.stringToKey(addressIdStr);
				Address add = new Address();// Datastore.getPersistanceManager().find(Address.class, addKey);
				add.setId(addKey);
				add.setAdditionalInfo(req.getParameter("address.additionalInfo"));
				add.setNumber(req.getParameter("address.number"));
				add.setPhone(req.getParameter("address.phone"));
				add.setStreet(req.getParameter("address.street"));
				add.setZipCode(req.getParameter("address.zipCode"));
				add.setNeighborhood(nm.get(neighId));
				add = addman.changeAddress(add);
				if (!addKey.equals(add.getId())) {
					Datastore.getPersistanceManager().getTransaction().begin();
					c.getAddresses().remove(addKey);
					c.getAddresses().add(add.getId());
					Datastore.getPersistanceManager().merge(c);
					Datastore.getPersistanceManager().getTransaction().commit();
				}

				// if (add.getNeighborhood().getId().equals(neighId)) {
				// Datastore.getPersistanceManager().getTransaction().begin();
				// add.setAdditionalInfo(req.getParameter("address.additionalInfo"));
				// add.setNumber(req.getParameter("address.number"));
				// add.setPhone(req.getParameter("address.phone"));
				// add.setStreet(req.getParameter("address.street"));
				// Datastore.getPersistanceManager().merge(add);
				// Datastore.getPersistanceManager().getTransaction().commit();
				// } else {
				//
				// Address novo = new Address();
				// novo.setAdditionalInfo(req.getParameter("address.additionalInfo"));
				// novo.setNumber(req.getParameter("address.number"));
				// novo.setPhone(req.getParameter("address.phone"));
				// novo.setStreet(req.getParameter("address.street"));
				//
				// Datastore.getPersistanceManager().getTransaction().begin();
				// c.getAddresses().remove(add.getId());
				// Datastore.getPersistanceManager().getTransaction().commit();
				//
				// }

			}

		} catch (JsonException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
		resp.sendRedirect("/enderecos.do");

	}

	private Address createNewAddress(Address add, Client c, Key neighId) {
		Datastore.getPersistanceManager().getTransaction().begin();
		Neighborhood n = Datastore.getPersistanceManager().find(Neighborhood.class, neighId);
		add.setNeighborhood(n);
		n.addAddress(add);
		Datastore.getPersistanceManager().merge(n);
		Datastore.getPersistanceManager().getTransaction().commit();
		Datastore.getPersistanceManager().getTransaction().begin();
		c.getAddresses().add(add.getId());
		Datastore.getPersistanceManager().merge(c);
		Datastore.getPersistanceManager().getTransaction().commit();
		return add;
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
