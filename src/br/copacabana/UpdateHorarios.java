package br.copacabana;

import javax.servlet.http.HttpSession;

import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.UserBean;
import br.com.copacabana.cb.entities.WorkingHours;
import br.com.copacabana.cb.entities.WorkingHours.DayOfWeek;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.spring.SessionCommand;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonObject;

public class UpdateHorarios implements Command, SessionCommand {
	private WorkingHours fri = new WorkingHours(DayOfWeek.FRIDAY);
	private WorkingHours holi = new WorkingHours(DayOfWeek.HOLIDAYS);
	private WorkingHours mon = new WorkingHours(DayOfWeek.MONDAY);
	private WorkingHours sun = new WorkingHours(DayOfWeek.SUNDAY);
	private WorkingHours sat = new WorkingHours(DayOfWeek.SATURDAY);
	private WorkingHours tue = new WorkingHours(DayOfWeek.TUESDAY);
	private WorkingHours thu = new WorkingHours(DayOfWeek.THURSDAY);
	private WorkingHours wed = new WorkingHours(DayOfWeek.WEDNESDAY);

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		JsonObject loggedUser = Authentication.getLoggedUser(session);
		String id = ((JsonObject) loggedUser.get("entity")).get("id").getAsString();
		String entityType = loggedUser.get("userType").getAsString();
		UserBean currentUser;
		if (entityType.equals("restaurant")) {
			RestaurantManager rman = new RestaurantManager();
			Restaurant r = (Restaurant) rman.get(KeyFactory.stringToKey(id));

			r.setFri(fri);
			r.setHoli(holi);
			r.setSat(sat);
			r.setSun(sun);
			r.setMon(mon);
			r.setTue(tue);
			r.setThu(thu);
			r.setWed(wed);
			rman.persist(r);
		}

	}

	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	public WorkingHours getFri() {
		return fri;
	}

	public void setFri(WorkingHours fri) {
		this.fri = fri;
	}

	public WorkingHours getHoli() {
		return holi;
	}

	public void setHoli(WorkingHours holi) {
		this.holi = holi;
	}

	public WorkingHours getMon() {
		return mon;
	}

	public void setMon(WorkingHours mon) {
		this.mon = mon;
	}

	public WorkingHours getSun() {
		return sun;
	}

	public void setSun(WorkingHours sun) {
		this.sun = sun;
	}

	public WorkingHours getSat() {
		return sat;
	}

	public void setSat(WorkingHours sat) {
		this.sat = sat;
	}

	public WorkingHours getTue() {
		return tue;
	}

	public void setTue(WorkingHours tue) {
		this.tue = tue;
	}

	public WorkingHours getThu() {
		return thu;
	}

	public void setThu(WorkingHours thu) {
		this.thu = thu;
	}

	public WorkingHours getWed() {
		return wed;
	}

	public void setWed(WorkingHours wed) {
		this.wed = wed;
	}
}
