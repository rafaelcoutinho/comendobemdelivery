package br.copacabana.marshllers;

import java.lang.reflect.Type;

import br.com.copacabana.cb.entities.Payment;
import br.com.copacabana.cb.entities.Payment.PaymentType;

import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;

public class PaymentDeSerializer implements JsonDeserializer<Payment> {

	@Override
	public Payment deserialize(JsonElement json, Type type, JsonDeserializationContext ctx) throws JsonParseException {
		String paymentType = json.getAsJsonObject().get("type").getAsString();
		PaymentType pt = PaymentType.valueOf(paymentType);
		Payment p = null;
		switch (pt) {
		case INCASH:
			//CANT have polymorphism in google :(
			//p = new PaymentInCash();
			//((PaymentInCash) p).setAmountInCash(json.getAsJsonObject().get("amountInCash").getAsDouble());
				
			p = new Payment();
			p.setType(PaymentType.INCASH);
			p.setAmountInCash(json.getAsJsonObject().get("amountInCash").getAsDouble());
			
			break;
		case CHEQUE:
			p = new Payment();
			p.setType(PaymentType.CHEQUE);
			
			break;
		default:
			p = new Payment();
			p.setType(pt);
		}
		
		p.setTotalValue(json.getAsJsonObject().get("totalValue").getAsDouble());

		return p;
	}

}
