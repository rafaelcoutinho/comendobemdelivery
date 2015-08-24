package br.com.copacabana.cb.entities.mgr;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import br.copacabana.Command;

public interface FormCommand extends Command {

	Object getInitialObject(Manager manager);

	Map<String, Object> getReferenceData(HttpServletRequest request, Manager manager);

}
