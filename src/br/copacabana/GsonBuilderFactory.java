package br.copacabana;

import br.com.copacabana.cb.entities.MealOrder;

import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class GsonBuilderFactory {

	public static GsonBuilder getInstance() {
		GsonBuilder gsonBuilder = new GsonBuilder().serializeNulls().excludeFieldsWithoutExposeAnnotation();		
		return gsonBuilder;
	}

	public static String escapeString(String json) {
		return json.replace('\n', ' ');
	}

	public static void main(String[] args) {
		GsonBuilder gb=GsonBuilderFactory.getInstance();
		MealOrder o = new MealOrder();
		o.setObservation("asfd s\" asfd");
		System.out.println(gb.create().toJson(o));
		JsonObject jsonObj = new JsonObject();
		jsonObj.add("quotes", new JsonPrimitive("this is a double quote:'\"'"));
		jsonObj. addProperty("quotes2","this is a double quote:'\"'");
		System.out.println(jsonObj.toString());
	}
}
