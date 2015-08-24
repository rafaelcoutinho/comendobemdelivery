dojo.provide("com.copacabana.order.ViewOrderDetailsWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.Dialog");
dojo.require("com.copacabana.util");

// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana.order",
		"ViewOrderDetailsWidgetStrings");

dojo.declare("com.copacabana.order.ViewOrderDetailsWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nStrings : null,
	templatePath : dojo.moduleUrl("com.copacabana.order",
			"templates/ViewOrderDetailsWidget.html"),
	constructor : function() {

	},
	
	eachMinuteHandler:null,
	handlers:[],
	destroyRecursive : function() {
		try{
		dojo.unsubscribe(this.eachMinuteHandler);
		for ( var i = 0; i < this.handlers.length; i++) {
			dojo.disconnect(this.handlers[i]);
		}
		
		dojo.forEach(this.getDescendants(), function(widget) {
			widget.destroyRecursive();
		});
		this.dialog.destroyRecursive();
		this.inherited(arguments);
		}catch(e){
			console.error("destroy recursive, view order details.",e);
		}
	},
	order : null,

	postMixInProperties : function() {
		this.inherited(arguments);
	},

	postCreate : function() {		
		this.inherited(arguments);
		this.handlers=[];
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.order","ViewOrderDetailsWidgetStrings");
		dojo.parser.parse(this.domNode);
		var dtitle = this.i18nStrings.orderDetailsTitle;
		var options = {
			title : dtitle,
			style : 'width: 600px;height:460px;'
			
		};
		this.dialog = new dijit.Dialog(options);
		this.dialog.containerNode.appendChild(this.domNode);
	},
	onClose:function(evt){
		console.log("onclose ",evt);
	},
	dialog : null,
	userView:false,
	addressDataLoadFail:function(error){
		console.error("failed to load rest data.",error);
		var msg = new com.copacabana.MessageWidget();
		msg.showMsg(this.i18nStrings.loadAddressFailed);
	},
	addressDataLoaded:function(data){
		var address=data.street+" "+data.number +","+data.additionalInfo+", "+data.neighborhood.name; 
		if(!data.additionalInfo||data.additionalInfo==''){
			 address=data.street+" "+data.number +", "+data.neighborhood.name;
		}
		
		var phone = data.phone;
		if(!phone){
			phone=this.orderDetails.clientPhone;
		}
		if(this.userView==true){
			if(this.orderDetails.retrieveAtRestaurant==true){
				console.log(dojo.query('.addressLabel',this.domNode)[0]);
				dojo.query('.addressLabel',this.domNode)[0].innerHTML=this.i18nStrings.retrieveAtRestaurant;	
			}
			this.fillAddress(address,phone);
		}else{
			if(this.orderDetails.retrieveAtRestaurant==true){				
				dojo.query('.addressLabel',this.domNode)[0].innerHTML=this.i18nStrings.restaurantRetrieveAtRestaurant;	
			}else{
				this.fillAddress(address,phone);
			}
		}
		 
		
		this.formattedAddress=address;
		this.addressPhone=phone;
		
	},
	addressPhone:null,
	formattedAddress:null,
	hideloading:function(){
		dojo.style(dojo.query(".loadingSection",this.domNode)[0],'display','none');
	},
	fillAddress:function(address,phone){
		
		dojo.query(".addressPlace",this.dialog.containerNode)[0].innerHTML=address;		
		dojo.query(".telAddressPlace",this.dialog.containerNode)[0].innerHTML='Tel:'+phone;
		
	},
	loadAddress:function(addressId){

		var xhrParams = {
				error : dojo.hitch(this, "addressDataLoadFail"),
				handleAs : 'json',
				load : dojo.hitch(this, "addressDataLoaded"),
				url : '/loadAddress.do?id='+addressId
		};
		dojo.xhrGet(xhrParams);
	},
	
	updateDialog:function(){
		if(this.userView==false && this.order.dailyCounter && this.order.dailyCounter>0){
			dojo.query(".orderNum",this.dialog.containerNode)[0].innerHTML=this.order.dailyCounter+" ("+this.order.idXlated+")";
		}else{
			dojo.query(".orderNum",this.dialog.containerNode)[0].innerHTML=this.order.idXlated;
		}
		dojo.query(".clientNamePlace",this.dialog.containerNode)[0].innerHTML=this.orderDetails.clientName;
		dojo.query(".clientTelPlace",this.dialog.containerNode)[0].innerHTML=this.orderDetails.clientPhone;
		
		if(this.userView==false && this.order.askForId==true){
			dojo.style(this.askId,"display","block");
		}
		this.loadAddress(this.orderDetails.address);
		
		if(this.orderDetails.payment.type=="INCASH"){
			var changeAmtStr = com.copacabana.util.moneyFormatter(this.orderDetails.payment.amountInCash);
			dojo.query(".paymentPlace",this.dialog.containerNode)[0].innerHTML=dojo.string.substitute(this.i18nStrings.paymentType_INCASH, [changeAmtStr]);
		}else{
			dojo.query(".paymentPlace",this.dialog.containerNode)[0].innerHTML=this.i18nStrings["paymentType_"+this.orderDetails.payment.type];
		}
		var clientPrefix="";
		if(this.userView){
			clientPrefix="CLIENT_";
		}
		dojo.query(".statusPlace",this.dialog.containerNode)[0].innerHTML=this.i18nStrings["label_"+clientPrefix+this.order.status];
		var rankingSite;
		if(this.orderDetails.clientRequestsOnSite<3){
			rankingSite=this.i18nStrings['rankingSiteText_'+this.orderDetails.clientRequestsOnSite];
			dojo.style(dojo.query(".rankingSite",this.dialog.containerNode)[0],'color','red');
		}else{
			rankingSite=dojo.string.substitute(this.i18nStrings.rankingSiteText, [(this.orderDetails.clientRequestsOnSite+1)]);
		}
		
		var rankingRest;
		if(this.orderDetails.clientRequestsOnRestaurant<3){
			rankingRest=this.i18nStrings['rankingRestText_'+this.orderDetails.clientRequestsOnRestaurant];
			dojo.style(dojo.query(".rankingRest",this.dialog.containerNode)[0],'color','red');
		}else{
			rankingRest=dojo.string.substitute(this.i18nStrings.rankingRestText, [(this.orderDetails.clientRequestsOnRestaurant+1)]);
		}
		
		dojo.query(".rankingSummary",this.dialog.containerNode)[0].innerHTML="("+this.orderDetails.clientRequestsOnSite+","+this.orderDetails.clientRequestsOnRestaurant+")";		
		dojo.query(".rankingSite",this.dialog.containerNode)[0].innerHTML=rankingSite;
		dojo.query(".rankingRest",this.dialog.containerNode)[0].innerHTML=rankingRest;
		
		if(this.orderDetails.cpf!=null){
			dojo.query(".cpfPlace",this.dialog.containerNode)[0].innerHTML = "CPF: "+this.orderDetails.cpf;
		}
		
		
		var plates = this.orderDetails.plates;
		var platesSection = dojo.query(".Items",this.dialog.containerNode)[0];
		var totalCost=0;
		
		this.totalItems.innerHTML=""+plates.length+"";
		var table = dojo.create("table",{className:'mytable'},platesSection);
		var thead = dojo.create("thead",{},table);
		dojo.create("th",{innerHTML:"Qtd"},thead);
		dojo.create("th",{innerHTML:"Nome"},thead);
		dojo.create("th",{innerHTML:"Pre&ccedil;o"},thead);
		var tbody = dojo.create("tbody",{},table);
		for ( var i = 0; i < plates.length; i++) {
			var plate = plates[i];
			var tr = dojo.create("tr",{},tbody);
  		    dojo.create("td",{innerHTML:plate.qty,className:"qtyColumn"},tr);
  		    var name=plate.name;
  		    var td = dojo.create("td",{innerHTML:name,className:"nameColumn"},tr);
  		    if(plate.restInternalCode && plate.restInternalCode.length>0){
  		    	dojo.create('span',{innerHTML:" c&oacute;digo:"+plate.restInternalCode,className:'codeColumn'},td);				
			}
  		    
  		    dojo.create("td",{innerHTML:com.copacabana.util.moneyFormatter(plate.priceInCents/100),className:"priceColumn"},tr);
  		  
			//var div = document.createElement("div");
			//div.setAttribute("class","item");
			//var spanQty = dojo.create("span",{style:{fontSize:'large'},className:'plateQty',innerHTML:plate.qty+"x "},div); 
			
				
/*				document.createElement("span");
			spanQty.setAttribute("style","font-size: large;");
			spanQty.setAttribute("class","plateQty");
			spanQty.innerHTML=plate.qty;*/
			
			//var spanName = dojo.create("span",{style:{fontSize:'large'},className:'plateTitle',innerHTML:plate.name},div);
			//document.createElement("span");
//			spanName.setAttribute("style","font-size: large;");
//			spanName.setAttribute("class","plateTitle");
//			
//			spanName.innerHTML=plate.name;
			
			//div.appendChild(spanQty);
			//div.appendChild(document.createTextNode(" "));
			//div.appendChild(spanName);
//			if(plate.restInternalCode && plate.restInternalCode.length>0){
//				dojo.create("span",{style:{fontSize:"small"},innerHTML:" c&oacute;digo:"+plate.restInternalCode},div);
//			}
			
			//var hr = document.createElement("hr");
			//var br = document.createElement("br");
			//platesSection.appendChild(div);

			//platesSection.appendChild(hr);
			
			
			totalCost+=plate.price*plate.qty;
			
		}
		
		totalCost+=this.orderDetails.deliveryCost;
		dojo.query(".deliveryCost",this.dialog.containerNode)[0].innerHTML=com.copacabana.util.moneyFormatter(this.orderDetails.deliveryCost);
		
		dojo.query(".deliveryCost",this.dialog.containerNode)[0].innerHTML=com.copacabana.util.moneyFormatter(this.orderDetails.deliveryCost);
		dojo.query(".totalCost",this.dialog.containerNode)[0].innerHTML=com.copacabana.util.moneyFormatter(this.order.totalAmountInCents/100);
		dojo.query(".observations",this.dialog.containerNode)[0].innerHTML=this.orderDetails.observation;
		
		dojo.style(dojo.query(".cancelOrder",this.dialog.containerNode)[0],"display","none");
		if(this.userView==true){
			dojo.style(dojo.query(".changeToNextStatus",this.dialog.containerNode)[0],"display","none");			
			dojo.style(dojo.query(".cancelOrder",this.dialog.containerNode)[0],"display","none");
			if(this.order.status=="NEW" && this.order.status!="VISUALIZEDBYRESTAURANT"){
				//TODO dojo.style(dojo.query(".cancelOrder",this.dialog.containerNode)[0],"display","true");
			}
			
		}else{			
			dojo.style(dojo.query(".printerSection",this.dialog.containerNode)[0],"display","block");
			if(this.order.status=="CANCELLED" || this.order.status=="EXPIRED"){
				dojo.style(dojo.query(".changeToNextStatus",this.dialog.containerNode)[0],"display","none");
			}else{				
				if(this.order.status=="NEW" || this.order.status=="VISUALIZEDBYRESTAURANT"){
					dojo.style(dojo.query(".cancelOrder",this.dialog.containerNode)[0],"display","block");
					dojo.style(dojo.query(".closeWindow",this.dialog.containerNode)[0],"display","none");
					dojo.style(this.dialog.closeButtonNode,"display","none");
				}
				
				if(this.order.status=="DELIVERED"){
					dojo.style(dojo.query(".changeToNextStatus",this.dialog.containerNode)[0],"display","none");
					dojo.style(dojo.query(".cancelOrder",this.dialog.containerNode)[0],"display","none");
				}
			}
			
			var labelBtn="";
			var titleBtn="";
			if(this.order.status=="NEW" || this.order.status=="VISUALIZEDBYRESTAURANT"){				
				labelBtn="Preparando pedido";
				titleBtn="Mudar status do pedido para em preparo";
			}else{			
				if(this.order.status=="PREPARING"){
					if(this.order.retrieveAtRestaurant==true){
						labelBtn="Pedido pronto";
						titleBtn="Pedido pronto, aguardando cliente.";
					}else{
						labelBtn="Pedido enviado";
						titleBtn="Pedido est&aacute; a caminho.";
					}
				}else{
					if(this.order.status=="INTRANSIT"){
						labelBtn="Pedido entregue";
						titleBtn="Pedido foi entregue ao cliente.";
					}else{						
						if(this.order.status=="WAITING_CUSTOMER"){
							labelBtn="Cliente retirou pedido";
							titleBtn="Cliente buscou o pedido.";
						}
					}
				}
			}	
			var buttonStatus = dijit.byNode(dojo.query(".changeToNextStatus",this.dialog.containerNode)[0]);
			
			
			buttonStatus.attr('label' ,labelBtn);
			buttonStatus.attr('title',titleBtn);
			
		}		
		if(this.orderDetails.status=='CANCELLED' || this.orderDetails.status=='EXPIRED'){
			var cancelRegion = dojo.query(".cancellationReason",this.dialog.containerNode)[0];			
			dojo.style(cancelRegion,'display','block');
			dojo.create('h3',{innerHTML:'Motivo cancelamento:'},cancelRegion);
			if(this.orderDetails.status=='EXPIRED'){
				dojo.create('span',{innerHTML:this.i18nStrings.expiredReason,style:{color:'red',fontWeigth:'bold'}},cancelRegion);
			}else{
				dojo.create('span',{innerHTML:this.orderDetails.reason,style:{color:'red',fontWeigth:'bold'}},cancelRegion);
			}
			
		}
		this.updateElapsedTime();
		this.hideloading();
	},
	rankingDetailsShown:false,
	toogleRankingDetails:function(){
		var toogler = dojo.query(".toogleRanking",this.dialog.containerNode)[0];
		if(this.rankingDetailsShown==true){
			dojo.style(dojo.query(".rankingDetails",this.dialog.containerNode)[0],"display","none");
			dojo.query(".toogleRanking",this.dialog.containerNode)[0].innerHTML="+";
			dojo.removeClass(toogler,'collapse');
			dojo.addClass(toogler,'expand');
		}else{
			dojo.style(dojo.query(".rankingDetails",this.dialog.containerNode)[0],"display","block");
			dojo.addClass(toogler,'collapse');
			dojo.removeClass(toogler,'expand');
			dojo.query(".toogleRanking",this.dialog.containerNode)[0].innerHTML="-";
		}
		this.rankingDetailsShown=!this.rankingDetailsShown;
	},
	orderDetails:null,
	
	loadedOrder:function(response){
		this.orderDetails=response;
		
		
		this.updateDialog();
	},
	showErrorMsg:function(msg){
		if(!msg){
			msg=this.i18nStrings.defaultErrorMsg;
		}
		var domMsgNode = dojo.query(".errorMsgPlace",this.domNode)[0];
		dojo.empty(domMsgNode);
		dojo.create('span',{innerHTML:msg},domMsgNode);
		dojo.style(domMsgNode,'visibility','visible');
	},
	detailsEndpoint:"/loadOrderDetails.do",
	startup : function() {
		try {
			
			var xhrArgs = {
				url : this.detailsEndpoint+"?id="+this.order.id,
				handleAs : "json",
				load :dojo.hitch(this,this.loadedOrder),
				error : function(error) {
					console.error(error);
					this.hideloading();
					this.showErrorMsg();
				}
			};
			var deferred = dojo.xhrGet(xhrArgs);	
			
			if(this.order.status=="NEW" || this.order.status=="VISUALIZEDBYRESTAURANT" || this.order.status=="PREPARING"){
				this.eachMinuteHandler=dojo.subscribe("onEachMinute",dojo.hitch(this,this.updateElapsedTime));				
			}
			try{				
				if(this.order.convenienceTaxInCents && this.order.convenienceTaxInCents>0){
					dojo.query(".convenienceCost",this.dialog.containerNode)[0].innerHTML="Taxa site: "+com.copacabana.util.moneyFormatter(this.order.convenienceTaxInCents/100.0);	
				}				
				if(this.order.discountInfo && this.order.discountInfo.value>0){
					var discountCostDom = dojo.query(".discountCost",this.dialog.containerNode)[0];
					dojo.style(discountCostDom,'display','block');
					discountCostDom.innerHTML="Desconto: "+com.copacabana.util.moneyFormatter(this.order.discountInfo.value/100);	
				}
			if(this.order.prepareForeCast && this.order.prepareForeCast.length>0){
				var prepareForeCastDom = dojo.query(".cancellationReason",this.dialog.containerNode)[0];
				dojo.style(prepareForeCastDom,'display','block');
				prepareForeCastDom.innerHTML="Previs&atilde;o: "+this.order.prepareForeCast;
			}
			}catch(e){
				console.error("cannot update details",e)
			}
			
			this.dialog.show();
			this.handlers.push(dojo.connect(dojo.query(".changeToNextStatus",this.dialog.containerNode)[0], "onclick", this, this.changeToNextStatus));
			this.handlers.push(dojo.connect(dojo.query(".cancelOrder",this.dialog.containerNode)[0], "onclick", this, this.cancelOrder));
			this.handlers.push(dojo.connect(dojo.query(".closeWindow",this.dialog.containerNode)[0], "onclick", this, this.closeWindow));
			this.handlers.push(dojo.connect(dojo.query(".printOrder",this.dialog.containerNode)[0], "onclick", this, this.printOrder));
			
		} catch (e) {
			console.error('View details startup failed.',e);
			this.showErrorMsg();
		}
	},
	currentDelay:null,
	updateElapsedTime:function(){
		
		this.order.orderedHour=com.copacabana.util.parseTime(this.orderDetails.orderedTime);
		this.order.orderedDate=com.copacabana.util.parseDate(this.orderDetails.orderedTime);		
		if(this.order.status=="NEW" || this.order.status=="VISUALIZEDBYRESTAURANT" || this.order.status=="PREPARING" || this.order.status=="INTRANSIT"){
			var elapsed = com.copacabana.util.getElapsedTime(this.order.orderedHour,this.order.orderedTime);
			dojo.query(".elapsedTimePlace", this.dialog.containerNode)[0].innerHTML=elapsed;
		}else{
			
			var elapsed = com.copacabana.util.getElapsedTime(this.order.orderedHour,this.order.orderedTime,this.order.lastStatusUpdateTime);
			dojo.query(".elapsedTimePlace", this.dialog.containerNode)[0].innerHTML=elapsed;
		}
	},
	oldNodes:[],
	changeToNextStatus:function(event){
		if (event) {
			// Stop the submit event since we want to control form submission.
			event.preventDefault();
			event.stopPropagation();
			dojo.stopEvent(event);
		}
		
		var newStatus;
		if(this.order.status=="NEW" || this.order.status=="VISUALIZEDBYRESTAURANT"){
			newStatus="PREPARING";
			//if(this.order.retrieveAtRestaurant==true){
				var msg = new com.copacabana.MessageWidget();
				var average = "15 minutos";
				if(this.currentDelay){
					average = this.currentDelay;					
				}
				msg.promptInputMsg("Insira a previs&atilde;o para preparo do pedido: ",dojo.hitch(this,this.finishPrepare),"Tempo para preparo",average);
				return;
			//}
		}else{
			if(this.order.status=="PREPARING"){
				if(this.order.retrieveAtRestaurant==true){
					newStatus="WAITING_CUSTOMER";
				}else{
					newStatus="INTRANSIT";	
				}
			}else{
				if(this.order.status=="INTRANSIT"||this.order.status=="WAITING_CUSTOMER"){
					newStatus="DELIVERED";
				}	
			}
		}
		this.tried=0;
		this.changeOrderStatus(newStatus, "n/a");
		
			
	},
	finishPrepare:function(response){
		this.tried=0;
		this.changeOrderStatus("PREPARING", "n/a",response);
	},
	confirmCancelClientIsAware:function(response){
		console.log(response);
		if(response=='yes'){
			var msg = new com.copacabana.MessageWidget();
			var options=[
			             {
			            	id:"yes",
			            	label:"Sim"		            	
			             },
			             {
				            	id:"no",
				            	label:"N&atilde;o"		            	
			             }
			         
			];
			             
			msg.promptMsg(this.i18nStrings.confirmCancelClientIsAware,options,dojo.hitch(this,this.confirmCancelLastStep),"Cancelar");
		}
	},
	confirmCancelLastStep:function(response){
		if(response=='yes'){
			
			var msg = new com.copacabana.MessageWidget();
			msg.promptInputMsg(this.i18nStrings.confirmCancelRequestReason,dojo.hitch(this,this.finishCancelOrder),"Cancelar");
			
		}else{
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg(this.i18nStrings.confirmCancelMakeClientAware);			
		}
	},
	finishCancelOrder:function(str){
		this.tried=0;
		this.changeOrderStatus("CANCELLED", str);
	},
	cancelOrder : function(event) {
		
			if (event) {
				// Stop the submit event since we want to control form submission.
				event.preventDefault();
				event.stopPropagation();
				dojo.stopEvent(event);
			}
		var msg = new com.copacabana.MessageWidget();
		var options=[
		             {
		            	id:"yes",
		            	label:"Sim"		            	
		             },
		             {
			            	id:"no",
			            	label:"N&atilde;o"		            	
		             }
		         
		];
		var cancelInitialMsg=this.i18nStrings.confirmCancelInitial;
		if(this.orderDetails.payment.type=='PAYPAL'){
			cancelInitialMsg=this.i18nStrings.confirmCancelInitialWithPaypal;
		}
		msg.promptMsg(cancelInitialMsg,options,dojo.hitch(this,this.confirmCancelClientIsAware),"Cancelar");
		/*var r=confirm(this.i18nStrings.confirmCancelInitial);
		if (r==true){
			r=confirm(this.i18nStrings.confirmCancelClientIsAware);
			if (r==true){
				var reason=prompt(this.i18nStrings.confirmCancelRequestReason);
				this.changeOrderStatus("CANCELLED", reason);
			}else{
				alert(this.i18nStrings.confirmCancelMakeClientAware);
			}
		}
		*/	
	},
	
	changeOrderStatus:function(newStatus,reason,timeToRetrieve,loadingText){
		com.copacabana.util.showLoading(loadingText);
		var form = dojo.create("form",{action:"/changeOrderStatus.do",method:"post"});
		dojo.create("input",{type:"text",name:"id",value:this.order.id},form);
		dojo.create("input",{type:"text",name:"key",value:this.order.id},form);
		dojo.create("input",{type:"text",name:"status",value:newStatus},form);
		dojo.create("input",{type:"text",name:"reason",value:reason},form);
		dojo.create("input",{type:"text",name:"delay",value:timeToRetrieve},form);
		
		
		var xhrArgs = {
			form : form,//dojo.query(".updateOrderForm", this.domNode)[0],
			handleAs : "json",
			load : dojo.hitch(this, function(data) {
				var entity = data;
				if(data.status==false){					
					if(data.errorCode=='PAYPALIOERROR' && this.tried<2){
						this.tried++;
						com.copacabana.util.hideLoading();
						console.log(newStatus,timeToRetrieve);
						this.changeOrderStatus(newStatus,reason,timeToRetrieve,this.i18nStrings.retryAuthorization+" "+this.tried);
					}else{
						com.copacabana.util.hideLoading();
						var msg = new com.copacabana.MessageWidget();
						if(data.errorCode=='PAYPALEXPIRED'){
							msg.showMsg(this.i18nStrings.errorPayPalExpired);
							this.order.status='CANCELLED';
							dojo.publish("onChangeOrderStatus",[this.order])
							this.dialog.hide();
							this.dialog.destroyRecursive();	
							this.destroyRecursive();
						}else{
							var msg = new com.copacabana.MessageWidget();
							if(data.errorCode=='PAYPALERROR' || data.errorCode=='PAYPALIOERROR'){
								msg.showMsg(this.i18nStrings.errorPayPalStatusChange);
							}else{
								if(data.errorCode=='INCORRECTSTATUSWORKFLOW'){
									msg.showMsg(this.i18nStrings.statusAlreadyCancelled);	
								}else{
									msg.showMsg(this.i18nStrings.errorDuringOrderStatusChange);
								}
							}
							this.dialog.hide();
							this.dialog.destroyRecursive();	
							this.destroyRecursive();
						}
					}
				}else{
					com.copacabana.util.hideLoading();
					data.idXlated=this.order.idXlated;
					dojo.publish("onChangeOrderStatus",[data])
					
					this.dialog.hide();
					this.dialog.destroyRecursive();	
					this.destroyRecursive();
				}
			}),
			error : function(error) {
				com.copacabana.util.hideLoading();
				console.log('pasosu',error)
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg(this.i18nStrings.errorDuringOrderStatusChange);
				console.log("Form error ", error);
				this.dialog.hide();
				this.dialog.destroyRecursive();
				this.destroyRecursive();
			}		
		};
		// Call the asynchronous xhrPost
		var deferred = dojo.xhrPost(xhrArgs);	
	},
	tried:0,
//	if(this.userView==false && (this.order.status=="NEW" || this.order.status=="VISUALIZEDBYRESTAURANT")){
//		var msg = new com.copacabana.MessageWidget();
//		msg.showMsg(this.i18nStrings.mustAcceptOrCancelOrder);
//		return;
//	}
	closeWindow:function(event){
		if (event) {
			// Stop the submit event since we want to control form submission.
			event.preventDefault();
			event.stopPropagation();
			dojo.stopEvent(event);
		}		
		try{
			this.dialog.hide();
			this.dialog.destroyRecursive();	
			this.destroyRecursive();
		}catch(e){
			console.error("failed to destroy dialog",e);
		}

	},
	printOrder:function(event){
		if (event) {
			// Stop the submit event since we want to control form submission.
			event.preventDefault();
			event.stopPropagation();
			dojo.stopEvent(event);
		}
		
		console.log(this.orderDetails);
		var form =dojo.query(".printOrderForm", this.dialog.containerNode)[0];
		dojo.empty(form);
		
		console.log('b',dojo.toJson(this.order));
		dojo.create("input",{type:"text",name:"orderId",value:this.order.id},form);
		dojo.create("input",{type:"text",name:"orderIdXlated",value:this.order.idXlated},form);
		dojo.create("input",{type:"text",name:"clientName",value:this.orderDetails.clientName},form);
		dojo.create("input",{type:"text",name:"clientPhone",value:this.orderDetails.clientPhone},form);
		dojo.create("input",{type:"text",name:"orderedTime",value:this.order.orderedTime},form);
		
		
		var plates = this.orderDetails.plates;
		
		var totalCost=0;
		for ( var i = 0; i < plates.length; i++) {
			var plate = plates[i];
			
			var pstr= plate.qty+"|"+plate.name+"|"+com.copacabana.util.moneyFormatter(plate.price)+"|"+com.copacabana.util.moneyFormatter(plate.price*plate.qty);
			dojo.create("input",{type:"text",name:"plate",value:pstr},form);
					
			totalCost+=plate.price*plate.qty;
			
		}
		
		totalCost+=this.order.deliveryCost/100;
		dojo.create("input",{type:"text",name:"deliveryCost",value:com.copacabana.util.moneyFormatter(this.order.deliveryCost/100)},form);
		
		dojo.create("input",{type:"text",name:"totalCost",value:com.copacabana.util.moneyFormatter(this.order.totalAmountInCents/100)},form);
		
		if(this.orderDetails.payment.type=="PAYPAL"){
			dojo.create("input",{type:"text",name:"pType",value:"online"},form);
		}else{
			dojo.create("input",{type:"text",name:"pType",value:"t"+this.orderDetails.payment.type},form);			
			if(this.orderDetails.payment.type=="INCASH"){
				dojo.create("input",{type:"text",name:"pTypeName",value:'Em dinheiro'},form);
				var moneyamount =this.orderDetails.payment.amountInCash;		
				console.log(com.copacabana.util.moneyFormatter(moneyamount))
				dojo.create("input",{type:"text",name:"moneyAmount",value:com.copacabana.util.moneyFormatter(moneyamount)},form);
				dojo.create("input",{type:"text",name:"moneyChange",value:com.copacabana.util.moneyFormatter(moneyamount-totalCost)},form);
			}else{
				dojo.create("input",{type:"text",name:"pTypeName",value:this.i18nStrings["paymentType_"+this.orderDetails.payment.type]},form);	
			}
		}
		if(this.orderDetails.retrieveAtRestaurant==true){
			dojo.create("input",{type:"text",name:"retrieveAtRestaurant",value:1},form);
		}else{
			dojo.create("input",{type:"text",name:"address",value:this.formattedAddress},form);
			dojo.create("input",{type:"text",name:"addressPhone",value:this.addressPhone},form);
		}
		
		if(this.orderDetails.cpf!=null){
			dojo.create("input",{type:"text",name:"clientCPF",value:this.orderDetails.cpf},form);
		}
		if(this.orderDetails.observation!=null && this.orderDetails.observation!=''){
			dojo.create("input",{type:"text",name:"observation",value:this.orderDetails.observation},form);
		}
		
		form.submit();
		
	}

});
