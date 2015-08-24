
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>

<%@page import="br.com.copacabana.cb.app.Configuration"%>
<%@include file="/static/commonScript.html" %>

<%@page import="br.copacabana.order.paypal.PayPalProperties"%>
<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@page import="br.copacabana.order.paypal.PayPalProperties.PayPalConfKeys"%><script type="text/javascript">
        

	        dojo.require("dijit.form.FilteringSelect");
	        dojo.require("dojo.parser"); 
	        

	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.CheckBox");
	        var count=0;
	        function saveAll(){
	        	count=0;
				var arr = dojo.query(".ppform");
				dojo.byId('log').innerHTML="Salvando:"+arr.length+" registros<br>";
				for ( var i = 0; i < arr.length; i++) {
					//console.log(arr[i]);
					submitForm(arr[i]);
				}
	        }
			function submitForm(formDom){
	        	 
	        	var xhrArgs = {
	                    form: formDom,
	                    handleAs: "text",
	                    load: function(data) {
	                    	//console.log(data);
	                    	count++;
	                    	console.log('salvou!',formDom);
	                    	dojo.byId('log').innerHTML=dojo.byId('log').innerHTML+count+": salvou<br>";
	                    	
	                    },
	                    error: function(error) {
	                   	 	console.error('error');
	                   	 count++;
	                   	 dijit.showTooltip("falhou salvar!", formDom.children[1]);
	                   	dojo.byId('log').innerHTML=dojo.byId('log').innerHTML+count+" erro!."+error+"<br>";
	                    }
	                }
	    		var deferred = dojo.xhrPost(xhrArgs);
	    		
	        	return false;
	        }			
	    </script>
<body class="tundra">	
<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<br/>
<%

ConfigurationManager cman = new ConfigurationManager();
PayPalProperties ppp = new PayPalProperties(cman);


%>
<input type="button" value="Salvar tudo" onclick="javascript:saveAll()"></input><br/>
<div id="log"></div>
<form action="/admin/createConf.do" method="post" class="ppform">
PayPay Url:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppUrl.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= ppp.getUrl()%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" class="ppform" method="post">
PayPay ReturnUrl:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppReturnUrl.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= ppp.getReturnUrl()%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" class="ppform" method="post">
PayPay CancelUrl:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppCancelUrl.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= ppp.getCancelUrl()%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>

<form action="/admin/createConf.do" class="ppform" method="post">
PayPay User:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppUser.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= ppp.getUser()%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" class="ppform" method="post">
PayPay Password:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppPassword.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= ppp.getPassword()%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" class="ppform" method="post">
PayPay Signature:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppSignature.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= ppp.getSignature()%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" class="ppform" method="post">
PayPay CurrencyCode:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppCurrencyCode.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= ppp.getCurrencyCode().name()%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" class="ppform" method="post">
PayPay FixedRate:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppFixedRate.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= cman.getConfigurationValue(PayPalProperties.PayPalConfKeys.pppFixedRate.name())%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" class="ppform" method="post">
PayPay Pct:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppPercentageValue.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= cman.getConfigurationValue(PayPalProperties.PayPalConfKeys.pppPercentageValue.name())%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>

<form action="/admin/createConf.do" class="ppform" method="post">
//PayPay ForwaredUrlPrefix:<input type="hidden" name="key" value="<%=PayPalProperties.PayPalConfKeys.pppForwardUrlPrefix.name() %>" readonly="readonly" /> = <input type="text" name="value" value="<%= ppp.getForwardUrlPrefix()%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>


<br/>
<hr>
</hr>
</body>