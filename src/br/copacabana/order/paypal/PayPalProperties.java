package br.copacabana.order.paypal;

import br.copacabana.spring.ConfigurationManager;
import br.sagui.paypal.CurrencyCode;

public class PayPalProperties implements br.sagui.paypal.PayPalProperties {
	public static enum PayPalConfKeys {
		pppFixedRate, pppPercentageValue, pppUrl, pppUser, pppPassword, pppCancelUrl, pppForwardUrlPrefix, pppReturnUrl, pppSignature, pppCurrencyCode
	};

	private ConfigurationManager cm;

	public PayPalProperties(ConfigurationManager cm) {
		this.cm = cm;
	}

	@Override
	public String getCancelUrl() {
		return cm.getConfigurationValue(PayPalConfKeys.pppCancelUrl.name());
	}

	@Override
	public CurrencyCode getCurrencyCode() {
		String str = cm.getConfigurationValue(PayPalConfKeys.pppCurrencyCode.name());
		if (str == null || str.length()==0) {
			return CurrencyCode.USD;
		} else {
			return CurrencyCode.valueOf(str);
		}
	}

	@Override
	public String getForwardUrlPrefix() {
		return cm.getConfigurationValue(PayPalConfKeys.pppForwardUrlPrefix.name());
	}

	@Override
	public String getPassword() {
		return cm.getConfigurationValue(PayPalConfKeys.pppPassword.name());
	}

	@Override
	public String getReturnUrl() {
		return cm.getConfigurationValue(PayPalConfKeys.pppReturnUrl.name());
	}

	@Override
	public String getSignature() {
		return cm.getConfigurationValue(PayPalConfKeys.pppSignature.name());
	}

	@Override
	public Float getTaxValue() {
		throw new RuntimeException("Taxes are calculated");
	}

	@Override
	public String getUrl() {
		return cm.getConfigurationValue(PayPalConfKeys.pppUrl.name());
	}

	@Override
	public String getUser() {
		return cm.getConfigurationValue(PayPalConfKeys.pppUser.name());
	}

}
