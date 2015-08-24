package br.copacabana;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.logging.Level;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.ClientLevel;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.OrderedPlate;
import br.com.copacabana.cb.entities.Payment;
import br.com.copacabana.cb.entities.Payment.PaymentType;
import br.copacabana.exception.ClientLevelException;
import br.copacabana.exception.InvalidCoupomException;
import br.copacabana.exception.InvalidCoupomException.InvalidCause;
import br.copacabana.marshllers.KeyWrapperDeSerializer;
import br.copacabana.marshllers.KeyWrapperSerializer;
import br.copacabana.marshllers.PaymentDeSerializer;
import br.copacabana.order.paypal.PayPalProperties;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.OrderManager;
import br.copacabana.usecase.control.UserActionManager;
import br.copacabana.xmpp.XmppController;
import br.sagui.paypal.LocaleCode;
import br.sagui.paypal.PayPalItemEnhanced;
import br.sagui.paypal.PayPalPaymentEnhancedVO;
import br.sagui.paypal.PayPalUtils;
import br.sagui.paypal.exception.PayPalAuthorizationException;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParser;

/**
 * @author Rafael Coutinho
 */
public class SubmitOrderController extends JsonViewController {
	private String formView;
	private String successView;

	public static void main2(String[] args) {
		String mealOrderStr = "{\"x\":'-47.0635012',\"y\":-22.8932027,\"plates\":[{\"name\":\"Asdfs\",\"qty\":1,\"price\":0,\"plate\":\"ag1jb21lbmRvYmVtYXBwchwLEgpSZXN0YXVyYW50GAkMCxIFUGxhdGUYugUM\",\"isFraction\":false}],\"deliveryCost\":13,\"restaurant\":\"ag1jb21lbmRvYmVtYXBwchALEgpSZXN0YXVyYW50GAkM\",\"observation\":\"\",\"payment\":{\"totalValue\":13,\"type\":\"CHEQUE\"},\"address\":\"ag1jb21lbmRvYmVtYXBwcjQLEgVTdGF0ZRgCDAsSBENpdHkYAwwLEgxOZWlnaGJvcmhvb2QYBgwLEgdBZGRyZXNzGCMM\",\"retrieveAtRestaurant\":false}";

		GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
		gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
		gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
		gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
		gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
		gsonBuilder.registerTypeAdapter(Payment.class, new PaymentDeSerializer());
		// gsonBuilder.registerTypeAdapter(Float.class, new
		// CoordinateDeSerializer());

		Gson gson = gsonBuilder.create();

		JsonParser pa = new JsonParser();
		MealOrder mo = gson.fromJson(pa.parse(mealOrderStr), MealOrder.class);
		System.out.println(mo.getX() + "," + mo.getY());

	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();
		try {

			model.put("mode", "view");
			String mealOrderStr = request.getParameter("mealOrder");

			GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
			gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
			gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
			gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
			gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
			gsonBuilder.registerTypeAdapter(Payment.class, new PaymentDeSerializer());

			Gson gson = gsonBuilder.create();

			JsonParser pa = new JsonParser();
			MealOrder mo = gson.fromJson(pa.parse(mealOrderStr), MealOrder.class);
			OrderManager mealMan = new OrderManager();

			ClientManager cm = new ClientManager();
			String loggedUserId = Authentication.getLoggedUser(request.getSession()).get("entity").getAsJsonObject().get("id").getAsString();

			Client c = cm.find(KeyFactory.stringToKey(loggedUserId), Client.class);
			mo.setClient(c);
			mo.setClientName(c.getName());
			mo.setClientPhone(c.getContact().getPhone());

			mo.setClientIp(getClientIpData(request));

			// if we have the user location
			if (Boolean.TRUE.equals(request.getSession().getAttribute("hasLocation"))) {
				if (mo.getX() == null) {
					try {
						Float x = (Float) request.getSession().getAttribute("xCoord");
						Float y = (Float) request.getSession().getAttribute("yCoord");
						mo.setX(x);
						mo.setY(y);
					} catch (Exception e) {
						log.log(Level.FINE, "Cannot get user location even if in session");
					}
				}
			}
			// validate discount
			if (mo.getDiscountInfo() != null) {
				mo.getDiscountInfo().validate(mo);
			}
			if (PaymentType.PAYPAL.equals(mo.getPayment().getType())) {

				// check for client level
				switch (c.getLevel()) {
				case NewBie: {
					mo.updateTotals();
					if (mo.getTotalAmountInCents() > 0) {
						throw new ClientLevelException("NEWBIE_COST");
					} else {
						Integer totalAmountLast30Days = cm.getOnlineOrdersLast30Days(c);
						if (totalAmountLast30Days > 0) {
							throw new ClientLevelException("NEWBIE_ALREADYORDERED");
						} 
					}
				}
					break;
				case ConfirmedPaymentData: {
					mo.updateTotals();
					if (mo.getTotalAmountInCents() > 10800) {
						throw new ClientLevelException("NEWBIE_COST");
					} else {
						Integer totalAmountLast30Days = cm.getOnlineOrdersLast30Days(c);
						if (totalAmountLast30Days > 30000) {
							throw new ClientLevelException("NEWBIE_ALREADYORDERED");
						} 
					}
				}
					break;
				case Bad: {
					throw new ClientLevelException("BAD_CUSTOMER");
				}
				default:
					break;
				}
				
				
				HttpSession session = request.getSession();
				ConfigurationManager confm = new ConfigurationManager();
				PayPalProperties ppp = new PayPalProperties(confm);

				PayPalPaymentEnhancedVO payPalVo = generatePayPalVO(mo, ppp, confm);

				PayPalUtils putils = new PayPalUtils(ppp.getUrl());
				UserActionManager.requestingPayPalToken(mealOrderStr, loggedUserId, request.getSession().getId());
				String token = putils.requestToken(payPalVo);

				log.log(Level.INFO, "Saving order before paypal: " + mealOrderStr);
				session.setAttribute("payPalPayment", mealOrderStr);
				session.setAttribute("convenienceTaxes", mo.getConvenienceTaxInCents());
				session.setAttribute("totalAmountInCents", mo.getTotalAmountInCents());
				session.setAttribute("deliveryCostInCents", mo.getDeliveryCostInCents());

				session.setAttribute("taxes", 0);
				UserActionManager.startedPayPalPayment(mealOrderStr, loggedUserId, request.getSession().getId());
				try{
					XmppController.sendMessage("rafael.coutinho@jabber.org", "Pedido paypal R$ "+mo.getTotalAmountInCents()+" - "+mo.getClientName()+" ");
				} catch (Exception e) {
					log.severe("failed to send XMPP msg");
				}
				// "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token="
				return new ModelAndView(new RedirectView(ppp.getForwardUrlPrefix() + token, false), model);
			} else {

				mo.updateTotals();
			}
			if(ClientLevel.Bad.equals(c.getLevel())){
				mo.setMustAskForId();
			}
			mealMan.createMealOrder(c, mo);

			request.getSession().removeAttribute("orderData");
			model.put("json", "");
			UserActionManager.completeOrder(mo, loggedUserId, request.getSession().getId());

			return new ModelAndView(getViewName(), model);
		} catch (InvalidCoupomException e) {
			log.log(Level.SEVERE, "Failed to submit order", e);
			if (e.getCauseCode().equals(InvalidCause.USER_IS_WRONG)) {
				model.put("orderSubmitError", "Houve problemas com o cupom utilizado. Este cupom está associado a outro cliente.");
			} else if (e.getCauseCode().equals(InvalidCause.VALUE_IS_WRONG)) {
				model.put("orderSubmitError", "Houve problemas com o cupom utilizado. O valor do desconto associado ao cupom não é o mesmo requerido.");
			} else if (e.getCauseCode().equals(InvalidCause.COUPOM_USED)) {
				model.put("orderSubmitError", "Houve problemas com o cupom utilizado. O coupom já foi usado antes.");
			} else if (e.getCauseCode().equals(InvalidCause.COUPOM_FOR_OTHER_RESTAURANT)) {
				model.put("orderSubmitError", "Houve problemas com o cupom utilizado. O coupom não é válido para este restaurante.");
			} else {
				model.put("orderSubmitError", "Houve problemas com o cupom utilizado.");
			}
			UserActionManager.registerMajorError(request, e, "Validating coupon in submit order");
			return new ModelAndView(getAlternateViewName(), model);
		} catch (ClientLevelException e) {
			// "Client is a NewBie and order cost is higher than R$ 30.00"
			log.log(Level.SEVERE, "ClientLevel do not allow this order", e);
			if (e.getMessage().equals("NEWBIE_ALREADYORDERED")) {
				model.put("orderSubmitError", "O seu rank não permite fazer pedidos com pagament online.");
			} else if (e.getMessage().equals("NEWBIE_COST")) {
				model.put("orderSubmitError", "O seu rank não permite pagamentos online deste montante.");
			}else if (e.getMessage().equals("BAD_CUSTOMER")) {
				model.put("orderSubmitError", "O seu rank não permite pagamentos online.");
			}
			model.put("isClientLevel", "true");
			UserActionManager.registerMajorError(request, e, "ClientLevel do not allow this order: " + e.getMessage());
			return new ModelAndView(getAlternateViewName(), model);
		}

		catch (Exception e) {
			if (e instanceof PayPalAuthorizationException) {
				PayPalAuthorizationException exce = ((PayPalAuthorizationException) e);
				if ("10426".equals(exce.getErrorcode())) {
					log.log(Level.SEVERE, "Error on order amount: ", exce);
				}

			}
			log.log(Level.SEVERE, "Failed to submit order", e);
			model.put("orderSubmitError", "Houve problemas para processar seu pedido.");
			UserActionManager.registerMajorError(request, e, "Error Submitting order");
			return new ModelAndView(getAlternateViewName(), model);
		}

	}

	public static String getClientIpData(HttpServletRequest request) {
		log.info("all ip info: ");
		log.info("x-forwarded-for: " + request.getHeader("x-forwarded-for"));
		log.info("VIA: " + request.getHeader("VIA"));
		log.info("getRemoteAddr: " + request.getRemoteAddr());
		log.info("getRemoteHost: " + request.getRemoteHost());

		String ip = request.getHeader("x-forwarded-for");
		if (ip != null && ip.trim().length() > 0) {
			return ip;
		} else {
			if (request.getRemoteAddr() != null) {
				return request.getRemoteAddr();
			} else {
				return request.getRemoteHost();
			}

		}
	}

	private static final String ENCODE_TYPE = "UTF-8";

	public static Map<String, String> parseResponse(String pPayload) throws UnsupportedEncodingException {
		Map<String, String> nvp = new HashMap<String, String>();
		StringTokenizer stTok = new StringTokenizer(pPayload, "&");
		while (stTok.hasMoreTokens()) {
			StringTokenizer stInternalTokenizer = new StringTokenizer(stTok.nextToken(), "=");
			if (stInternalTokenizer.countTokens() == 2) {
				nvp.put(URLDecoder.decode(stInternalTokenizer.nextToken(), ENCODE_TYPE), URLDecoder.decode(stInternalTokenizer.nextToken(), ENCODE_TYPE));
			}
		}
		return nvp;
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

	/**
	 * @deprecated use the one inside the MealOrder
	 * @param mo
	 * @throws InvalidCoupomException
	 */
	@Deprecated
	private void updateOrderTotals(MealOrder mo) throws InvalidCoupomException {
		Integer totalAmt = new Integer(0);
		for (Iterator<OrderedPlate> iterator = mo.getPlates().iterator(); iterator.hasNext();) {
			OrderedPlate plate = (OrderedPlate) iterator.next();
			totalAmt += plate.getQty() * plate.getPriceInCents();
		}
		Integer delCost = mo.getDeliveryCostInCents();
		totalAmt += delCost;
		// ConfigurationManager cm = new ConfigurationManager();
		// Integer fixedRate =
		// Integer.parseInt(cm.getConfigurationValue(PayPalProperties.PayPalConfKeys.pppFixedRate.name()));
		// Double pctValue =
		// Double.parseDouble(cm.getConfigurationValue(PayPalProperties.PayPalConfKeys.pppPercentageValue.name()));
		// Integer convenience = (int) ((pctValue * totalAmt) + fixedRate);
		// totalAmt += convenience;
		mo.setConvenienceTaxInCents(0);
		mo.getPayment().setTaxes(0.0);

		if (mo.getDiscountInfo() != null) {
			if (mo.getDiscountInfo().validate(mo) == true) {
				totalAmt = totalAmt - mo.getDiscountInfo().getValue();
			}
		}

		mo.setTotalAmountInCents(totalAmt);
	}

	private PayPalPaymentEnhancedVO generatePayPalVO(MealOrder mo, PayPalProperties ppp, ConfigurationManager cm) {

		PayPalPaymentEnhancedVO ppalVo = new PayPalPaymentEnhancedVO();
		ppalVo.setAllowNote(false);
		ppalVo.setReturnUrl(ppp.getReturnUrl());
		ppalVo.setCancelUrl(ppp.getCancelUrl());
		Integer totalAmt = new Integer(0);
		for (Iterator<OrderedPlate> iterator = mo.getPlates().iterator(); iterator.hasNext();) {
			OrderedPlate plate = (OrderedPlate) iterator.next();
			PayPalItemEnhanced item = new PayPalItemEnhanced();
			item.setName(plate.getName());
			item.setQuantity(plate.getQty());
			item.setPriceInCents(plate.getPriceInCents());
			totalAmt += plate.getQty() * plate.getPriceInCents();
			item.setDescription("");// TODO should we add the plate description?
			ppalVo.addItem(item);
		}

		// delivery cost
		Integer delCost = mo.getDeliveryCostInCents();
		if (delCost > 0) {
			PayPalItemEnhanced itemDelivery = new PayPalItemEnhanced();
			itemDelivery.setName("Entrega");
			itemDelivery.setQuantity(1);
			itemDelivery.setPriceInCents(delCost);
			itemDelivery.setDescription("Taxa de entrega.");
			ppalVo.addItem(itemDelivery);
		}

		if (mo.getDiscountInfo() != null) {
			totalAmt -= mo.getDiscountInfo().getValue();
			Integer discountCost = mo.getDiscountInfo().getValue();
			PayPalItemEnhanced itemDiscount = new PayPalItemEnhanced();
			itemDiscount.setName("Desconto");
			itemDiscount.setQuantity(1);
			itemDiscount.setPriceInCents(-1 * discountCost);
			itemDiscount.setDescription("Desconto via cupom.");
			ppalVo.addItem(itemDiscount);
		}

		// ppalVo.setDeliveryCost(delCost);
		totalAmt += delCost;

		// Convenience charge
		PayPalItemEnhanced item = new PayPalItemEnhanced();
		item.setName("Taxa de conveniência");
		item.setQuantity(1);
		Integer fixedRate = Integer.parseInt(cm.getConfigurationValue(PayPalProperties.PayPalConfKeys.pppFixedRate.name()));
		Double pctValue = Double.parseDouble(cm.getConfigurationValue(PayPalProperties.PayPalConfKeys.pppPercentageValue.name()));

		Integer convenience = (int) ((pctValue * totalAmt) + fixedRate);
		item.setPriceInCents(convenience);
		item.setDescription("Taxa para realizar o pagamento online.");
		ppalVo.addItem(item);

		// totalAmt += convenience;

		ppalVo.setPassword(ppp.getPassword());
		ppalVo.setSignature(ppp.getSignature());
		ppalVo.setTax(0);

		mo.setConvenienceTaxInCents(convenience);
		mo.updateTotals();

		ppalVo.setNoShipping(true);
		ppalVo.setUser(ppp.getUser());
		ppalVo.setCurrencyCode(ppp.getCurrencyCode());
		ppalVo.setLocaleCode(LocaleCode.BR);

		return ppalVo;

	}

	public static void main(String[] args) throws Exception {
		double d = 10.46100001;
		System.out.println(NumberRounder(d));
		System.out.println(TaxRounder(d));
		d = 10.46;
		System.out.println(NumberRounder(d));
		System.out.println(TaxRounder(d));
		d = 10;
		System.out.println(NumberRounder(d));
		System.out.println(TaxRounder(d));
		System.out.println("ended");

	}

	public static Double TaxRounder(Double b) {
		Double a = b * 10;
		Integer integer = a.intValue();
		Double cents = a % integer;
		if (cents < 0.5) {
			cents = 0.0;
		} else {
			cents = 0.5;
		}
		Double value = integer + cents;
		return value / 10;

	}

	private static Double calculateTaxAux(Double itemsAmount, Double deliveryCost, String pct) {
		Double totalCost = itemsAmount + deliveryCost;

		Double pctValue = Double.parseDouble(pct);
		Double pctTotal = (totalCost * pctValue);
		return SubmitOrderController.NumberRounder(TaxRounder(pctTotal));
	}

	private Double calculateTax(Double itemsAmount, Double deliveryCost, ConfigurationManager cm) {
		Double totalCost = itemsAmount + deliveryCost;

		Double pctValue = Double.parseDouble(cm.getConfigurationValue(PayPalProperties.PayPalConfKeys.pppPercentageValue.name()));
		Double pctTotal = (totalCost * pctValue);
		return SubmitOrderController.NumberRounder(TaxRounder(pctTotal));
	}

	public static Double NumberRounder(Double pctTotal) {
		int p = pctTotal.toString().indexOf('.');
		if (p > -1) {
			if (pctTotal.toString().length() >= p + 3) {
				return Double.parseDouble(pctTotal.toString().substring(0, p + 3));
			}
		} else {
			p = pctTotal.toString().indexOf(',');
			if (p > -1) {
				if (pctTotal.toString().length() >= p + 3) {
					return Double.parseDouble(pctTotal.toString().substring(0, p + 3));
				}
			}

		}
		return pctTotal;

	}

}