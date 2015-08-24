/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.util"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.util"] = true;
dojo.provide("com.copacabana.util");
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dojo.currency");

com.copacabana.util.moneyFormatter=function(value,sym){
	var symbol = 'R$ ';
	if(sym){
		symbol=sym;
	}
	return dojo.currency.format(value,{
		currency:'BRL',
		symbol:symbol,
		places:2
	});
};

com.copacabana.util.checkValidForm=function(cssclass,domNode) {
	if (!cssclass) {
		cssclass = ".mandatory";
	}
	var reqs = dojo.query(cssclass,domNode);	
	for ( var i = 0; i < reqs.length; i++) {
		try {
			var dreq = dijit.byNode(reqs[i]);
			if (!dreq.isValid()) {
				console.log(dreq);
				dijit.showTooltip("* Campo obrigat&oacute;rio", reqs[i]);
				return false;
			}
		} catch (e) {
			console.log(e);
		}

	}
	return true;
};
com.copacabana.util.myErrorDom=null;
com.copacabana.util.checkValidFormAdv=function(cssclass,domNode) {
	if(com.copacabana.util.myErrorDom!=null){
		dijit.hideTooltip(com.copacabana.util.myErrorDom);
		com.copacabana.util.myErrorDom=null;
	}
	if (!cssclass) {
		cssclass = ".mandatory";
	}
	var reqs = dojo.query(cssclass,domNode);	
	for ( var i = 0; i < reqs.length; i++) {
		try {
			var dreq = dijit.byNode(reqs[i]);
			if (!dreq.isValid()) {
				dijit.showTooltip("* Campo obrigat&oacute;rio", reqs[i]);
				com.copacabana.util.myErrorDom=reqs[i];
				return false;
			}
		} catch (e) {
			console.log(e);
		}

	}
	return true;
};

com.copacabana.util.parseTime=function(fullDate){
	
	var p = fullDate.lastIndexOf(' ');
	var time = fullDate.substring(p+1); 
	return time;
};
com.copacabana.util.parseDate=function(fullDate){
	
	var p = fullDate.lastIndexOf(' ');
	var date = fullDate.substring(0,p); 
	return date;
};

com.copacabana.util.trimNumber=function (s) {
	  while (s.substr(0,1) == '0' && s.length>1) { s = s.substr(1,9999); }
	  return s;
	}

com.copacabana.util.getElapsedTime=function(/*str in format HH:MM*/time,dateTimeStr,refDateStr) {
	var d = new Date();
	if(refDateStr){
		d=com.copacabana.util.getDate(refDateStr);
	}
	if(dateTimeStr){
		//check if it's waiting longer than the max limit of time
		var rdate=com.copacabana.util.getDate(dateTimeStr);	
		//console.log("date: "+ dateTimeStr+"="+ rdate);		
				
		var maxDiff = new Date();
		var maxHours = 3;
		maxDiff.setTime(maxDiff.getTime()-maxHours*60*60*1000);
		//console.log("Max:"+maxDiff);
		
		if(rdate<maxDiff){
			return '+ de '+maxHours+'h';
		}
	
	}
	var minDiff = dojo.date.difference(d,rdate,'minute');
	minDiff*=-1;
	var hours = 0;
	if(minDiff>=60){
		hours = parseInt(minDiff/60);
		minDiff = minDiff - (60*hours);
	}
//	var hour = d.getHours();
//	var minute = d.getMinutes();
//	
//	var a = time.split(":");
//	
//	
//	var pHour=(parseInt(com.copacabana.util.trimNumber(a[0])));
//	var pMinute=(parseInt(com.copacabana.util.trimNumber(a[1])));
//	if(hour<pHour){
//		hour+=24;
//	}
//	
//	var hourDiff = hour-pHour;
//	var mmStr=(((minute)-pMinute));
//	//if(hourDiff>0){
//		//hourDiff--;
//		if(mmStr<0){
//			mmStr+=60;
//		}
//	//}
	
	if(minDiff<10){
		minDiff="0"+minDiff;
	}
	return hours+":"+minDiff;
	
}
com.copacabana.util.getDate=function(dateTimeStr){
	var dateStr = com.copacabana.util.parseDate(dateTimeStr);
	var dateA=dateStr.split('/');
	
	var day = parseInt(com.copacabana.util.trimNumber(dateA[0]));
	var month = parseInt(com.copacabana.util.trimNumber(dateA[1]));
	var year = parseInt(com.copacabana.util.trimNumber(dateA[2]));
	
	var timeStr = com.copacabana.util.parseTime(dateTimeStr);
	var timeA=timeStr.split(":");
	var hour = parseInt(com.copacabana.util.trimNumber(timeA[0]));
	var minute = parseInt(com.copacabana.util.trimNumber(timeA[1]));
	return new Date(year, month-1, day, hour, minute, 0, 0);

}
var dialogAjax=null;

com.copacabana.util.showLoading=function(txt){
	if(dialogAjax==null){
		dialogAjax = new dijit.Dialog({			
			templateString:null,			
			templateString:"<div class=\"dijitDialog\" tabindex=\"-1\" waiRole=\"dialog\" waiState=\"labelledby-${id}_title\"  style=\"width:233px;height:32px;\">\r\n    <div dojoAttachPoint=\"titleBar\" class=\"dijitDialogTitleBar\" style=\"display:none\">\r\n    <span dojoAttachPoint=\"titleNode\" class=\"dijitDialogTitle\" id=\"${id}_title\">${title}</span>\r\n    <span dojoAttachPoint=\"closeButtonNode\" class=\"dijitDialogCloseIcon\" dojoAttachEvent=\"onclick: onCancel\">\r\n        <span dojoAttachPoint=\"closeText\" class=\"closeText\">x</span>\r\n    </span>\r\n    </div>\r\n        <div dojoAttachPoint=\"containerNode\" class=\"dijitDialogPaneContent\" style=\"text-align:center;background-repeat:no-repeat;background-image: url('/resources/img/barra_vermelha.png');color: white;font-size: medium;font-weight: bold;\"><img src='/resources/img/loading.gif' style=\"float: left;\"></img><span dojoAttachPoint=\"loadingtxt\" style=\"color:white\">a</span></div>\r\n</div>\r\n",
			duration:500				
		});		
	}
	if(txt && txt.length>0){
		dialogAjax.loadingtxt.innerHTML=txt;
	}else{
		dialogAjax.loadingtxt.innerHTML="Carregando...";
	}
	
	dialogAjax.show();
};
com.copacabana.util.hideLoading=function(){
	dialogAjax.hide();	
};

com.copacabana.util.cleanNode=function(node){
	try{
	while(node.hasChildNodes()){
		node.removeChild(node.childNodes[0]);
	}}
	catch (e) {
console.log('Failed to clean Ndoe '+node,e);
	}
};
com.copacabana.util.closeWarning=function(id){
	var url = "/msgRead.do?id=" + id;
	dijit.hideTooltip(dojo.byId('msgHandler'));
	var xhrArgs = {
		url : url,
		handleAs : "text",
		load : function(data) {
			
		},
		error : function(error) {
			console.log("failed to change msg status." ,error);
		}
	}
	var deferred = dojo.xhrGet(xhrArgs);
	
};
com.copacabana.util.acceptTerms=function(id){
	var url = "/msgRead.do?id=" + id;
	dialogs[id].hide();
	//dialogs[id].shutdown();
	var xhrArgs = {
		url : url,
		handleAs : "text",
		load : function(data) {
			
		},
		error : function(error) {
			console.log("failed to change msg status." ,error);
		}
	}
	var deferred = dojo.xhrGet(xhrArgs);	

}
var dialogs=[];
com.copacabana.util.warning=function(id,msgText,msgType){
	var msgPos=dojo.byId('msgHandler');
	
	if(msgPos==null){  
		msgPos = dojo.create('div',{id:'msgHandler',style:{zIndex:-100,height:'50%',position:'absolute',top:'0px',width:'50%'}},dojo.body());
	}
	
	
	if(msgType){
		switch (msgType) {
		case "CONFIRM_EMAIL":
			msgText+='<div onClick="com.copacabana.util.closeWarning(\''+id+'\')" class="closeButton">Fechar</div>'
			dijit.showTooltip(msgText, msgPos,['after']);
			break;
		case "NORMAL":
			msgText+='<div onClick="com.copacabana.util.closeWarning(\''+id+'\')" class="closeButton">Fechar</div>'
			dijit.showTooltip(msgText, msgPos,['after']);
			break;
		case "ACCEPT_TERMS":
			msgText+='<div onClick="com.copacabana.util.acceptTerms(\''+id+'\')" class="closeButton">Aceitar</div>'
			var options = {
					title : 'Termos de uso do site ComendoBem',
					style : 'width: 600px;height:460px;',
					closable:false,
					content: msgText,
					onHide:com.copacabana.util.refuseTerms
						
			};
			var dialog = new dijit.Dialog(options);
			dialog.onClose=com.copacabana.util.refuseTerms;
			dialog.onUnload=com.copacabana.util.refuseTerms;
			dialog.show();
			dialogs[id]=dialog;
			
			break;

		default:
			break;
		}
	} else {
		
		dijit.showTooltip(msgText, msgpos);
		
	}
};
com.copacabana.util.refuseTerms=function(id){	
	var msg = new com.copacabana.MessageWidget();
	msg.showMsg('O site ComendoBem s&oacute; pode ser acessado se voc&ecirc; concordar com os termos de uso, caso contr&aacute;rio contacte o ComendoBem.');	
	return false;	
};
com.copacabana.util.blink =function(node){
    dojo.fadeOut ({
                    node:node,
                    duration:3000
                 }).play();
    	dojo.fadeIn ({
                    node:node,
                    duration:3000
                 }).play()
   };
   
com.copacabana.util.createFacebookButtonCurrent=function(parentNode,urlArg){
	var url = window.location;
	if(urlArg){
		url=urlArg;
	}
	var fullurl ='http://www.facebook.com/plugins/like.php?href='+url;
	fullurl+='&locale=pt_BR&';
	fullurl+='layout=button_count&show_faces=true&width=110&action=recommend&colorscheme=light&height=21';
	
	var style={border: '0px none', overflow: 'hidden', width: '120px', height: '21px'};
	var allowtransparency="true"; 
	var scrolling="no";
	var frameborder="0";
	
	var args = {src:fullurl, style:style,allowtransparency:allowtransparency,scrolling:scrolling,frameborder:frameborder,width:120};
	var button = dojo.create('iframe',args,parentNode);
	return button;
   //<iframe src="http://www.facebook.com/plugins/like.php?href=http://www.comendobem.com.br&amp;layout=button_count&amp;show_faces=false&amp;width=450&amp;action=recommend&amp;colorscheme=light&amp;locale=pt_BR&amp;ref=aaa&amp;height=21" style="border: medium none; overflow: hidden; width: 450px; height: 21px;" allowtransparency="true" scrolling="no" frameborder="0"></iframe>
};

com.copacabana.util.phoneFormat=function(){ 
	
	//return '\\(?[0]?\\d{2}\\)?\\s?\\d{4}[\\-,\\.]?\\d{4}';
	return '(\\(?[0]?\\d{2,3}\\)?\\s?)?\\d{4}[\\-,\\.,\\s]?\\d{4}'; 
	
	
};
com.copacabana.util.emailFormat=function(){ 
	
	return '\\b[a-z0-9._%-]+@[a-z0-9.-]+\\.[a-z]{2,4}\\b';
};

com.copacabana.util.cepFormat=function(){ 
	
	return '[0-9]{2}\.?[0-9]{3}\\-?[0-9]{0,3}';
}

com.copacabana.util.isCpfValid=function(cpf){
	
	cpf=cpf.replace(/\./g,'');
	cpf=cpf.replace(/\-/g,'');
		
	if (cpf.length != 11 || cpf == "00000000000" || cpf == "11111111111" || cpf == "22222222222" || cpf == "33333333333" || cpf == "44444444444" || cpf == "55555555555" || cpf == "66666666666" || cpf == "77777777777" || cpf == "88888888888" || cpf == "99999999999"){
		return false;
	}
	var soma = 0;
	for (i=0; i < 9; i ++)
		soma += parseInt(cpf.charAt(i)) * (10 - i);
	var resto = 11 - (soma % 11);
	if (resto == 10 || resto == 11)
		resto = 0;
	if (resto != parseInt(cpf.charAt(9)))
		return false;
	soma = 0;
	for (i = 0; i < 10; i ++)
		soma += parseInt(cpf.charAt(i)) * (11 - i);
	resto = 11 - (soma % 11);
	if (resto == 10 || resto == 11)
		resto = 0;
	if (resto != parseInt(cpf.charAt(10)))
		return false;
	return true;

};

com.copacabana.util.cacheFoodCat=function(items,request){
	var store=request.store;
	var dataitems =[];
	for ( var i = 0; i < items.length; i++) {
		
	
		dataitems.push({
				id:store.getValue(items[i], "id"),
				isMainCategory:store.getValue(items[i], "isMainCategory"),
				imgUrl:store.getValue(items[i], "imgUrl"),
				name:store.getValue(items[i], "name"),
				description:store.getValue(items[i], "description")
		}
		);
		
	}
	console.log("caching categories",dataitems);
	
	//dojo.cookie('foodCatCache',dojo.toJson(dataitems),{expire:1});
};
com.copacabana.util.loadFoodCats=function(){
//	try{
//		var cache = dojo.fromJson(dojo.cookie('foodCatCache'));
//		console.log(cache);
//		if(cache!=null){
//			console.log("categories cache hit!",dataitems);
//			return new dojo.data.ItemFileReadStore(
//					{
//						data:{
//							identifier:"id", 
//							label: "name", 
//							items: cache
//						}
//					});	
//		}
//	}catch (e) {
//		
//	}
	dojo.cookie('foodCatCache',{},{expire:-1});
	var ifstore= new dojo.data.ItemFileReadStore({
        url: "/listFoodCategoriesItemFileReadStore.do"
    });	
	var sort = [{attribute: "name", descending: true}];
	ifstore.fetch({onComplete: com.copacabana.util.cacheFoodCat, onError: function(err){console.error(err)},sort:sort});
	
	
	return ifstore;	
};
com.copacabana.util.showFollowUs=function(){
	/*if(dojo.cookie("hasShownToday")=="TRUE"){
		//return;	
	}
	dojo.cookie("hasShownToday", "TRUE", {
        expires: 1
    });
	var msgPos=dojo.byId('followHandler');
	msgPos=dojo.create('div',{id:'followHandler',style:{marginTop:"-60px", marginLeft:"190px"}},dojo.byId('logo'));
	console.log('a0')
	//'<a href="http://twitter.com/share" class="twitter-share-button" data-text="Gostei de fazer pedidos pela internet usando o ComendoBem" data-count="horizontal" data-via="comendobem_camp">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>'
	msgText='<div style="height:20px"><a href="http://twitter.com/share" class="twitter-share-button" data-url="www.comendobem.com.br" data-text="Encontrei o Maghalita no http://www.comendobem.com/" data-count="horizontal" data-via="comendobem_camp">Tweet</a><ul class="followUsList" style="float:none"><li class="btnLabel">Compartilhe: </li><li style="float: left;"><a href="http://twitter.com/share" class="twitter-share-button" data-url="www.comendobem.com.br" data-text="Encontrei o Maghalita no http://www.comendobem.com/" data-count="horizontal" data-via="comendobem_camp">Tweet</a></li><li style="float: left;"><a  rel="nofollow" class="addBtn facebookBtn" href="http://www.facebook.com/share.php?u=http://www.comendobem.com.br/" onclick="window.open(this.href,\'fb\',\'location=1,status=1,scrollbars=1,width=900,height=400\'); return false;"></a></li></ul></div>';
	//dijit.showTooltip(dojo.byId('tuit').innerHTML, msgPos,['after']);*/	
};
com.copacabana.util.showSuccessAction=function(txt){
	if(!txt){
		txt="Dados salvos";
	}
	com.copacabana.util.showLoading(txt);
	setTimeout(com.copacabana.util.hideLoading,1000);
}

com.copacabana.util.toolTip=null;
com.copacabana.util.showTimedMessage=function(txt,dom,time,position){
	com.copacabana.util.hideTimedMessage();
	com.copacabana.util.toolTip=dom;
	if(!position){
		position=['after'];
	}
	dijit.showTooltip(txt,dom,position);
	setTimeout(com.copacabana.util.hideTimedMessage,time);
};
com.copacabana.util.hideTimedMessage=function(){
	if(com.copacabana.util.toolTip!=null){
		dijit.hideTooltip(com.copacabana.util.toolTip);
	}
};
com.copacabana.util.startPasswordRegen=function(email,callback,errorCallback){
var xhrArgs = {
		content: {email:email},
		url:'/dispararGeracaoSenha.do',
		handleAs: "text",
		load : function(response) {					
			callback(response);
		},
		error: function(response) {
			 errorCallback(response);			
		}
};
//
var deferred = dojo.xhrPost(xhrArgs);
};
com.copacabana.util.sendPasswordReminder=function(email,callback,errorCallback){
	var xhrArgs = {
			content: {email:email},
			url:'/lembreteSenha.do',
			handleAs: "text",
			load : function(response) {					
				callback(response);
			},
			error: function(response) {
				 errorCallback(response);			
			}
	};
	//
	var deferred = dojo.xhrPost(xhrArgs);
};
com.copacabana.util.executeLogin=function(uname,pwd,isFacebook,fbuser,successCallback,errorCallback){
	var counter=0;
	var pwdEncoded = new com.copacabana.Cripter().encode(pwd);
	var dataToServer = {login:uname,password:pwdEncoded,isMD5:true,isFacebook:isFacebook};
	if(fbuser!=null){
		dataToServer.fbuser=dojo.toJson(fbuser)
	}

	var xhrArgs = {
		content: dataToServer,
		url:'/authenticateNoSSL.do',
		handleAs: "json",
		load : function(response){successCallback(response)},
		error: function(response) {							
			if(!response.sessionId || response.sessionId==sessionId){				
					if(response.authStatus=='MUSTRETRY' && this.counter<3){
						counter++;
						//panel.innerHTML="Contactando facebook...";									
						//executeLogin(null);
					}else{
						counter=0;
						logging=false;
						//com.copacabana.util.cleanNode(panel);
						//panel.innerHTML="Problemas no servidor, por favor tente novamente.";
						//console.error("Erro ao executar login...",response);
						errorCallback();
					}								
			}else{				
				counter=0;
				//panel.innerHTML="Sess&atilde;o expirada recarregando...";
				sessionId = response.sessionId;
				com.copacabana.util.executeLogin(uname,pwd,isFacebook,fbuser,successCallback,errorCallback);
				//executeLogin(null);
			}
			
		}
	};

var deferred = dojo.xhrPost(xhrArgs);
};
com.copacabana.util.deliveryRangeCache={};
com.copacabana.util.loadDeliveryRange=function(restId,callback,errorFct){
	if(com.copacabana.util.deliveryRangeCache[restId]!=null){
		callback(com.copacabana.util.deliveryRangeCache[restId]);
	}else{
		var url = "/listDeliveryRangeForRestaurant.do?key="	+restId;
		var xhrArgs = {
			url : url,
			handleAs : "text",
			load : function(data){
				var entity = dojo.fromJson(data);
				com.copacabana.util.deliveryRangeCache[restId]=entity;
				callback(entity);
			},
			error : function(error) {
					console.error("Failed to load delivery Range ",error);
					errorFct(error);
				}
		};
		var deferred = dojo.xhrPost(xhrArgs);	
	}
	
};

}
