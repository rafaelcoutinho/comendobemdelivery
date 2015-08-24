package br.copacabana;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;

public class HotSiteController extends AbstractController {

	private Manager<Restaurant> manager;

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		System.out.println(req.getRequestURI());
		return null;
	}

	public void setManager(Manager<Restaurant> manager) {
		this.manager = manager;
	}

}
