<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Monitoracao</title>

<cb:header />

<link href="../../styles/restaurant/profile.css" type="text/css"
	rel="stylesheet" />
<link href="../../styles/restaurant/order.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="../../styles/restaurant/order_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>

<link href="../../styles/restaurant/menu.css" type="text/css"
	rel="stylesheet" />

<script type="text/javascript">
 
            djConfig = {
            	baseUrl : './',                
                modulePaths: {
                    'com.copacabana' : '/scripts/com/copacabana'
                },
                parseOnLoad: true,
                isDebug: false,
                
                usePlainJson: true,
                locale: 'pt' <%-- DO NOT change this locale for now. --%>
                   
            };
        </script>
<SCRIPT TYPE="text/javascript"
	SRC="http://ajax.googleapis.com/ajax/libs/dojo/1.3/dojo/dojo.xd.js.uncompressed.js"></SCRIPT>
<script type="text/javascript">
			dojo.require("dijit.form.Textarea");
	        dojo.require("com.copacabana.RoundedButton");	        
	        dojo.require("com.copacabana.monitor.MonitorSessionWidget");
	        dojo.require("dijit.form.FilteringSelect");
	        dojo.require("dojo.parser"); 
	        dojo.require("dojo.data.ItemFileReadStore");
	        dojo.require("dijit.form.Button");
	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.CheckBox");
	        dojo.require("dijit.Dialog");
	        dojo.require("dijit.form.TimeTextBox");
	        dojo.require("dijit.form.Button");
	        dojo.require("dijit.form.DateTextBox");
	      	        
	        function refreshTable(){
				dojo.publish("onEachMinute",[60]);
	        }	        
			dojo.addOnLoad(function() {
				setInterval ("refreshTable()",60000);
				dijit.byId
			});
			function refreshList(){
				dijit.byId('sessoes').updateList();
				
			}
</script>
</head>
<cb:body closedMenu="true">

	<jsp:include page="monitorheader.jsp"><jsp:param
			name="isSession" value="true"></jsp:param></jsp:include>
<button dojoType="dijit.form.Button" type="button" value="atualizar" onclick="refreshList()">Atualizar</button><br>
	<div dojoType="com.copacabana.monitor.MonitorSessionWidget"	id="sessoes"></div>

	
	<br>
	
</cb:body>
</html>