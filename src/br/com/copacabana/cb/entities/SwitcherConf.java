package br.com.copacabana.cb.entities;

import java.util.Date;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Query;

import br.com.copacabana.cb.entities.WorkingHours.DayOfWeek;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Key;

@Entity
@NamedQueries({ 
	@NamedQuery(name = "getAllSwitcherConf", query = "SELECT n FROM SwitcherConf n order by dayOfWeek,restId,foodCat"),
	@NamedQuery(name = "getRestSwitcherConf", query = "SELECT n FROM SwitcherConf n where n.restId=:restId"),
	@NamedQuery(name = "getRestSwitcherConfByDay", query = "SELECT n FROM SwitcherConf n where n.restId=:restId and dayOfWeek=:dayOfWeek"), 
	@NamedQuery(name = "getRestSwitcherConfByDayAndFoodCat", query = "SELECT n FROM SwitcherConf n where n.restId=:restId and dayOfWeek=:dayOfWeek and n.foodCat=:foodCatId"), 
	@NamedQuery(name = "getSwitcherConfByDay", query = "SELECT n FROM SwitcherConf n where dayOfWeek=:dayOfWeek ") })
public class SwitcherConf {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Long id;
	Key restId;
	Key foodCat;
	PlateStatus toStatus = PlateStatus.AVAILABLE;
	DayOfWeek dayOfWeek = DayOfWeek.MONDAY;
	Date lastRun = new Date(0);

	public SwitcherConf(Key restId, Key foodCat, PlateStatus toStatus, DayOfWeek dayOfWeek) {
		super();
		this.restId = restId;
		this.foodCat = foodCat;
		this.toStatus = toStatus;
		this.dayOfWeek = dayOfWeek;
	}

	public Long getId() {
		return id;
	}

	public Key getRestId() {
		return restId;
	}

	public Key getFoodCat() {
		return foodCat;
	}

	public PlateStatus getToStatus() {
		return toStatus;
	}
	
	public DayOfWeek getDayOfWeek() {
		return dayOfWeek;
	}

	public Date getLastRun() {
		return lastRun;
	}

	public void setLastRun(Date lastRun) {
		this.lastRun = lastRun;
	}
	public static SwitcherConf getConf(Long id) {
		return Datastore.getPersistanceManager().find(SwitcherConf.class, id);
	}

	public static List<SwitcherConf> list() {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getAllSwitcherConf");
		return q.getResultList();
	}

	public static List<SwitcherConf> listConfsByDay(DayOfWeek dayOfWeek) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getSwitcherConfByDay");
		q.setParameter("dayOfWeek", dayOfWeek);
		return q.getResultList();
	}

	public static List<SwitcherConf> listRestConfsByDate(Key restId, DayOfWeek dayOfWeek) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getRestSwitcherConfByDay");
		q.setParameter("restId", restId);
		q.setParameter("dayOfWeek", dayOfWeek);
		return q.getResultList();
	}

	public static SwitcherConf listRestConfsByDate(Key restId, DayOfWeek dayOfWeek, Key foodCatId) {
		Query q = Datastore.getPersistanceManager().createNamedQuery("getRestSwitcherConfByDayAndFoodCat");
		q.setParameter("restId", restId);
		q.setParameter("dayOfWeek", dayOfWeek);
		q.setParameter("foodCatId", foodCatId);
		return (SwitcherConf) q.getSingleResult();
	}
}
