<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.SubmitOrderController"%>
<%@page import="java.util.HashSet"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="java.util.Set"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="javax.persistence.Query"%>
<%@page import="br.com.copacabana.cb.entities.TurnType"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.Plate"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.PlateManager"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<pre>
<%
	
	PlateManager pm = new PlateManager();
	RestaurantManager rman = new RestaurantManager();
	FoodCategoryManager fman = new FoodCategoryManager();
	Set<String> cats = new HashSet<String>();
	cats.add("ag1jb21lbmRvYmVtYXBwchQLEgxGT09EQ0FURUdPUlkYoeYSDA");
	cats.add("ag1jb21lbmRvYmVtYXBwchMLEgxGT09EQ0FURUdPUlkYgX0M");
	cats.add("ag1jb21lbmRvYmVtYXBwchQLEgxGT09EQ0FURUdPUlkYiu4SDA");
	cats.add("ag1jb21lbmRvYmVtYXBwchILEgxGT09EQ0FURUdPUlkYAQw");
	cats.add("ag1jb21lbmRvYmVtYXBwchQLEgxGT09EQ0FURUdPUlkYgscSDA");
	cats.add("ag1jb21lbmRvYmVtYXBwchQLEgxGT09EQ0FURUdPUlkYuZECDA");

	//cats.add("ag5jb21lbmRvYmVtYmV0YXITCxIMRk9PRENBVEVHT1JZGO0IDA");
	Restaurant steak = rman.getRestaurantByUniqueURL("churrascaria");
	Set<Plate> plates = steak.getPlates();

	String hp = (String) session.getAttribute("handledPlates");
	if (hp == null) {
		hp = "";
	}
	for (Iterator<Plate> iter = plates.iterator(); iter.hasNext();) {
		Plate p = iter.next();
		if (p.getDescription().contains("Acompanha sobremesa flambada.")) {
			String str = p.getDescription();
			str = str.replace("Acompanha sobremesa flambada.", "");
			p.setDescription(str);
			pm.persist(p);
		}
		if (!hp.contains(KeyFactory.keyToString(p.getId())) && p.isExtension() == false) {

			if (cats.contains(KeyFactory.keyToString(p.getFoodCategory()))) {
				Double price = SubmitOrderController.TaxRounder(p.getPrice() * 0.7);
				out.println("original " + p.getPrice() + " new: " + price);
				String str = p.getDescription();
				if (str.contains("Para duas pessoas.")) {
					str = str.replace("Para duas pessoas.", "Para 1 pessoa");
				} else {
					str += " Para 1 pessoa";
				}

				String name = p.getName();
				name = "Para 1 pessoa";
				Plate novo = new Plate();
				novo.setDescription(str);
				novo.setName(name);
				novo.setExtendsPlate(p.getId());
				novo.setPrice(price);
				novo.setFoodCategory(p.getFoodCategory());
				novo.setAvailableTurn(p.getAvailableTurn());
				novo.setStatus(p.getStatus());
				steak.addPlate(novo);
				out.println(p.getName() + ":" + novo.getName() + " '" + novo.getDescription() + "' - R$" + novo.getPrice());
				hp += " "+KeyFactory.keyToString(p.getId())+" "; 
			}
		}
	}
	rman.persist(steak);
	session.setAttribute("handledPlates",hp);
%>
</pre>