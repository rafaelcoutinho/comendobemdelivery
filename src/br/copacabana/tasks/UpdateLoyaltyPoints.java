package br.copacabana.tasks;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.persistence.NoResultException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.LoyaltyPoints;
import br.com.copacabana.cb.entities.MealOrder;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.OrderManager;
import br.copacabana.usecase.invitation.InvitationManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class UpdateLoyaltyPoints extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.Servlet");

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		this.doGet(req, resp);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			PrintWriter out = resp.getWriter();
			OrderManager om = new OrderManager();
			Key idMo = KeyFactory.stringToKey(req.getParameter("id"));
			MealOrder mo = om.get(idMo);
			out.print("update loyalty for " + mo.getId().getId());
			ClientManager cm = new ClientManager();
			InvitationManager invMan = new InvitationManager();

			//int perOrder = 500;
			int perFriendsOrder = 200;

			ConfigurationManager confman = new ConfigurationManager();
//			if (confman.getConfigurationValue("loyalty.perOrder") != null && confman.getConfigurationValue("loyalty.perOrder").length() > 0) {
//				perOrder = (Integer.parseInt(confman.getConfigurationValue("loyalty.perOrder")));
//			}
			if (confman.getConfigurationValue("loyalty.perFriendsOrder") != null && confman.getConfigurationValue("loyalty.perFriendsOrder").length() > 0) {
				perFriendsOrder = (Integer.parseInt(confman.getConfigurationValue("loyalty.perFriendsOrder")));
			}

			LoyaltyPoints points = null;
			out.print("updating for client " + mo.getClientName());
			Datastore.getPersistanceManager().getTransaction().begin();
			try {
				points = cm.getLoyaltyForCurrentMonth(mo.getClient());
			} catch (NoResultException e) {
				points = new LoyaltyPoints(mo.getClient());
			}
			points.setPerOrder(1);
			points.setMyOrders(points.getMyOrders() + mo.getTotalAmountInCents());
			if (points.getId() == null) {
				Datastore.getPersistanceManager().persist(points);
			} else {
				Datastore.getPersistanceManager().merge(points);
			}
			Datastore.getPersistanceManager().getTransaction().commit();
			out.print("checking inviter of " + mo.getClientName());
			try {
				Key k = invMan.getGetMyInviterId(mo.getClient());
				Client myInviter = cm.get(k);
				Datastore.getPersistanceManager().getTransaction().begin();
				LoyaltyPoints inviterPoints = null;
				try {
					inviterPoints = cm.getLoyaltyForCurrentMonth(myInviter);
				} catch (NoResultException e) {
					inviterPoints = new LoyaltyPoints(myInviter);
				}
				inviterPoints.setPerFriendsOrder(perFriendsOrder);
				inviterPoints.setFriendsOrders(inviterPoints.getFriendsOrders() + 1);
				
				if (inviterPoints.getId() == null) {
					Datastore.getPersistanceManager().persist(inviterPoints);
				} else {
					Datastore.getPersistanceManager().merge(inviterPoints);
				}
				Datastore.getPersistanceManager().getTransaction().commit();
				out.print("updated inviter " + myInviter.getName());
			} catch (NoResultException e) {
				log.info("user was not invited by anyone");
				out.print("user was not invited by anyone");
			}

		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to execute update loyalty task", e);
		}

	}
}
