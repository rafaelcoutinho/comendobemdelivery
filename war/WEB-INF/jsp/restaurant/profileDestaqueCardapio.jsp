<%@page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@page import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.highlight.HighlightBean"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Destaques Restaurante</title>

<cb:header />
<style>

.statusPlate{
color: red;
font-weight: bold;
}
</style>
<link href="/styles/restaurant/profile.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/restaurant/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
	<link href="/styles/restaurant/profile_ie_8.css" type="text/css"
		rel="stylesheet" />
</c:if>

<link href="/styles/restaurant/menu.css" type="text/css"
	rel="stylesheet" />

<%@include file="/static/commonScript.html"%>
<%
Enumeration enume= request.getAttributeNames();
while(enume.hasMoreElements()){
	System.out.println(enume.nextElement());
}
HighlightBean hbean = (HighlightBean)request.getAttribute("command");
List<FoodCategory> mainFoodCats = (List<FoodCategory>)request.getAttribute("mainFoodCats");

%>
<script type="text/javascript">
			dojo.require("dojo.data.ItemFileReadStore");
			dojo.require('dijit.form.FilteringSelect');
			dojo.require("dijit.form.Form");
			dojo.require("dijit.form.Button");
			dojo.require("com.copacabana.util");
			var foodCategories;
			
			var mainFoodCats=[<%
    		for(Iterator<FoodCategory> iter = mainFoodCats.iterator();iter.hasNext();){
    			FoodCategory fc = iter.next();
    		  %>{name:'<%=fc.getName()%>',id:'<%=KeyFactory.keyToString(fc.getId())%>'}<%
    			if(iter.hasNext()){
    				%>,<%
    			}
    		}
    		  %>];
			
			var currHighCats=[<%
             for(int i =0;i<hbean.getCategories().length;i++){
          	   out.print("'"+KeyFactory.keyToString(hbean.getCategories()[i])+"'");
					if(i<hbean.getCategories().length-1){
						out.print(",");	
					}
				   	
             }
			%>];
			var currHighPlate=[<%
			                   for(int i =0;i<hbean.getPlates().length;i++){
			                  	   out.print("'"+KeyFactory.keyToString(hbean.getPlates()[i])+"'");
			        					if(i<hbean.getPlates().length-1){
			        						out.print(",");	
			        					}
			        				   	
			                     }
			        			%>];
			
			dojo.addOnLoad(function() {	
				//com.copacabana.util.showLoading();
				refreshPlateList();
				foodCategories=new dojo.data.ItemFileReadStore(
						{
							data:{
								identifier:"id", 
								label: "name", 
								items: mainFoodCats
							}
						});	
				var sortAttributes = [{attribute: "name", descending: false}];
			    var completed =function (items, findResult){			    	
			    	var store = new dojo.data.ItemFileReadStore({data: { identifier: "id",
			    		items:mainFoodCats }});			    	
			    	dijit.byId("foodCat1").store = store;
			    	dijit.byId("foodCat2").store = store;
			    	dijit.byId("foodCat3").store = store;
			    	
			    	updateCurrentVals(currHighCats,[]);
			    	
			    }
			    var error = function (errData, request){
			    	  console.log("Failed in sorting data.",errData);
			    	  
			      	
			    	}
			    foodCategories.fetch({onComplete: completed, onError: error, sort: sortAttributes});
				
			});
			updateCurrentVals=function(vals,plates){
				console.log('cats',vals)
				for(var i=0;i<vals.length;i++){					
					dijit.byId("foodCat"+(i+1)).attr('value',vals[i]);
				}
				console.log("plates",plates);
				for(var i=0;i<plates.length;i++){
					console.log('setting ps '+plates[i])
					dijit.byId("plate_"+(i+1)).attr('value',plates[i]);
				}	
			}
			var store;
			var refreshPlateList=function(){
				store = new dojo.data.ItemFileReadStore( {
					url : "/restPlateList.do?key="+loggedRestaurant.id
				});	
				store.clearOnClose=true;
				loadedPlates(store);
				return;
				var xhrArgs = {
						url : "/restPlateList.do?key="+loggedRestaurant.id,								
						handleAs : "json",
						load : loadedPlates,
						error : function(error) {
					console.error("cannot load plates.",error)
				}
				}
				var deferred = dojo.xhrPost(xhrArgs);

			}
			var availablePlates = [];
			var totalPlate=5;
			var loadedPlates=function(data){
				var sortAttributes = [{attribute: "title", descending: false}];
				var queryData= {
	                query: {"isExtension":false},
	                queryOptions: {},
	                sort: sortAttributes,
	                onBegin: function(){availablePlates=[]},
	                onComplete: function(items, request){
	                	for (i = 0; i < items.length; i++) {
	                        var item = items[i];	                        
	                        availablePlates.push(
	                        {
	                        	id:store.getValue(item, "id"),
	                        	title:store.getValue(item, "title"),
	                        	'img':'<img src="'+store.getValue(item, "imageUrl")+'.small" />'+store.getValue(item, "title")
	                        }		
	                        );
	                        console.log(store.getValue(item, "title"));	                        
	                    }
	                	store=new dojo.data.ItemFileReadStore({
    						data:{
    							'identifier':'id',
    							'label':'title',
    							
    							'items':availablePlates
    						}
	                	});	
	                	
	                	
	                	console.log('bom',availablePlates);
	                	for(var i=1;i<=totalPlate;i++){
	                		
	    					dijit.byId("plate_"+i).store= store;  
	    					
	    					//dijit.byId("plate_"+i).store.clearOnClose = true;			
	    					//dijit.byId("plate_"+i).store.close();
	    				}
	                	updateCurrentVals([],currHighPlate);
	                	//com.copacabana.util.hideLoading();
	                },
	                onError: function(err){console.error(err)}
	            };
				
				data.fetch(queryData);
				
				
			
				
				
				for(var i=1;i<=totalPlate;i++){
				//	dijit.byId("plate_"+i).store=store;
					
				}
            	//updateCurrentVals([],currHighPlate);
            	
								
			}
		/*	updateRestaurante=function(id){
				console.log(id);
				var args = {
						identity: id,  
						onItem :refreshPlate,
						onError : function(item, request) {
									console.error(item);
								}
				};
				store.fetchItemByIdentity(args);
			}*/
			refreshPlate=function(data,domId){
				console.log(data);
				//dojo.byId(domId).innerHTML=data.title;
			}
			updatePlate=function(id,domId){
				console.log("updatePlate id:",id);
				return;
				var fct=function(data){
					refreshPlate(data,domId);
				}
				if(id!=null && id!=''){
					var args = {
							identity: id,  
							onItem :fct,
							onError : function(item, request) {
								console.error(item);
							}
					};
					store.fetchItemByIdentity(args);
				}
			}
			submitForm=function(){
				dojo.byId('mainForm').submit();
			}
		  </script>
<style>
</style>
</head>
<cb:body closedMenu="true">


	<jsp:include page="restheader.jsp"><jsp:param
			name="isMenu" value="true"></jsp:param></jsp:include>

	<div id="dadosCardapio">
<form action="atualizaDestaqueCardapio.do" method="post" id="mainForm">
	<div id="cardapio" style="margin-bottom:40px">
	<h2>Categorias de destaque</h2>
	Selecione até 3 categorias de destaque do seu estabelecimento, estas definem em qual categoria seu estabelecimento será encontrado no site:<br/><br/>
	<select dojoType="dijit.form.FilteringSelect" 
		id="foodCat1" name="categories" autoComplete="true" selectOnClick="true"
		invalidMessage="Categoria inv&aacute;lida" style="width: 12em;"></select>
		<select dojoType="dijit.form.FilteringSelect"
		id="foodCat2" name="categories" autoComplete="true" selectOnClick="true"
		invalidMessage="Categoria inv&aacute;lida" style="width: 12em;"></select>
		<select dojoType="dijit.form.FilteringSelect"
		id="foodCat3" name="categories" autoComplete="true" selectOnClick="true"
		invalidMessage="Categoria inv&aacute;lida" style="width: 12em;"></select>
		<br/>
		<hr>
		<h2>Produtos de destaque</h2>
		Selecione até 5 produtos de destaque do seu estabelecimento, estes serão os produtos apresentados no topo de seu menu de produtos:<br/><br/>
		<style>
		.plateSelection{
		width: 500px;
		}
		</style> 
		<table>
		<tr><td>Produto 1</td><td><select dojoType="dijit.form.FilteringSelect" selectOnClick="true" queryExpr="*\${0}*"
		id="plate_1" name="plates" autoComplete="false" onChange="updatePlate" searchAttr="title" labelAttr="title"
		invalidMessage="Produto inv&aacute;lido" class="plateSelection" ></select></td>
		<td><div id="plate_1_desc"></div></td>
		</tr>
		<tr><td>Produto 2</td><td><select dojoType="dijit.form.FilteringSelect" selectOnClick="true" queryExpr="*\${0}*"
		id="plate_2" name="plates" autoComplete="false" onChange="updatePlate" searchAttr="title" labelAttr="title"
		invalidMessage="Produto inv&aacute;lido" class="plateSelection" ></select></td>
		<td><div id="plate_2_desc"></div></td>
		</tr>
		<tr><td>Produto 3</td><td><select dojoType="dijit.form.FilteringSelect" selectOnClick="true" queryExpr="*\${0}*"
		id="plate_3" name="plates" autoComplete="false" onChange="updatePlate" searchAttr="title" labelAttr="title" 
		invalidMessage="Produto inv&aacute;lido" class="plateSelection" ></select></td>
		<td><div id="plate_3_desc"></div></td>
		</tr>
		<tr><td>Produto 4</td><td><select dojoType="dijit.form.FilteringSelect" selectOnClick="true" queryExpr="*\${0}*"  
		id="plate_4" name="plates" autoComplete="false" onChange="updatePlate" searchAttr="title" labelAttr="title"
		invalidMessage="Produto inv&aacute;lido" class="plateSelection" ></select></td>
		
		<td><div id="plate_4_desc"></div></td>
		</tr>
		<tr><td>Produto 5</td><td><select dojoType="dijit.form.FilteringSelect" selectOnClick="true" queryExpr="*\${0}*"
		id="plate_5" name="plates" autoComplete="false" onChange="updatePlate" searchAttr="title" labelAttr="title"
		invalidMessage="Produto inv&aacute;lido" class="plateSelection" ></select></td>
		<td><div id="plate_5_desc"></div></td>
		</tr>
				
		</table>
	</div>
	<div id="categoria"></div>

	<ul class="menu">
		<li><a href="/cardapio.do">Produtos</a></li>
		<li ><a href="/cardapioAlmoco.do">Exclusivo almo&ccedil;o</a></li>
		<li  class="selecionado"><a href="/destaqueCardapio.do">Destaques</a></li>
	</ul>
	</div>
	<div id="barraEmbaixo" class="fundoCinza barraSalvar"><a
		href="javascript:submitForm()" id="submitButton"> <img
		src="/resources/img/btSalvar.png" alt="salvar" /> </a></div>
	<div id="response"></div>
	</form>
</cb:body>
</html>