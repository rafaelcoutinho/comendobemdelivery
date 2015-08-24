package br.copacabana.marshllers;

import java.lang.reflect.Type;

import br.com.copacabana.cb.entities.Neighborhood;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class NeighItemSerializer implements JsonSerializer<Neighborhood> {

	@Override
	public JsonElement serialize(Neighborhood kw, Type arg1, JsonSerializationContext arg2) {
		if(kw==null ){
			return new JsonNull();
		}
		
		JsonObject jsonObj = new JsonObject();
		jsonObj.add("id", new JsonPrimitive(KeyFactory.keyToString(kw.getId())));
		jsonObj.add("name", new JsonPrimitive(kw.getName()));
		jsonObj.add("zip", new JsonPrimitive(kw.getZip()));
		jsonObj.add("city", new JsonPrimitive(KeyFactory.keyToString(kw.getCity().getId())));
		
		
		return jsonObj;
	}

}
