package br.copacabana;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;

import org.datanucleus.sco.backed.ArrayList;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.validation.Errors;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import br.com.copacabana.cb.entities.mgr.FormCommand;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.pe.KeyPropertyEditor;

import com.google.appengine.api.datastore.Key;

/**
 * @author Rafael Coutinho
 */
public class FormController extends SimpleFormController {
	protected static final Logger log = Logger.getLogger("copacabana.Controllers");

	protected Manager manager;

	public void setManager(Manager manager) {
		this.manager = manager;
	}

	// // reestabelecer o form
	// protected Object formBackingObject(HttpServletRequest request) throws
	// Exception {
	// FormCommand cmd = (FormCommand) getCommand(request);
	// if(cmd instanceof SessionCommand){
	// ((SessionCommand)cmd).setSession(request.getSession());
	// }
	// return cmd.getInitialObject(manager);
	//
	//
	// }

	// dados de referencia de form
	protected Map<String, Object> referenceData(HttpServletRequest request, Object command, Errors errors) throws Exception {

		FormCommand cmd = (FormCommand) command;
		Map<String, Object> model = cmd.getReferenceData(request, manager);
		return model;
	}

	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
		try {

			super.initBinder(request, binder);
			binder.registerCustomEditor(Key.class, new KeyPropertyEditor());
			binder.registerCustomEditor(ArrayList.class, new CustomCollectionEditor(List.class, false));
			binder.registerCustomEditor(HashSet.class, new CustomCollectionEditor(Set.class, false));
			binder.registerCustomEditor(Double.class, new CustomNumberEditor(Double.class, false));
			binder.registerCustomEditor(Date.class, new CustomDateEditor(new SimpleDateFormat("yyyy-MM-dd"), true));

		} catch (Throwable e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	@Override
	protected ModelAndView onSubmit(Object object) throws Exception {
		final Map<String, Object> model = new HashMap<String, Object>();
		((Command) object).execute();

		return new ModelAndView(getSuccessView(), model);
	}

	public Manager getManager() {
		return manager;
	}

}