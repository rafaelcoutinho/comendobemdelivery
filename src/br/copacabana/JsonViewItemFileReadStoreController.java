package br.copacabana;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.cache.Cache;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.Neighborhood;
import br.copacabana.marshllers.CityItemSerializer;
import br.copacabana.marshllers.KeyWrapperDeSerializer;
import br.copacabana.marshllers.KeyWrapperSerializer;
import br.copacabana.marshllers.NeighItemSerializer;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.Key;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * This Controller load an entity based on it's parameter name (usually id) and
 * Retrieve Command will use the configured manager to load the right entity.
 * 
 * @author Rafael Coutinho
 */
public class JsonViewItemFileReadStoreController extends JsonViewController {
	private static final Logger log = Logger.getLogger("copacabana.Controllers");
	private String classname;
	private String queryName;
	private String queryItemId;
	private String queryItemClass;
	private String cacheName;
	private String idLabel = "id";
	private String nameLabel = "name";
	private String jsonCacheName;
	private String jsonCacheId;

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

	protected static final Logger logcache = Logger.getLogger("copacabana.Caches");

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
				if (queryItemClass != null && queryItemClass.length() > 0) {
					((ListCommandFilteredBy) command).setQueryItemClass(queryItemClass);
				}
			}
			if (command instanceof GetLoggedUserCommand) {
				((GetLoggedUserCommand) command).setSession(request.getSession(true));
			}
			if (command instanceof CacheableCommand) {
				((CacheableCommand) command).setCache(cacheName);
			}
			if(command instanceof SessionCommand){
				((SessionCommand) command).setSession(request.getSession());
			}

			if (logger.isInfoEnabled())
				logger.info("Going to view " + getViewName() + " executing command " + command.getClass());

			command.setClassName(classname);
			command.execute(manager);

			DateSerializer dateSerializer = new DateSerializer(request);
			DateDeSerializer dateDeSerializer = new DateDeSerializer(request);

			GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
			gsonBuilder.registerTypeAdapter(Date.class, dateSerializer);
			gsonBuilder.registerTypeAdapter(Date.class, dateDeSerializer);
			gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
			gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
			gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
			gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
			gsonBuilder.registerTypeAdapter(City.class, new CityItemSerializer());
			gsonBuilder.registerTypeAdapter(Neighborhood.class, new NeighItemSerializer());

			if (command instanceof GsonSerializable) {
				Map<Class, Object> m = ((GsonSerializable) command).getGsonAdapters(manager);
				for (Iterator iterator = m.keySet().iterator(); iterator.hasNext();) {
					Class clazz = (Class) iterator.next();
					Object serializer = (Object) m.get(clazz);
					gsonBuilder.registerTypeAdapter(clazz, serializer);
				}

			}

			Gson gson = gsonBuilder.create();

			String json = gson.toJson(command.getEntity()); // Or use new
			// StringBuffer b = new StringBuffer();
			// b.append("{ \"identifier\":\"").append(idLabel).append("\", \"label\": \"").append(nameLabel).append("\", items: ");
			// String first =
			// "{ identifier:\""+idLabel+"\", label: \""+nameLabel+"\", items: ";
			// json=GsonBuilderFactory.escapeString(json);
			// b.append(json);
			//			
			// String last = "}";
			// b.append(last);
			//			
			// json=first+json+last;
			// System.out.println(json);

			// GsonBuilder
			// ().create();

			if (logger.isInfoEnabled()) {
				logger.info("JSON " + json);
			}
			String results = convertJsonToFileItemStore(json, idLabel, nameLabel).toString();
			if (jsonCacheName != null) {
				JsonViewItemFileReadStoreController.updateCacheValue(jsonCacheName, request.getParameter(jsonCacheId), results);
			}
			model.put("json", results);

			return new ModelAndView(getViewName(), model);
		} catch (Exception e) {
			e.printStackTrace();
			StringBuilder errormsg = new StringBuilder();
			errormsg.append("QueryName:").append(queryName).append(" / ");
			errormsg.append("queryItemId:").append(queryItemId).append(" / ");
			errormsg.append("queryItemClass:").append(queryItemClass).append(" / ");
			errormsg.append("classname:").append(classname).append(" / ");

			log.log(Level.SEVERE, "JsonViewItemFileReadStoreController failed. " + errormsg, e);
			Map<String, Object> model = new HashMap<String, Object>();

			JsonException exception = new JsonException(e.getMessage());

			throw exception;
		} finally {

		}
	}

	public static String getCachedValue(String jsonCacheName, String ckey) {
		Cache cache = CacheController.getCache();
		Map<String, String> thisCache = (HashMap<String, String>) cache.get(jsonCacheName);
		if(thisCache==null){
			return null;
		}
		return thisCache.get(ckey);
	}

	public static void updateCacheValue(String jsonCacheName, String ckey, String results) {
		Cache cache = CacheController.getCache();
		Map<String, String> thisCache = (HashMap<String, String>) cache.get(jsonCacheName);
		if(thisCache==null){
			thisCache=new HashMap<String, String>();
		}
		thisCache.put(ckey, results);
		cache.put(jsonCacheName, thisCache);
	}
	public static void invalidateCacheValue(String jsonCacheName, String ckey) {
		Cache cache = CacheController.getCache();
		Map<String, String> thisCache = (HashMap<String, String>) cache.get(jsonCacheName);
		if(thisCache!=null){
			thisCache.remove(ckey);
		}else{
			thisCache=new HashMap<String, String>();
		}
		cache.put(jsonCacheName, thisCache);
	}

	private static final String p4 = "}";
	private static final String p1 = "{ identifier:\"";
	private static final String p2 = "\", label: \"";
	private static final String p3 = "\", items: ";

	public static String convertJsonToFileItemStore(String json, String idLabel, String nameLabel) {
		StringBuilder sb = new StringBuilder(p1);
		sb.append(idLabel).append(p2).append(nameLabel).append(p3).append(GsonBuilderFactory.escapeString(json)).append(p4);
		return sb.toString();
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

	public String getIdLabel() {
		return idLabel;
	}

	public void setIdLabel(String idLabel) {
		this.idLabel = idLabel;
	}

	public String getNameLabel() {
		return nameLabel;
	}

	public void setNameLabel(String nameLabel) {
		this.nameLabel = nameLabel;
	}

	public String getCacheName() {
		return cacheName;
	}

	public void setCacheName(String cacheName) {
		this.cacheName = cacheName;
	}

	public String getQueryItemClass() {
		return queryItemClass;
	}

	public void setQueryItemClass(String queryItemClass) {
		this.queryItemClass = queryItemClass;
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
