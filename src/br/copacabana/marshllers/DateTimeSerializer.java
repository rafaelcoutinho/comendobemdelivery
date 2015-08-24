package br.copacabana.marshllers;

import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import br.copacabana.util.TimeController;

import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class DateTimeSerializer implements JsonSerializer<Date> {
	private String patternDay = "dd/MM/yyyy kk:mm";
	private SimpleDateFormat day = new SimpleDateFormat(patternDay, new Locale("pt", "br"));
	public DateTimeSerializer() {
		day.setTimeZone(TimeController.getDefaultTimeZone());
	}

	public JsonElement serialize(Date src, Type typeOfSrc, JsonSerializationContext context) {		
		JsonElement json = new JsonPrimitive(day.format(src));
		return json;
	}

}
