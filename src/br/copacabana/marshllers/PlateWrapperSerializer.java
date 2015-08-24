package br.copacabana.marshllers;

import java.lang.reflect.Type;
import java.util.logging.Level;
import java.util.logging.Logger;

import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.PlateSize;
import br.com.copacabana.cb.entities.PlateStatus;
import br.com.copacabana.cb.entities.TurnType;
import br.copacabana.spring.FoodCategoryManager;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.JsonElement;
import com.google.gson.JsonNull;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonSerializer;

public class PlateWrapperSerializer implements JsonSerializer<Plate> {
	protected static final Logger log = Logger.getLogger("copacabana.Controllers");

	@Override
	public JsonElement serialize(Plate kw, Type arg1, JsonSerializationContext arg2) {
		if (kw == null) {
			return new JsonNull();
		}
		JsonObject jsonObj = new JsonObject();
		try {

			jsonObj.add("id", new JsonPrimitive(KeyFactory.keyToString(kw.getId())));
			jsonObj.add("title", new JsonPrimitive(kw.getTitle()));
			jsonObj.add("description", new JsonPrimitive(kw.getDescription()));
			jsonObj.add("name", new JsonPrimitive(kw.getName()));
			jsonObj.add("price", new JsonPrimitive(Double.valueOf(kw.getPriceInCents()) / 100));
			jsonObj.add("priceInCents", new JsonPrimitive(kw.getPriceInCents()));
			jsonObj.add("status", new JsonPrimitive(kw.getStatus().name()));
			jsonObj.add("isExtension", new JsonPrimitive(kw.isExtension()));
			if (kw.isExtension()) {
				jsonObj.add("extendsPlate", new JsonPrimitive(KeyFactory.keyToString(kw.getExtendsPlate())));
			}
			jsonObj.add("foodCategory", new JsonPrimitive(KeyFactory.keyToString(kw.getFoodCategory())));
			if (kw.getImageUrl() != null) {
				jsonObj.add("imageUrl", new JsonPrimitive(kw.getImageUrl()));
			}
			jsonObj.add("availableTurn", new JsonPrimitive(kw.getAvailableTurn().name()));
			if (!TurnType.ANY.equals(kw.getAvailableTurn())) {
				jsonObj.add("currentTurn", new JsonPrimitive(TimeController.getCurrentTurn().name()));
			}
			if (kw.getPlateSize() != null) {
				jsonObj.add("plateSize", new JsonPrimitive(kw.getPlateSize().name()));
			} else {
				jsonObj.add("plateSize", new JsonPrimitive(PlateSize.NONE.name()));
			}
		} catch (Exception e) {
			jsonObj.add("id", new JsonPrimitive(KeyFactory.keyToString(kw.getId())));
			jsonObj.add("title", new JsonPrimitive(""));
			jsonObj.add("description", new JsonPrimitive(""));
			jsonObj.add("name", new JsonPrimitive(""));
			jsonObj.add("price", new JsonPrimitive(0));
			jsonObj.add("priceInCents", new JsonPrimitive(0));
			jsonObj.add("status", new JsonPrimitive(PlateStatus.HIDDEN.name()));
			jsonObj.add("isExtension", new JsonPrimitive(false));
			jsonObj.add("plateSize", new JsonPrimitive(PlateSize.NONE.name()));
			jsonObj.add("foodCategory", new JsonPrimitive(new FoodCategoryManager().list().get(0).getIdStr()));
			jsonObj.add("availableTurn", new JsonPrimitive(TurnType.ANY.name()));
			log.log(Level.SEVERE, "erro ao converter prato ", e);
		}

		return jsonObj;
	}

}
