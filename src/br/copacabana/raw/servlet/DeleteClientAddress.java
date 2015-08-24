package br.copacabana.raw.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Client;
import br.copacabana.Authentication;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.JsonException;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class DeleteClientAddress extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			Key userK = Authentication.getLoggedUserKey(req.getSession());

			Client c = Datastore.getPersistanceManager().find(Client.class, userK);
			String addressIdStr = req.getParameter("addKey");
			Key addKey = KeyFactory.stringToKey(addressIdStr);
			Datastore.getPersistanceManager().getTransaction().begin();
			c.getAddresses().remove(addKey);
			Datastore.getPersistanceManager().getTransaction().commit();
		} catch (JsonException e) {
			e.printStackTrace();

		}
		resp.sendRedirect("/enderecos.do");

	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
