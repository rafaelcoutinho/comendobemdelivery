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
	        function loadFoodCat(){
	        	var stateStore = new dojo.data.ItemFileReadStore({
	                url: "/listFoodCategoriesItemFileReadStore.do"
	            });
	            dijit.byId("foodCategoriesSelection").store = stateStore;
	            
	        }
			dojo.addOnLoad(function() {			
				loadFoodCat();
	            sendFormCategory();
	            
			});
		      
			function sendFormCategory() {

	            var button = dijit.byId("submitFoodButton");

	            dojo.connect(button, "onClick", function(event) {
	                //Stop the submit event since we want to control form submission.
	                event.preventDefault();
	                event.stopPropagation();

	                //The parameters to pass to xhrPost, the form, how to handle it, and the callbacks.
	                //Note that there isn't a url passed.  xhrPost will extract the url to call from the form's
	                //'action' attribute.  You could also leave off the action attribute and set the url of the xhrPost object
	                //either should work.
	                var xhrArgs = {
	                    form: dojo.byId("cityform"),
	                    handleAs: "text",
	                    load: function(data) {
	                    	console.log(data);
	                    	var entity= dojo.fromJson(data);
	                        dojo.byId("response").innerHTML = "criada!";
	                        dijit.byId("chave").attr("value",entity.id);
	                        loadFoodCat();
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
			var foundCategory=function(items, request){				
				if(items[0]){					
					dijit.byId("imgUrl").attr("value",items[0].imgUrl);
					dijit.byId("name").attr("value",items[0].name);
					dijit.byId("description").attr("value",items[0].description);
					dijit.byId("chave").attr("value",items[0].id);
					if(items[0].isMainCategory=="true"){
						dojo.byId("isMainCategory").value="on";
					}else{
						dojo.byId("isMainCategory").value="off";
					}
					
				}				
			}
			var fetchFailed=function(error,req){
				alert("falhou:"+error);
			}
			var clearOldCList=function(){
				dojo.byId("cityform").reset();
			}
	        var atualizaForm=function(){
	        	var valor = dijit.byId("foodCategoriesSelection").attr("value");
	        	dijit.byId("chave").attr("value",valor);
	        	var a = dijit.byId("foodCategoriesSelection").store.fetch({
	                query: {
	                    id: valor
	                },
	                onBegin: clearOldCList,
	                onComplete: foundCategory,
	                onError: fetchFailed,
	                queryOptions: {
	                    deep: true
	                }
	            });
	        }
		</script>
		<body class="tundra"><jsp:include page="/admin/adminHeader.jsp"></jsp:include> 
<h2>Cria Categoria</h2>
<form action="/admin/createFoodCategory.do" id="cityform">
Nome: <input
	type="text" name="foodcategory.name"  id="name" dojoType="dijit.form.TextBox"> <br/>
	Descricao: <input  dojoType="dijit.form.TextBox" id="description" 
	type="text" name="foodcategory.description"> <br/>
	UrlImagem: <input  dojoType="dijit.form.TextBox"
	type="text" name="foodcategory.imgUrl" id="imgUrl" ><br/>
	&Eacute; principal: <select id="isMainCategory"  name="foodcategory.isMainCategory"><option value="on">Sim</option><option value="off" selected="selected">Nao</option> </select>
	<br/>
	id: <input
	type="text" name="foodcategory.id" id="chave" dojoType="dijit.form.TextBox"> <br/>
	
	<button type="submit" dojoType="dijit.form.Button" id="submitFoodButton">Cria Categoria</button>
</form>
<hr></hr>

<br/>
<select dojoType="dijit.form.FilteringSelect"
		id="foodCategoriesSelection" name="foodCategory" autoComplete="true"
		invalidMessage="Categoria invalida" style="width: 12em;" onchange="atualizaForm()"></select>
<div id="response"></div>

</body>