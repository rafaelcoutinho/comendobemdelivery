package br.copacabana;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;

import javax.cache.Cache;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.OrderedPlate;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.Restaurant;
import br.com.copacabana.cb.entities.TurnType;
import br.com.copacabana.cb.entities.WorkingHours.DayOfWeek;
import br.copacabana.order.paypal.PayPalProperties.PayPalConfKeys;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.PlateManager;
import br.copacabana.spring.RestaurantManager;
import br.copacabana.usecase.control.UserActionManager;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;

/**
 * @author Rafael Coutinho
 */
public class PlaceOrderController extends JsonViewController {
	private String formView;
	private String successView;

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("mode", "view");
		try {
			Cache cache = CacheController.getCache();
			if (cache.get(PayPalConfKeys.pppFixedRate.name()) == null) {
				ConfigurationManager cm = new ConfigurationManager();
				cache.put(PayPalConfKeys.pppFixedRate.name(), cm.getConfigurationValue(PayPalConfKeys.pppFixedRate.name()));
				cache.put(PayPalConfKeys.pppPercentageValue.name(), cm.getConfigurationValue(PayPalConfKeys.pppPercentageValue.name()));
			}
			if (!Authentication.isUserLoggedIn(request.getSession())) {
				String orderData = request.getParameter("orderData");
				request.getSession().setAttribute("orderData", orderData);
				model.put("forwardUrl", "/continueOrder.jsp");
				UserActionManager.startOrderNotLogged(orderData, request.getSession().getId());
				return new ModelAndView(getFormView(), model);
			} else {
				String orderData = "";
				JsonObject user = Authentication.getLoggedUser(request.getSession());
				String loggedUserId = user.get("entity").getAsJsonObject().get("id").getAsString();

				if (request.getParameter("orderData") == null) {
					orderData = (String) request.getSession().getAttribute("orderData");

				} else {
					orderData = request.getParameter("orderData");
				}

				log.log(Level.INFO, "OrderJSon: {0}", orderData);
				JsonParser pa = new JsonParser();
				JsonObject orderDataJson = (JsonObject) pa.parse(orderData);

				ClientManager cman = new ClientManager();
				Client c = cman.find(KeyFactory.stringToKey(loggedUserId), Client.class);

				MealOrder mo = getMealOrder(c, orderDataJson);
				request.getSession().setAttribute("clientPhone", "");

				DateSerializer dateSerializer = new DateSerializer(request);
				DateDeSerializer dateDeSerializer = new DateDeSerializer(request);
				GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();// new
				// GsonBuilder().setPrettyPrinting().serializeNulls().excludeFieldsWithoutExposeAnnotation();
				gsonBuilder.registerTypeAdapter(Date.class, dateSerializer);
				gsonBuilder.registerTypeAdapter(Date.class, dateDeSerializer);
				gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
				gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());

				Gson gson = gsonBuilder.create();
				model.putAll(updateModelData(mo, c, gson));

				String json = gson.toJson(mo); // Or use new
				json = GsonBuilderFactory.escapeString(json);

				request.getSession().setAttribute("orderData", json);
				UserActionManager.startOrder(json, loggedUserId, request.getSession().getId());
				return new ModelAndView(getSuccessView(), model);
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Failed to place order.");
			try {
				String orderData = "";
				log.log(Level.SEVERE, "Checking logged user.");
				JsonObject user = Authentication.getLoggedUser(request.getSession());
				if (user == null) {
					log.log(Level.SEVERE, "user is not logged in.");
				}
				String loggedUserId = user.get("entity").getAsJsonObject().get("id").getAsString();
				log.log(Level.SEVERE, "logged user id {0}", loggedUserId);

				if (request.getParameter("orderData") == null) {
					log.log(Level.SEVERE, "Order is not in request, checking session");
					orderData = (String) request.getSession().getAttribute("orderData");
				} else {
					log.log(Level.SEVERE, "Order is in request");
					orderData = request.getParameter("orderData");
				}
				if (orderData == null) {
					log.log(Level.SEVERE, "Order was null!");
				}
				log.log(Level.SEVERE, "Order is order  :" + orderData);
				log.log(Level.SEVERE, "Exception was {0}.", e);
				log.log(Level.SEVERE, "Error was {0}.", e.getMessage());

				UserActionManager.registerMajorError(request, e, loggedUserId, request.getSession().getId(), "placing order");

			} catch (Exception ex) {
				log.log(Level.SEVERE, "Failed during loggin of error was {0}.", e);
				UserActionManager.registerMajorError(request, e, "placing order 2");
			}
			throw e;
		}
	}

	public static Map<String, Object> updateModelData(MealOrder mo, Client c, Gson gson) {
		Map<String, Object> model = new HashMap<String, Object>();
		RestaurantManager rman = new RestaurantManager();
		Restaurant r = rman.getRestaurant(mo.getRestaurant());
		Boolean b = r.getOnlyForRetrieval();
		if (b != null && true == b) {
			model.put("onlyForRetrieval", Boolean.TRUE);
		} else {
			model.put("onlyForRetrieval", Boolean.FALSE);
		}
		model.put("restaurantAddressKey", KeyFactory.keyToString(r.getAddress()));
		model.put("clientCpf", c.getCpf());
		model.put("level", c.getLevel().ordinal());
		JsonObject json = new JsonObject();
		ConfigurationManager cm = new ConfigurationManager();
		String hasSpecificLogic = cm.getConfigurationValue("hasSpecificLogic");
		model.put("noTakeAwayOrders", "false");
		if (hasSpecificLogic != null && hasSpecificLogic.endsWith("true")) {
			json = getSteakHouseSpecificData(mo, c, gson);
			getMakisSpecificLogic(mo, c, gson, json);
			getPapagaiosSpecificLogic(mo, c, gson, json);
			getPizzadoroSpecificLogic(mo,c,gson,json);

			if (noTakeAwayOrders(mo) == true) {
				model.put("noTakeAwayOrders", "true");
			}
		}
		model.put("hasSpecificLogic", json.toString());
		if (json.get("javascript") != null && json.get("javascript").getAsString().length() > 0) {
			model.put("hasSpecificLogicJavascript", json.get("javascript").getAsString());
		}

		Address restAddress = new AddressManager().getAddress(r.getAddress());
		model.put("restaurantAddress", gson.toJson(restAddress));

		return model;
	}

	private static boolean noTakeAwayOrders(MealOrder mo) {
		ConfigurationManager cm = new ConfigurationManager();
		String ids = cm.getConfigurationValue("no.takeaway.ids");
		String restId = KeyFactory.keyToString(mo.getRestaurant());
		if (ids.contains(restId)) {
			return true;
		}

		return false;
	}

	private static void getPapagaiosSpecificLogic(MealOrder mo, Client c, Gson gson, JsonObject json) {
		ConfigurationManager cm = new ConfigurationManager();
		String idStr = cm.getConfigurationValue("papagaios.id");
		if (idStr != null && idStr.length() > 0) {
			Key k = KeyFactory.stringToKey(idStr);
			if (k.equals(mo.getRestaurant())) {
				json.add("javascript", new JsonPrimitive("/scripts/custom/papagaios.js"));

			}
		}

	}
	private static void getPizzadoroSpecificLogic(MealOrder mo, Client c, Gson gson, JsonObject json) {
		ConfigurationManager cm = new ConfigurationManager();
		String idStr = cm.getConfigurationValue("pizzadoro.id");
		if (idStr != null && idStr.length() > 0) {
			Key k = KeyFactory.stringToKey(idStr);
			if (k.equals(mo.getRestaurant())) {
				json.add("javascript", new JsonPrimitive("/scripts/custom/pizzadoro.js"));
			}
		}

	}

	private static void getMakisSpecificLogic(MealOrder mo, Client c, Gson gson, JsonObject json) {
		try {
			ConfigurationManager cm = new ConfigurationManager();
			PlateManager pm = new PlateManager();
			String makisIdStr = cm.getConfigurationValue("makis.Id");
			if (makisIdStr != null && makisIdStr.length() > 0) {
				Key makis = KeyFactory.stringToKey(makisIdStr);
				if (makis != null && makis.equals(mo.getRestaurant())) {
					String packageId = cm.getConfigurationValue("makis.package.id");
					if (packageId != null && packageId.length() > 0) {
						json.add("makisPackageCostId", new JsonPrimitive(packageId));
						json.add("makisMsg", new JsonPrimitive(cm.getConfigurationValue("makis.msg")));
						boolean isIncluded = false;
						Key packageKey = KeyFactory.stringToKey(packageId);
						for (Iterator<OrderedPlate> iterator = mo.getPlates().iterator(); iterator.hasNext();) {
							OrderedPlate plate = (OrderedPlate) iterator.next();
							if (Boolean.FALSE.equals(plate.getIsFraction()) && plate.getPlate().equals(packageKey)) {
								isIncluded = true;
								break;
							}
						}
						if (isIncluded == false) {
							Plate packagePlate = pm.get(packageKey);
							OrderedPlate oplate = new OrderedPlate();
							oplate.setName(packagePlate.getName());
							oplate.setPrice(packagePlate.getPrice());
							oplate.setPriceInCents(packagePlate.getPriceInCents());
							oplate.setQty(1);
							oplate.setPlate(packageKey);
							mo.getPlates().add(oplate);
						}
					}
				}
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "failed to add makis specific logic", e);
		}

	}

	private static JsonObject getSteakHouseSpecificData(MealOrder mo, Client c, Gson gson) {
		JsonObject json = new JsonObject();
		json.add("freeDelivery", new JsonPrimitive("false"));
		try {
			ConfigurationManager cm = new ConfigurationManager();
			String steakIdStr = cm.getConfigurationValue("steakHouse.Id");
			if (steakIdStr != null && steakIdStr.length() > 0) {
				Key steak = KeyFactory.stringToKey(steakIdStr);
				if (steak.equals(mo.getRestaurant())) {
					if (!TimeController.getDayOfWeek().equals(DayOfWeek.SATURDAY) && !TimeController.getDayOfWeek().equals(DayOfWeek.SUNDAY)) {
						if (TimeController.getCurrentTurn().equals(TurnType.LUNCH)) {
							String foodCatsStr = cm.getConfigurationValue("steakHouse.FoodCats");
							if (foodCatsStr != null && foodCatsStr.length() > 0) {
								String[] foodCatsArray = foodCatsStr.split("\\|");
								Set<Key> foodCats = new HashSet<Key>();
								for (int i = 0; i < foodCatsArray.length; i++) {
									if (foodCatsArray[i].length() > 0) {
										foodCats.add(KeyFactory.stringToKey(foodCatsArray[i]));
									}
								}

								List<OrderedPlate> plates = mo.getPlates();
								PlateManager pm = new PlateManager();
								for (Iterator iterator = plates.iterator(); iterator.hasNext();) {
									OrderedPlate orderedPlate = (OrderedPlate) iterator.next();
									Plate p = null;
									if (Boolean.TRUE.equals(orderedPlate.getIsFraction())) {
										p = pm.getPlate(orderedPlate.getFractionPlates().iterator().next());
									} else {
										p = pm.getPlate(orderedPlate.getPlate());
									}
									if (!foodCats.contains(p.getFoodCategory())) {
										json.add("freeDelivery", new JsonPrimitive("false"));
										return json;
									}

								}
								json.add("freeDelivery", new JsonPrimitive("true"));
								json.add("msg", new JsonPrimitive(cm.getConfigurationValue("steakHouse.msg")));
							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Could not set up things for SteakHouse", e);
		}

		return json;
	}

	public MealOrder getMealOrder(Client c, JsonObject sessionOderData) {

		MealOrder mo = new MealOrder();
		mo.setClient(c);
		if (c.getContact() != null) {
			mo.setClientPhone(c.getContact().getPhone());
		}

		mo.setAddress(getAddress(sessionOderData, c));

		mo.setObservation(getObservation(sessionOderData));
		mo.setRestaurant(getRestKey(sessionOderData));

		mo.setPlates(getPlates(sessionOderData));

		return mo;
	}

	private Key getAddress(JsonObject sessionOderData, Client c) {
		try {
			if (sessionOderData.get("address") == null) {
				if (c.getMainAddress() != null) {
					return c.getMainAddress();
				} else {
					return null;
				}
			} else {
				if (sessionOderData.get("address") != null && !sessionOderData.get("address").isJsonNull() ) {
					return KeyFactory.stringToKey(sessionOderData.get("address").getAsString());
				}else{
					return null;
				}

			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "no address da sessão havia {0}", sessionOderData.get("address"));
			log.log(Level.SEVERE, "Error ao buscar endereço de cliente ou em sessão", e);

			return null;
		}
	}

	public List<OrderedPlate> getPlates(JsonObject sessionOderData) {
		List<OrderedPlate> orderedPlates = new ArrayList<OrderedPlate>();
		JsonArray array = sessionOderData.get("plates").getAsJsonArray();
		for (int i = 0; i < array.size(); i++) {
			JsonObject pjson = array.get(i).getAsJsonObject();
			orderedPlates.add(getOrdered(pjson));
		}
		return orderedPlates;

	}

	private OrderedPlate getOrdered(JsonObject pjson) {
		OrderedPlate oplate = new OrderedPlate();
		oplate.setName(pjson.get("name").getAsString());
		oplate.setPrice(pjson.get("price").getAsDouble());
		oplate.setPriceInCents(Double.valueOf(pjson.get("price").getAsDouble() * 100.0).intValue());
		oplate.setQty(pjson.get("qty").getAsInt());

		if (pjson.get("isFraction").getAsBoolean() == true) {
			oplate.setIsFraction(Boolean.TRUE);
			Set<Key> fractionPlates = new HashSet<Key>();
			JsonArray fractionKeys = pjson.get("fractionKeys").getAsJsonArray();
			for (int i = 0; i < fractionKeys.size(); i++) {
				Key fractionKey = KeyFactory.stringToKey(fractionKeys.get(i).getAsString());
				fractionPlates.add(fractionKey);
			}
			oplate.setFractionPlates(fractionPlates);
			return oplate;

		} else {
			String pkey = "";
			if (pjson.get("plate").isJsonObject()) {
				pkey = pjson.get("plate").getAsJsonObject().get("id").getAsString();
			} else {
				pkey = pjson.get("plate").getAsString();
			}
			oplate.setPlate(KeyFactory.stringToKey(pkey));
			return oplate;
		}
	}

	public Key getRestKey(JsonObject sessionOderData) {
		String restKey;
		if (sessionOderData.get("restaurant") != null) {
			if (sessionOderData.get("restaurant").isJsonObject()) {
				restKey = sessionOderData.get("restaurant").getAsJsonObject().get("id").getAsString();
			} else {
				restKey = sessionOderData.get("restaurant").getAsString();
			}
		} else {
			restKey = sessionOderData.get("plates").getAsJsonArray().get(0).getAsJsonObject().get("plate").getAsJsonObject().get("value").getAsJsonObject().get("restaurant").getAsString();
		}
		return KeyFactory.stringToKey(restKey);
	}

	public String getObservation(JsonObject sessionOderData) {
		return sessionOderData.get("observation").getAsString();
	}

	public String getFormView() {
		return formView;
	}

	public void setFormView(String formView) {
		this.formView = formView;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}