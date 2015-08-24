package br.copacabana.raw.servlet;

import java.io.IOException;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.copacabana.Authentication;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;
import br.copacabana.spring.client.AddressBean;
import br.copacabana.spring.client.ClientAddressBean;

import com.google.appengine.api.datastore.Key;

public class LoadClientAddresses extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			Key userK = Authentication.getLoggedUserKey(req.getSession());

			Client client = Datastore.getPersistanceManager().find(Client.class, userK);
			ClientAddressBean clientAddressBean = new ClientAddressBean(client);
			for (Iterator<Key> iterator = client.getAddresses().iterator(); iterator.hasNext();) {
				Key addK = iterator.next();
				Address address = Datastore.getPersistanceManager().find(Address.class, addK);
				clientAddressBean.addAddress(new AddressBean(address));
			}
			// System.out.println("Total enderecos " +
			// client.getAddresses().size());
			req.setAttribute("entity", clientAddressBean);

			// Query q =
			// Datastore.getPersistanceManager().createNamedQuery("getCitiesOrderByName");

			// req.setAttribute("cities", q.getResultList());

			req.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");
			resp.setCharacterEncoding("UTF-8");
			req.getRequestDispatcher("/WEB-INF/jsp/user/manageAddress.jsp").include(req, resp);

		} catch (JsonException e) {
			if (e.getErrorCode().equals(ErrorCode.USERNOTLOGGEDIN)) {
				resp.sendError(403);
			} else {
				throw new ServletException(e);
			}
		}

	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
