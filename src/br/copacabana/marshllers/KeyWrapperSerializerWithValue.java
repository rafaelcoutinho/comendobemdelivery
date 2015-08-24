package br.copacabana.marshllers;

import java.lang.reflect.Type;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.mgr.JPAManager;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class KeyWrapperSerializerWithValue implements JsonSerializer<KeyWrapper> {
	private JPAManager man;
	public KeyWrapperSerializerWithValue(JPAManager man){
		this.man=man;
	}
	@Override
	public JsonElement serialize(KeyWrapper kw, Type arg1, JsonSerializationContext arg2) {
		if(kw==null || kw.getK()==null){
			return new JsonNull();
		}
		if(kw.getValue()==null){
			man.find(kw, kw.getK().getClass());
		}
		return new JsonPrimitive(KeyFactory.keyToString(kw.getK()));
	}

}
