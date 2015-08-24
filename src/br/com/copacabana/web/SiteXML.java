package br.com.copacabana.web;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.CacheController;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.search.bean.RestaurantBean;

import com.google.appengine.api.datastore.KeyFactory;

public class SiteXML extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/xml");
		String str = (String) CacheController.getCache().get("SiteXML");
		if (str == null || str.length() == 0) {
			str = getXML().toString();
			CacheController.getCache().put("SiteXML", str);
		}
		resp.getWriter().println(str);
	}

	private StringBuilder getXML() {
		StringBuilder siteXML = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + "<urlset xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\" xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.WEEK_OF_MONTH, -1);
		String lastDate = sdf.format(cal.getTime());

		for (int i = 0; i < UrlList.urlList.length; i++) {
			siteXML.append(createSiteEntry(Constants.HOSTNAME, UrlList.urlList[i], lastDate));
		}

		try {
			WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());

			RestaurantManager restMan = new RestaurantManager();
			List<Restaurant> rest = restMan.list("getRestaurant");
			for (Iterator<Restaurant> iterator = rest.iterator(); iterator.hasNext();) {
				Restaurant restaurant = (Restaurant) iterator.next();
				RestaurantBean rb = new RestaurantBean(restaurant);
				String key = KeyFactory.keyToString(restaurant.getId());
				String url = escapeXMLChars(rb.getDirectAccessUrl());
				siteXML.append(createSiteEntry(Constants.HOSTNAME, url, lastDate));
			}

			List<City> l = new CityManager().list();
			for (Iterator iterator = l.iterator(); iterator.hasNext();) {
				City city = (City) iterator.next();
				Set<Neighborhood> n = city.getNeighborhoods();
				String ccname = city.getName().toLowerCase();
				ccname = ccname.replace(' ', '-');
				for (Iterator iterator2 = n.iterator(); iterator2.hasNext();) {
					Neighborhood neighborhood = (Neighborhood) iterator2.next();
					String nname = neighborhood.getName().toLowerCase();
					nname = nname.replace(' ', '-');
					nname = nname.toLowerCase();
					String url = ccname + "/" + nname;
					siteXML.append(createSiteEntry(Constants.HOSTNAME, url, lastDate));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		siteXML.append("</urlset>");
		return siteXML;
	}

	private StringBuilder createSiteEntry(String host, String page, String date) {
		// http://beta.comendobem.com.br/jsp/quemsomos.jsp
		StringBuilder sb = new StringBuilder();
		sb.append("<url><loc>");
		sb.append(host);
		sb.append(page);
		sb.append("</loc><lastmod>");
		sb.append(date);
		sb.append("</lastmod><changefreq>monthly</changefreq><priority>1.0</priority></url>");
		return sb;
	}

	private String escapeXMLChars(String url) {
		return url.replaceAll("&", "&amp;").replaceAll("\\s", "+");
	}

}
