<%@page import="br.copacabana.cache.OrdersCacheEntry"%>
<%@page import="javax.cache.CacheStatistics"%>
<%@page import="br.copacabana.CacheController"%><%
CacheStatistics cs =  CacheController.getCache().getCacheStatistics();
CacheController.getCache().remove("AtomXML");
CacheController.getCache().clear();

//in order to keep the initial ones 
// check spring-servletXML for all the needed caches to init.
// all the jsonCacheName names must be here too.
CacheController.getCache().put("listNeighborsByCityItemFileReadStore", new HashMap<String, String>());
CacheController.getCache().put("listRestaurantPlatesFast", new HashMap<String, String>());
CacheController.getCache().put("listRestaurantHighlightPlatesFast", new HashMap<String, String>());

if(request.getParameter("cleanOrderCacheToo")!=null){
	CacheController.getCache().put("newOrderCache",new OrdersCacheEntry());
}
%>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
Cache Hits: <%=cs.getCacheHits()%>
<%@page import="java.util.HashMap"%><br/>
Cache Misses: <%=cs.getCacheMisses()%><br/>
Cache Object count: <%=cs.getObjectCount()%><br/>

