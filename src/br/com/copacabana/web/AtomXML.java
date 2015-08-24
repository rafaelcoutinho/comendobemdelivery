package br.com.copacabana.web;

import java.io.IOException;
import java.text.MessageFormat;
import java.util.Iterator;
import java.util.List;
import java.util.ResourceBundle;
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

public class AtomXML extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 504289440721087639L;
	String requestUrl = "http://www.comendobem.com.br/comopedir.do";
	String keywords = "delivery de comidas pela internet, delivery de massas, delivery de comida japonesa, chinesa, entrega de pizza, delivery de pizza,delivery, comida, restaurante, restaurantes, almoco, almoço, jantar, lanches, pizza, pizzaria, hamburger,disk-pizza, cardapio virtual, cardapio online, cardapio on-line, cardapio restaurante";

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/xml");

		String str = (String) CacheController.getCache().get("AtomXML");
		if (str == null || str.length() == 0) {
			str = getXML().toString();
			CacheController.getCache().put("AtomXML", str);
		}
		resp.getWriter().println(str);
	}

	private StringBuilder getXML() {
		StringBuilder siteXML = new StringBuilder("<?xml version='1.0' encoding='UTF-8'?><?xml-stylesheet href=\"http://www.comendobem.com.br/styles/atom.css\" type=\"text/css\"?>");
		siteXML.append("<feed xmlns='http://www.w3.org/2005/Atom' xmlns:openSearch='http://a9.com/-/spec/opensearchrss/1.0/' xmlns:georss='http://www.georss.org/georss' xmlns:thr='http://purl.org/syndication/thread/1.0'>");
		siteXML.append("<id>tag:comendobem.com.br,2010</id>");
		siteXML.append("<updated>2010-08-16T18:36:55.665-03:00</updated>");
		siteXML.append("<title type='text'>ComendoBem.com.br - Site de delivery pela internet com pagamento online.</title>");
		siteXML.append("<subtitle type='html'>delivery de comidas pela internet, delivery de massas, delivery de comida japonesa, chinesa, entrega de pizza, delivery de pizza,delivery, comida, restaurante, restaurantes, almoco, almoço, jantar, lanches, pizza, pizzaria, hamburger,disk-pizza, cardapio virtual, cardapio online, cardapio on-line, cardapio restaurante.</subtitle>");
		siteXML.append("<link rel='http://schemas.google.com/g/2005#feed' type='application/atom+xml' href='http://www.comendobem.com.br/atom.xml'/>");
		siteXML.append("<link rel='self' type='application/atom+xml' href='http://www.comendobem.com.br/atom.xml'/>");
		siteXML.append("<link rel='alternate' type='text/html' href='http://www.comendobem.com.br/'/><link rel='hub' href='http://www.comendobem.com/'/>");
		siteXML.append("<author><name>CopacabanaTech</name>");
		siteXML.append("<uri>http://www.copacabanatech.com/</uri><email>contato@copacabanatech.com</email></author>");
		siteXML.append("<generator version='7.00' uri='http://www.comendobem.com.br'>ComendoBem</generator>");
		siteXML.append("<openSearch:totalResults>13</openSearch:totalResults><openSearch:startIndex>1</openSearch:startIndex><openSearch:itemsPerPage>25</openSearch:itemsPerPage>");

		String pdate = "2010-09-16T17:37:00.001-03:00";
		String udate = "2010-09-16T17:37:00.001-03:00";

		for (int i = 0; i < UrlList.urlList.length; i++) {
			siteXML.append(createEntry(Constants.HOSTNAME, UrlList.urlList[i], requestUrl, UrlList.urlTitle[i], UrlList.urlTitle[i], pdate, udate, keywords));
		}

		try {
			WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());

			RestaurantManager restMan = new RestaurantManager();
			List<Restaurant> rest = restMan.list("getRestaurant");
			for (Iterator iterator = rest.iterator(); iterator.hasNext();) {
				Restaurant restaurant = (Restaurant) iterator.next();
				String key = KeyFactory.keyToString(restaurant.getId());
				String title = restaurant.getName() + " também faz delivery (entregas) pela internet usando o comendobem.com.br";
				RestaurantBean rb = new RestaurantBean(restaurant);
				String url = escapeXMLChars(rb.getDirectAccessUrl());
				String content = "O " + restaurant.getName() + " também faz delivery (entregas) pela internet usando o <a href=\"http://www.comendobem.com.br\">www.comendobem.com.br</a>.<br>";
				if (restaurant.getImageUrl() != null && restaurant.getImageUrl().length() > 0) {
					content += "<img src=\"";
					content += Constants.HOSTNAME + restaurant.getImageUrl() + "\"/>";
				}
				content += "<br/>" + restaurant.getDescription() + "<br/>";
				content = content.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");

				siteXML.append(createEntry(Constants.HOSTNAME, rb.getDirectAccessUrl(), requestUrl, content, title, pdate, udate, keywords + " " + restaurant.getName()));

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());

			CityManager restMan = new CityManager();

			List<City> rest = restMan.list("getCities");
			String atomKeys = ResourceBundle.getBundle("messages").getString("atom.keywords");
			String atomContent = ResourceBundle.getBundle("messages").getString("atom.content");
			String atomTitle = ResourceBundle.getBundle("messages").getString("atom.title");
			for (Iterator<City> iterator = rest.iterator(); iterator.hasNext();) {
				City city = (City) iterator.next();
				String key = KeyFactory.keyToString(city.getId());
				String url = escapeXMLChars("home.do");
				String kwords = MessageFormat.format(atomKeys, new String[] { city.getName() });
				String title = MessageFormat.format(atomTitle, new String[] { city.getName() });
				String content = MessageFormat.format(atomContent, new String[] { city.getName() });
				siteXML.append(createEntry(Constants.HOSTNAME, url, requestUrl, content, title, pdate, udate, kwords));

				Set<Neighborhood> n = city.getNeighborhoods();
				String ccname = city.getName().toLowerCase();
				siteXML.append(createEntry(Constants.HOSTNAME, ccname, requestUrl, content, title, pdate, udate, kwords));
				ccname = ccname.replace(' ', '-');
				for (Iterator iterator2 = n.iterator(); iterator2.hasNext();) {
					Neighborhood neighborhood = (Neighborhood) iterator2.next();
					String nname = neighborhood.getName().toLowerCase();
					nname = nname.replace(' ', '-');
					nname = nname.toLowerCase();
					String url2 = ccname + "/" + nname;
					siteXML.append(createEntry(Constants.HOSTNAME, url2, requestUrl, content, title, pdate, udate, kwords));

				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		siteXML.append("</feed>");
		return siteXML;
	}

	private String escapeXMLChars(String url) {
		return url.replaceAll("&", "&amp;").replaceAll("\\s", "+");
	}

	private StringBuilder createEntry(String host, String page, String requestpage, String content, String title, String pdate, String udate, String keywords) {
		StringBuilder siteXML = new StringBuilder();
		siteXML.append("<entry>");
		siteXML.append("<id>tag:comendobem.com.br,2010:a</id>");
		siteXML.append("<published>");
		// 2010-08-16T17:37:00.001-03:00
		siteXML.append(pdate);
		siteXML.append("</published>");
		siteXML.append("<updated>");
		siteXML.append(udate);
		siteXML.append("</updated>");
		siteXML.append("<category scheme='http://www.comendobem.com.br/atom/ns#' term='");
		siteXML.append(keywords);
		siteXML.append("'/>");
		siteXML.append("<title type='text'>");
		siteXML.append(title);
		siteXML.append("</title>");
		siteXML.append("<content type='html'>");
		siteXML.append(content);
		siteXML.append("</content>");
		siteXML.append("<link rel='replies' type='application/atom+xml' href='");
		siteXML.append(host);
		siteXML.append(requestpage);
		siteXML.append("' title='Fazer pedido'/>");

		siteXML.append("<link rel='alternate' type='text/html' href='");
		siteXML.append(host);

		siteXML.append(page);

		siteXML.append("' title='");
		siteXML.append(title);
		siteXML.append("' />");

		siteXML.append("<link rel='self' type='application/atom+xml' href='");

		siteXML.append(host);

		siteXML.append(page);
		siteXML.append("'/>");
		siteXML.append("<author><name>ComendoBem.com.br</name><uri>http://www.comendobem.com.br/home.do</uri>");
		siteXML.append("<email>contato@comendobem.com.br</email>");
		siteXML.append("</author>");

		siteXML.append("</entry>");

		return siteXML;
	}

}
