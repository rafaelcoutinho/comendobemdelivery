package br.copacabana.spring.rest;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.Authentication;
import br.copacabana.RetrieveCommand;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;

public class LoadRestaurantData extends RetrieveCommand<Restaurant> implements SessionCommand {
	private HttpSession s;

	@Override
	public void execute() throws Exception {
		RestaurantManager rman = new RestaurantManager();
		Restaurant r = rman.get(Authentication.getLoggedUserKey(s));
		this.entity = r;
	}

	@Override
	public void setSession(HttpSession s) {
		this.s = s;

	}
}
