package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.google.appengine.api.datastore.Key;
import com.google.gson.annotations.Expose;

@Entity
@NamedQueries( { @NamedQuery(name = "getWarnMessage", query = "SELECT s FROM WarnMessage s"), 
	@NamedQuery(name = "getWarnMessageByUser", query = "SELECT s FROM WarnMessage s WHERE s.userBean = :userBean and read=false"),
	@NamedQuery(name = "getConfEmailWarnMessageByUser", query = "SELECT s FROM WarnMessage s WHERE s.userBean = :userBean and msgType='CONFIRM_EMAIL' and read=false")
	
})
public class WarnMessage implements Serializable {
	public WarnMessage(String msg, MessageType msgType, Key userBean) {
		super();
		this.msg = msg;
		this.msgType = msgType;
		this.userBean = userBean;
	}
	public enum MessageType {
		CONFIRM, WARN, NORMAL,ACCEPT_TERMS, CONFIRM_EMAIL
	};

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Long id;

	private String msg = "";
	@Temporal(TemporalType.DATE)
	private Date lastChange = new Date();
	@Enumerated(EnumType.STRING)
	private MessageType msgType = MessageType.NORMAL;
	private Key userBean = null;
	private Boolean read = false;
	
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public MessageType getMsgType() {
		return msgType;
	}
	public void setMsgType(MessageType msgType) {
		this.msgType = msgType;
	}
	public Key getUserBean() {
		return userBean;
	}
	public void setUserBean(Key userBean) {
		this.userBean = userBean;
	}
	public Boolean getRead() {
		return read;
	}
	public void setRead(Boolean read) {
		this.lastChange=new Date();
		this.read = read;
	}
	public Date getLastChange() {
		return lastChange;
	}
	public void setLastChange(Date lastChange) {
		this.lastChange = lastChange;
	}

}
