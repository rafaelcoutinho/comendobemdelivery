package br.copacabana.tasks;

import java.io.IOException;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Logger;

import javax.cache.CacheStatistics;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.PlateStatus;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.SwitcherConf;
import br.copacabana.CacheController;
import br.copacabana.spring.FoodCategoryManager;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.RestaurantManager;

public class SwitchCategories extends HttpServlet {
	protected static final Logger log = Logger.getLogger("copacabana.Servlet");

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		SwitcherConf conf = SwitcherConf.getConf(Long.parseLong(req.getParameter("id")));
		RestaurantManager rm = new RestaurantManager();
		
		Restaurant r = rm.get(conf.getRestId());
		
		FoodCategoryManager fman = new FoodCategoryManager();
		FoodCategory foodCat = fman.get(conf.getFoodCat());

		PlateStatus status = conf.getToStatus();
		log.info("Setting plates of " + foodCat.getName() + " to " + status.name());
		PlateManager pm = new PlateManager();
		List<Plate> plates = pm.listPlatesByCat(r, foodCat);
		for (Iterator iterator = plates.iterator(); iterator.hasNext();) {
			Plate plate = (Plate) iterator.next();
			plate.setStatus(status);
		}
		conf.setLastRun(new Date());
		log.info("done for " + plates.size());
		CacheStatistics cs =  CacheController.getCache().getCacheStatistics();
		
		CacheController.clear();

	}
}
