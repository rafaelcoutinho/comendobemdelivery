package br.com.copacabana.web;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.DeliveryRange;
import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.CacheController;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.DeliveryManager;
import br.copacabana.spring.FoodCategoryManager;
import br.copacabana.spring.NeighborhoodManager;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;


public class RorXML extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 504289440721087639L;
	private static int latestDay = -1;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/xml;charset=utf-8");
		resp.setCharacterEncoding("utf-8");

		String str = (String) CacheController.getCache().get("ror");
		if (str == null || str.length() == 0) {
			str = getXML().toString();
			CacheController.getCache().put("ror", str);
		}

		resp.getWriter().println(str);
	}

	private StringBuilder getXML() {
		StringBuilder siteXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?><rss version=\"2.0\" xmlns:ror=\"http://rorweb.com/0.1/\" ><channel>");

		siteXML.append("<title>ComendoBem RSS feeder</title><link>");
		siteXML.append(Constants.HOSTNAME);

		siteXML.append("</link><description>ComendoBem.com.br - Site de delivery pela internet com pagamento online.</description>" + "<language>pt-br</language><copyright>Copyright  2010. All rights reserved.</copyright><category>News</category><ttl>60</ttl>");
		siteXML.append("<image><title>ComendoBem Feeder</title><url>");
		siteXML.append(Constants.HOSTNAME);
		siteXML.append("resources/img/logo.png</url>");
		// siteXML.append("<width>179</width><height>133</height>");
		siteXML.append("<link>");
		siteXML.append(Constants.HOSTNAME);
		siteXML.append("home.do");
		siteXML.append("</link>");
		siteXML.append("</image>");
		for (int i = 0; i < UrlList.urlList.length; i++) {
			siteXML.append(createEntry(Constants.HOSTNAME, UrlList.urlList[i], UrlList.urlTitle[i], UrlList.urlTitle[i], "pedidos via internet, delivery, campinas"));
		}

		try {
			WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());

			RestaurantManager restMan = new RestaurantManager();
			List<Restaurant> rest = restMan.list("getRestaurant");
			for (Iterator<Restaurant> iterator = rest.iterator(); iterator.hasNext();) {
				Restaurant restaurant = (Restaurant) iterator.next();
				String key = KeyFactory.keyToString(restaurant.getId());
				String title = restaurant.getName() + " tambem faz delivery (entregas) pela internet usando o comendobem.com.br";

				String description = getDescriptionRestaurant(restaurant);
				String keywords = getKeywordsRestaurant(restaurant);
				String url = escapeXMLChars("home.do?showRestaurant=true&restaurantId=" + key);
				if (restaurant.getUniqueUrlName() != null && !restaurant.getUniqueUrlName().equals("")) {
					String uniqueurl = escapeXMLChars(restaurant.getUniqueUrlName() + ".restaurante");
					siteXML.append(createEntry(Constants.HOSTNAME, uniqueurl, title, description, keywords));
				}

				siteXML.append(createEntry(Constants.HOSTNAME, url, title, description, keywords));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());

			CityManager restMan = new CityManager();
			List<City> rest = restMan.list("getCities");
			String rorDesc = ResourceBundle.getBundle("messages").getString("ror.desc");
			String rorKeyWords = ResourceBundle.getBundle("messages").getString("ror.keywords");
			String rorDescNeighs = ResourceBundle.getBundle("messages").getString("ror.desc.neighs");
			String rorContet = ResourceBundle.getBundle("messages").getString("ror.content");
			for (Iterator<City> iterator = rest.iterator(); iterator.hasNext();) {
				City city = (City) iterator.next();
				String key = KeyFactory.keyToString(city.getId());
				String url = escapeXMLChars("home.do");
				String content = MessageFormat.format(rorContet, new String[] { city.getName() });
				String description = MessageFormat.format(rorDesc, new String[] { city.getName() });
				String keywords = MessageFormat.format(rorKeyWords, new String[] { city.getName(), city.getState().getName() });
				siteXML.append(createEntry(Constants.HOSTNAME, url, content, description, keywords));

				Set<Neighborhood> n = city.getNeighborhoods();
				String ccname = city.getName().toLowerCase();
				ccname = ccname.replace(' ', '-');

				for (Iterator iterator2 = n.iterator(); iterator2.hasNext();) {
					Neighborhood neighborhood = (Neighborhood) iterator2.next();
					String nname = neighborhood.getName().toLowerCase();
					nname = nname.replace(' ', '-');
					nname = nname.toLowerCase();
					String url2 = ccname + "/" + nname;
					String contentN = MessageFormat.format(rorDescNeighs, new String[] { city.getName(), neighborhood.getName() });
					siteXML.append(createEntry(Constants.HOSTNAME, url2, contentN, description, keywords));
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		siteXML.append("</channel></rss>");

		return siteXML;

	}

	public static String getKeywordsRestaurant(Restaurant restaurant) {
		StringBuilder sb = new StringBuilder(restaurant.getName());
		sb.append(",");
		PlateManager pman = new PlateManager();
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("restaurant", restaurant);
		List l = pman.list("getPlateByRestaurantOrderedByName", m);
		Set<Key> fcs = new HashSet<Key>();
		for (Iterator iterator = l.iterator(); iterator.hasNext();) {
			Plate p = (Plate) iterator.next();
			sb.append(p.getName());
			sb.append(",");
			fcs.add(p.getFoodCategory());
		}
		FoodCategoryManager fcman = new FoodCategoryManager();
		for (Iterator iterator = fcs.iterator(); iterator.hasNext();) {
			Key key = (Key) iterator.next();
			String name = fcman.find(key, FoodCategory.class).getName();
			sb.append(name);
			sb.append(",");

		}

		DeliveryManager dman = new DeliveryManager();
		m.put("restaurantKey", restaurant.getId());
		Set<DeliveryRange> neighbList = restaurant.getDeliveryRanges();
		NeighborhoodManager nman = new NeighborhoodManager();
		for (Iterator iterator = neighbList.iterator(); iterator.hasNext();) {
			DeliveryRange deliveryRange = (DeliveryRange) iterator.next();
			Neighborhood neighbor = nman.find(deliveryRange.getNeighborhood(), Neighborhood.class);
			sb.append(neighbor.getName());
			sb.append(",");
		}

		return sb.toString();
	}

	private String getDescriptionRestaurant(Restaurant restaurant) {
		StringBuilder sb = new StringBuilder(restaurant.getName());
		sb.append(" também faz entregas de delivery online pelo ComendoBem!	<br> Experimente os nossos pratos:<br/>");
		PlateManager pman = new PlateManager();
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("restaurant", restaurant);
		List l = pman.list("getPlateByRestaurantOrderedByName", m);
		for (Iterator iterator = l.iterator(); iterator.hasNext();) {
			Plate p = (Plate) iterator.next();
			sb.append("<br>");
			sb.append(p.getName());
		}
		sb.append("<br>");
		sb.append("Entregando em :");
		sb.append("<br>");
		DeliveryManager dman = new DeliveryManager();
		m.put("restaurantKey", restaurant.getId());
		Set<DeliveryRange> neighbList = restaurant.getDeliveryRanges();
		NeighborhoodManager nman = new NeighborhoodManager();
		for (Iterator iterator = neighbList.iterator(); iterator.hasNext();) {
			DeliveryRange deliveryRange = (DeliveryRange) iterator.next();
			Neighborhood neighbor = nman.find(deliveryRange.getNeighborhood(), Neighborhood.class);
			sb.append(neighbor.getName() + ", " + neighbor.getCity().getName());
			sb.append("<br>");
		}
		return sb.toString();
	}

	public static String escapeXMLChars(String url) {
		return url.replaceAll("&", "&amp;").replaceAll("\\s", "+");
	}

	public static String escapeAllXMLChars(String url) {
		return url.replaceAll("&", "&amp;").replaceAll("\\s", "+").replaceAll("<", "&lt;").replaceAll(">", "&gt;");

	}

	private StringBuilder createEntry(String host, String page, String title, String description, String keywords) {
		StringBuilder siteXML = new StringBuilder();
		siteXML.append("<item><link>");
		siteXML.append(Constants.HOSTNAME);
		siteXML.append(page);
		siteXML.append("</link><title>");
		siteXML.append(title);
		siteXML.append("</title>");

		description = "";//XML.escape(description);// escapeAllXMLChars(description);//FIXME stop using import com.google.appengine.labs.repackaged.org.json.XML;
		siteXML.append("<description>");
		siteXML.append(description);
		siteXML.append("</description>");
		if (keywords == null || keywords.length() == 0) {
			keywords = "Delivery, pizza, massas, comida, restaurante, pedidos";
		}
		siteXML.append("<ror:keywords>");
		//siteXML.append(XML.escape(keywords));//FIXME stop using import com.google.appengine.labs.repackaged.org.json.XML;
		siteXML.append("</ror:keywords>");
		siteXML.append("<ror:type>Feed</ror:type><ror:updatePeriod>weekly</ror:updatePeriod><ror:sortOrder>0</ror:sortOrder><ror:resourceOf>sitemap</ror:resourceOf>");
		siteXML.append("<ror:seeAlso>");
		siteXML.append(Constants.HOSTNAME);
		siteXML.append("home.do");
		siteXML.append("</ror:seeAlso>");

		siteXML.append("</item>");
		return siteXML;
	}

}
