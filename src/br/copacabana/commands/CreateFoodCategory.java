package br.copacabana.commands;

import br.com.copacabana.cb.entities.FoodCategory;
import br.com.copacabana.cb.entities.mgr.Manager;
import br.copacabana.Command;
import br.copacabana.ReturnValueCommand;
import br.copacabana.spring.FoodCategoryManager;

public class CreateFoodCategory implements Command, ReturnValueCommand {
	private FoodCategory foodcategory = new FoodCategory();

	@Override
	public void execute(Manager manager) throws Exception {
		execute();
	}

	@Override
	public void execute() throws Exception {
		FoodCategoryManager fman = new FoodCategoryManager();
		if (foodcategory.getId() != null) {
			FoodCategory f = fman.find(foodcategory.getId(), FoodCategory.class);
			f.setDescription(foodcategory.getDescription());
			f.setDescription(foodcategory.getDescription());
			f.setImgUrl(foodcategory.getImgUrl());
			f.setIsMainCategory(foodcategory.getIsMainCategory());
			fman.persist(f);
		} else {
			fman.persist(foodcategory);
		}

	}

	public FoodCategory getFoodcategory() {
		return foodcategory;
	}

	public void setFoodcategory(FoodCategory foodcategory) {
		this.foodcategory = foodcategory;
	}

	@Override
	public Object getEntity() {

		return foodcategory;
	}

}
