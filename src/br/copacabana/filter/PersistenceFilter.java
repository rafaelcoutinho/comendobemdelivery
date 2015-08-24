package br.copacabana.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.copacabana.EntityManagerBean;

public class PersistenceFilter implements Filter {

	@Override
	public void init(FilterConfig arg0) throws ServletException {		
		ctx = arg0.getServletContext();
	}
	@Override
	public void destroy() {

	}

	@Override
	public void doFilter(ServletRequest arg0, ServletResponse arg1, FilterChain chain) throws IOException, ServletException {
		WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(ctx);
		EntityManagerBean em = (EntityManagerBean) wac.getBean("entityManager");
		try {
			chain.doFilter(arg0, arg1);
		} finally {
			em.flush();						
		}

	}

	private ServletContext ctx;



}
