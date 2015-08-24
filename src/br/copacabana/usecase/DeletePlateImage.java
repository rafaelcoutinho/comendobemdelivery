package br.copacabana.usecase;

import java.io.IOException;

import javax.cache.Cache;
import javax.persistence.EntityManager;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.Picture;
import br.com.copacabana.cb.entities.Plate;
import br.copacabana.Authentication;
import br.copacabana.CacheController;
import br.copacabana.JsonViewItemFileReadStoreController;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.PlateManager;

import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

public class DeletePlateImage extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse res) throws ServletException, IOException {
		try {
			Key k = Authentication.getLoggedUserKey(request.getSession());
			if (k.getKind().equalsIgnoreCase("Restaurant")) {
				Key pid = KeyFactory.stringToKey(request.getParameter("pid"));
				ServletContext context = getServletContext();
				WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
				PlateManager rman = (PlateManager) applicationContext.getBean("plateManager");
				EntityManager em = rman.getEntityManagerBean().getEntityManager();
				Plate p = rman.find(pid, Plate.class);
				if (p.getImageKey() != null) {
					em.remove(em.find(Picture.class, p.getImageKey()));
				}
				p.setImageUrl(null);
				p.setImageKey(null);
				rman.update(p);
				Cache cache = CacheController.getCache();

				JsonViewItemFileReadStoreController.invalidateCacheValue("listRestaurantPlatesFast", KeyFactory.keyToString(p.getRestaurant().getId()));
				res.getWriter().print("{status:'ok'}");

			} else {
				JsonException exception = new JsonException("Must have a logged in restaurant");
				throw exception;
			}

		} catch (br.copacabana.spring.JsonException e) {
			e.printStackTrace();
			request.setAttribute("exception", e);
			throw new ServletException(e);
		} catch (Exception e) {
			log(e.getMessage());
			e.printStackTrace();
			JsonException exception = new JsonException(e.getMessage());
			request.setAttribute("exception", exception);
			throw new ServletException(exception);
		}

	}
}
