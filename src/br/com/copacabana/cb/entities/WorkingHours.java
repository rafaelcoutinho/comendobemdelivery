package br.com.copacabana.cb.entities;

import java.io.Serializable;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

import javax.persistence.Embeddable;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;

import br.copacabana.util.TimeController;

import com.google.gson.annotations.Expose;

@Entity
@Embeddable
public class WorkingHours implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static Map<DayOfWeek, Integer> dayOfWeekCalendarConverter = new HashMap<DayOfWeek, Integer>();
	public static Map<Integer, DayOfWeek> calendarDayOfWeekConverter = new HashMap<Integer, DayOfWeek>();

	static {
		dayOfWeekCalendarConverter.put(DayOfWeek.MONDAY, Calendar.MONDAY);
		dayOfWeekCalendarConverter.put(DayOfWeek.TUESDAY, Calendar.TUESDAY);
		dayOfWeekCalendarConverter.put(DayOfWeek.WEDNESDAY, Calendar.WEDNESDAY);
		dayOfWeekCalendarConverter.put(DayOfWeek.THURSDAY, Calendar.THURSDAY);
		dayOfWeekCalendarConverter.put(DayOfWeek.FRIDAY, Calendar.FRIDAY);
		dayOfWeekCalendarConverter.put(DayOfWeek.SATURDAY, Calendar.SATURDAY);
		dayOfWeekCalendarConverter.put(DayOfWeek.SUNDAY, Calendar.SUNDAY);

		calendarDayOfWeekConverter.put(Calendar.MONDAY, DayOfWeek.MONDAY);
		calendarDayOfWeekConverter.put(Calendar.TUESDAY, DayOfWeek.TUESDAY);
		calendarDayOfWeekConverter.put(Calendar.WEDNESDAY, DayOfWeek.WEDNESDAY);
		calendarDayOfWeekConverter.put(Calendar.THURSDAY, DayOfWeek.THURSDAY);
		calendarDayOfWeekConverter.put(Calendar.FRIDAY, DayOfWeek.FRIDAY);
		calendarDayOfWeekConverter.put(Calendar.SATURDAY, DayOfWeek.SATURDAY);
		calendarDayOfWeekConverter.put(Calendar.SUNDAY, DayOfWeek.SUNDAY);

	}

	public enum DayOfWeek {
		MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY, HOLIDAYS
	};

	// @Id
	// @GeneratedValue(strategy = GenerationType.IDENTITY)
	// private Key id;

	@Expose
	private Integer[] secondTurn = new Integer[] { -1, 0, -1, 0 };
	@Expose
	Boolean closed = false;

	private Calendar getCalendar(int hour, int minute) {
		Calendar cal = Calendar.getInstance();
		cal.setTimeZone(TimeController.getDefaultTimeZone());
		cal.set(Calendar.HOUR_OF_DAY, hour);
		cal.set(Calendar.MINUTE, minute);
		return cal;
	}

	

	
	 
	public boolean isInRange(Calendar now) {
		boolean a = this.checkPeriod(now, startingHour, startingMinute, closingHour, closingMinute);

		if (a == false && this.getHasSecondTurn()) {
			a = this.checkPeriod(now, secondTurn[0], secondTurn[1], secondTurn[2], secondTurn[3]);
		}
		return a;
	}

	public boolean getHasSecondTurn() {
		return secondTurn != null && secondTurn.length > 0 && secondTurn[0] != null && secondTurn[0] != -1;
	}

	private boolean checkPeriod(Calendar now, int hs, int ms, int hc, int mc) {
		Calendar periodo1Start = getCalendar(hs, ms);
		Calendar periodo1Close = getCalendar(hc, mc);

		periodo1Start.set(Calendar.DAY_OF_YEAR, now.get(Calendar.DAY_OF_YEAR));
		periodo1Close.set(Calendar.DAY_OF_YEAR, now.get(Calendar.DAY_OF_YEAR));
		if (hs > hc) {
			periodo1Close.set(Calendar.DAY_OF_YEAR, periodo1Start.get(Calendar.DAY_OF_YEAR) + 1);
		}
		boolean a = now.after(periodo1Start) && now.before(periodo1Close);
		return a;

	}

	@Enumerated(EnumType.STRING)
	@Expose
	private DayOfWeek day = DayOfWeek.MONDAY;
	@Expose
	private Integer startingHour = 11;
	@Expose
	private Integer startingMinute = 00;
	@Expose
	private Integer closingHour = 22;
	@Expose
	private Integer closingMinute = 00;

	private TimeZone timezone = TimeZone.getDefault();
	@Expose
	private String description = "";

	public WorkingHours(DayOfWeek dow) {
		this.day = dow;
	}

	public Integer getClosingHour() {
		return closingHour;
	}

	public Integer getClosingMinute() {
		return closingMinute;
	}

	public DayOfWeek getDay() {
		return day;
	}

	public String getDescription() {
		return description;
	}

	public Integer getStartingHour() {
		return startingHour;
	}

	public Integer getStartingMinute() {
		return startingMinute;
	}

	public TimeZone getTimezone() {
		return timezone;
	}

	public void setClosingHour(Integer closingHour) {
		this.closingHour = closingHour;
	}

	public void setClosingMinute(Integer closintMinute) {
		this.closingMinute = closintMinute;
	}

	protected void setDay(DayOfWeek day) {
		this.day = day;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public void setStartingHour(Integer startingHour) {
		this.startingHour = startingHour;
	}

	public void setStartingMinute(Integer startingMinute) {
		this.startingMinute = startingMinute;
	}

	public void setTimezone(TimeZone timezone) {
		this.timezone = timezone;
	}

	public WorkingHours() {
		// TODO Auto-generated constructor stub
	}

	public Integer[] getSecondTurn() {
		return secondTurn;
	}

	public void setSecondTurn(Integer[] secondTurn) {
		this.secondTurn = secondTurn;
	}





	public boolean isClosed() {
		if(closed==null){
			return false;
		}
		return closed;
	}





	public void setClosed(boolean closed) {
		this.closed = closed;
		if(closed==true){
			this.startingHour=this.closingHour=this.startingMinute=this.closingMinute=0;
		}
	}





	public boolean closesToday() {

		return closed;
	}

}
