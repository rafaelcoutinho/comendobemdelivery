package br.com.copacabana.cb.entities;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;

import com.google.appengine.api.datastore.Text;

@Entity
@NamedQueries({ @NamedQuery(name = "getEmails", query = "SELECT f FROM EmailContent f") })
public class EmailContent {
	@Id
	private String id;
	private String subject;
	private Text msg = new Text("");

	public EmailContent(String id, String msg) {
		super();
		this.id = id;
		this.msg = new Text(msg);
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Text getMsg() {
		return msg;
	}

	public void setMsg(Text msg) {
		this.msg = msg;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

}
