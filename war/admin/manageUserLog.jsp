<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%><%@page
	import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="br.copacabana.util.TimeController"%>

<%@page import="org.apache.tools.ant.types.TimeComparison"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.com.copacabana.cb.entities.UserActionsLog"%>
<%@page import="com.google.storage.onestore.v3.OnestoreEntity.User"%>
<%@page import="java.util.List"%>
<%@page import="javax.persistence.Query"%>
<%@page import="br.copacabana.raw.filter.Datastore"%>
<%
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM kk:mm:ss");
	sdf.setTimeZone(TimeController.getDefaultTimeZone());
	SimpleDateFormat sdf2 = new SimpleDateFormat("kk:mm:ss dd/MM/yyyy");
	sdf2.setTimeZone(TimeController.getDefaultTimeZone());
	Date start = new Date(0);
	Date end = new Date();
	String dateParam = "";

	String stepsAllows = "startedNotLogged,started,complete";

	if (request.getParameter("deleteSureSequences") != null) {
		int counter = 0;
		Query q = Datastore.getPersistanceManager().createNamedQuery("listUserActionsLogOrdered");
		HashMap<String, List<UserActionsLog>> map = new HashMap<String, List<UserActionsLog>>();

		List<UserActionsLog> list = q.getResultList();

		for (Iterator iter = list.iterator(); iter.hasNext();) {
			UserActionsLog log = (UserActionsLog) iter.next();
			if (map.get(log.getSessionId()) == null) {
				map.put(log.getSessionId(), new ArrayList());
			}
			map.get(log.getSessionId()).add(log);
		}

		for (Iterator<String> iter = map.keySet().iterator(); iter.hasNext();) {
			List<UserActionsLog> l = map.get(iter.next());
			if (l.size() == 1) {
				UserActionsLog ll = l.get(0);
				if (ll.getState().equals("startedNotLogged")) {
					Datastore.getPersistanceManager().getTransaction().begin();
					Datastore.getPersistanceManager().remove(ll);
					Datastore.getPersistanceManager().getTransaction().commit();
					counter++;
				}

			}
		}
		response.sendRedirect("manageUserLog.jsp?deletedCounter=" + counter);

	}
	if (request.getParameter("deleteOldSequences") != null) {

		int counter = 0;
		Query q = Datastore.getPersistanceManager().createNamedQuery("listUserActionsUntil");
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH,-1);
		q.setParameter("date",c.getTime());
		List<UserActionsLog> list = q.getResultList();

		for (Iterator iter = list.iterator(); iter.hasNext();) {
			UserActionsLog log = (UserActionsLog) iter.next();
			Datastore.getPersistanceManager().getTransaction().begin();
			Datastore.getPersistanceManager().remove(log);
			Datastore.getPersistanceManager().getTransaction().commit();
			counter++;
		}
		response.sendRedirect("manageUserLog.jsp?deletedCounter=" + counter);
	}

	if (request.getParameter("start") != null) {
		start = sdf2.parse(request.getParameter("start"));
		dateParam = "&start=" + request.getParameter("start") + "&end=" + request.getParameter("end");
		end = sdf2.parse(request.getParameter("end"));
	}
	request.setAttribute("dateParams", dateParam);
	List<UserActionsLog> list = null;
	Query q = null;
	if (request.getParameter("sessionId") != null) {

		if (request.getParameter("action") != null) {
			if (request.getParameter("action").equals("delete")) {
				q = Datastore.getPersistanceManager().createNamedQuery("listUserActionsLogBySessionId");
				q.setParameter("sessionId", request.getParameter("sessionId"));
				list = q.getResultList();
				Datastore.getPersistanceManager().getTransaction().begin();
				for (Iterator<UserActionsLog> iter = list.iterator(); iter.hasNext();) {
					Datastore.getPersistanceManager().remove(iter.next());
				}
				Datastore.getPersistanceManager().getTransaction().commit();
				response.sendRedirect("manageUserLog.jsp");
			}
		} else {
			q = Datastore.getPersistanceManager().createNamedQuery("listUserActionsLogBySessionIdByDate");
			q.setParameter("sessionId", request.getParameter("sessionId"));
		}

	} else if (request.getParameter("userKey") != null) {
		q = Datastore.getPersistanceManager().createNamedQuery("listUserActionsLogByUser");
		q.setParameter("userKey", request.getParameter("userKey"));

	} else {
		q = Datastore.getPersistanceManager().createNamedQuery("listUserActionsLogOrdered");

	}
	q.setParameter("start", start);
	q.setParameter("end", end);
	list = q.getResultList();
%>
<script type="text/javascript">
<!--
	var showDetalhes = function(id) {
		var el = document.getElementById(id);
		if (el.style.display == 'block') {
			el.style.display = 'none';
		} else {
			el.style.display = 'block';
		}
	}
//-->
</script>
<jsp:include page="/admin/adminHeader.jsp"></jsp:include>
Registro de ações de usuário
<br>
<c:if test="${not empty param.deletedCounter }">
Foram apagados ${param.deletedCounter} registros<br>
</c:if>
<a href="manageUserLog.jsp?deleteSureSequences=true">Apagar not
logged only</a>
<br>
<br>
<a href="manageUserLog.jsp?deleteOldSequences=true">Sequencias com
mais de 1 mês</a>
<br>
<br>
<form action="manageUserLog.jsp"><c:if
	test="${not empty param.end }">
Filtrando de <%=sdf.format(start)%><%=start%> a <%=sdf.format(end)%>
	<%=end%><Br>
</c:if> De <input type="text" name="start" value="${param.start}"> à <input
	type="text" name="end" value="${param.end}"> <input
	type="submit" value="filtrar"><br>
</form>
<table>
	<thead>
		<tr>
			<th>Data</th>
			<th>Sessao</th>
			<th>Acao</th>
			<th>Estado</th>
			<th>Usuario</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
		<%
			ClientManager cm = new ClientManager();

			for (Iterator<UserActionsLog> iter = list.iterator(); iter.hasNext();) {
				try{
				UserActionsLog log = iter.next();
				String userData = "Unknown";
				if (log.getUser() != null) {
					
					if ("CLIENT".equals(log.getKind())) {
						userData = cm.get(KeyFactory.stringToKey(log.getUser())).getUser().getLogin();
					} else {
						userData = log.getKind();
					}
				}
		%>
		<tr>
			<td><%=sdf.format(log.getDate())%></td>
			<td><a
				href="manageUserLog.jsp?sessionId=<%=log.getSessionId()%>${dateParams}"><%=log.getSessionId()%></a></td>
			<td><%=log.getAction()%></td>
			<td><%=log.getState()%></td>
			<td><a
				href="manageUserLog.jsp?userKey=<%=log.getUser()%>${dateParams}"><%=userData%></a></td>
			<td>
			<div onclick='showDetalhes("det_<%=log.getId().toString()%>")'>Detalhes</div>
			<div style="display: none" id="det_<%=log.getId().toString()%>"><%=log.getAllInfo().getValue()%></div>
			</td>
			<td><a
				href="manageUserLog.jsp?action=delete&sessionId=<%=log.getSessionId()%>"
				onclick="return confirm('certeza que quer apagar essa sessao?');">Apagar
			por Sessão</a>
		</tr>
		<%
			
			}catch(Exception e){
				%><Tr><td>Erro <%=e.getMessage() %></td></Tr><%	
			}
			}
		%>

		<tr></tr>
	</tbody>

</table>