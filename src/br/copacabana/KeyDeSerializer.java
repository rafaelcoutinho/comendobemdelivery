package br.copacabana;

import java.lang.reflect.Type;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

public class KeyDeSerializer implements JsonDeserializer<Key> {

	public KeyDeSerializer() {

	}

	public Key deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
		return KeyFactory.stringToKey(json.getAsString());
	}

}
