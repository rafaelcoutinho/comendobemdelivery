package br.copacabana;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.logging.Level;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

import br.com.copacabana.cb.KeyWrapper;
import br.com.copacabana.cb.entities.OrderedPlate;
import br.com.copacabana.cb.entities.Payment;
import br.copacabana.marshllers.KeyWrapperDeSerializer;
import br.copacabana.marshllers.KeyWrapperSerializer;
import br.copacabana.marshllers.PaymentDeSerializer;
import br.copacabana.spring.JsonException;
import br.copacabana.usecase.control.UserActionManager;

import com.google.appengine.api.datastore.Key;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParser;

/**
 * @author Rafael Coutinho
 */
public class PayPalCancelController extends JsonViewController {
	private String formView;
	private String successView;

	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			Map<String, Object> model = new HashMap<String, Object>();
			model.put("mode", "view");
			String token = request.getParameter("token");
			String payerID = request.getParameter("PayerID");
			String mealOrderStr = (String) request.getSession().getAttribute("payPalPayment");
			request.getSession().removeAttribute("payPalPayment");
			log.log(Level.INFO, "Order Cancelled in paypal: " + mealOrderStr);

			GsonBuilder gsonBuilder = GsonBuilderFactory.getInstance();
			gsonBuilder.registerTypeAdapter(Key.class, new KeyDeSerializer());
			gsonBuilder.registerTypeAdapter(Key.class, new KeySerializer());
			gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperDeSerializer());
			gsonBuilder.registerTypeAdapter(KeyWrapper.class, new KeyWrapperSerializer());
			gsonBuilder.registerTypeAdapter(Payment.class, new PaymentDeSerializer());

			Gson gson = gsonBuilder.create();

			JsonParser pa = new JsonParser();
			request.getSession().setAttribute("orderData", mealOrderStr);
			model.put("forwardUrl", "/continueOrder.jsp");
			UserActionManager.cancelledPayPalPayment(mealOrderStr, request);
			return new ModelAndView(getViewName(), model);
		} catch (Exception e) {
			e.printStackTrace();
			UserActionManager.registerMajorError(request, e, "error during paypal cancellation");
			throw new JsonException(e.getMessage());
		}

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