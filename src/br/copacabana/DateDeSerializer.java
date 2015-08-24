package br.copacabana;

import java.lang.reflect.Type;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

public class DateDeSerializer implements JsonDeserializer<Date> {
	private HttpServletRequest request;

	public DateDeSerializer(HttpServletRequest req) {
		request = req;
	}

	public Date deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
		DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT, request.getLocale());

		try {
			return df.parse(json.getAsString());
		} catch (ParseException e) {

			e.printStackTrace();
			return null;
		}
	}

}
