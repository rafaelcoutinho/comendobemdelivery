package br.com.copacabana.cb.entities;

import javax.persistence.Embeddable;
import javax.persistence.Entity;

import br.com.copacabana.cb.entities.mgr.DiscountManager;
import br.copacabana.exception.InvalidCoupomException;
import br.copacabana.exception.InvalidCoupomException.InvalidCause;

import com.google.gson.annotations.Expose;

@Entity
@Embeddable
public class DiscountInfo {
	@Expose
	private String code;
	@Expose
	private Integer value;
	@Expose
	private DiscountType type;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public Integer getValue() {
		return value;
	}

	public void setValue(Integer value) {
		this.value = value;
	}

	public DiscountType getType() {
		return type;
	}

	public void setType(DiscountType type) {
		this.type = type;
	}

	public boolean validate(MealOrder mo) throws InvalidCoupomException {
		DiscountManager dm = new DiscountManager();
		DiscountCoupom dc = dm.get(mo.getDiscountInfo().getCode());
		if(!dc.getStatus().equals(DiscountStatus.NOT_USED)){
			throw new InvalidCoupomException("Coupom is already used",InvalidCause.COUPOM_USED);
		}
		if (dc.getAssocitedUser() != null) {
			if (!mo.getClient().getId().equals(dc.getAssocitedUser())) {
				throw new InvalidCoupomException("Coupom belongs to another user",InvalidCause.USER_IS_WRONG);
			}
		}
		
		if(dc.getValidRestaurants()!=null && dc.getValidRestaurants().size()>0){
			if(!dc.getValidRestaurants().contains(mo.getRestaurant())){
				throw new InvalidCoupomException("Coupom is not valid for this Restaurant used",InvalidCause.COUPOM_FOR_OTHER_RESTAURANT);
			}
		}
		if (dc.getType().equals(DiscountType.VALUE)) {
			// discount value must be the same.
			if (dc.getValue()<mo.getDiscountInfo().getValue()) {
				throw new InvalidCoupomException("Coupom values is lower than requested",InvalidCause.VALUE_IS_WRONG);
			}
		}

		return true;
	}

}
