package br.copacabana;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.datanucleus.sco.backed.ArrayList;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.State;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.pe.CityPropertyEditor;
import br.copacabana.spring.pe.FoodCategoryPropertyEditor;
import br.copacabana.spring.pe.KeyPropertyEditor;
import br.copacabana.spring.pe.KeyWrapperPropertyEditor;
import br.copacabana.spring.pe.NeighborPropertyEditor;
import br.copacabana.spring.pe.SimplePropertyEditor;
import br.copacabana.spring.pe.StatePropertyEditor;

import com.google.appengine.api.datastore.Key;

/**
 * This Controller load an entity based on it's parameter name (usually id) and
 * Retrieve Command will use the configured manager to load the right entity.
 * 
 * @author Rafael Coutinho
 */
public class ViewController extends SimpleViewController {
	protected static final Logger log = Logger.getLogger("copacabana.Controllers");

	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
		try {
			
			super.initBinder(request, binder);
			// binder.registerCustomEditor(State.class, new
			// StatePropertyEditor(manager));
			binder.registerCustomEditor(City.class, new CityPropertyEditor(manager));
			binder.registerCustomEditor(State.class, new StatePropertyEditor(manager));
			binder.registerCustomEditor(FoodCategory.class, new FoodCategoryPropertyEditor(manager));
			binder.registerCustomEditor(Neighborhood.class, new NeighborPropertyEditor(manager));
			binder.registerCustomEditor(Restaurant.class, new SimplePropertyEditor<Restaurant>(manager, Restaurant.class));
			binder.registerCustomEditor(KeyWrapper.class, new KeyWrapperPropertyEditor(manager));
			binder.registerCustomEditor(Key.class, new KeyPropertyEditor());
			binder.registerCustomEditor(ArrayList.class, new CustomCollectionEditor(List.class, false));
			binder.registerCustomEditor(HashSet.class, new CustomCollectionEditor(Set.class, false));
			binder.registerCustomEditor(Date.class, new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd"), true));

		} catch (Throwable e) {
			log.log(Level.SEVERE, "Binding error JsonView", e);
			throw new JsonException(e.getMessage());

		}
	}

	/**
	 * @see org.springframework.web.servlet.mvc.AbstractController#handleRequestInternal(javax.servlet.http.HttpServletRequest,
	 *      javax.servlet.http.HttpServletResponse)
	 */

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			RetrieveCommand command = (RetrieveCommand) getCommand(request);
			if (command instanceof SessionCommand) {
				((SessionCommand) command).setSession(request.getSession());
			}

			if (logger.isDebugEnabled())
				logger.debug("Going to view " + getViewName() + " executing command " + command);

			Map<String, Object> model = new HashMap<String, Object>();
			model.put(MODE, "view");
			if (command != null) {
				command.execute(manager);
				if (command.getEntity() != null)
					model.put(MODEL_NAME, command.getEntity());
			}
			return new ModelAndView(getViewName(), model);
		} catch (Exception e) {
			log.log(Level.SEVERE, "Erro ", e);
			throw e;
		}
	}
}
