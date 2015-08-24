<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page import="com.google.appengine.api.channel.ChannelService"%>
<%@page import="com.google.appengine.api.channel.ChannelServiceFactory"%>
<%@page import="com.google.appengine.api.channel.ChannelService"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="br.copacabana.GsonBuilderFactory"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="br.copacabana.usecase.ServerClientMonitors"%>
<%@page import="br.com.copacabana.cb.entities.DeliveryRange"%><%@page
	import="br.copacabana.spring.DeliveryManager"%><%@page
	import="br.copacabana.spring.OrderManager"%><%@page
	import="br.com.copacabana.cb.entities.Payment"%><%@page
	import="br.com.copacabana.cb.entities.Payment.PaymentType"%><%@page
	import="br.com.copacabana.cb.entities.OrderType"%><%@page
	import="br.com.copacabana.cb.entities.MealOrderStatus"%><%@page
	import="java.util.Date"%><%@page
	import="br.com.copacabana.cb.entities.OrderedPlate"%><%@page
	import="java.util.HashSet"%><%@page
	import="br.com.copacabana.cb.entities.MealOrder"%><%@page
	import="java.util.Enumeration"%><%@page
	import="br.copacabana.spring.AddressManager"%><%@page
	import="br.com.copacabana.cb.entities.Neighborhood"%><%@page
	import="br.copacabana.spring.NeighborhoodManager"%><%@page
	import="br.copacabana.spring.ClientManager"%><%@page
	import="br.com.copacabana.cb.entities.Client"%><%@page
	import="com.google.appengine.api.datastore.Key"%><%@page
	import="com.google.appengine.api.datastore.KeyFactory"%><%@page
	import="br.com.copacabana.cb.entities.Address"%><%@page
	import="java.util.logging.Level"%><%@page
	import="java.util.logging.Logger"%>
<%@page
	import="br.copacabana.CacheController"%><%@page import="java.util.Set"%><%@page
	import="br.com.copacabana.cb.entities.UserBean"%><%@page
	import="br.com.copacabana.cb.entities.RestaurantClient"%><%@page
	import="br.copacabana.spring.RestaurantClientManager"%><%@page
	import="br.copacabana.Authentication"%><%@page
	import="br.com.copacabana.cb.entities.Restaurant"%><%@page
	import="br.copacabana.spring.RestaurantManager"%>
<%
	Logger log = Logger.getLogger("copacabana.Servlet");
	try {
		String id="";
		String username = request.getParameter("username");
		String token = request.getParameter("token");
		Authentication auth = new Authentication();
		if (auth.tokenBasedAuthentication(username, token, ServerClientMonitors.getSeed(), "true", session)) {
			
			String orderStr = request.getParameter("order");
			JsonParser parser= new JsonParser();
			JsonObject obj = parser.parse(orderStr).getAsJsonObject();
			System.out.println();	
			 
			JsonObject addressJson = obj.get("address").getAsJsonObject();
			Address address = new Address();

			
			address.setStreet(addressJson.get("street").getAsString());
			
			address.setPhone(addressJson.get("phone").getAsString());
			String additionalInfo = addressJson.get("additionalInfo").getAsString();
			address.setAdditionalInfo(additionalInfo);
			String number = addressJson.get("number").getAsString();
			address.setNumber(number);

			NeighborhoodManager nman = new NeighborhoodManager();

			String neighId = addressJson.get("neighborhood").getAsJsonObject().get("id").getAsString();
			Neighborhood n = nman.get(KeyFactory.stringToKey(neighId));
			if (n == null) {
				log.severe("Bairro invalido, usando o 1o");
				n = nman.list().iterator().next();
			}
			address.setNeighborhood(n);

			AddressManager addMan = new AddressManager();
			address = addMan.createAddres(address);
			Key addKey = address.getId();

			OrderManager om = new OrderManager();
			MealOrder mo = new MealOrder();
			mo.setAddress(addKey);
			Key clientId = KeyFactory.stringToKey(obj.get("client").getAsJsonObject().get("id").getAsString());
			Client client = null;
			if (clientId.getKind().equals("CLIENT")) {
				client = new ClientManager().get(clientId);
			} else {
				client = new RestaurantClientManager().get(clientId);
			}
			mo.setClient((Client) client);
			mo.setClientName(client.getName());
			mo.setClientPhone(client.getMainPhone());
			if (client.getId().getKind().equals("CLIENT")) {
				mo.setClientRequestsOnRestaurant(om.getClientOrdersInRestaurant(client, mo.getRestaurant()).size());
				mo.setClientRequestsOnSite(om.getClientOrdersInSite(client).size());
			} else {
				mo.setClientRequestsOnRestaurant(0);
				mo.setClientRequestsOnSite(0);
			}

			/*String delayForecast = request.getParameter("delayForecast");
			if (delayForecast != null && delayForecast.length() > 0) {
				mo.setPrepareForeCast(delayForecast);
			}*/

			
			JsonArray plates = obj.get("plates").getAsJsonArray();
			//while (request.getParameter("plates[" + i + "][name]") != null) {
				for(int i=0;i<plates.size();i++){
					JsonObject op = plates.get(i).getAsJsonObject();	
				
				String name = op.get("name").getAsString();
				log.info("plate: " + name);
				Integer qty = op.get("qty").getAsInt();
				log.info("plate.qty: " + qty);
				String idPlate = op.get("id").getAsString();
				log.info("plate.id: " + idPlate);
				Boolean isCustom =  op.get("custom").getAsBoolean();
				log.info("plate.custom: " + isCustom);
				Boolean isFraction =  op.get("fraction").getAsBoolean();
				
				log.info("plate.fraction: " + isFraction);
				Integer priceInCents = op.get("priceInCents").getAsInt();//Integer.parseInt(request.getParameter("plates[" + i + "][priceInCents]"));
				log.info("plate.price: " + priceInCents);
				OrderedPlate op1 = new OrderedPlate();

				op1.setName(name);
				op1.setPriceInCents(priceInCents);
				op1.setIsFraction(isFraction);
				op1.setQty(qty);
				op1.setIsCustom(isCustom);
				if (isFraction) {
					Set<Key> ids = new HashSet<Key>();
					ids.add(KeyFactory.stringToKey(idPlate));
					JsonArray fractionIds = op.get("fractionIds").getAsJsonArray();// request.getParameter("plates[" + i + "][fractionId]");
					for(int j=0;j<fractionIds.size();j++){
						ids.add(KeyFactory.stringToKey(fractionIds.get(j).getAsString()));
					}
					op1.setFractionPlates(ids);
				} else {
					if (!isCustom) {
						op1.setPlate(KeyFactory.stringToKey(idPlate));
					}
				}
				op1.setMealorder(mo);
				mo.getPlates().add(op1);
				i++;
			}

			if (obj.has("cpf")) {
				mo.setCpf(obj.get("cpf").getAsString());
			}

			mo.setConvenienceTaxInCents(0);
			Key deliveryRange = KeyFactory.stringToKey(obj.get("deliveryRangeId").getAsString());
			DeliveryRange delRange = new DeliveryManager().get(deliveryRange);

			mo.setDeliveryCostInCents((int) (delRange.getCost() * 100));
			mo.setDeliveryCost(delRange.getCost());

			RestaurantManager rman = new RestaurantManager();
			

			Restaurant rest = rman.getRestaurant(Authentication.getLoggedUserKey(session));
			mo.setRestaurant(rest.getId());

			mo.setObservation(obj.get("observation").getAsString());
			mo.setOrderedTime(new Date());
			mo.updateTotals();
			mo.setStatus(MealOrderStatus.NEW);
			mo.setOrderType(OrderType.EXTERNALSITE);
			String ptypeStr = obj.get("paymentType").getAsString();
			PaymentType ptype = PaymentType.valueOf(ptypeStr);
			Payment pay = new Payment();
			pay.setType(ptype);
			if (ptype.equals(PaymentType.INCASH)) {
				String amountInCash = obj.get("amountInCash").getAsString();
				Double cost = Double.parseDouble(amountInCash);
				pay.setAmountInCash(cost);
			}

			mo.setPayment(pay);

			om.create(mo);
			ChannelService channelService = ChannelServiceFactory.getChannelService();

			String monToken = channelService.createChannel("Client_"+KeyFactory.keyToString(clientId));
%>{"status":"ok","id":"<%=KeyFactory.keyToString(mo.getId())%>","oldId":"<%=id%>","idXlated":"<%=mo.getXlatedId()%>","token":"<%=monToken %>"}<%
	} else {
%>{"status":"fail","message":"invalid credential
<%=username%>","code":"1"}<%
	}
	} catch (Exception e) {
		log.log(Level.SEVERE, "Error ao syncronizar pedidos", e);
		log.log(Level.SEVERE, "order {0}", request.getParameter("order"));
	
%>{"status":"fail","message":"error","code":"2"}<%
	}
%>