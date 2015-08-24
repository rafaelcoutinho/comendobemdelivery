package br.copacabana.marshllers;

import java.lang.reflect.Type;
import java.util.Iterator;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.spring.central.RestaurantMonitorBean;
import br.copacabana.usecase.beans.MealOrderSimpleSerializer;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class RestaurantMonitorBeanSerializer implements JsonSerializer<RestaurantMonitorBean> {
	Manager man;
	public RestaurantMonitorBeanSerializer(Manager man) {
		super();
		// df.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
		this.man = man;
		
	}

	@Override
	public JsonElement serialize(RestaurantMonitorBean restBean, Type arg1, JsonSerializationContext arg2) {
		MealOrderSimpleSerializer mos = new MealOrderSimpleSerializer();
		JsonObject mj = new JsonObject();
		mj.add("restaurantKey", new JsonPrimitive(KeyFactory.keyToString(restBean.getRestaurant().getId())));
		JsonObject newOrders = new JsonObject();
		JsonArray newOrdersArray = new JsonArray();
		for (Iterator iterator = restBean.getNewOrders().iterator(); iterator.hasNext();) {
			MealOrder mo = (MealOrder) iterator.next();
			newOrdersArray.add(mos.serialize(mo, null, null));			
		}
		mj.add("newOrders", newOrdersArray);
		
		JsonArray onGoingOrders = new JsonArray();
		for (Iterator iterator = restBean.getOnGoingOrders().iterator(); iterator.hasNext();) {
			MealOrder mo = (MealOrder) iterator.next();
			onGoingOrders.add(mos.serialize(mo, null, null));			
		}
		mj.add("onGoingOrders", onGoingOrders);

		return mj;
	}

}
