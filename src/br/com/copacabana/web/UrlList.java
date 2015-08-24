package br.com.copacabana.web;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.City;
import br.com.copacabana.cb.entities.Neighborhood;
import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.CacheController;
import br.copacabana.spring.CityManager;
import br.copacabana.spring.RestaurantManager;

public class UrlList extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/plain");
		String str = (String) CacheController.getCache().get("UrlList");
		if (str == null || str.length() == 0) {
			str = getTxt(req, resp).toString();
			CacheController.getCache().put("UrlList", str);
		}
		resp.getWriter().println(str);
	}

	private StringBuilder getTxt(HttpServletRequest req, HttpServletResponse resp) {
		StringBuilder siteXML = new StringBuilder(Constants.HOSTNAME);
		siteXML.append("\n");
		for (int i = 0; i < urlList.length; i++) {

			siteXML.append(Constants.HOSTNAME);
			siteXML.append(urlList[i]);
			siteXML.append("\n");
		}
		
		RestaurantManager rm = new RestaurantManager();
		for (Iterator<Restaurant> iterator = rm.list().iterator(); iterator.hasNext();) {
			Restaurant r = iterator.next();
			if(r.getDirectAccessUrl()!=null){
				siteXML.append(Constants.HOSTNAME);
				siteXML.append(r.getDirectAccessUrl());
				siteXML.append("\n");	
			}
		}
		
		CityManager cm = new CityManager();
		List<City> l = cm.list();
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
				siteXML.append(Constants.HOSTNAME);
				siteXML.append(url);
				siteXML.append("\n");
			}
		}

		return siteXML;
	}

	public static final String[] urlList = new String[] { "home.do", "cidadescomdelivery.do", "jsp/quemsomos.jsp", "jsp/privacidade.jsp", "contato.do", "contatoRestaurante.do", "jsp/comopedir.jsp", "loginRegistro.do", "mostraCategorias/Cachaças", "mostraCategorias/Pizzas", "mostraCategorias/Massas", "mostraCategorias/Chopp"};
	public static final String[] urlTitle = new String[] { "ComendoBem.com.br - Site de delivery pela internet com pagamento online.", "Cidades com delivery do ComendoBem", "Quem somos", "Politica de privacidade", "Contato", "Inscrevendo seu restaurante", "Como pedir", "Login", "Cidades com delivery do ComendoBem", "Cachaças de alto padrão", "Delivery de pizzas", "Delivery de Massas", "Delivery de chopp", "Empório Rota Joaquim", "Vila Re Pizzaria", "Churrascaria Baby Beef Steak House", "Chopp Kremer Campinas", "Espetinhos Campinas de Barão" };

}
