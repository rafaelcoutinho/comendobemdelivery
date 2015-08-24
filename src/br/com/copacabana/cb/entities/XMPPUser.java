package br.com.copacabana.cb.entities;

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
@NamedQueries( { @NamedQuery(name = "getXmppUser", query = "SELECT s FROM XMPPUser s"), 
	@NamedQuery(name = "getXmppUserByIp", query = "SELECT s FROM XMPPUser s where ip=:ip"), 
	@NamedQuery(name = "getXmppUserByStatus", query = "SELECT s FROM XMPPUser s WHERE s.status = :status"),
	@NamedQuery(name = "getXmppUserByUserId", query = "SELECT s FROM XMPPUser s WHERE s.userId = :userId"),
	@NamedQuery(name = "getXmppUserByUserBeanId", query = "SELECT s FROM XMPPUser s WHERE s.associatedUserBeanId = :userBeanId"),
	@NamedQuery(name = "getXmppUserByLastUse", query = "SELECT s FROM XMPPUser s order by lastUse desc"),
	@NamedQuery(name = "getXmppUserSinceLastUse", query = "SELECT s FROM XMPPUser s where s.lastUse>=:date"),
	})
public class XMPPUser {

	public XMPPUser(String userId, String userPassword) {
		super();
		this.userId = userId;
		this.userPassword = userPassword;
	}

	public XMPPUser() {
		super();
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Expose
	private Key id;

	@Expose
	private Key associatedUserBeanId;

	@Expose
	private String ip;

	@Expose
	private String userId;
	@Expose
	private String userPassword;
	@Expose
	private String clientVersion;
	@Expose
	@Temporal(TemporalType.DATE)
	private Date lastUse = new Date();

	@Expose
	@Enumerated(EnumType.STRING)
	private XMPPStatus status = XMPPStatus.OFFLINE;

	public Key getId() {
		return id;
	}

	public void setId(Key id) {
		this.id = id;
	}

	public Key getAssociatedUserBeanId() {
		return associatedUserBeanId;
	}

	public void setAssociatedUserBeanId(Key associatedUserBeanId) {
		this.associatedUserBeanId = associatedUserBeanId;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public Date getLastUse() {
		return lastUse;
	}

	public void setLastUse(Date lastUse) {
		this.lastUse = lastUse;
	}

	public XMPPStatus getStatus() {
		return status;
	}

	public void setStatus(XMPPStatus status) {
		this.status = status;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPassword() {
		return userPassword;
	}

	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}

	public String getClientVersion() {
		return clientVersion;
	}

	public void setClientVersion(String clientVersion) {
		this.clientVersion = clientVersion;
	}

}
