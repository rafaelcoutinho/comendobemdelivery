package br.copacabana.util;

import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

import br.com.copacabana.cb.entities.TurnType;
import br.com.copacabana.cb.entities.WorkingHours;
import br.com.copacabana.cb.entities.WorkingHours.DayOfWeek;

public class TimeController {
	protected static final Locale brazil = new Locale("pt", "br");

	public static TimeZone getDefaultTimeZone() {
		return TimeZone.getTimeZone("America/Sao_Paulo");
	}

	public static Locale getDefaultLocale() {
		return brazil;
	}

	public static Date getTodayMidnight() {
		Calendar cal = Calendar.getInstance(TimeController.getDefaultTimeZone());		
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);

		return cal.getTime();
	}
	

	public static DayOfWeek getTodaysDayOfWeek() {
		Calendar now = java.util.Calendar.getInstance(getDefaultTimeZone(), getDefaultLocale());
		int dayOfWeek = now.get(Calendar.DAY_OF_WEEK);
		DayOfWeek dow = WorkingHours.calendarDayOfWeekConverter.get(dayOfWeek);
		return dow;
	}

	public static TurnType getCurrentTurn() {
		int hour = Calendar.getInstance(getDefaultTimeZone()).get(Calendar.HOUR_OF_DAY);
		if (hour < 17 && hour > 4) {
			return TurnType.LUNCH;
		} else {
			return TurnType.DINNER;
		}
	}

	public static DayOfWeek getDayOfWeek() {
		Calendar now = java.util.Calendar.getInstance(getDefaultTimeZone(), new Locale("pt", "br"));
		int dayOfWeek = now.get(Calendar.DAY_OF_WEEK);
		DayOfWeek dow = WorkingHours.calendarDayOfWeekConverter.get(dayOfWeek);
		return dow;
	}

	public static void main(String[] args) {
		System.out.println(getTodayMidnight());
	}

	public static Calendar getDefaultCalendar() {
		Calendar c = Calendar.getInstance();
		c.setTimeZone(getDefaultTimeZone());
		return c;
	}
}
