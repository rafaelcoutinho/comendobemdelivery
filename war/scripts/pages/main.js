dojo.require("com.copacabana.search.SearchRestaurantsWidget");
dojo.require("com.copacabana.search.SearchResultsManagerWidget");
dojo.require("com.copacabana.HighLightWidget");
dojo.require("com.copacabana.UserProfileWidget");
dojo.require("com.copacabana.RestaurantTypeOptionWidget");
dojo.require("com.copacabana.RestaurantWheelWidget");
dojo.require("dijit.form.Form");
dojo.require('com.copacabana.util');
dojo.require("com.copacabana.RestaurantViewWidget");
dojo.require("com.copacabana.RestPlateMenuWidget");
dojo.addOnLoad(function() {
	com.copacabana.util.showLoading();
	dojo.subscribe("onSearchBeingExecuted", removeDicas);
	dojo.subscribe("onOpenRestaurant", showRestaurant);
	dojo.subscribe("onLoggedIn", setCurrentButtons);
	foodCategoriesCache = new dojo.data.ItemFileReadStore( {
		url : "/listFoodCategoriesItemFileReadStore.do"
	});
	if (showRestaurantAtStart == true) {
		loadRestaurant(restaurantId);
	}
	com.copacabana.util.hideLoading();
	setTimeout("com.copacabana.util.showFollowUs()", 2000);
	
	
	
	
});
var showLoginDialog=function(){
	try{
		dijit.byId("loginDialog").show();
	}catch(e){
		console.error(e)
	}
}
function removeDicas() {
	var main = document.getElementById("conteudo_main");	
	main.style.display = 'none';
	var search = document.getElementById("conteudo_search");
	search.style.display = 'block';
	var restDom = document.getElementById("conteudo_restaurante");
	restDom.style.display = 'none';
	if (restView != null) {
		restView.destroy(false);
		restView.destroyDescendants(false);
		restView.destroyRecursive(false);
		restView = null;
	}
}
var foodCategoriesCache;

var loadRestaurant = function(id) {
	var xhrArgs = {
		url : "/getRestaurant.do?id=" + id,		
		handleAs : "json",
		load : function(data) {
			showRestaurant(data);
		},
		error : function(error) {
			console.error(error);
		}
	}
	var deferred = dojo.xhrPost(xhrArgs);

}
var showRestaurant = function(data) {

	if (restView != null) {
		restView.destroy(false);
		restView.destroyDescendants(false);
		restView.destroyRecursive(false);
		restView = null;
	}
	var main = document.getElementById("conteudo_main");
	main.style.display = 'none';
	// var restView = new com.copacabana.RestaurantViewWidget(data);

	var search = document.getElementById("conteudo_search");
	search.style.display = 'none';

	var restDom = document.getElementById("conteudo_restaurante");
	restDom.style.display = 'block';

	if (restView != null) {
		restView.destroy(false);
		restView.destroyDescendants(false);
		restView.destroyRecursive(false);
	}
	restView = new com.copacabana.RestaurantViewWidget(data);
	restView.setRestaurant(data);
	restView.startup();
	restView.showPanel();
	dojo.byId("restaurantView").appendChild(restView.domNode);

}
var restView = null;



var showButtons=function(className){
	var buttons = dojo.query('.'+className);
	for(var i=0;i<buttons.length;i++){
		dojo.style(buttons[i],'display','block')
	}
}
var hideButtons=function(className){
	var buttons = dojo.query('.'+className);
	for(var i=0;i<buttons.length;i++){
		dojo.style(buttons[i],'display','none')
	}
}
var setCurrentButtons=function(name,user){
	dojo.empty(dojo.byId("loginLinks"));
	if(name=='Restaurant'){		
		hideButtons("clientButtons");
		hideButtons("unknownButtons");
		showButtons("restaurantButtons");
	}else{
		if(name=='Client'){			
			hideButtons("restaurantButtons");
			hideButtons("unknownButtons");
			showButtons("clientButtons");
			if(user){
				dojo.create("span",{innerHTML:"Bem vindo "+user.name},dojo.byId("loginLinks"));
			}
		}else{			
			
			hideButtons("restaurantButtons");
			hideButtons("clientButtons");
			showButtons("unknownButtons");
		}
	}	
}

dojo.require("com.copacabana.util");


var createImgNode=function(){
	var  imageNode =  dojo.create('img',{src:dojo.moduleUrl("com.copacabana", "images/smallOrangeGrayLoader.gif"),alt:'autenticando'});

	return imageNode
}
var forwardPage =null
var logging=false;
var loginReturn=function(response){
	
	logging=false;
	var domNode= dojo.byId('loginDialog');
	var panel = dojo.query(".loginMsgs",domNode)[0];
	com.copacabana.util.cleanNode(panel);
	
	if(response.status==true){
		var uname = dijit.byNode(dojo.query(".username",domNode)[0]).attr('value');
		panel.innerHTML="Ok! Aguarde...";
		dojo.cookie("lastCBUser",uname, {
            expires: 30
        });
		if(forwardPage!=null && forwardPage!=""){
			window.location=forwardPage;
		}else{
			if (response.sessionBean.userType == "restaurant") {
				dojo.publish('onLoggedIn',['Restaurant']);
				window.location = "/restaurantPortal.jsp";
			} else if(response.sessionBean.userType == "central"){
				window.location = "/centralPortal.jsp";
			}else{
				var qdado = dojo.byId('homeRight');
				dojo.publish('onLoggedIn',['Client',response.sessionBean.entity]);
				dojo.empty(qdado);
				dojo.create("p",{innerHTML:'Bem vindo '+response.sessionBean.entity.name},qdado);
				if(response.moreInfo.pendingOrders>0 ){
						//window.location = "/clientPortal.jsp";
						dojo.create("div",{innerHTML:"Voc&ecirc; possui pedidos em execu&ccedil;&atilde;o."},qdado);
						dojo.create("a",{href:"/meusPedidos.do",innerHTML:"Veja aqui"},qdado);
					}else{
						//just replace the login template							
						dojo.create("div",{innerHTML:response.moreInfo.cbNews},qdado)
					}
					dijit.byId('loginDialog').hide()
				}
			
		}
	}else{
		if(response.authStatus=='OAUTH_FB'){
			panel.innerHTML="Sua conta est&aacute; associada ao Facebook. ";
			dojo.create("br",{},panel);
			dojo.create("span",{innerHTML:"Utilize o acesso via Facebook"},panel);
			dojo.create("br",{},panel);
			dojo.create("span",{innerHTML:"ou "},panel);
			dojo.create("a",{innerHTML:"clique aqui",onclick:"reGeneratePwd();return false;"},panel);
			dojo.create("span",{innerHTML:" para gerar uma senha nova para seu e-mail."},panel);
		}else{
			if(!response.sessionId || response.sessionId==sessionId){
				panel.innerHTML="Por favor, verifique seu usu&aacute;rio e senha.";
			}else{				
				panel.innerHTML="Sess&atilde;o expirada recarregando...";
				sessionId = response.sessionId;
				executeLogin(null);
			}
		}
		
	}

}

var executeLogin=function(isFacebook,fbuser){
	isFacebook=isFacebook!=null
	if (!isFacebook && !com.copacabana.util.checkValidFormAdv(".mandatory",dojo.byId('loginDialog'))) {
		console.log("false");
		return false;
	} else {	
		var domNode= dojo.byId('loginDialog');
		var panel = dojo.query(".loginMsgs",domNode)[0];
		com.copacabana.util.cleanNode(panel);				
		panel.appendChild(createImgNode());
		var pwdDijit = dijit.byNode(dojo.query(".password",domNode)[0]);
		var pwd=pwdDijit.attr('value')+"|"+sessionId;
		var pwdEncoded= new com.copacabana.Cripter().encode(pwd);
		var uname = dijit.byNode(dojo.query(".username",domNode)[0]).attr('value');
		uname=dojo.string.trim(uname);
		var errCallback=function(response){
			com.copacabana.util.cleanNode(panel);
			panel.innerHTML="Problemas no servidor, por favor tente novamente.";
			//console.error("Erro ao executar login...",response);
		}
		com.copacabana.util.executeLogin(uname,pwd,isFacebook,fbuser,loginReturn,errCallback);
		
		
		
		return false;
	}
}
var reGeneratePwd=function(){
	var domNode= dojo.byId('loginDialog');
	var email = dijit.byNode(dojo.query(".username",domNode)[0]).attr('value');
	
	var domNode= dojo.byId('loginDialog');
	var panel = dojo.query(".loginMsgs",domNode)[0];
	var success= function(response) {					
		panel.innerHTML="Um email foi enviado para voc&ecirc; com as instru&ccedil;&otilde;es para gerar sua senha.";
	};
	var err = function(response) {
		console.error('error to execute remider.',response);					
		panel.innerHTML="Usu&aacute;rio n&atilde;o encontrado. Por favor, verifique seu email cadastrado.";
	}
	com.copacabana.util.startPasswordRegen(email,success,err);
	
	
	
}	
var executeReminder=function(){
	var domNode= dojo.byId('loginDialog');
	var email=dijit.byNode(dojo.query("emailReminder",domNode)[0]).attr("value");
	
	var domNode= dojo.byId('loginDialog');
	var panel = dojo.query(".loginMsgs",domNode)[0];
	var scc= function(response) {					
		panel.innerHTML="Um email foi enviado para voc&ecirc; com sua senha.";
	};
	var err=function(response) {
		console.error('error to execute remider.',response);					
		panel.innerHTML="Usu&aacute;rio n&atilde;o encontrado. Por favor, verifique seu email cadastrado.";
	}
	
	com.copacabana.util.sendPasswordReminder(email,success,err);
	
	return false;
}	