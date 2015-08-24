package br.copacabana.marshllers;

import java.lang.reflect.Type;

import br.com.copacabana.cb.entities.City;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

public class CityItemDeSerializer implements JsonDeserializer<City> {

	@Override
	public City deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
		
		return null;
	}}
