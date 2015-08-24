<%@page import="br.com.copacabana.cb.entities.Neighborhood"%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">

<title>Comendo Bem!</title>
<script type="text/javascript">
 
            djConfig = {
            	baseUrl : './',                
                modulePaths: {
                    'com.copacabana' : '/scripts/com/copacabana'
                },
                parseOnLoad: true,
                isDebug: true,
                usePlainJson: true
                   
            };
        </script>
<%@include file="/static/commonScript.html" %>
<script type="text/javascript">
        
	        dojo.require("com.copacabana.search.SearchRestaurantsWidget");
	        dojo.require("com.copacabana.HighLightWidget");
	        dojo.require("com.copacabana.UserProfileWidget");
	        dojo.require("com.copacabana.RestaurantTypeOptionWidget");
	        dojo.require("com.copacabana.RestaurantWheelWidget");
	        dojo.require("dijit.form.FilteringSelect");
	        dojo.require("dojo.parser"); 
	        dojo.require("dojo.data.ItemFileReadStore");
	        dojo.require("dijit.form.Button");
	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.CheckBox");
	        
	        
	        var storeData10 = {
	                identifier: 'abbr',
	                label: 'name',
	                items: [{
	                    abbr: 'ec',
	                    name: 'Ecuador',
	                    capital: 'Quito'
	                },
	                {
	                    abbr: 'eg',
	                    name: 'Egypt',
	                    capital: 'Cairo'
	                },
	                {
	                    abbr: 'sv',
	                    name: 'El Salvador',
	                    capital: 'San Salvador'
	                },
	                {
	                    abbr: 'gq',
	                    name: 'Equatorial Guinea',
	                    capital: 'Malabo'
	                },
	                {
	                    abbr: 'er',
	                    name: 'Eritrea',
	                    capital: 'Asmara'
	                },
	                {
	                    abbr: 'ee',
	                    name: 'Estonia',
	                    capital: 'Tallinn'
	                },
	                {
	                    abbr: 'et',
	                    name: 'Ethiopia',
	                    capital: 'Addis Ababa'
	                }]
	            };


	        
	        
			dojo.addOnLoad(function() {			
				var stateStore = new dojo.data.ItemFileReadStore({
	                url: "/listCitiesItemFileReadStore.do"
	            });
	            dijit.byId("citySelection").store = stateStore;
	            
	            
	            var reloadableStore1 = new dojo.data.ItemFileReadStore({
	            	
	            	clearOnClose:true,
	            	data:{
	            		identifier:"id",
		            	label:"name",
		            	items:[
		                       {id:"1",name:"alou bla",value:"foi"},
		                       {id:"2",name:"bla",value:"foi"},
		                       {id:"3",name:"cla",value:"foi"},
		                       {id:"4",name:"clou alou",value:"foi"},
		                       {id:"34",name:"tla",value:"foi"}
		                       
		                       ]
	            	}
	                
	            });
	            reloadableStore1.clearOnClose = true;
	            reloadableStore1.close();
	            dijit.byId("mySelection").store = reloadableStore1;
	            
	            sendForm();
			});
		      

		        function sendForm() {
		            var button = dijit.byId("submitButton");

		            dojo.connect(button, "onClick", function(event) {
		                //Stop the submit event since we want to control form submission.
		                event.preventDefault();
		                event.stopPropagation();

		                //The parameters to pass to xhrPost, the form, how to handle it, and the callbacks.
		                //Note that there isn't a url passed.  xhrPost will extract the url to call from the form's
		                //'action' attribute.  You could also leave off the action attribute and set the url of the xhrPost object
		                //either should work.
		                var xhrArgs = {
		                    form: dojo.byId("myform"),
		                    handleAs: "text",
		                    load: function(data) {
		                    	console.log(data);
		                    	var entity= dojo.fromJson(data);
		                        dojo.byId("response").innerHTML = "Form posted.<br>Id:'<a href=\"getNeighbor.do?id="+entity.id+"\" target=_blank>view</a>'";
		                    },
		                    error: function(error) {
		                        //We'll 404 in the demo, but that's okay.  We don't have a 'postIt' service on the
		                        //docs server.
		                        dojo.byId("response").innerHTML = "failed to post data."+error;
		                    }
		                }
		                //Call the asynchronous xhrPost
		                dojo.byId("response").innerHTML = "Form being sent..."
		                var deferred = dojo.xhrPost(xhrArgs);
		            });
		        }
		</script>
<body class="tundra">	<jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<a href="GerenciadorBairros.jsp">Gerenciador em lote</a> | <a href="deliveryRangeBulkupdate.jsp">Gerenciador de área de entrega</a> | <a href="VisualizaBairrosNoMapa.jsp">Visualizador de área de entrega</a>  <br/>	
<h2>Cria Bairro</h2>
<form action="/admin/createNeighbor.do" id="myform">Nome: <input
	type="text" name="name"  dojoType="dijit.form.TextBox"> <br/>
	Id: <input type="text" name="id"  dojoType="dijit.form.TextBox"> <br/>
Cep: <input type="text" name="zip"  dojoType="dijit.form.TextBox"> <br/>
MapUrl: <input type="text" name="mapReferenceImageUrl"  dojoType="dijit.form.TextBox"> <br/>
<select dojoType="dijit.form.FilteringSelect" id="citySelection" 
	name="city" autoComplete="true" invalidMessage="Invalid city name"></select><br>
<button type="submit" dojoType="dijit.form.Button" id="submitButton">
Send it!</button>
</form>
<select dojoType="dijit.form.FilteringSelect" id="mySelection2"  
	name="city" autoComplete="true" invalidMessage="Invalid city name"></select>
	 <select dojoType="dijit.form.FilteringSelect" id="mySelection"  queryExpr="*\${0}*"
		name="criteria.neighbor" autoComplete="true" style="background-color: white;width: 175px;margin-bottom:5px;margin-top: 5px;" selectOnClick="true"
		invalidMessage="Bairro inv&aacute;lido"></select>	
<br/>
<div id="response"></div>
</body>