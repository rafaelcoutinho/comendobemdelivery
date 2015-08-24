package br.copacabana.usecase.beans;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;

import javax.cache.Cache;
import javax.persistence.Query;
import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.CacheController;
import br.copacabana.GsonBuilderFactory;
import br.copacabana.JsonViewItemFileReadStoreController;
import br.copacabana.KeyDeSerializer;
import br.copacabana.KeySerializer;
import br.copacabana.ListCommand;
import br.copacabana.ListCommandFilteredBy;
import br.copacabana.RetrieveCommand;
import br.copacabana.marshllers.CityItemSerializer;
import br.copacabana.marshllers.KeyWrapperDeSerializer;
import br.copacabana.marshllers.KeyWrapperSerializer;
import br.copacabana.marshllers.NeighItemSerializer;
import br.copacabana.raw.filter.Datastore;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.FoodCategoryManager;
import br.copacabana.spring.NeighborhoodManager;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.SessionCommand;
import br.copacabana.usecase.GetDailyTip;
import br.copacabana.usecase.GetWeeklyTip;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class PrepareHome extends RetrieveCommand implements SessionCommand {

	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	static Cache cache;

	private HighlightTip getWeekly() {

		GetWeeklyTip d = new GetWeeklyTip();
		d.execute(new ConfigurationManager());
		return d.getEntity();
	}

	private HighlightTip getDaily() {
		GetDailyTip d = new GetDailyTip();
		d.execute();
		return d.getEntity();

	}

	public void execute(Manager manager) {

		ConfigurationManager cm = new ConfigurationManager();
		entity = new HashMap();
		GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
		gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
		gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
		Gson g = gsonBuilder.create();
		cache = CacheController.getCache();
		if (cache.get("dailyHighlightJson") == null) {
			cache.put("dailyHighlightJson", g.toJson(getDaily()));
		}
		((Map) entity).put("daily", cache.get("dailyHighlightJson"));

		if (cache.get("weeklyHighlightJson") == null) {
			cache.put("weeklyHighlightJson", g.toJson(getWeekly()));
		}
		((Map) entity).put("weekly", cache.get("weeklyHighlightJson"));

		if (cache.get("catListJson") == null) {
			cache.put("catListJson", g.toJson(getFoodCategoryList()));
		}
		((Map) entity).put("catList", cache.get("catListJson"));
		if (cache.get("defaultCityKey") == null) {
			cache.put("defaultCityKey", g.toJson(getConfValue("defaultCityKey")));
		}
		((Map) entity).put("defaultCityKey", cache.get("defaultCityKey"));

		if (cache.get("defaultCityName") == null) {
			cache.put("defaultCityName", g.toJson(getConfValue("defaultCityName")));
		}
		((Map) entity).put("defaultCityName", cache.get("defaultCityName"));

		if (cache.get("citiesList") == null) {
			ListCommand l = new ListCommand();
			try {
				l.setCache("citiesListCache");
				l.execute(new CityManager());
				Gson gson = getGson();
				String json = gson.toJson(l.getEntity());
				String cityList = JsonViewItemFileReadStoreController.convertJsonToFileItemStore(json, "id", "name");
				cache.put("citiesList", cityList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		((Map) entity).put("citiesList", cache.get("citiesList"));

		if (cache.get("defaultCityKey") != null && cache.get("defaultNeighborList") == null) {
			ListCommandFilteredBy l = new ListCommandFilteredBy();
			try {

				l.setQueryName("searchNeighborhoodByCity");
				l.setQueryItemId("city");
				l.setQueryItemClass("br.com.copacabana.cb.entities.City");

				l.setKey(KeyFactory.stringToKey(getConfValue("defaultCityKey")));
				NeighborhoodManager nman = new NeighborhoodManager();
				l.execute(nman);
				Gson gson = getGson();
				String json = gson.toJson(l.getEntity());
				String neighList = JsonViewItemFileReadStoreController.convertJsonToFileItemStore(json, "id", "name");
				cache.put("defaultNeighborList", neighList);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		((Map) entity).put("defaultNeighborList", cache.get("defaultNeighborList"));
		((Map) entity).put("foodCatObj", getFoodCategoryList());

	}

	private Gson gson = null;

	private Gson getGson() {
		if (this.gson == null) {
			GsonBuilder gsonBuilder2 = GsonBuilderFactory.getInstance();
			gsonBuilder2.registerTypeAdapter(Key.class, new KeyDeSerializer());
			gsonBuilder2.registerTypeAdapter(Key.class, new KeySerializer());
			gsonBuilder2.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
			gsonBuilder2.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
			gsonBuilder2.registerTypeAdapter(City.class, new CityItemSerializer());
			gsonBuilder2.registerTypeAdapter(Neighborhood.class, new NeighItemSerializer());

			this.gson = gsonBuilder2.create();
		}
		return this.gson;
	}

	public static List<FoodCategory> getFoodCategoryList() {
		PlateManager pm = new PlateManager();
		Map<String, Object> m = new HashMap<String, Object>();
		try {
			Query q = Datastore.getPersistanceManager().createQuery("select from FoodCategory where isMainCategory=true order by name");
			List<FoodCategory> list = q.getResultList();

			return list;
		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to get food cat: {0}", e);
			return new FoodCategoryManager().list("getFoodCategories");
			// return new ArrayList<FoodCategory>();
		}

	}

	private String getConfValue(String key) {
		Configuration weeklyHighlightImageAlt = Datastore.getPersistanceManager().find(Configuration.class, key);
		if (weeklyHighlightImageAlt == null) {
			log.log(Level.SEVERE, "Cannot find {0} configuration", key);
			return "";
		}
		return weeklyHighlightImageAlt.getValue();
	}

}
