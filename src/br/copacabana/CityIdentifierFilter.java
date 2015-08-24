package br.copacabana;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import br.com.copacabana.cb.entities.City;
import br.copacabana.usecase.CityIdentifier;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class CityIdentifierFilter implements Filter {

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		String cityKey = (String) ((HttpServletRequest) req).getSession().getAttribute("identifiedCity");
		if (cityKey == null) {
			JsonObject jsonCity = new JsonObject();
			((HttpServletRequest) req).getSession().setAttribute("jsonIdentifiedCity", jsonCity.toString());
			Boolean tried = (Boolean) ((HttpServletRequest) req).getSession().getAttribute("alreadyTriedIndentifyCity");
			if (!Boolean.TRUE.equals(tried)) {
				City c = CityIdentifier.findCityByIP((HttpServletRequest) req, ctx);
				if (c == null) {
					c = CityIdentifier.findDefaultCity((HttpServletRequest) req, ctx);
				}
				if (c == null) {
					System.err.println("No default city");

				} else {
					jsonCity.add("id", new JsonPrimitive(KeyFactory.keyToString(c.getId())));
					jsonCity.add("name", new JsonPrimitive(c.getName()));
					((HttpServletRequest) req).getSession().setAttribute("jsonIdentifiedCity", jsonCity.toString());
					((HttpServletRequest) req).getSession().setAttribute("identifiedCity", KeyFactory.keyToString(c.getId()));
					((HttpServletRequest) req).getSession().setAttribute("identifiedCityName", c.getName());
					((HttpServletRequest) req).getSession().setAttribute("alreadyTriedIndentifyCity", Boolean.TRUE);
				}
			}
		}
		chain.doFilter(req, res);

	}

	private ServletContext ctx;

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		ctx = arg0.getServletContext();

	}

}
