package br;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.copacabana.EntityManagerBean;
import br.copacabana.spring.NeighborhoodManager;

public class Test extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
		String results = "";
		String query = "";
		String queryName = "";
		if (request.getParameter("queryName") != null) {
			try {
				queryName = request.getParameter("queryName");

				String[] attr = request.getParameterValues("attributes");
				String[] attrVals = request.getParameterValues("attributesValues");

				ServletContext context = getServletContext();
				WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(context);
				EntityManagerBean manager = (EntityManagerBean) ctx.getBean("entityManager");

				Map<Object, String> m = new HashMap<Object, String>();
				for (int i = 0; i < attrVals.length; i++) {
					m.put(attr[i], attrVals[i]);
				}
				List l = new ArrayList();// jpa.list(queryName, m);
				// List l = jpa.list("getNeighborhood");
				for (Iterator iterator = l.iterator(); iterator.hasNext();) {
					Object object = (Object) iterator.next();

					results += object;
					results += "<br>";
				}
				// createQuery("select from FoodCategory where isMainCategory=true order by name");
				// EntityManager em = manager.getEntityManager();

			} catch (Throwable e) {
				results = e.getMessage();

			}

		} else {
			if (request.getParameter("query") != null) {
				try {
					query = request.getParameter("query");
					String[] attr = request.getParameterValues("attributes");
					ServletContext context = getServletContext();
					WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(context);
					EntityManagerBean manager = (EntityManagerBean) ctx.getBean("entityManager");
					NeighborhoodManager jpa = new NeighborhoodManager();

					List l = jpa.query(query);
					// List l = jpa.list("getNeighborhood");
					for (Iterator iterator = l.iterator(); iterator.hasNext();) {
						Object object = (Object) iterator.next();

						results += object;
						results += "<br>";
					}
					// createQuery("select from FoodCategory where isMainCategory=true order by name");
					// EntityManager em = manager.getEntityManager();

				} catch (Throwable e) {
					results = e.getMessage();

				}
			}
		}
		request.setAttribute("queryName", queryName);
		request.setAttribute("query", query);
		request.setAttribute("results", results);
		ServletContext context = getServletContext();
		RequestDispatcher dispatcher = context.getRequestDispatcher("/admin/QueryTester.jsp");
		dispatcher.forward(request, resp);
	}
}
