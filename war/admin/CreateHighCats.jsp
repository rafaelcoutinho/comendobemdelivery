<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="br.com.copacabana.cb.entities.HighlightedFoodCategory"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.spring.FoodCategoryManager"%>
<%@page import="org.springframework.web.context.WebApplicationContext"%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<%

ServletContext context = getServletContext();
WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
FoodCategoryManager foodMan = (FoodCategoryManager) applicationContext.getBean("foodcategoryManager");
List foodCats = foodMan.getMainFoodCategories();
for(Iterator<FoodCategory> iter = foodCats.iterator();iter.hasNext();){
	FoodCategory fc = iter.next();
	HighlightedFoodCategory hfc= foodMan.getHighlighCategory(fc.getId());
	out.println(fc.getName()+" has "+hfc.getRestaurants().size()+" restaurants<br>");
}
%>