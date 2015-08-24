package br.copacabana;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;

import br.copacabana.spring.JsonException;
import br.copacabana.usecase.beans.UpdateOrderStatus;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

public class OrderStatusController extends JsonCommandController {
	@SuppressWarnings("unchecked")
	protected Object formBackingObject(HttpServletRequest request) throws Exception {
		return new UpdateOrderStatus();
	}
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		try {
			return super.onSubmit(request, response, command, errors);
		} catch (Exception e) {
			JsonObject returnObj = new JsonObject();
			returnObj.add("status", new JsonPrimitive(false));
			Map<String, Object> model = new HashMap<String, Object>();
			if (e instanceof JsonException) {				
				if (JsonException.ErrorCode.PAYPALEXPIRED.equals(((JsonException) e).getErrorCode())) {
					returnObj.add("errorCode", new JsonPrimitive(((JsonException) e).getErrorCode().name()));					
				} else {
					if (JsonException.ErrorCode.PAYPALERROR.equals(((JsonException) e).getErrorCode())) {
						returnObj.add("errorCode", new JsonPrimitive(((JsonException) e).getErrorCode().name()));						
					}else{
						returnObj.add("errorCode", new JsonPrimitive(((JsonException) e).getErrorCode().name()));
					}
				}
			}
			model.put("json", returnObj.toString());
			return new ModelAndView(getSuccessView(), model);
		}
	}
}
