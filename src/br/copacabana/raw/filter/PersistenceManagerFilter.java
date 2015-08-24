package br.copacabana.raw.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class PersistenceManagerFilter implements Filter {

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		Datastore.initialize();
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		try {

			chain.doFilter(request, response);
		} finally {
			Datastore.finishRequest();
		}
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

}
