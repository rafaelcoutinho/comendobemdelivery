package br.copacabana.usecase.beans;

import java.lang.reflect.Type;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.TimeZone;

import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.Restaurant;
import br.copacabana.spring.RestaurantManager;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class MealOrderSimpleSerializer implements JsonSerializer<MealOrder> {
	// private String pattern = "kk:mm";
	// private SimpleDateFormat df = new SimpleDateFormat(pattern, new
	// Locale("pt", "br"));
	private String patternDay = "dd/MM/yyyy kk:mm";
	private SimpleDateFormat day = new SimpleDateFormat(patternDay, new Locale("pt", "br"));

	public MealOrderSimpleSerializer() {
		super();
		// df.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
	}

	private boolean showRestDetails = false;

	public MealOrderSimpleSerializer(boolean showRestDetails) {
		super();
		// df.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
		this.showRestDetails = showRestDetails;

	}

	@Override
	public JsonElement serialize(MealOrder meal, Type arg1, JsonSerializationContext arg2) {
		day.setTimeZone(TimeZone.getTimeZone("America/Sao_Paulo"));
		JsonObject mj = new JsonObject();
		mj.add("id", new JsonPrimitive(KeyFactory.keyToString(meal.getId())));
		mj.add("idXlated", new JsonPrimitive(meal.getClient().getId().getId() + "." + meal.getId().getId()));

		JsonElement lst = new JsonPrimitive(day.format(meal.getLastStatusUpdateTime()));
		mj.add("lastStatusUpdateTime", lst);

		mj.add("orderedTime", new JsonPrimitive(day.format(meal.getOrderedTime())));
		mj.add("status", new JsonPrimitive(meal.getStatus().name()));

		RestaurantManager restMan = new RestaurantManager();
		Restaurant rest = restMan.find(meal.getRestaurant(), Restaurant.class);
		mj.add("restaurant", new JsonPrimitive(KeyFactory.keyToString(meal.getRestaurant())));
		mj.add("restaurantName", new JsonPrimitive(rest.getName()));
		if (rest.getContact() != null) {
			if (rest.getContact().getPhone() == null) {
				mj.add("restaurantPhone", new JsonPrimitive(""));
			} else {
				mj.add("restaurantPhone", new JsonPrimitive(rest.getContact().getPhone()));
			}

		} else {
			mj.add("restaurantPhone", new JsonPrimitive("-"));
		}

		if (Boolean.TRUE.equals(meal.getRetrieveAtRestaurant())) {
			mj.add("retrieveAtRestaurant", new JsonPrimitive(meal.getRetrieveAtRestaurant()));
		} else {
			mj.add("retrieveAtRestaurant", new JsonPrimitive(false));
		}
		mj.add("paymentType", new JsonPrimitive(meal.getPayment().getType().name()));
		mj.add("paymentTotalValue", new JsonPrimitive(meal.getTotalAmountInCents()));
		mj.add("convenienceTax", new JsonPrimitive(meal.getConvenienceTaxInCents()));
		mj.add("deliveryCost", new JsonPrimitive(meal.getDeliveryCostInCents()));

		if (meal.getDiscountInfo() != null && meal.getDiscountInfo().getValue() != null && meal.getDiscountInfo().getValue() > 0) {
			JsonObject discount = new JsonObject();
			discount.add("value", new JsonPrimitive(meal.getDiscountInfo().getValue()));
			discount.add("code", new JsonPrimitive(meal.getDiscountInfo().getCode()));
			mj.add("discountInfo", discount);
		}

		mj.add("totalAmountInCents", new JsonPrimitive(meal.getTotalAmountInCents()));
		if (meal.getAskForId() != null) {
			mj.add("askForId", new JsonPrimitive(meal.getAskForId()));
		} else {
			mj.add("askForId", new JsonPrimitive("false"));
		}

		if (meal.getPrepareForeCast() != null) {
			mj.add("prepareForeCast", new JsonPrimitive(meal.getPrepareForeCast()));
		}
		if (meal.getDailyCounter() != null) {
			mj.add("dailyCounter", new JsonPrimitive(meal.getDailyCounter()));
		}

		mj.add("tax", new JsonPrimitive(meal.getPayment().getTaxes()));

		if (meal.getOrderType() != null) {
			mj.add("orderType", new JsonPrimitive(meal.getOrderType().name()));
		}

		if (meal.getCpf() != null) {
			mj.add("cpf", new JsonPrimitive(meal.getCpf()));
		} else {
			mj.add("cpf", new JsonNull());
		}

		return mj;
	}

}
