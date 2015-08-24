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
import com.google.gson.JsonParser;

public class UpdateHorariosWithTurns implements Command, SessionCommand {
	private String MONDAY = "";
	private String TUESDAY = "";
	private String WEDNESDAY = "";
	private String THURSDAY = "";
	private String FRIDAY = "";
	private String SATURDAY = "";
	private String SUNDAY = "";
	private String HOLIDAYS = "";

	public static void main(String[] args) {
		String s = "{\"open\":{\"h\":1,\"m\":0},\"close\":{\"h\":13,\"m\":30},\"hasSecondTurn\":true,\"secondTurnStart\":{\"h\":16,\"m\":0},\"secondTurnClose\":{\"h\":5,\"m\":30}}";
		JsonParser jp = new JsonParser();
		JsonObject mon = jp.parse(s).getAsJsonObject();
		WorkingHours wo = new UpdateHorariosWithTurns().getFromJson(mon, DayOfWeek.MONDAY);
		System.out.println(wo.getStartingHour() + ":" + wo.getStartingMinute());
		System.out.println(wo.getClosingHour() + ":" + wo.getClosingMinute());
		System.out.println(wo.getHasSecondTurn());

	}

	WorkingHours getFromJson(JsonObject json, WorkingHours.DayOfWeek day) {
		WorkingHours wo = new WorkingHours(day);
		wo.setStartingHour(json.get("open").getAsJsonObject().get("h").getAsInt());
		wo.setStartingMinute(json.get("open").getAsJsonObject().get("m").getAsInt());
		wo.setClosingHour(json.get("close").getAsJsonObject().get("h").getAsInt());
		wo.setClosingMinute(json.get("close").getAsJsonObject().get("m").getAsInt());
		wo.setClosed(json.get("isClosed").getAsBoolean());

		if (json.get("hasSecondTurn").getAsBoolean()) {
			Integer[] integer = new Integer[4];
			integer[0] = json.get("secondTurnStart").getAsJsonObject().get("h").getAsInt();
			integer[1] = json.get("secondTurnStart").getAsJsonObject().get("m").getAsInt();
			integer[2] = json.get("secondTurnClose").getAsJsonObject().get("h").getAsInt();
			integer[3] = json.get("secondTurnClose").getAsJsonObject().get("m").getAsInt();
			wo.setSecondTurn(integer);
		}
		return wo;

	}

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
		JsonParser jp = new JsonParser();
		if (entityType.equals("restaurant")) {
			try {
				RestaurantManager rman = new RestaurantManager();
				Restaurant r = (Restaurant) rman.get(KeyFactory.stringToKey(id));

				r.setMon(getFromJson(jp.parse(MONDAY).getAsJsonObject(), DayOfWeek.MONDAY));
				r.setTue(getFromJson(jp.parse(TUESDAY).getAsJsonObject(), DayOfWeek.TUESDAY));
				r.setWed(getFromJson(jp.parse(WEDNESDAY).getAsJsonObject(), DayOfWeek.WEDNESDAY));
				r.setThu(getFromJson(jp.parse(THURSDAY).getAsJsonObject(), DayOfWeek.THURSDAY));
				r.setFri(getFromJson(jp.parse(FRIDAY).getAsJsonObject(), DayOfWeek.FRIDAY));
				r.setSat(getFromJson(jp.parse(SATURDAY).getAsJsonObject(), DayOfWeek.SATURDAY));
				r.setSun(getFromJson(jp.parse(SUNDAY).getAsJsonObject(), DayOfWeek.SUNDAY));
				r.setHoli(getFromJson(jp.parse(HOLIDAYS).getAsJsonObject(), DayOfWeek.HOLIDAYS));

				rman.persist(r);
			} catch (java.lang.IllegalStateException e) {
				if (e.getMessage().equals("This is not a JSON Object.")) {
					System.out.println(MONDAY);
					System.out.println(jp.parse(MONDAY));
				}
				throw e;
			}
		}

	}

	private HttpSession session;

	@Override
	public void setSession(HttpSession s) {
		session = s;

	}

	public String getMONDAY() {
		return MONDAY;
	}

	public void setMONDAY(String mONDAY) {
		MONDAY = mONDAY;
	}

	public String getTUESDAY() {
		return TUESDAY;
	}

	public void setTUESDAY(String tUESDAY) {
		TUESDAY = tUESDAY;
	}

	public String getWEDNESDAY() {
		return WEDNESDAY;
	}

	public void setWEDNESDAY(String wEDNESDAY) {
		WEDNESDAY = wEDNESDAY;
	}

	public String getTHURSDAY() {
		return THURSDAY;
	}

	public void setTHURSDAY(String tHURSDAY) {
		THURSDAY = tHURSDAY;
	}

	public String getFRIDAY() {
		return FRIDAY;
	}

	public void setFRIDAY(String fRIDAY) {
		FRIDAY = fRIDAY;
	}

	public String getSATURDAY() {
		return SATURDAY;
	}

	public void setSATURDAY(String sATURDAY) {
		SATURDAY = sATURDAY;
	}

	public String getSUNDAY() {
		return SUNDAY;
	}

	public void setSUNDAY(String sUNDAY) {
		SUNDAY = sUNDAY;
	}

	public String getHOLIDAYS() {
		return HOLIDAYS;
	}

	public void setHOLIDAYS(String hOLIDAYS) {
		HOLIDAYS = hOLIDAYS;
	}

}
