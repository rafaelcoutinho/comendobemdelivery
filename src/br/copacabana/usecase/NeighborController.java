package br.copacabana.usecase;

import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.entities.Neighborhood;
import br.copacabana.JsonPersistController;
import br.copacabana.spring.NeighborhoodManager;

public class NeighborController extends JsonPersistController {
	@Override
	protected ModelAndView onSubmit(Object object) throws Exception {
		try {
			Neighborhood n = (Neighborhood) object;
			NeighborhoodManager nm = (NeighborhoodManager) manager;
			//City c=(City) nm.findObj(n.getCity(), City.class);
			//n.setCity(c);
			nm.persist(n);
			
			return assembleReturn(n.getId(),n);

		} catch (Exception e) {
			throwJsonError(e);
		}
		return null;// never reached
	}
}
