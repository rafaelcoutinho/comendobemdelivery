package br.copacabana;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.logging.Level;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.Address;
import br.com.copacabana.cb.entities.Client;
import br.com.copacabana.cb.entities.MealOrder;
import br.com.copacabana.cb.entities.OrderedPlate;
import br.com.copacabana.cb.entities.Payment;
import br.copacabana.marshllers.KeyWrapperDeSerializer;
import br.copacabana.marshllers.KeyWrapperSerializer;
import br.copacabana.marshllers.PaymentDeSerializer;
import br.copacabana.order.paypal.PayPalProperties;
import br.copacabana.spring.AddressManager;
import br.copacabana.spring.ClientManager;
import br.copacabana.spring.ConfigurationManager;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;
import br.copacabana.spring.OrderManager;
import br.copacabana.usecase.control.UserActionManager;
import br.sagui.paypal.CurrencyCode;
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
import com.paypal.sdk.exceptions.PayPalException;

/**
 * @author Rafael Coutinho
 */
public class PayPalAuthorizationController extends JsonViewController {
	private String formView;
	private String successView;

	private static PayPalPaymentEnhancedVO create() {

		PayPalPaymentEnhancedVO ppalVo = new PayPalPaymentEnhancedVO();
		ppalVo.setAllowNote(false);
		ppalVo.setReturnUrl("http://localhost:8888/Showpp.jsp");
		ppalVo.setCancelUrl("http://localhost:8888/fazPedido.do?mode=view");
		Integer totalAmt = new Integer(0);
		PayPalItemEnhanced item1 = new PayPalItemEnhanced();
		item1.setName("Pratinho");
		item1.setQuantity(1);
		item1.setPriceInCents(1000);
		totalAmt += 1000 * 1;
		item1.setDescription("");// TODO should we add the plate description?
		ppalVo.addItem(item1);

		Integer delCost = 100;

		PayPalItemEnhanced itemDelivery = new PayPalItemEnhanced();
		itemDelivery.setName("Entrega");
		itemDelivery.setQuantity(1);
		itemDelivery.setPriceInCents(delCost);
		itemDelivery.setDescription("Taxa de entrega.");
		ppalVo.addItem(itemDelivery);

		// ppalVo.setDeliveryCost(delCost);
		totalAmt += delCost;

		ppalVo.setPassword("1266964423");
		ppalVo.setSignature("AAjz5U.uxSNMucR5yEhqCImSlw4pAWL9DiYlJagQFUMJGTvYue6wOAAQ");
		ppalVo.setTax(0);

		ppalVo.setNoShipping(true);
		ppalVo.setUser("rafael_1266964413_biz_api1.gmail.com");
		ppalVo.setCurrencyCode(CurrencyCode.USD);
		ppalVo.setLocaleCode(LocaleCode.BR);

		return ppalVo;

	}

	public static void main(String[] args) {

		try {
			boolean complete = false;
			PayPalPaymentEnhancedVO payPalVo = create();

			PayPalUtils putils = new PayPalUtils("https://api-3t.sandbox.paypal.com/nvp");
			if (complete) {
				String token = putils.requestToken(payPalVo);
				System.out.println("https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=" + token);
			} else {
				putils.completeExpressCheckout("USD", "EC-4PP3467107213880Y", "1100", "4DCD9KX2RT44U", "AAjz5U.uxSNMucR5yEhqCImSlw4pAWL9DiYlJagQFUMJGTvYue6wOAAQ ", "1266964423", "rafael_1266964413_biz_api1.gmail.com");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	void completePayPalPayment(String token, String payerId, Integer totalAmountInCents) throws JsonException {
		try {
			ConfigurationManager confm = new ConfigurationManager();
			PayPalProperties ppp = new PayPalProperties(confm);
			PayPalUtils putils = new PayPalUtils(ppp.getUrl());
			Integer amt = totalAmountInCents;

			putils.completeExpressCheckout(ppp.getCurrencyCode().name(), token, amt, payerId, ppp.getSignature(), ppp.getPassword(), ppp.getUser());
			// Payment payment = mo.getPayment();
			// payment.setConfirmed("true");
			// mo.setPayment(payment);
		} catch (PayPalAuthorizationException e) {
			e.printStackTrace();
			if (e.getErrorcode().equals("10415")) {
				log.log(Level.INFO, "Tentou autorizar 2 vezes... {0}", e.getShortmsg());
				// Acho q por eqto devemos deixar
				throw new JsonException("Cannot authorize paypal", ErrorCode.PAYPALAUTHORIZATIONREPEATED);

			} else {
				if (e.getErrorcode().equals("10411")) {
					log.log(Level.INFO, "Paypal expired. {0}", e.getShortmsg());
					try {
						// Demorou muito!
					} catch (Exception e1) {
						// TODO: handle exception
					}
					throw new JsonException("Cannot authorize paypal", ErrorCode.PAYPALEXPIRED);

				} else {
					log.log(Level.SEVERE, "Tem q buscar esse pgto: {0} payer:{1} - {2}", new Object[] { token, payerId, e });
					log.log(Level.SEVERE, "{0} {1} - {2}", new Object[] { e.getMessage(), e.getLocalizedMessage(), e });
					throw new JsonException("Cannot authorize paypal", ErrorCode.PAYPALERROR);
				}
			}
		} catch (IOException e) {

			log.log(Level.SEVERE, "Tem q buscar esse pgto: {0} payer:{1} - {2}", new Object[] { token, payerId, e });

			throw new JsonException("IO Exception cannot authorize paypal", ErrorCode.PAYPALIOERROR);// try
																										// again
		}
	}

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();
		try {
			model.put("mode", "view");
			request.getSession().removeAttribute("pptoken");
			String token = request.getParameter("token");
			String payerID = request.getParameter("PayerID");
			HttpSession session = request.getSession();
			String mealOrderStr = (String) session.getAttribute("payPalPayment");

			GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
			gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
			gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
			gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
			gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
			gsonBuilder.registerTypeAdapter(Payment.class, new PaymentDeSerializer());

			Gson gson = gsonBuilder.create();

			JsonParser pa = new JsonParser();

			OrderManager mealMan = new OrderManager();

			Integer totalAmountInCents = (Integer) session.getAttribute("totalAmountInCents");
			String blackList = new ConfigurationManager().getConfigurationExtendedValue("ppblacklist");
			if (blackList.indexOf(payerID + "|") >= 0) {

				throw new JsonException("Payer is in black list: " + payerID, ErrorCode.PAYPAL_BLACKLIST);
			}
			if (!"true".equals(request.getSession().getAttribute("delayedPayment"))) {
				// pegar autorizacao
				try {
					this.completePayPalPayment(token, payerID, totalAmountInCents);
				} catch (JsonException e) {
					if (!e.getErrorCode().equals(ErrorCode.PAYPALAUTHORIZATIONREPEATED)) {
						throw e;
					}
					UserActionManager.payPalAutorizedMoreThanOnce(request.getSession());
				}
			}
			request.getSession().removeAttribute("delayedPayment");
			ClientManager cm = new ClientManager();
			String loggedUserId = Authentication.getLoggedUser(request.getSession()).get("entity").getAsJsonObject().get("id").getAsString();
			Integer convenienceInCents = (Integer) session.getAttribute("convenienceTaxes");
			Integer deliveryCostInCents = (Integer) session.getAttribute("deliveryCostInCents");

			session.removeAttribute("payPalPayment");
			session.removeAttribute("convenienceTaxes");
			// taxes are 0
			session.removeAttribute("taxes");
			session.removeAttribute("totalAmountInCents");
			session.removeAttribute("deliveryCostInCents");

			MealOrder mo = gson.fromJson(pa.parse(mealOrderStr), MealOrder.class);
			Client c = cm.find(KeyFactory.stringToKey(loggedUserId), Client.class);
			mo.setClient(c);
			mo.setClientName(c.getName());
			mo.setClientPhone(c.getContact().getPhone());
			mo.setMustAskForId();
			Payment p = mo.getPayment();
			p.setToken(token);
			p.setPayerId(payerID);
			p.setTaxes(0.0);
			p.setConfirmed("true");
			mo.setPayment(p);
			if (convenienceInCents != null) {
				mo.setConvenienceTaxInCents(convenienceInCents);
			} else {
				mo.setConvenienceTaxInCents(0);
			}
			mo.setTotalAmountInCents(totalAmountInCents);
			mo.setDeliveryCostInCents(deliveryCostInCents);
			mealMan.createMealOrder(c, mo);

			model.put("json", "");
			UserActionManager.completeWithPayPalOrder(mo, loggedUserId, request.getSession().getId());
			request.getSession().removeAttribute("ppretries");
			return new ModelAndView(getViewName(), model);
		} catch (JsonException e) {
			String token = request.getParameter("token");
			String payerID = request.getParameter("PayerID");

			model.put("mode", "view");
			model.put("PayerID", payerID);
			// model.put("token", token);
			switch (e.getErrorCode()) {
			/*
			 * case PAYPALAUTHORIZATIONREPEATED:
			 * UserActionManager.payPalAutorizedMoreThanOnce
			 * (request.getSession()); model.put("mode", "view"); String token =
			 * request.getParameter("token"); String payerID =
			 * request.getParameter("PayerID"); model.put("PayerID", payerID);
			 * model.put("token", token); //let's leave it like this for now
			 * return new ModelAndView(getViewName(), model);
			 */
			case PAYPALIOERROR:
				UserActionManager.registerPaypalPaymentIOFailure(request, token, payerID, e.getMessage());
				// let's leave it like this for now
				Integer retries = (Integer) request.getSession().getAttribute("ppretries");
				if (retries == null) {
					retries = 1;
				}
				log.log(Level.SEVERE, "Retrying paypal after timeout {0}", retries);
				if (retries > 4) {
					request.getSession().removeAttribute("ppretries");
					return new ModelAndView(getAlternateViewName(), model);
				} else {
					request.getSession().setAttribute("pptoken", token);
					return new ModelAndView("redirect:/paypalHandler.jsp", model);
				}

			case PAYPALEXPIRED:
				UserActionManager.registerPaypalPaymentFailure(request, token, payerID, "Expired " + e.getMessage());
				return new ModelAndView(getAlternateViewName(), model);

			case PAYPAL_BLACKLIST:
				UserActionManager.registerPaypalBlackList(request, token, payerID, "BlackListed " + e.getMessage());
			case PAYPALERROR:
				UserActionManager.registerPaypalPaymentFailure(request, token, payerID, "PAYPALERROR " + e.getMessage());
				return new ModelAndView(getAlternateViewName(), model);

			default:
				throw e;
			}

		} catch (Exception e) {
			UserActionManager.registerMajorError(request, e, "Error Confirming paypal order");
			throw new JsonException(e.getMessage());
		}

	}

	private String createPayPalData(HttpServletRequest request, HttpServletResponse response, MealOrder mo, AddressManager am) throws IOException, PayPalException {
		StringBuffer sb = new StringBuffer();
		// System.out.println(request.getServerName());
		String host = "localhost:8080";
		if (!request.getServerName().equals("localhost")) {
			host = "www.comendobem.com.br";
		}
		String cancelURL = URLEncoder.encode("http://" + host + "/placeOrder.do", ENCODE_TYPE);
		sb.append("CANCELURL=" + cancelURL);
		sb.append("&");
		String successUrl = URLEncoder.encode("http://" + host + "/submitOrder.do", ENCODE_TYPE);
		sb.append("RETURNURL=" + successUrl);
		sb.append("&");

		sb.append("PAYMENTACTION=Authorization");
		sb.append("&");
		sb.append("TAXAMT=");
		sb.append(getTaxAmount());
		sb.append("&");
		sb.append("ALLOWNOTE=0");
		sb.append("&");
		int i = 0;
		float f = 0;
		for (Iterator iterator = mo.getPlates().iterator(); iterator.hasNext();) {
			OrderedPlate plate = (OrderedPlate) iterator.next();
			f += addPlate(plate, sb, i++);
		}
		sb.append("AMT=" + (f + getTaxAmount()));
		sb.append("&");
		sb.append("ITEMAMT=" + f);
		sb.append("&");

		sb.append("METHOD=SetExpressCheckout");
		sb.append("&");
		// sb.append("CURRENCYCODE=BRL");
		sb.append("CURRENCYCODE=USD");
		sb.append("&");
		sb.append("PWD=");
		sb.append(getPwd());
		sb.append("&");
		sb.append("SOURCE=PAYPAL_JAVA_SDK_61");
		sb.append("&");

		sb.append("SIGNATURE=" + "ACUe-E7Hjxmeel8FjYAtjnx-yjHAABHt.L3KGsZNgvV4-JhMr.XJe9JN");
		sb.append("&");
		sb.append("USER=rafael_1265629971_biz_api1.comendobem.com.br");
		sb.append("&");
		sb.append("VERSION=61.0");
		sb.append("&");
		sb.append("LOCALECODE=BR");
		sb.append("&");
		sb.append("NOSHIPPING=1");
		// sb.append("&ADDROVERRIDE=1");
		Address deliveryAddress = am.find(mo.getAddress(), Address.class);
		String street = URLEncoder.encode(deliveryAddress.getStreet(), ENCODE_TYPE);
		String addPhone = URLEncoder.encode(deliveryAddress.getPhone(), ENCODE_TYPE);

		URL url = new URL("https://api-3t.sandbox.paypal.com/nvp");
		// System.out.println(sb.toString());
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setDoOutput(true);
		connection.setRequestMethod("POST");

		OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
		writer.write(sb.toString());
		writer.close();
		BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		String line;
		StringBuffer sbresponse = new StringBuffer();
		while ((line = reader.readLine()) != null) {
			sbresponse.append(line);
		}
		// System.out.println(sbresponse);
		Map<String, String> responseMap = parseResponse(sbresponse.toString());
		String strAck = responseMap.get("ACK");
		if (strAck != null && !(strAck.equals("Success") || strAck.equals("SuccessWithWarning"))) {
			System.err.println("falhou");
			return sbresponse.toString();
		} else {
			// response.sendRedirect("https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC%2d01468399S03008716");
			return responseMap.get("TOKEN");
		}

	}

	private Object getPwd() {
		return "1265629978";
	}

	private float getTaxAmount() {

		return 2.0f;
	}

	private static final String ENCODE_TYPE = "UTF-8";

	private Map<String, String> parseResponse(String pPayload) throws UnsupportedEncodingException {
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

	private float addPlate(OrderedPlate plate, StringBuffer encoder, int pos) throws UnsupportedEncodingException {
		encoder.append("L_NAME" + pos + "=" + URLEncoder.encode(plate.getName(), ENCODE_TYPE));
		encoder.append("&");
		encoder.append("L_NUMBER" + pos + "=" + 1);
		encoder.append("&");
		encoder.append("L_ITEMWEIGHTUNIT" + pos + "=lbs");
		encoder.append("L_ITEMWEIGHTVALUE" + pos + "=1");
		encoder.append("&");

		encoder.append("L_DESC" + pos + "=" + URLEncoder.encode("no desc", ENCODE_TYPE));
		encoder.append("&");

		encoder.append("L_AMT" + pos + "=" + plate.getPrice().toString());
		encoder.append("&");
		encoder.append("L_QTY" + pos + "=" + plate.getQty() + "");
		encoder.append("&");
		Float f = Float.valueOf("" + (plate.getPrice() * plate.getQty()));

		return f;
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