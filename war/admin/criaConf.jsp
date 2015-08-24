<%@page import="br.copacabana.spring.ConfigurationManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>

<%@page import="br.com.copacabana.cb.app.Configuration"%>

<%
EntityManagerBean em = CityIdentifier.getEntityManager(getServletContext());
ConfigurationManager cman = new ConfigurationManager();

String contactEmail="";

if(((Configuration)cman.find("contactEmail", Configuration.class))!=null){	
	contactEmail= ((Configuration)cman.find("contactEmail", Configuration.class)).getValue();
}

String defaultCityKey="";
if(((Configuration)cman.find("defaultCityKey", Configuration.class))!=null){	
	defaultCityKey= ((Configuration)cman.find("defaultCityKey", Configuration.class)).getValue();
}
String defaultCityName="";
if(((Configuration)cman.find("defaultCityName", Configuration.class))!=null){	
	defaultCityName= ((Configuration)cman.find("defaultCityName", Configuration.class)).getValue();
}


String dailyHighlightImageAlt="";
if(((Configuration)cman.find("dailyHighlightImageAlt", Configuration.class))!=null){	
	dailyHighlightImageAlt= ((Configuration)cman.find("dailyHighlightImageAlt", Configuration.class)).getValue();
}
String dailyHighlightTitle="";
if(((Configuration)cman.find("dailyHighlightTitle", Configuration.class))!=null){	
	dailyHighlightTitle= ((Configuration)cman.find("dailyHighlightTitle", Configuration.class)).getValue();
}
String dailyHighlightDesc="";
if(((Configuration)cman.find("dailyHighlightDesc", Configuration.class))!=null){	
	dailyHighlightDesc= ((Configuration)cman.find("dailyHighlightDesc", Configuration.class)).getValue();
}

String dailyHighlightImageUrl="";
if(((Configuration)cman.find("dailyHighlightImageUrl", Configuration.class))!=null){	
	dailyHighlightImageUrl= ((Configuration)cman.find("dailyHighlightImageUrl", Configuration.class)).getValue();
}

String dailyHighlightName="";
if(((Configuration)cman.find("dailyHighlightName", Configuration.class))!=null){	
	dailyHighlightName= ((Configuration)cman.find("dailyHighlightName", Configuration.class)).getValue();
}

String dailyHighlightURL="";
if(((Configuration)cman.find("dailyHighlightURL", Configuration.class))!=null){	
	dailyHighlightURL= ((Configuration)cman.find("dailyHighlightURL", Configuration.class)).getValue();
}

String weeklyHighlightImageAlt="";
if(((Configuration)cman.find("weeklyHighlightImageAlt", Configuration.class))!=null){	
	weeklyHighlightImageAlt= ((Configuration)cman.find("weeklyHighlightImageAlt", Configuration.class)).getValue();
}

String weeklyHighlightImageUrl="";
if(((Configuration)cman.find("weeklyHighlightImageUrl", Configuration.class))!=null){	
	weeklyHighlightImageUrl= ((Configuration)cman.find("weeklyHighlightImageUrl", Configuration.class)).getValue();
}


String weeklyHighlightName="";
if(((Configuration)cman.find("weeklyHighlightName", Configuration.class))!=null){	
	weeklyHighlightName= ((Configuration)cman.find("weeklyHighlightName", Configuration.class)).getValue();
}

String weeklyHighlightURL="";
if(((Configuration)cman.find("weeklyHighlightURL", Configuration.class))!=null){	
	weeklyHighlightURL= ((Configuration)cman.find("weeklyHighlightURL", Configuration.class)).getValue();
}

String weeklyHighlightTitle="";
if(((Configuration)cman.find("weeklyHighlightTitle", Configuration.class))!=null){	
	weeklyHighlightTitle= ((Configuration)cman.find("weeklyHighlightTitle", Configuration.class)).getValue();
}

String weeklyHighlightDesc="";
if(((Configuration)cman.find("weeklyHighlightDesc", Configuration.class))!=null){	
	weeklyHighlightDesc= ((Configuration)cman.find("weeklyHighlightDesc", Configuration.class)).getValue();
}

String cbNews="";
if(((Configuration)cman.find("cbNews", Configuration.class))!=null){	
	cbNews= ((Configuration)cman.find("cbNews", Configuration.class)).getValue();
}
String maxWaitingTime="";
if(((Configuration)cman.find("maxWaitingTime", Configuration.class))!=null){	
	maxWaitingTime= ((Configuration)cman.find("maxWaitingTime", Configuration.class)).getValue();
}
%>

<%@include file="/static/commonScript.html" %>

<script type="text/javascript">
        
			var defCityKey = '<%=defaultCityKey%>';
			
	        dojo.require("dijit.form.FilteringSelect");
	        dojo.require("dojo.parser"); 
	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.CheckBox");
	        dojo.require("com.copacabana.search.SearchRestaurantsWidget");
	        
	        dojo.require("com.copacabana.HighLightWidget");
	        dojo.require("com.copacabana.UserProfileWidget");
	        dojo.require("dijit.form.FilteringSelect");
	        
	        dojo.require("dijit.form.FilteringSelect");
	        dojo.require("dojo.parser"); 
	        dojo.require("dojo.data.ItemFileReadStore");
	        dojo.require("dijit.form.Button");
	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.CheckBox");
	        dojo.require("dijit.form.SimpleTextarea");
	        dojo.addOnLoad(function() {			
				var stateStore = new dojo.data.ItemFileReadStore({
	                url: "/listCitiesItemFileReadStore.do"
	            });
	            dijit.byId("citySelection").store = stateStore;
	            dijit.byId("citySelection").attr('value',defCityKey);
	            
	            console.log(dijit.byId("citySelection").attr('displayedValue'));         
			});
	        function saveCityName(){
	        	
	        	
	        	dojo.byId('cityNameVal').value=dijit.byId("citySelection").attr('displayedValue')
	        	 
	        	var xhrArgs = {
	                    form: dojo.byId('citynameform'),
	                    handleAs: "text",
	                    load: function(data) {
	                    	console.log(data);
	                    	dojo.byId('citykeyform').submit();
	                    	
	                    },
	                    error: function(error) {
	                   	 console.log('error');
	                    }
	                }
	    		var deferred = dojo.xhrPost(xhrArgs);
	    		console.log('enviado');
	        	return false;
	        }		


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
<body class="tundra"><jsp:include page="/admin/adminHeader.jsp"></jsp:include> 	
<form action="/admin/createConf.do" method="post">
Chave:<input type="text" name="key" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" dojoType="dijit.form.TextBox" /> <input type="submit" value="Create Conf" >
</form>
<br/>

<form action="/admin/createConf.do" method="post" id="citykeyform">
Default City:<input type="hidden" name="key" value="defaultCityKey"/>  
<select dojoType="dijit.form.FilteringSelect" id="citySelection" 
	name="value" autoComplete="true" invalidMessage="Invalid city name"></select>
	 <input type="button" value="Set default city" onclick="javascript:saveCityName()">
<br/>
</form>
<form action="/admin/createConf.do" method="post" id="citynameform" >
<input type="hidden" name="key" value="defaultCityName"/><input type="hidden" name="value" id="cityNameVal" dojoType="dijit.form.TextBox"   value="<%=defaultCityName %>"/> 

	 

</form>
<hr></hr>
<input type="button" value="Salvar tudo" onclick="javascript:saveAll()"></input><br/>


<div id="log"></div>
<form action="/admin/createConf.do" method="post" class="ppform">
contactEmail:<input type="hidden" name="key" value="contactEmail" readonly="readonly" /> = <input type="text" name="value" value="<%= contactEmail%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>

<form action="/admin/createConf.do" method="post" class="ppform">
cbNews:<input type="hidden" name="key" value="cbNews" readonly="readonly" /> = <textarea name="value" dojoType="dijit.form.SimpleTextarea" ><%= cbNews%></textarea> <input type="submit" value="Salvar">
</form>
<a href="/getDailyHighlight.do" target="_blank">Daily Highlight</a>

<form action="/admin/createConf.do" method="post" class="ppform">
dailyHighlightTitle:<input type="hidden" name="key" value="dailyHighlightTitle" readonly="readonly" /> = <input type="text" name="value" value="<%= dailyHighlightTitle%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" method="post" class="ppform">
dailyHighlightDesc:<input type="hidden" name="key" value="dailyHighlightDesc" readonly="readonly" /> = <input type="text" name="value" value="<%= dailyHighlightDesc%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>

<form action="/admin/createConf.do" method="post" class="ppform">
dailyHighlightImageAlt:<input type="hidden" name="key" value="dailyHighlightImageAlt" readonly="readonly" /> = <input type="text" name="value" value="<%= dailyHighlightImageAlt%>" dojoType="dijit.form.TextBox" /> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" method="post" class="ppform">
dailyHighlightImageUrl:<input type="hidden" name="key" value="dailyHighlightImageUrl" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=dailyHighlightImageUrl %>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" method="post" class="ppform">
dailyHighlightName:<input type="hidden" name="key" value="dailyHighlightName" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=dailyHighlightName %>"  dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" method="post" class="ppform">
dailyHighlightURL:<input type="hidden" name="key" value="dailyHighlightURL" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=dailyHighlightURL%>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>
<hr></hr>
<br/>
<a href="/getWeeklyHighlight.do" target="_blank">Weekly Highlight</a>

<form action="/admin/createConf.do" method="post" class="ppform">
weeklyHighlightTitle:<input type="hidden" name="key" value="weeklyHighlightTitle" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=weeklyHighlightTitle%>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>

<form action="/admin/createConf.do" method="post" class="ppform">
weeklyHighlightDesc:<input type="hidden" name="key" value="weeklyHighlightDesc" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=weeklyHighlightDesc%>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>


<form action="/admin/createConf.do" method="post" class="ppform">
weeklyHighlightImageAlt:<input type="hidden" name="key" value="weeklyHighlightImageAlt" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=weeklyHighlightImageAlt%>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" method="post" class="ppform">
weeklyHighlightImageUrl:<input type="hidden" name="key" value="weeklyHighlightImageUrl" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=weeklyHighlightImageUrl %>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" method="post" class="ppform">
weeklyHighlightName:<input type="hidden" name="key" value="weeklyHighlightName" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=weeklyHighlightName%>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>
<form action="/admin/createConf.do" method="post" class="ppform">
weeklyHighlightURL:<input type="hidden" name="key" value="weeklyHighlightURL" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=weeklyHighlightURL%>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>
<br/>
<hr>
<form action="/admin/createConf.do" method="post" class="ppform">
maxWaitingTime:<input type="hidden" name="key" value="maxWaitingTime" readonly="readonly" dojoType="dijit.form.TextBox"/> = <input type="text" name="value" value="<%=maxWaitingTime%>" dojoType="dijit.form.TextBox"/> <input type="submit" value="Salvar">
</form>


</body>