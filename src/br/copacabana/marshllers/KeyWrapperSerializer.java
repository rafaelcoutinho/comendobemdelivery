package br.copacabana.marshllers;

import java.lang.reflect.Type;

import br.com.copacabana.cb.KeyWrapper;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class KeyWrapperSerializer implements JsonSerializer<KeyWrapper> {

	@Override
	public JsonElement serialize(KeyWrapper kw, Type arg1, JsonSerializationContext arg2) {
		if(kw==null || kw.getK()==null){
			return new JsonNull();
		}
		return new JsonPrimitive(KeyFactory.keyToString(kw.getK()));
	}

}
