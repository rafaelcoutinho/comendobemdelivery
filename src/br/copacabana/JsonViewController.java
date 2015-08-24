package br.copacabana;

import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.cache.Cache;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.datanucleus.sco.backed.ArrayList;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
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
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * This Controller load an entity based on it's parameter name (usually id) and
 * Retrieve Command will use the configured manager to load the right entity.
 * 
 * @author Rafael Coutinho
 */
public class JsonViewController extends ViewController {
	protected static final Logger log = Logger.getLogger("copacabana.Controllers");
	private String classname;
	private String queryName;
	private String queryItemId;
	private String staticParams;
	private String staticField;
	private String cacheName;
	private String jsonCacheName;
	private String jsonCacheId;
	protected static final Logger logcache = Logger.getLogger("copacabana.Caches");

	@Override
	protected void initApplicationContext() {
		super.initApplicationContext();
		if (jsonCacheName != null) {
			Cache cache = CacheController.getCache();			
			Map<String, String> thisCache = new HashMap<String, String>();
			cache.put(jsonCacheName, thisCache);
			logcache.log(Level.FINE,"Recreating cache: {0}" ,jsonCacheName);
		}
	}
	public String getClassname() {
		return classname;
	}

	public void setClassname(String classname) {
		this.classname = classname;
	}

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
			binder.registerCustomEditor(KeyWrapper.class, new KeyWrapperPropertyEditor(manager));
			binder.registerCustomEditor(Key.class, new KeyPropertyEditor());
			binder.registerCustomEditor(ArrayList.class, new CustomCollectionEditor(List.class, false));
			binder.registerCustomEditor(HashSet.class, new CustomCollectionEditor(Set.class, false));

		} catch (Throwable e) {
			logger.error("Binding error JsonView",e);
			throw new JsonException(e.getMessage());

		}
	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

		try {
			Map<String, Object> model = new HashMap<String, Object>();
			if (jsonCacheName != null) {
				String results = JsonViewItemFileReadStoreController.getCachedValue(jsonCacheName, request.getParameter(jsonCacheId));
				if (logcache.isLoggable(Level.INFO)) {
					if (results != null) {
						logcache.log(Level.INFO, "Cache hit for {0}:{1}!", new String[] { jsonCacheName, request.getParameter(jsonCacheId) });
					} else {
						logcache.log(Level.INFO, "Cache miss for {0}:{1}!", new String[] { jsonCacheName, request.getParameter(jsonCacheId) });

					}
				}
				if (results != null) {
					model.put("json", results);
					return new ModelAndView(getViewName(), model);
				}
			}
			
			RetrieveCommand command = (RetrieveCommand) getCommand(request);
			if (command instanceof ListCommandFilteredBy) {
				((ListCommandFilteredBy) command).setQueryName(queryName);
				((ListCommandFilteredBy) command).setQueryItemId(queryItemId);
				((ListCommandFilteredBy) command).setStaticParams(staticParams);
				((ListCommandFilteredBy) command).setStaticField(staticField);
			}
			
			if(command instanceof SessionCommand){
				((SessionCommand) command).setSession(request.getSession());
			}
			if(command instanceof CacheableCommand){
				((CacheableCommand) command).setCache(cacheName);
			}
			if (logger.isInfoEnabled())
				logger.info("Going to view " + getViewName() + " executing command " + command.getClass());

			
			command.setClassName(classname);
			command.execute(manager);

			DateSerializer dateSerializer = new DateSerializer(request);
			DateDeSerializer dateDeSerializer = new DateDeSerializer(request);
			
			GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();// new GsonBuilder().setPrettyPrinting().serializeNulls().excludeFieldsWithoutExposeAnnotation();
			gsonBuilder.registerTypeAdapter(Date.class, dateSerializer);
			gsonBuilder.registerTypeAdapter(Date.class, dateDeSerializer);
			gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
			gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
			
			if(command instanceof GsonSerializable){
				Map<Class,Object>m=((GsonSerializable)command).getGsonAdapters(manager);
				for (Iterator iterator = m.keySet().iterator(); iterator.hasNext();) {
					Class clazz = (Class) iterator.next();
					Object serializer = (Object) m.get(clazz);
					gsonBuilder.registerTypeAdapter(clazz, serializer);	
				}				
			}
			
			// gsonBuilder.registerTypeAdapter(KeyWrapper.class, new
			// KeyWrapperDeSerializer());
			// gsonBuilder.registerTypeAdapter(KeyWrapper.class, new
			// KeyWrapperSerializer());

			Gson gson = gsonBuilder.serializeSpecialFloatingPointValues().create();
			
			String json = gson.toJson(command.getEntity()); // Or use new
			json=GsonBuilderFactory.escapeString(json);
			
			// GsonBuilder
			// ().create();

			if (logger.isInfoEnabled())
				logger.info("JSON " + json);

			if (jsonCacheName != null) {
				JsonViewItemFileReadStoreController.updateCacheValue(jsonCacheName, request.getParameter(jsonCacheId), json);
			}
			model.put("json", json);

			return new ModelAndView(getViewName(), model);
		} catch (JsonException e) {			
			logger.error(e.getMessage(),e);
			throw e;
		} catch (Exception e) {
			
			StringBuilder sb = new StringBuilder();
			sb.append("getQueryItemId:"+getQueryItemId());			
			sb.append("getQueryName:"+getQueryName());
			sb.append("getCommandName:"+getCommandName());			
			sb.append("getStaticField:"+getStaticField());
			sb.append("getStaticParams:"+getStaticParams());
			
			logger.error("Failed to execute JsonViewController. ",e);
			Map<String, Object> model = new HashMap<String, Object>();

			JsonException exception = new JsonException(e.getMessage());

			throw exception;
		} finally {
			
		}
	}

	public String getQueryName() {
		return queryName;
	}

	public void setQueryName(String queryName) {
		this.queryName = queryName;
	}

	public String getQueryItemId() {
		return queryItemId;
	}

	public void setQueryItemId(String queryItemId) {
		this.queryItemId = queryItemId;
	}

	public String getStaticParams() {
		return staticParams;
	}

	public void setStaticParams(String staticParams) {
		this.staticParams = staticParams;
	}

	public String getStaticField() {
		return staticField;
	}

	public void setStaticField(String staticField) {
		this.staticField = staticField;
	}

	public String getCacheName() {
		return cacheName;
	}

	public void setCacheName(String cacheName) {
		this.cacheName = cacheName;
	}
	public String getJsonCacheName() {
		return jsonCacheName;
	}
	public void setJsonCacheName(String jsonCacheName) {
		this.jsonCacheName = jsonCacheName;
	}
	public String getJsonCacheId() {
		return jsonCacheId;
	}
	public void setJsonCacheId(String jsonCacheId) {
		this.jsonCacheId = jsonCacheId;
	}
}
