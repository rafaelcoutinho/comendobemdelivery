package br.copacabana.spring.restClient;

import javax.servlet.http.HttpSession;

import br.copacabana.RetrieveCommand;
import br.copacabana.spring.OrderManager;
import br.copacabana.spring.SessionCommand;

public class MonitorRequest extends RetrieveCommand implements SessionCommand {
	String codigo;
	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	@Override
	public void execute() throws Exception {
		OrderManager om = new OrderManager();



	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String id) {
		this.codigo = id;
	}
}
