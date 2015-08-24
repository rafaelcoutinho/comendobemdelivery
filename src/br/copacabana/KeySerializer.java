package br.copacabana;

import java.lang.reflect.Type;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonElement;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class KeySerializer implements JsonSerializer<Key> {

	public KeySerializer() {

	}

	public JsonElement serialize(Key src, Type typeOfSrc, JsonSerializationContext context) {

		JsonElement json = new JsonPrimitive(KeyFactory.keyToString(src));
		return json;
	}

}
