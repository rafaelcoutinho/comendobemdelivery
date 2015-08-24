package br.copacabana;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.mvc.BaseCommandController;

import br.com.copacabana.cb.entities.mgr.Manager;

/**
 * This implements a simple view controller with a viewName (to where the user
 * will be forwarded) and alternativeViewName in case of exceptions. It also
 * sets all facebook parameters into the any commands that implements the
 * FBParametable interface
 * 
 * @author Rafael Coutinho
 */
public abstract class SimpleViewController extends BaseCommandController {
	protected String viewName;
	protected String alternateViewName;
	public static final String MODEL_NAME = "entity";
	public static final String MODE = "mode";

	/** @return the viewName */
	public String getViewName() {
		return viewName;
	}

	/**
	 * @param viewName
	 *            the viewName to set
	 */
	public void setViewName(String viewName) {
		this.viewName = viewName;
	}

	/**
	 * @return the alternateViewName
	 */
	public String getAlternateViewName() {
		return alternateViewName;
	}

	/**
	 * @param alternateViewName
	 *            the alternateViewName to set
	 */
	public void setAlternateViewName(String alternateViewName) {
		this.alternateViewName = alternateViewName;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.springframework.web.servlet.mvc.BaseCommandController#getCommand(
	 * javax.servlet.http.HttpServletRequest)
	 */
	@Override
	protected Object getCommand(HttpServletRequest request) throws Exception {
		Object obj = super.getCommand(request);

		bindAndValidate(request, obj);

		return obj;
	}

	protected Manager manager;

	/**
	 * @param expertManager
	 *            the expertManager to set
	 */
	public void setManager(Manager manager) {
		this.manager = manager;
	}

}
