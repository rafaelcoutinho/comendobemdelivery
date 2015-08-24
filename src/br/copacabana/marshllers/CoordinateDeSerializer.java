package br.copacabana.marshllers;

import java.lang.reflect.Type;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

public class CoordinateDeSerializer implements JsonDeserializer<Float> {

	@Override
	public Float deserialize(JsonElement json, Type type, JsonDeserializationContext ctx) throws JsonParseException {
		System.out.println("aa"+json);

		return 0.0f;
	}

}
