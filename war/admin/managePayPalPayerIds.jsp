<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.copacabana.spring.UserBeanManager"%>
<%@page import="br.com.copacabana.cb.entities.Central"%>
<%@page import="br.com.copacabana.cb.entities.mgr.CentralManager"%>
<%@page import="java.util.List"%>
<%@page import="br.copacabana.AuthenticationController"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.com.copacabana.cb.entities.UserBean"%>
<%@page import="java.util.Iterator"%><jsp:include
	page="/admin/adminHeader.jsp"></jsp:include>
<%


ConfigurationManager confman = new ConfigurationManager();

if ("save".equals(request.getParameter("action"))) {
	String larger = request.getParameter("ppblacklist");
	
	StringBuilder largerStr = new StringBuilder();
	largerStr.append(confman.getConfigurationExtendedValue("ppblacklist"));
	largerStr.append(larger).append("|");
	
	confman.createOrUpdateExtended("ppblacklist", largerStr.toString());
	
	String larger2 = request.getParameter("ppblacklistDesc");
	StringBuilder largerStr2 = new StringBuilder();
	largerStr2.append(confman.getConfigurationExtendedValue("ppblacklistDesc"));
	largerStr2.append(larger2).append("|");
	
	confman.createOrUpdateExtended("ppblacklistDesc", largerStr2.toString());
}
if ("remove".equals(request.getParameter("action"))) {
	String largerConf = confman.getConfigurationExtendedValue("ppblacklist");
	String[] pids = largerConf.split("\\|");
	String descsConf = confman.getConfigurationExtendedValue("ppblacklistDesc");
	String[] descs = descsConf.split("\\|");
	StringBuilder descStr = new StringBuilder();
	StringBuilder pidStr = new StringBuilder();
	for (int i=0;i<pids.length;i++) {
		if(!pids[i].equals(request.getParameter("pid"))){
			descStr.append(descs[i]).append("|");
			pidStr.append(pids[i]).append("|");
		}
	}
	confman.createOrUpdateExtended("ppblacklist", pidStr.toString());
	confman.createOrUpdateExtended("ppblacklistDesc", descStr.toString());
	
}
String largerConf = confman.getConfigurationExtendedValue("ppblacklist");
String labelConf = confman.getConfigurationExtendedValue("ppblacklistDesc");	
	


	
%> current list: <%=largerConf%> <bR>
 current label: <%=labelConf%> <bR>

<br />
<br />
PayerIds suspeitos<br/>
<form action="managePayPalPayerIds.jsp">
<input type="hidden" name="action" value="save">
	<input type="text" name="ppblacklist" value="">:<input type="text" name="ppblacklistDesc" value=""><br>
	<input type="submit"></form>
	<%
	if(largerConf.length()>0){
	String[] pids = largerConf.split("\\|");
	String[] labelConfs = labelConf.split("\\|");
	for (int i=0;i<pids.length;i++) {
		System.out.println(pids[i]);
	%>
	<%=pids[i] %>: <%=labelConfs[i] %> <a href="managePayPalPayerIds.jsp?action=remove&pid=<%=pids[i] %>">remover</a><br>
	<%
		}
	}		
	%>



<br />

<br />
<br>
