package br.copacabana;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;
import br.copacabana.spring.SessionCommand;
import br.copacabana.spring.UserBeanManager;

public class PasswordReminder implements Command, SessionCommand {
	private String email;
	private HttpSession session;
	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		MailSender ms = new MailSender();
		ConfigurationManager cm = new ConfigurationManager();
		Configuration confEmail = cm.find("contactEmail", Configuration.class);
		String replyTo = "contato@comendobem.com.br";
		if (confEmail != null) {
			replyTo = confEmail.getValue();
		}
		UserBeanManager ub = new UserBeanManager();
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("login", email);
		List<UserBean> ubl = ub.list("getUserByLogin", m);
		if (ubl.isEmpty()) {
			throw new JsonException("No user found.", ErrorCode.USERNOTFOUND);
		}
		UserBean user = ubl.get(0);
		String subject = "ComendoBem: Lembrete de senha";
		String msg = "Olá,<br> você solicitou sua senha no site <a href=\"www.comendobem.com.br\">ComendoBem</a>. <br>Sua senha é: '" + user.getPassword() + "'<br><br>Atenciosamente, <br>Equipe ComendoBem";		
		ms.sendEmail(replyTo, "Lembrete de senha", replyTo, "Lembrete de Senha", email, "", subject, msg);
		log.log(Level.INFO, "pwd reminder email was successfully sent");
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

}
