package br.copacabana.usecase.loyalty;

import java.util.List;

import javax.persistence.NoResultException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.LoyaltyPoints;
import br.copacabana.spring.ClientManager;
import br.copacabana.usecase.MainServlet;

public class MyPoints extends MainServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5592715044926396751L;

	@Override
	protected boolean isClientProtected() {
		return true;
	}

	@Override
	protected void doInternalGet(HttpServletRequest req, HttpServletResponse resp) {
		ClientManager cm = new ClientManager();

		Client c = cm.get(this.getLoggedClient(req.getSession()));
		LoyaltyPoints currentMonth = null;
		try {
			currentMonth = cm.getLoyaltyForCurrentMonth(c);
		} catch (NoResultException e) {
			log.info("no points this month");
		}
		List<LoyaltyPoints> previousMonths = cm.getLoyaltyBecoreCurrentMonth(c);
		req.setAttribute("currentMonth", currentMonth);
		req.setAttribute("previousMonths", previousMonths);
	}
}
