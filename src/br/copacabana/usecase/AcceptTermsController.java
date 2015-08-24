package br.copacabana.usecase;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.Restaurant.SiteStatus;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Authentication;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.usecase.beans.AcceptTermsBean;

import com.google.appengine.api.datastore.Key;

public class AcceptTermsController extends SimpleFormController {

	protected String classname;

	public String getClassname() {
		return classname;
	}

	public void setClassname(String classname) {
		this.classname = classname;
	}

	protected Manager manager;

	public void setManager(Manager manager) {
		this.manager = manager;
	}

	// reestabelecer o form
	protected Object formBackingObject(HttpServletRequest request) throws Exception {
		return new AcceptTermsBean();

	}
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		String accepted = request.getParameter("accepted");
		if(!"YES".equals(accepted)){
			return showNewForm(request, response);
		}
		Key k = Authentication.getLoggedUserKey(request.getSession());
		RestaurantManager restMan = new RestaurantManager();
		Restaurant r = restMan.getRestaurant(k);
		r.setSiteStatus(SiteStatus.ACTIVE);
		r.setLastAcceptedTermsDate(new Date());
		restMan.persist(r);
		request.getSession().removeAttribute("restaurantNotActive");		
		return new ModelAndView(getSuccessView());
	}
	
	
}
