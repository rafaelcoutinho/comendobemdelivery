package br.copacabana.usecase;

import java.io.IOException;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.ListRestaurantByFoodCategoryCommand;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.FoodCategoryManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class LoadCategory extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {		
		try {
			String cityName = extractCity(req.getPathInfo());
			String catName = extractCategory(req.getPathInfo());
			ServletContext context = getServletContext();
			WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
			FoodCategory f = ((FoodCategoryManager) applicationContext.getBean("foodcategoryManager")).getFoodCategoryByName(catName);
			CityManager cityMan = (CityManager) applicationContext.getBean("cityManager");
			Key citykey = null;
			if (cityMan == null || cityName.length()==0) {
				ConfigurationManager cm = (ConfigurationManager) applicationContext.getBean("confManager");
				citykey = KeyFactory.stringToKey(cm.getConfigurationValue("defaultCityKey"));
			} else {
				City c = cityMan.getCityByName(cityName);
				citykey = c.getId();
			}
			ListRestaurantByFoodCategoryCommand cmd = new ListRestaurantByFoodCategoryCommand();
			cmd.setId(KeyFactory.keyToString(f.getId()));
			cmd.setCityId(citykey);
			cmd.execute((Manager) applicationContext.getBean("plateManager"));
			Set<Restaurant> restList = (Set<Restaurant>) cmd.getEntity();
			req.setAttribute("preLoadedRestList", restList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		req.getRequestDispatcher("/home.do").forward(req, resp);

	}

	private static String extractCategory(String pathInfo) {
		int lastSlash = pathInfo.lastIndexOf('/');
		if (lastSlash > -1) {
			return pathInfo.substring(lastSlash + 1);
		}
		return null;
	}

	private static String extractCity(String pathInfo) {
		int lastSlash = pathInfo.lastIndexOf('/');
		int preLast = pathInfo.lastIndexOf('/', lastSlash - 1);
		if (lastSlash > -1) {
			return pathInfo.substring(preLast + 1, lastSlash);
		}
		return null;
	}

}
