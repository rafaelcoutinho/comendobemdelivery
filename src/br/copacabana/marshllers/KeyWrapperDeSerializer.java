package br.copacabana.marshllers;

import java.lang.reflect.Type;

import br.com.copacabana.cb.KeyWrapper;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

public class KeyWrapperDeSerializer implements JsonDeserializer<KeyWrapper> {

	@Override
	public KeyWrapper deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
		KeyWrapper kw = new KeyWrapper();
		
		kw.setK(KeyFactory.stringToKey(json.getAsJsonObject().get("k").getAsString()));
		return kw;
	}}
