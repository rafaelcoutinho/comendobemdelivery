package br.copacabana;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.datanucleus.sco.backed.ArrayList;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.validation.BindException;
import org.springframework.validation.Errors;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.State;
import br.com.copacabana.cb.entities.WorkingHours;
import br.copacabana.commands.IPableCommand;
import br.copacabana.exception.JsonExceptionable;
import br.copacabana.marshllers.KeyWrapperDeSerializer;
import br.copacabana.marshllers.KeyWrapperSerializer;
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
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

/**
 * @author Rafael Coutinho
 */
public class JsonCommandController extends PersistController {
	// protected String objectClass;
	//
	// public String getObjectClass() {
	// return objectClass;
	// }
	//
	// public void setObjectClass(String objectClass) {
	// this.objectClass = objectClass;
	// }

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Object command = getCommand(request);
		log.log(Level.INFO, "Command {0}", command);
		log.log(Level.INFO, "Id param {0}", request.getParameter("id"));
		return super.handleRequestInternal(request, response);
	}

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
		errors.printStackTrace();
		return super.showForm(request, response, errors);
	}

	// reestabelecer o form
	@SuppressWarnings("unchecked")
	protected Object formBackingObject(HttpServletRequest request) throws Exception {
		try {
			log.log(Level.INFO, "formBackingObject");
			// return getClass().forName(objectClass).getConstructor(new
			// Class[0]).newInstance(new Object[0]);
			String id = request.getParameter("id");
			log.log(Level.INFO, "formBackingObject id {0}", id);
			if (id != null && id.length() != 0) {
				Key k = KeyFactory.stringToKey(id);
				log.log(Level.INFO, "formBackingObject k {0}", k);
				if (k != null) {
					try {
						Object o = manager.find(k, getCommandClass());
						log.log(Level.INFO, "formBackingObject o {0}", o);
						if (o != null)
							return o;
					} catch (Exception e) {
						log.log(Level.SEVERE, "formBackingObject json commandcontroller o search {0}", e);
					}
				}
			}
			return getCommandClass().getConstructor(new Class[0]).newInstance(new Object[0]);
		} catch (Exception e) {
			e.printStackTrace();
			log.log(Level.SEVERE, "formBackingObject json commandcontroller {0}", e);
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
	protected void onBind(HttpServletRequest request, Object command) throws Exception {

		try {
			super.onBind(request, command);
		} catch (Exception e) {
			e.printStackTrace();
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
		return super.onSubmit(request, response, command, errors);
	}

	@Override
	protected ModelAndView onSubmit(Object object) throws Exception {
		try {
			log.info("calling onSubmit");

			((Command) object).execute();
			Map<String, Object> model = new HashMap<String, Object>();
			if (object instanceof ReturnValueCommand) {
				GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
				gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
				gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
				gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
				gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
				if (object instanceof GsonSerializable) {
					Map<Class, Object> m = ((GsonSerializable) object).getGsonAdapters(manager);
					for (Iterator iterator = m.keySet().iterator(); iterator.hasNext();) {
						Class clazz = (Class) iterator.next();
						Object serializer = (Object) m.get(clazz);
						gsonBuilder.registerTypeAdapter(clazz, serializer);
					}

				}
				Gson gson = gsonBuilder.create();
				Object returnedObj = ((ReturnValueCommand) object).getEntity();
				String json;
				if (returnedObj instanceof StringBuffer) {
					JsonObject jobj = new JsonObject();
					jobj.add("type", new JsonPrimitive("string"));
					jobj.add("value", new JsonPrimitive(((StringBuffer) returnedObj).toString()));
					json = jobj.toString();
				} else if (returnedObj instanceof JsonObject) {
					json = ((JsonObject) returnedObj).toString();
				} else {
					json = gson.toJson(returnedObj); // Or use new
				}
				json = GsonBuilderFactory.escapeString(json);

				model.put("json", json);
			}

			model.put("mode", "view");

			return new ModelAndView(getSuccessView(), model);
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