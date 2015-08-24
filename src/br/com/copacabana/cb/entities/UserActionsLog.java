package br.com.copacabana.cb.entities;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.google.appengine.api.datastore.Text;

@Entity
@NamedQueries( { 
	@NamedQuery(name = "listUserActionsLogOrdered", query = "SELECT s FROM UserActionsLog s and s.date>:start and s.date<=:end order by date,sessionId"),
	@NamedQuery(name = "listUserActionsLogBySessionIdByDate", query = "SELECT s FROM UserActionsLog s where s.sessionId=:sessionId and s.date>:start and s.date<=:end order by date,sessionId"),
	@NamedQuery(name = "listUserActionsLogBySessionId", query = "SELECT s FROM UserActionsLog s where s.sessionId=:sessionId "),
	@NamedQuery(name = "listUserActionsUntil", query = "SELECT s FROM UserActionsLog s where s.date<=:date "),
	@NamedQuery(name = "listUserActionsLogByUser", query = "SELECT s FROM UserActionsLog s where s.user=:userKey and s.date>:start and s.date<=:end order by date,sessionId"),
})

public class UserActionsLog {
	public UserActionsLog(String action, String state, String user, String allInfo, String sessionId, String kind) {
		super();
		this.action = action;
		this.state = state;
		this.allInfo = new Text(allInfo);
		this.sessionId = sessionId;
		this.user = user;
		this.kind = kind;
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String sessionId;
	private String action;
	private String state;
	private String user;
	private String kind;
	private Text allInfo;
	@Temporal(TemporalType.DATE)
	private Date date = new Date();

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getSessionId() {
		return sessionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Text getAllInfo() {
		return allInfo;
	}

	public void setAllInfo(Text allInfo) {
		this.allInfo = allInfo;
	}

	public String getUser() {
		return user;
	}

	public void setUser(String user) {
		this.user = user;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

}
