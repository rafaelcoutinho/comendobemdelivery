package br.copacabana.spring.search;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.persistence.NoResultException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.RestaurantSearchCommand;
import br.copacabana.SearchCriteria;
import br.copacabana.ViewController;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.NeighborhoodManager;
import br.copacabana.spring.search.bean.RestaurantBean;

import com.google.appengine.api.datastore.KeyFactory;

public class DirectSearchController extends ViewController {
	public static String stripeCityPath(String pathinfo) {
		while (pathinfo.startsWith("/")) {
			pathinfo = pathinfo.substring(1);
		}
		if (pathinfo.endsWith("/")) {
			pathinfo = pathinfo.substring(0, pathinfo.length() - 1);
		}

		return pathinfo;
	}

	Pattern pat = Pattern.compile("/?(\\w*)/?([a-z\\-\\s]*)?/?");

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String reqUri = request.getRequestURI();
		String[] params = getLocationSearch(reqUri);
		RestaurantSearchCommand restSearch = new RestaurantSearchCommand();
		CityManager cm = new CityManager();
		City c = cm.getCityByName(params[0]);
		Map<String, Object> model = new HashMap<String, Object>();
		SearchCriteria criteria = new SearchCriteria();
		criteria.setCity(KeyFactory.keyToString(c.getId()));
		if (params.length > 1) {
			try {
				NeighborhoodManager nm = new NeighborhoodManager();
				Neighborhood n = nm.getNeighborByName(params[1]);
				criteria.setNeighbor(KeyFactory.keyToString(n.getId()));
				model.put("neigh", n.getName());
			} catch (NoResultException e) {
				// TODO: handle exception
			}
		}
		criteria.setOpenStatus("false");
		restSearch.setCriteria(criteria);
		restSearch.execute();
		// List<Restaurant> rests = restSearch.getEntity();
		List<RestaurantBean> rests = convert(restSearch.getEntity());
		ModelAndView mv = super.handleRequestInternal(request, response);

		model.put("restaurants", rests);
		model.put("city", c.getName());

		model.put("isDirectSearch", true);
		mv.addAllObjects(model);
		return mv;
	}

	private List<RestaurantBean> convert(List<Restaurant> list) {
		List<RestaurantBean> listBean = new ArrayList<RestaurantBean>();
		for (Iterator<Restaurant> iterator = list.iterator(); iterator.hasNext();) {
			Restaurant restaurant = (Restaurant) iterator.next();
			listBean.add(new RestaurantBean(restaurant));

		}
		return listBean;

	}

	private String[] getLocationSearch(String reqUri) {

		reqUri = URLDecoder.decode(reqUri);
		reqUri = reqUri.toLowerCase();
		Matcher match = pat.matcher(reqUri);
		String city = null;
		String neighborhood = null;

		if (match.find()) {
			city = match.group(1);
			neighborhood = match.group(2);
			neighborhood = neighborhood.replace('-', ' ');
			city = city.replace('-', ' ');
			city = properCase(city);
			if (neighborhood != null && neighborhood.length() > 0) {
				neighborhood = properCase(neighborhood);
			}

		}
		return new String[] { city, neighborhood };
	}

	private String properCase(String city) {
		char[] chars = city.toCharArray();
		System.out.println(city);
		chars[0] = (new String(new char[] { chars[0] })).toUpperCase().charAt(0);
		for (int i = 1; i < chars.length; i++) {
			if (chars[i - 1] == ' ') {
				chars[i] = (new String(new char[] { chars[i] })).toUpperCase().charAt(0);
			}
		}
		return new String(chars);
	}

	public static void main(String[] args) {
		new DirectSearchController().getLocationSearch("/campinas/vila itapura/");
		new DirectSearchController().getLocationSearch("/campinas/vila+itapura/");
	}
}
