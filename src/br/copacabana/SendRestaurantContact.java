package br.copacabana;

import java.util.logging.Logger;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.app.Configuration;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.SessionCommand;

public class SendRestaurantContact implements Command, SessionCommand {
	private String name;
	private String email;
	private String phone;
	private String contactName;

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

		String msg = "Nome Restaurante:" + name + "\nEmail:" + email + "\nPhone:" + phone + "\nNome contato:" + contactName;
		String subject = "ComendoBem: Contato de restaurante";
		ms.sendEmail(toEmail, "Fale com ComendoBem", email, name, toEmail, "Admin ComendoBem", subject, msg);
		log.info("SendContact email was successfully sent");
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

	@Override
	public void setSession(HttpSession s) {
		this.session = s;

	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getContactName() {
		return contactName;
	}

	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

}
