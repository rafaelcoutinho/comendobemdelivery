package br.copacabana.marshllers;

import java.lang.reflect.Type;

import br.com.copacabana.cb.entities.City;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class CityItemSerializer implements JsonSerializer<City> {

	@Override
	public JsonElement serialize(City kw, Type arg1, JsonSerializationContext arg2) {
		if(kw==null ){
			return new JsonNull();
		}
		
		JsonObject jsonObj = new JsonObject();
		jsonObj.add("id", new JsonPrimitive(KeyFactory.keyToString(kw.getId())));
		jsonObj.add("name", new JsonPrimitive(kw.getName()));
		jsonObj.add("state", new JsonPrimitive(kw.getState().getId()));
		
		return jsonObj;
	}

}
