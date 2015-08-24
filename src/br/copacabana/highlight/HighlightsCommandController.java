package br.copacabana.highlight;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.datanucleus.sco.backed.ArrayList;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.validation.BindException;
import org.springframework.validation.Errors;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.RestPlateHighlights;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.State;
import br.com.copacabana.cb.entities.WorkingHours;
import br.copacabana.Authentication;
import br.copacabana.CacheController;
import br.copacabana.PersistController;
import br.copacabana.commands.IPableCommand;
import br.copacabana.exception.JsonExceptionable;
import br.copacabana.spring.FoodCategoryManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.pe.CityPropertyEditor;
import br.copacabana.spring.pe.FoodCategoryPropertyEditor;
import br.copacabana.spring.pe.KeyPropertyEditor;
import br.copacabana.spring.pe.KeyWrapperPropertyEditor;
import br.copacabana.spring.pe.NeighborPropertyEditor;
import br.copacabana.spring.pe.SimplePropertyEditor;
import br.copacabana.spring.pe.StatePropertyEditor;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

/**
 * @author Rafael Coutinho
 */
public class HighlightsCommandController extends PersistController {
	// protected String objectClass;
	//
	// public String getObjectClass() {
	// return objectClass;
	// }
	//
	// public void setObjectClass(String objectClass) {
	// this.objectClass = objectClass;
	// }

	@SuppressWarnings("unchecked")
	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
		try {

			super.initBinder(request, binder);
			// binder.registerCustomEditor(State.class, new
			// StatePropertyEditor(manager));
			binder.registerCustomEditor(City.class, new CityPropertyEditor(manager));
			binder.registerCustomEditor(State.class, new StatePropertyEditor(manager));
			binder.registerCustomEditor(FoodCategory.class, new FoodCategoryPropertyEditor(manager));
			binder.registerCustomEditor(Address.class, new SimplePropertyEditor<Address>(manager, Address.class));
			binder.registerCustomEditor(Neighborhood.class, new NeighborPropertyEditor(manager));
			binder.registerCustomEditor(Restaurant.class, new SimplePropertyEditor<Restaurant>(manager, Restaurant.class));
			binder.registerCustomEditor(WorkingHours.class, new SimplePropertyEditor<WorkingHours>(manager, WorkingHours.class));
			binder.registerCustomEditor(KeyWrapper.class, new KeyWrapperPropertyEditor(manager));
			binder.registerCustomEditor(Key.class, new KeyPropertyEditor());
			binder.registerCustomEditor(ArrayList.class, new CustomCollectionEditor(List.class, false));
			binder.registerCustomEditor(HashSet.class, new CustomCollectionEditor(Set.class, false));
			SimpleDateFormat sdf = new SimpleDateFormat("hh:mm:ss dd-MM-yyyy", new Locale("pt", "br"));

			binder.registerCustomEditor(Date.class, new CustomDateEditor(sdf, false));

		} catch (Throwable e) {
			// TODO: handle exception
			log.log(Level.SEVERE, "initBinder json commandcontroller", e);
			throw new JsonException(e.getMessage());

		}
	}

	@Override
	protected ModelAndView showForm(HttpServletRequest request, HttpServletResponse response, BindException errors) throws Exception {
		ServletContext context = getServletContext();
		WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
		FoodCategoryManager foodMan = (FoodCategoryManager) applicationContext.getBean("foodcategoryManager");
		request.setAttribute("mainFoodCats", foodMan.getMainFoodCategories());
		return super.showForm(request, response, errors);
	}

	// reestabelecer o form
	@SuppressWarnings("unchecked")
	protected Object formBackingObject(HttpServletRequest request) throws Exception {
		try {
			Key k = Authentication.getLoggedUserKey(request.getSession());
			ServletContext context = getServletContext();
			WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
			FoodCategoryManager foodMan = (FoodCategoryManager) applicationContext.getBean("foodcategoryManager");
			Key[] cats = foodMan.getHighlightedFoodCategory(k);
			HighlightBean hbean = new HighlightBean();
			PlateManager plateMan = (PlateManager) applicationContext.getBean("plateManager");
			hbean.setCategories(cats);
			RestPlateHighlights rplates = plateMan.getRestaurantPlateHighlighs(k);
			Key[] plates = new Key[rplates.getPlates().size()];
			plates = rplates.getPlates().toArray(plates);
			hbean.setPlates(plates);
			hbean.setRestaurant(k);
			return hbean;

		} catch (Exception e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "formBackingObject high commandcontroller {0}", e);
			throw new JsonException(e.getMessage());
		}

	}

	@Override
	protected Map<String, Object> referenceData(HttpServletRequest request, Object command, Errors errors) throws Exception {
		// TODO Auto-generated method stub
		return new HashMap<String, Object>();
	}

	@Override
	protected void onBind(HttpServletRequest request, Object command, BindException errors) throws Exception {
		try {
			super.onBind(request, command, errors);
		} catch (Exception e) {
			log.log(Level.SEVERE, "onbind json commandcontroller", e);
			throw new JsonException(e.getMessage());
		}
	}

	@Override
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		if (command instanceof SessionCommand) {
			((SessionCommand) command).setSession(request.getSession());
		}
		if (command instanceof IPableCommand) {
			String ip = request.getRemoteAddr();
			if (ip == null || ip.length() == 0) {
				ip = request.getRemoteHost();
				if (ip == null || ip.length() == 0) {
					ip = request.getHeader("x-forwarded-for");
				}
			}
			((IPableCommand) command).setIp(ip);
		}
		HighlightBean hb = (HighlightBean) command;
		Key k = Authentication.getLoggedUserKey(request.getSession());
		hb.setRestaurant(k);

		return super.onSubmit(request, response, command, errors);
	}

	@Override
	protected ModelAndView onSubmit(Object object) throws Exception {
		try {
			log.info("calling onSubmit");
			HighlightBean hbean = (HighlightBean) object;
			Key[] cats = hbean.getCategories();
			WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
			FoodCategoryManager foodMan = (FoodCategoryManager) applicationContext.getBean("foodcategoryManager");
			PlateManager plateMan = (PlateManager) applicationContext.getBean("plateManager");
			plateMan.updateHighlights(hbean.getRestaurant(), hbean.getPlates());

			foodMan.dissociateAll(hbean.getRestaurant());

			for (int i = 0; i < cats.length; i++) {
				Key k = cats[i];
				if (k != null) {
					foodMan.associateHighlightCat(k, hbean.getRestaurant());
				}
			}
			CacheController.invalidateCache("listRestaurantHighlightPlatesFast", KeyFactory.keyToString(hbean.getRestaurant()));
			return new ModelAndView(getSuccessView());
		} catch (Exception e) {
			log.log(Level.SEVERE, "Executing json command controller {0}", e);
			log.log(Level.SEVERE, "Cause {0}", e.getCause());
			if (e instanceof JsonExceptionable) {
				throw ((JsonExceptionable) e).getJsonFormat();
			}
			if (e instanceof JsonException) {
				throw e;
			}
			throw new JsonException(e.getMessage());
		}
	}
}