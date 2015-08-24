package br.copacabana;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Logger;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.SessionCommand;

public class SendContact implements Command, SessionCommand {
	private String name;
	private String email;
	private String msg;
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
		String toEmail = "rafael.coutinho@gmail.com";
		if (confEmail != null) {
			toEmail = confEmail.getValue();
		}
		String msgHeader = createMsgHeader();
		String subject = "ComendoBem: Mensagem postado no fale conosco por " + name;
		ms.sendEmail(toEmail, "Fale com ComendoBem", email, name, toEmail, "Admin ComendoBem", subject, msgHeader + msg);
		
		log.info("SendContact email was successfully sent");
		//TODO should we store user email?
//		if (Authentication.isUserLoggedIn(session) == false) {
//			NewsletterManager nman = new NewsletterManager();
//			if (nman.get(email) == null) {
//				nman.createNewsletterUser(email, name);
//			}
//		}
	}

	private String createMsgHeader() {
		StringBuilder header = new StringBuilder();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm");
		header.append("--------------");
		header.append("Data ");
		header.append(sdf.format(new Date()));
		header.append("\n");
		if (Authentication.isUserLoggedIn(session)) {
			header.append("Usuario logado:\n");
			try {
				header.append(Authentication.getLoggedUser(session).toString());
				header.append("\n");
			} catch (JsonException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			header.append("Usuario nao estava logado\n");
		}
		header.append("Nome: ");
		header.append(name);
		header.append("\n");
		header.append("E-mail: ");
		header.append(email);
		header.append("\n");
		header.append("--------------");
		header.append("\n");
		return header.toString();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

}
