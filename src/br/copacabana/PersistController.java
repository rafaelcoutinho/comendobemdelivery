package br.copacabana;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;

import org.springframework.validation.Errors;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import br.com.copacabana.cb.entities.mgr.Manager;

import com.google.gson.Gson;

/**
 * @author Rafael Coutinho
 */
public class PersistController extends SimpleFormController {
    protected static final Logger log = Logger.getLogger("copacabana.Controllers");

	protected String classname;

	public String getClassname() {
		return classname;
	}

	public void setClassname(String classname) {
		this.classname = classname;
	}

	protected Manager manager;

	public void setManager(Manager manager) {
		this.manager = manager;
	}

	// reestabelecer o form
	protected Object formBackingObject(HttpServletRequest request) throws Exception {

		return new Gson();

	}

	// dados de referencia de form
	protected Map<String, Object> referenceData(HttpServletRequest request, Object command, Errors errors) throws Exception {
		final Map<String, Object> model = new HashMap<String, Object>();
		Long entityId = ServletRequestUtils.getLongParameter(request, "id", -1);

		log.log(Level.INFO,"setting referenceData");
		RetrieveCommand retrieveCommand = new RetrieveCommand();
		retrieveCommand.setId(entityId);
		retrieveCommand.execute(manager);
		Object obj = retrieveCommand.getEntity();
		model.put("entity", obj);

		model.put("mode", "edit");

		// model.put("changePwd", "false");

		return model;
	}

	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
		try {
			
			super.initBinder(request, binder);
			// binder.registerCustomEditor(State.class, new
			// StatePropertyEditor(manager));
			// binder.registerCustomEditor(City.class, new
			// CityPropertyEditor(manager));

		} catch (Throwable e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}

	@Override
	protected ModelAndView onSubmit(Object object) throws Exception {

		
		PersistCommand persistCommand = new PersistCommand(object);
		persistCommand.execute(manager);

		Map<String, Object> model = new HashMap<String, Object>();

		model.put("id", persistCommand.getId());
		model.put("mode", "view");
		
		return new ModelAndView(getSuccessView(), model);
	}

}