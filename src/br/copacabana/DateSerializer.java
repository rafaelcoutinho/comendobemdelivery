package br.copacabana;

import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;


public class DateSerializer implements JsonSerializer<Date> {
	private HttpServletRequest request;
	private SimpleDateFormat df; 
	public DateSerializer(HttpServletRequest req){
		request=req;
		df=new SimpleDateFormat("dd/MM/yyyy");
	}
	public JsonElement serialize(Date src, Type typeOfSrc, JsonSerializationContext context) {
		
		
		JsonElement json = new JsonPrimitive(df.format(src));				
		return json;
	}		

}
