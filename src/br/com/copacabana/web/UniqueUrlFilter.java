package br.com.copacabana.web;

import java.io.IOException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.copacabana.spring.RestaurantManager;

public class UniqueUrlFilter implements Filter {

	@Override
	public void destroy() {

	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
		try {
			HttpServletRequest request = (HttpServletRequest) req;
			String url = getPossibleRestaurantUrl(request.getRequestURI());
			if (url != null && url.length() > 0) {
				if (m.contains(url)) {					
					request.getRequestDispatcher("/" + url + ".restaurante").forward(req, resp);
					return;
				}else if(centrais.contains(url)){
					request.getRequestDispatcher("/" + url + ".central").forward(req, resp);
					return;					
				} 
			}
		} catch (Exception e) {
			
		}
		chain.doFilter(req, resp);
	}

	private String getPossibleRestaurantUrl(String pathInfo) {
		if (pathInfo != null && !pathInfo.endsWith(".do") && !pathInfo.endsWith(".jsp") && !pathInfo.endsWith("/")) {
			int lastSlash = pathInfo.lastIndexOf('/');
			if (lastSlash > -1) {
				return pathInfo.substring(lastSlash + 1);
			}
		}
		return null;
	}

	public static Set<String> m = new HashSet<String>();
	public static Set<String> centrais = new HashSet<String>();

	public static void replaceCentral(String url, String byUrl) {
		if (centrais.contains(url)) {
			centrais.remove(url);
		}
		centrais.add(byUrl);
	}
	public static void replace(String url, String byUrl) {
		if (m.contains(url)) {
			m.remove(url);
		}
		m.add(byUrl);
	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(config.getServletContext());
		RestaurantManager rman = ((RestaurantManager) applicationContext.getBean("restaurantManager"));
		List<Restaurant> rlist = rman.list();
		for (Iterator iterator = rlist.iterator(); iterator.hasNext();) {
			Restaurant restaurant = (Restaurant) iterator.next();
			m.add(restaurant.getUniqueUrlName());
		}
		
		CentralManager cman = ((CentralManager) applicationContext.getBean("centralManager"));
		for (Iterator<Central> iterator = cman.list().iterator(); iterator.hasNext();) {
			Central restaurant =  iterator.next();
			centrais.add(restaurant.getDirectAccess());
		}
		
	}

}
