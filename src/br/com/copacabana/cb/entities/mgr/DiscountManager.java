package br.com.copacabana.cb.entities.mgr;

import java.util.Calendar;
import java.util.Date;

import javax.persistence.NoResultException;

import br.com.copacabana.cb.entities.DiscountCoupom;
import br.com.copacabana.cb.entities.DiscountStatus;
import br.copacabana.util.TimeController;

import com.google.appengine.api.datastore.Key;

public class DiscountManager extends AbstractJPAManager<DiscountCoupom> {

	@Override
	public String getDefaultQueryName() {
		return "allDiscounts";
	}

	@Override
	protected Class getEntityClass() {
		return DiscountCoupom.class;
	}

	public boolean isValid(String code, Key userKey) {
		return false;
	}

	public static void main(String[] args) {
		String codeStr = "2134AD";
		String code = codeStr.substring(0, codeStr.length() - 2);
		String crc = codeStr.substring(codeStr.length() - 2);
		DiscountCoupom disc = new DiscountCoupom();
		Calendar c = Calendar.getInstance(TimeController.getDefaultTimeZone());
		c.setTime(disc.getCreate());
		Integer second = c.get(Calendar.SECOND);
		String hexString = Integer.toHexString(second);
		System.out.println(hexString);
		System.out.println(crc);
		System.out.println(code);
		
		
	}
	
	public DiscountCoupom get(String codeStr) {
		String idStr = codeStr.substring(0, codeStr.length() - 2);
		String crc = codeStr.substring(codeStr.length() - 2);
		Long id = Long.parseLong(idStr);
		DiscountCoupom disc = get(id);
		String hexString = disc.getCrc();		
		if (hexString.equals(crc)) {
			return disc;
		}
		throw new NoResultException();
	}

	public boolean isValid(DiscountCoupom disc) {
		if (!disc.getStatus().equals(DiscountStatus.NOT_USED)) {
			return false;
		}
		if (!new Date().before(disc.getExpireDate())) {
			return false;
		}

		return true;
	}

	public void makeDiscountUsed(String code) {
		DiscountCoupom dc = get(code);
		dc.setStatus(DiscountStatus.USED);
		
	}

}
