package br.copacabana;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.datanucleus.sco.backed.ArrayList;
import org.springframework.beans.propertyeditors.CustomBooleanEditor;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.validation.BindException;
import org.springframework.validation.Errors;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.State;
import br.com.copacabana.cb.entities.WorkingHours;
import br.copacabana.exception.JsonExceptionable;
import br.copacabana.marshllers.KeyWrapperDeSerializer;
import br.copacabana.marshllers.KeyWrapperSerializer;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.pe.CityPropertyEditor;
import br.copacabana.spring.pe.FoodCategoryPropertyEditor;
import br.copacabana.spring.pe.KeyPropertyEditor;
import br.copacabana.spring.pe.KeyWrapperPropertyEditor;
import br.copacabana.spring.pe.NeighborPropertyEditor;
import br.copacabana.spring.pe.SimplePropertyEditor;
import br.copacabana.spring.pe.StatePropertyEditor;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * @author Rafael Coutinho
 */
public class JsonPersistController extends PersistController {

	@SuppressWarnings("unchecked")
	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
		try {
			logger.debug("initBinder");
			super.initBinder(request, binder);
			// binder.registerCustomEditor(State.class, new
			// StatePropertyEditor(manager));
			binder.registerCustomEditor(City.class, new CityPropertyEditor(manager));
			binder.registerCustomEditor(State.class, new StatePropertyEditor(manager));
			binder.registerCustomEditor(FoodCategory.class, new FoodCategoryPropertyEditor(manager));
			binder.registerCustomEditor(Neighborhood.class, new NeighborPropertyEditor(manager));
			binder.registerCustomEditor(Restaurant.class, new SimplePropertyEditor<Restaurant>(manager, Restaurant.class));
			binder.registerCustomEditor(WorkingHours.class, new SimplePropertyEditor<WorkingHours>(manager, WorkingHours.class));
			binder.registerCustomEditor(KeyWrapper.class, new KeyWrapperPropertyEditor(manager));
			binder.registerCustomEditor(Key.class, new KeyPropertyEditor());
			binder.registerCustomEditor(ArrayList.class, new CustomCollectionEditor(List.class, false));
			binder.registerCustomEditor(HashSet.class, new CustomCollectionEditor(Set.class, false));
			binder.registerCustomEditor(Double.class, new CustomNumberEditor(Double.class, false));
			binder.registerCustomEditor(Date.class, new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd"), true));
			binder.registerCustomEditor(Boolean.class, new CustomBooleanEditor(false));
			binder.registerCustomEditor(Boolean.class, new CustomBooleanEditor(CustomBooleanEditor.VALUE_ON, CustomBooleanEditor.VALUE_FALSE, false));
		} catch (Throwable e) {
			// TODO: handle exception
			log.log(Level.SEVERE, "Json persist init binding.", e);
			throw new JsonException(e.getMessage());

		}
	}

	@Override
	protected ModelAndView showForm(HttpServletRequest request, HttpServletResponse response, BindException errors) throws Exception {
		return super.showForm(request, response, errors);
	}
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Object obj = getCommand(request);
		//System.out.println(obj);
		return super.handleRequestInternal(request, response);
	}
	
	// reestabelecer o form
	@SuppressWarnings("unchecked")
	protected Object formBackingObject(HttpServletRequest request) throws Exception {
		try {
			// return getClass().forName(objectClass).getConstructor(new
			// Class[0]).newInstance(new Object[0]);
			String id = request.getParameter("id");
			if (id != null && id.length() != 0) {
				Key k = KeyFactory.stringToKey(id);

				if (k != null) {
					Object o = manager.find(k, getCommandClass());
					return o;
				}
			}
			return getCommandClass().getConstructor(new Class[0]).newInstance(new Object[0]);
		} catch (Exception e) {
			log.log(Level.SEVERE, "Json persist formbacking.", e);
			throw new JsonException(e.getMessage());
		}

	}

	@Override
	protected Map<String, Object> referenceData(HttpServletRequest request, Object command, Errors errors) throws Exception {
		if (errors != null) {
			log.log(Level.SEVERE, "Jsonpersistcontroller reference data", errors);
		}
		return new HashMap<String, Object>();

	}

	@Override
	protected void onBind(HttpServletRequest request, Object command, BindException errors) throws Exception {
		try {
			super.onBind(request, command, errors);
		} catch (Exception e) {
			logger.error(e);
			log.log(Level.SEVERE, "Json persist binding." + e.getMessage());
			log.log(Level.FINE, "Json persist binding.", e);
			throw new JsonException(e.getMessage());
		}
	}

	@Override
	protected void onBind(HttpServletRequest request, Object command) throws Exception {

		try {
			super.onBind(request, command);
		} catch (Exception e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "Json persist binding.", e);
			throw new JsonException(e.getMessage());
		}
	}

	@Override
	protected ModelAndView onSubmit(Object object) throws Exception {
		try {

			JsonPersistCommand persistCommand = new JsonPersistCommand(object);
			persistCommand.execute(manager);
			return assembleReturn(persistCommand.getId(), persistCommand.getEntity());

		} catch (Exception e) {
			throwJsonError(e);
		}
		return null;// never reached
	}

	protected void throwJsonError(Exception e) throws JsonException {
		log.log(Level.SEVERE, "Failed jsonPersisting:" + e.getMessage());
		log.log(Level.INFO, "Failed jsonPersisting", e);
		if (e instanceof JsonException) {
			throw ((JsonException) e);
		}
		if (e instanceof JsonExceptionable) {
			throw ((JsonExceptionable) e).getJsonFormat();
		}
		throw new JsonException(e.getMessage());
	}

	protected ModelAndView assembleReturn(Object id, Object entity) {
		Map<String, Object> model = new HashMap<String, Object>();

		model.put("id", id);
		model.put("mode", "view");

		GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
		gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
		gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
		gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
		gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
		Gson gson = gsonBuilder.create();

		String json = gson.toJson(entity); // Or use new
		json = GsonBuilderFactory.escapeString(json);

		if (log.isLoggable(Level.INFO))
			log.info("JSON " + json);

		model.put("json", json);

		return new ModelAndView(getSuccessView(), model);

	}

}