dojo.provide("com.copacabana.order.OrderManagerWidget");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CurrencyTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.MessageWidget");
dojo.require("dijit.form.SimpleTextarea");
dojo.require("com.copacabana.lbs.FindUserLocation");
dojo.require("dojo.cookie");

// I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");

dojo.requireLocalization("com.copacabana.order", "OrderManagerWidgetStrings");

dojo.declare("com.copacabana.order.OrderManagerWidget", [ dijit._Widget,
		dijit._Templated ], {
	i18nStrings : null,
	templatePath : dojo.moduleUrl("com.copacabana.order",
			"templates/OrderManagerWidget.html"),
	constructor : function(order) {
		this.order = order;
		
	},
	destroyRecursive : function() {		
		dojo.forEach(this.getDescendants(), function(widget) {			
			widget.destroyRecursive();
		});
		this.inherited(arguments);
	},
	order : null,

	postMixInProperties : function() {
		this.inherited(arguments);
	},
	deliveryCostInCents:0,
	customUpdateDeliveryCost:function(cost,costInCents){
		
	},
	updateDeliveryCost:function(cost,costInCents){
		this.customUpdateDeliveryCost(cost,costInCents);
		this.deliveryCost = cost;
		this.deliveryCostInCents = costInCents;
		var deliveryManager = dijit.byId("deliveryManager");
		
		if(deliveryManager.isDeliverable==true){
			if(specificLogic && specificLogic.freeDelivery && specificLogic.freeDelivery=="true"){
				this.deliveryCost=0;
				this.deliveryCostInCents=0;
				this.updateTotals();
				if(specificLogic.msg){
					com.copacabana.util.showTimedMessage(specificLogic.msg,dojo.query('.delCost')[0],5000);					
				}
			}else{
				this.updateTotals();
			}
		}else{
			this.updateTotals();
		}
		
		
	},
	minimumCost:0,
	updateDeliveryMinimumCostChange:function(minimum){
		this.minimumCost=minimum;
		this.checkMinimumValue();
		
	},
	checkMinimumValue:function(){
		if(this.minimumCost>0){
			if(this.minimumCost>this.subTotal){
				var msg = dojo.string.substitute(this.i18nStrings.minimumDeliveryCost,[this.minimumCost]);			
				dijit.showTooltip(msg, dojo.byId('totalWrapper'),['before','above']);
			}else{
				dijit.hideTooltip(dojo.byId('totalWrapper'));
			}
		}else{
			dijit.hideTooltip(dojo.byId('totalWrapper'));
		}
		
	},
	postCreate : function() {
		this.inherited(arguments);
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana.order",	"OrderManagerWidgetStrings");
		dojo.subscribe("onQuantityChanged",dojo.hitch(this,this.updateTotals));
		dojo.subscribe("onDeliveryCostChange",dojo.hitch(this,this.updateDeliveryCost));
		dojo.subscribe("onDeliveryMinimumCostChange",dojo.hitch(this,this.updateDeliveryMinimumCostChange));
		dojo.query(".observationArea", this.domNode)[0].value=this.order.observation;
		
		dojo.subscribe("onUserLocationCoords",dojo.hitch(this,this.userLocationFound));
		this.loadRestaurantData(this.order.restaurant);		
	},
	restaurant:null,
	restDataLoadFail:function(error){
		console.error("failed to load rest data.",error);
	},
	onlyForRetrieval:false,
	restDataLoaded:function(data){		
		this.restaurant=data;
		dojo.query(".restPlace", this.domNode)[0].innerHTML=this.restaurant.name;
		for ( var i = 0; i < this.restaurant.acceptablePayments.length; i++) {			
			var paymentName = this.restaurant.acceptablePayments[i];
			if(this.payPalDataController.level && this.payPalDataController.level=='PAYPAL'){
				
			}else{
				var payNode=dojo.query('.paymentType_'+paymentName, this.domNode)[0];			
				dojo.style(payNode,'display','block');
			}
		}
		switch (this.payPalDataController.level) {
		case 0:
			this.clientLevelTxt.innerHTML="O seu usu&aacute;rio s&oacute; ainda n&atilde;o permite fazer pedidos online. ";
			dojo.create("a",{target:"_blank",href:"/reputacaoConta.html",innerHTML:"saiba mais.",style:{fontSize:"small"}},this.clientLevelTxt);
			break;
		case 1:
			this.clientLevelTxt.innerHTML="O seu usu&aacute;rio s&oacute; permite fazer pedidos com pagamento online com valores menores que R$ 100,00. ";
			dojo.create("a",{target:"_blank",href:"/reputacaoConta.html",innerHTML:"saiba mais.",style:{fontSize:"small"}},this.clientLevelTxt);
			break;
		default:
			break;
		}
		
		
	},
	loadRestaurantData:function(restId){

		var xhrParams = {
				error : dojo.hitch(this, "restDataLoadFail"),
				handleAs : 'json',
				load : dojo.hitch(this, "restDataLoaded"),
				url : '/getRestaurant.do?id='+restId
		};
		dojo.xhrGet(xhrParams);
	},
	observation:null,
	obsChanged:function(){
		console.log("obs");
		console.log(dojo.query(".observationArea", this.domNode)[0].value);
		this.order.observation=dojo.query(".observationArea", this.domNode)[0].value;
	},
	totalOrderCost:0,
	deliveryCost:0,
	getSubTotalCost:function(){
		var subTotal=0;
		for ( var i = 0; i < this.plateList.length; i++) {
			var p = this.plateList[i];
			subTotal+=p.getTotalCost();
		}
		return subTotal;
	},
	subTotal:0,
	customUpdateTotals:function(){
		console.log('nocustomization');
	},
	updateTotals:function(){
		this.customUpdateTotals();
		var subTotal= this.getSubTotalCost();
		this.subTotal=subTotal;
		dojo.query(".subtotal", this.domNode)[0].innerHTML=com.copacabana.util.moneyFormatter(subTotal);
		//var deliveryCost = parseFloat(dojo.query(".delCost", this.domNode)[0].innerHTML);
		//console.log('updating toatl');
		this.totalOrderCost=this.deliveryCost+subTotal;
		if(this.discount!=null){			
			this.totalOrderCost= this.discount.calculateValue(this.totalOrderCost);
		}
		
		dojo.query(".delCost", this.domNode)[0].innerHTML=com.copacabana.util.moneyFormatter(this.deliveryCost);
		dojo.query(".totalOrderCost", this.domNode)[0].innerHTML=com.copacabana.util.moneyFormatter(this.totalOrderCost);
		this.checkMinimumValue();
		
			
	},
	discNode:null,
	discTextNode:null,
	discount:null,
	discountCostNode:null,
	discCostText:null,
	
	discountIsValid:function(data,code){		
		com.copacabana.util.hideTimedMessage();
		
		dojo.empty(this.discCostText);
		var node =this.discCostText; 
		var discText=this.discCostText;
		this.discount={
			code:code,
			value:data.value,
			node:node,
			isValid:true,
			txtNode:discText,
			type:data.type
		}
		switch (data.type) {
			case "VALUE":{
				this.discount.valueInCents=data.value;
				this.discount.discValue=(parseFloat(data.value)/100);
				this.discount.calculateValue=function(total){
					var totalRet = (total-(parseFloat(this.valueInCents)/100));
					if(totalRet<0){
						totalRet=0;
					}
					dojo.empty(this.node);
					this.txtNode = dojo.create("span",{innerHTML:com.copacabana.util.moneyFormatter(-1*this.discValue),className:"totalCost"},this.node);
					return totalRet;
				}				
				com.copacabana.util.showTimedMessage("Cupom v&aacute;lido. <br>Desconto de "+com.copacabana.util.moneyFormatter(this.discount.discValue),this.discMsgsDom,3000,['after']);
			}
			break;
			case "PERCENTAGE":	
				this.discount.pct=data.value;
				this.discount.discValue=null;
				this.discount.calculateValue=function(total){
					var value=(total-(total*parseFloat(this.pct/100)));
					this.discValue=total-value;					
					dojo.empty(this.node);
					this.txtNode=dojo.create("span",{innerHTML:com.copacabana.util.moneyFormatter(-1*this.discValue),className:"totalCost"},this.node);
					return value;
				};
				
				com.copacabana.util.showTimedMessage("Cupom v&aacute;lido. <br>Desconto de "+data.value+"%",this.discMsgsDom,3000,['after','below']);
			
			break;
		default:
			break;
		}
		this.updateTotals();
		
		
	},
	discountIsNotValid:function(){
		com.copacabana.util.hideTimedMessage();
	//	dojo.empty(this.discountCostNode);
//		this.discCostText= dojo.create("span",{innerHTML:"0,00",className:"totalCost"},this.discountCostNode);
		com.copacabana.util.showTimedMessage("Cupom inv&aacute;lido.",this.discMsgsDom,4000);
		this.discount={
				valueInCents:0,
				isValid:false,
				calculateValue:function(total){
					return total;
				}
			}
		this.updateTotals();
	},
	
	cupomForm:null,
	cupomImgDom:null,
	discMsgsDom:null,
	showDiscountSection:function(){
		
		this.cupomForm =dojo.create("div",{innerHTML:"Insira o c&oacute;digo do cupom: "},this.discDesc);
		this.cupomImgDom = dojo.create('img',{src:"/resources/img/loading.gif",style:{visibility:'hidden'}},this.cupomForm);
		var txtNode = dojo.create("div",{},this.cupomForm);
	     var props = {
	            name: "discCode",
	            style:{
	            		width:"60px",
	            		textAlign:"left"
	            }
	     };
	    this.discTextNode=new dijit.form.TextBox(props, txtNode);
		
	    this.discDesc
	    
	    this.discountSection = dojo.create("div",{style:{display:"none"}},this.discDesc);
	    
	    
	    this.discMsgsDom = dojo.query(".totalOrderCost", this.domNode)[0]; 
	    
	    var removeStyle={padding: "1px 4px",backgroundColor:"#f9f9f9",marginLeft:"110px",'float':"left",width:"10px"};
	    var remove = dojo.create("div",{style:removeStyle,innerHTML:"X"},this.discountSection)
	    dojo.connect(remove,"onmouseover",function(){dojo.style(remove,"backgroundColor",'#a9a9a9')});
	    dojo.connect(remove,"onmouseout",function(){dojo.style(remove,"backgroundColor",'#f9f9f9')});
	    dojo.create("span",{innerHTML:"Desconto: "},this.discountSection);
	    this.discCostText= dojo.create("span",{innerHTML:"R$ 0,00",className:"totalCost"},this.discountSection);
	    
	    
	    
	    var aaa=this.cupomForm ;
	    var discDom=this.discountSection;
	    dojo.connect(remove,"onclick",function(){
	    	//dojo.style(this.discountSection,"display","none");
			dojo.style(aaa,"display","block");			
			dojo.style(discDom,"display","none");
	    });
	    
		var fct = function(val){
	    	var code=this.discTextNode.attr('value');
	    	console.log("code",code)
			console.log("disc",this.discount)
			/*if(this.discount && code==this.discount.code){
				return;
			}*/	    	
	    	dojo.style(this.cupomImgDom,"visibility","visible");	
	    	var fct = function(data){
	    		dojo.style(this.cupomImgDom,"visibility","hidden");
	    		var code2=this.discTextNode.attr('value');
	    		if(data.valid){
	    			if(data.valid && data.valid==true){
	    				dojo.style(this.discountSection,"display","block");
	    				dojo.style(this.cupomForm,"display","none");
	    				this.discountIsValid(data,code2);
	    			}else{
	    				this.discountIsNotValid(data,code2);
	    			}
	    		}else{
	    			console.error(data);	
	    			this.discountIsNotValid(data,code2);
	    		}
	    	}
	    	var restIdToCheck="";
	    	if(this.restaurant){
	    		restIdToCheck=this.restaurant.id;
	    	}
	    	var xhrParams = {
					error : dojo.hitch(this, fct),
					handleAs : 'json',
					load : dojo.hitch(this,fct),
						
					url : '/isCupomValid.do?code='+code+"&restId="+restIdToCheck
			};
			dojo.xhrGet(xhrParams);
	    	
	    	//var disc = {valid:true,value:190,type:"VALUE"};
	    	//this.discountIsValid(disc);
	    	
	    	
	    }
	    dojo.connect(this.discTextNode,"onBlur",dojo.hitch(this,fct));
	    //this.discountCostNode=dojo.create("span",{},this.discDesc);
	    
	    dojo.style(this.discBtn,"display","none");
	},
	showDiscountSectionTable:function(){
		this.resultsNode = dojo.query(".plateMenuList", this.domNode)[0];
		this.discNode=dojo.create("tr",{className:"item"},this.resultsNode);
		var td1 = dojo.create("td",{className:"colunaItem"},this.discNode);
		dojo.create("span",{innerHTML:"Desconto",style:{textAlign:'left'}},td1);
		
		var td = dojo.create("td",{colspan:2},this.discNode);
		dojo.create("span",{innerHTML:"Insira o c&oacute;digo do cupom:",style:{textAlign:'left'}},td);
		var txtNode = dojo.create("div",{},td);
	     var props = {
	            name: "discCode",
	            style:{
	            		width:"60px",
	            		textAlign:"left"
	            }
	     };
	    this.discTextNode=new dijit.form.TextBox(props, txtNode);
	    var fct = function(val){
	    	var code=this.discTextNode.attr('value');
	    	console.log("code",code)
			console.log("disc",this.discount)
			if(this.discount && code==this.discount.code){
				return;
			}
	    	console.log('validating',code);
	    	dojo.empty(this.discCostText);
	    	dojo.create('img',{src:"/resources/img/loading.gif"},this.discCostText);
	    	var fct = function(data){
	    			var code2=this.discTextNode.attr('value');
	    			if(data.valid==true){
	    				this.discountIsValid(data,code2);
	    			}else{
	    				this.discountIsNotValid(data,code2);
	    			}
	    	}
	    	var xhrParams = {
					error : dojo.hitch(this, "discountIsNotValid"),
					handleAs : 'json',
					load : dojo.hitch(this,fct),
						
					url : '/isCupomValid.do?code='+code
			};
			dojo.xhrGet(xhrParams);
	    	
	    	//var disc = {valid:true,value:190,type:"VALUE"};
	    	//this.discountIsValid(disc);
	    	
	    	
	    }
	    dojo.connect(this.discTextNode,"onBlur",dojo.hitch(this,fct));
	    this.discountCostNode=dojo.create("td",{},this.discNode);
	    this.discCostText= dojo.create("span",{innerHTML:"0,00",className:"totalCost"},this.discountCostNode);
	    dojo.style(this.discBtn,"display","none");
	    
	},
	displayOrder:function(){		
		this.resultsNode = dojo.query(".plateMenuList", this.domNode)[0];		
		com.copacabana.util.cleanNode(this.resultsNode);
		var results = this.order.plates;

		var counter=0;
		if(results.length===0){
			this.resultsNode.innerHTML="Nenhum prato.";	
		}else{
			
			for ( var i = 0; i < results.length; i++) {
				var p = results[i];
				var wid = new com.copacabana.order.OrderEntryWidget(p,p.qty);
				if(specificLogic.makisPackageCostId && specificLogic.makisPackageCostId==p.plate){
					wid.isReadonly=true;
					if(specificLogic.makisMsg && specificLogic.makisMsg.length>0){
						wid.readOnlyMsg=specificLogic.makisMsg;
					}
				}
				wid.startup();
				this.plateList.push(wid);
				this.resultsNode.appendChild(wid.domNode);
				
			}			
		}
		
		
		
	},
	resultsNode:null,
	plateList:[],
	geoLocator:null,
	totalCashAmmountDijit:null,
	startup : function() {
		try {			
			dojo.parser.parse(this.domNode);
			this.displayOrder();			
			this.updateTotals();	
			this.totalCashAmmountDijit = dijit.byNode(dojo.query(".totalPaidAmount", this.domNode)[0]);
			this.totalCashAmmountDijit.attr("value","0,00");
			dijit.byId('InCash').onChange=dojo.hitch(this,this.moneyChangeUpdated);
			
			

			
			
			//dojo.connect(totalCashAmmountDijit, "onChange", this.changedMoneyAmount);
			dojo.connect(this.totalCashAmmountDijit, "onBlur",dojo.hitch(this,this.changedMoneyAmount));
			
			
			dijit.byId('useCpf').onChange=dojo.hitch(this,this.useCPFChanged);
			var cpfInitiallyShown = dojo.cookie("useCpf");
			console.log('cpfInitiallyShown',cpfInitiallyShown);
			if(cpfInitiallyShown=='true'){
				dijit.byId('useCpf').attr('value','YES');
				this.useCPFChanged(null);
			}
			
			
			if(this.geoLocator==null){
				this.geoLocator = new com.copacabana.lbs.FindUserLocation();
				this.geoLocator.startup();
				this.geoLocator.avoidAddressConversion();
			}
			this.geoLocator.findLocation();
			
			
		} catch (e) {
			console.error(e);
		}
	},
	changedMoneyAmount:function(arg){
		var val = this.totalCashAmmountDijit.getDisplayedValue();
		if(val && val.indexOf(',')==-1){
			var value =val+",00";
			this.totalCashAmmountDijit.attr('value',value);
		}
	},
	userIsAwareOfRetrivingPlate:false,
	payPalDataController:null,
	payPalConfirmed:false,
	confirmPayPal:function(response){			
		if(response=='yes' ){
			this.payPalConfirmed=true;
			this.submitOrder();			
		}else{
			this.registerRefusal();
		}

		return;
	},
	registerRefusal:function(){
		try{			
			var xhrParams = {
					error :function(error){},					
					load : function(data){},
					preventCache:true,
					failOk:true,
					url : '/userRefusedPayPalPayment.jsp'
			};
			dojo.xhrGet(xhrParams);	
		}catch(e){
			
		}
	},
	confirmRetrievingAtRestaurant:function(response){			
		if(response=='yes' ){
			this.userIsAwareOfRetrivingPlate=true;
			this.submitOrder();			
		}

		return;
	},
	submitOrder:function(){
		com.copacabana.util.showLoading();
		var mealorder={};
		mealorder.plates=[];
		var subTotal=0;
		var restId = this.restaurant.id;
		for ( var i = 0; i < this.plateList.length; i++) {
			var p = this.plateList[i];
			if(p.qty==0){
				continue;
			}
			var orderedPlate={
					name:p.orderedPlate.name,
					qty:p.qty,
					price:p.orderedPlate.price,
					priceInCents:p.orderedPlate.priceInCents,
					plate:p.orderedPlate.plate,
					restInternalCode:p.orderedPlate.restInternalCode,
					isFraction:false
					
			}
			if(p.orderedPlate.isFraction==true){
				orderedPlate.fractionPlates=p.orderedPlate.fractionPlates;
				orderedPlate.isFraction=true;
			}
			mealorder.plates.push(orderedPlate);
		}
		
		mealorder.deliveryCost=this.deliveryCost;
		mealorder.deliveryCostInCents=this.deliveryCostInCents;
		mealorder.restaurant=restId;
		mealorder.observation=dojo.query(".observationArea", this.domNode)[0].value; 

		//mealorder.payment
		
		if(this.coords){
			mealorder.x=this.coords.x;
			mealorder.y=this.coords.y;
		}
		

		var deliveryManager = dijit.byId("deliveryManager");

		if(deliveryManager.isDeliverable==false){
			com.copacabana.util.hideLoading();
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg(this.i18nStrings.addressNotInRange,msg.errorType);			
			return;
		}
		
		mealorder.address=deliveryManager.selectedAddress.id;
		if(deliveryManager.selectedAddress.isRetrieveAtRestaurant==true) {
			if(this.onlyForRetrieval==true && this.userIsAwareOfRetrivingPlate==false){
				com.copacabana.util.hideLoading();
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
				
				var confMsg = this.i18nStrings.confirmRetrieveAtRestaurant;
				msg.promptMsg(confMsg,options,dojo.hitch(this,this.confirmRetrievingAtRestaurant),"Retirada no restaurante");
				return;
			}
			mealorder.retrieveAtRestaurant=true;						
		}else{
			mealorder.retrieveAtRestaurant=false;
		}
		
		mealorder.payment={totalValue:this.totalOrderCost,type:""};
		var subtotal = this.getSubTotalCost();
		if(this.minimumCost>subtotal){///mealorder.payment.totalValue){
			com.copacabana.util.hideLoading();			
			var msg = new com.copacabana.MessageWidget();
			msg.showMsg(this.i18nStrings.minimumValueNotSatisfied,msg.errorType);
			return;
		}
		
		var cheque = dojo.byId("Cheque").checked;//dijit.byNode(dojo.query(".CHEQUE", this.domNode)[0]);
		var cash =  dojo.byId("InCash").checked;//dijit.byNode(dojo.query(".INCASH", this.domNode)[0]);
		var paypal =  dojo.byId("PayPal").checked;		
		if(subtotal>0.0 && mealorder.payment.totalValue==0){
			cheque=false;
			cash=true;
			dijit.byNode(dojo.query(".totalPaidAmount", this.domNode)[0]).attr("value","0,00");
		}
		if(cheque){
			mealorder.payment.type="CHEQUE";
		}else if(cash){
			mealorder.payment.type="INCASH";
			if(!dijit.byNode(dojo.query(".totalPaidAmount", this.domNode)[0]).isValid()){
				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg(this.i18nStrings.ammountInCashNotValid,msg.errorType);

				return;
			}
			var ammountInCash=parseFloat(dijit.byNode(dojo.query(".totalPaidAmount", this.domNode)[0]).attr("value"));
			if(isNaN(ammountInCash)==true){
				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg(this.i18nStrings.ammountInCashNotValid,msg.errorType)

				return;
			}
			if(ammountInCash<mealorder.payment.totalValue){
				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg(this.i18nStrings.ammountInCashLesserThanCost,msg.errorType);				
				return;
			}
			mealorder.payment.amountInCash=ammountInCash;
		}else if(paypal){
			mealorder.payment.type="PAYPAL";
			if(this.payPalConfirmed!=true){
				com.copacabana.util.hideLoading();
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
				//parseFloat(dojo.query(".subtotal", this.domNode)[0].innerHTML);
				var tax = this.payPalDataController.calculateTax(subtotal,mealorder.deliveryCost,this.discount);
				var confMsg = dojo.string.substitute(this.i18nStrings.payPalConfirmMsg,[tax]);
				msg.promptMsg(confMsg,options,dojo.hitch(this,this.confirmPayPal),"Pagamento com ca&atilde;o");
				return;
			}
			this.payPalConfirmed=false;
			
		}else{
			
			var paymentTypes = dojo.query('.paymentType',this.domNode);
			var checked = false;
			for ( var i = 0; i < paymentTypes.length; i++) {
				var chkDijit = dijit.byNode(dojo.query('.paymentType',this.domNode)[i]);
				checked=chkDijit.attr('checked')
				if(checked){
					mealorder.payment.type=chkDijit.attr('id');
					break;
				}
			}
			if(checked==false){
				com.copacabana.util.hideLoading();
				var msg = new com.copacabana.MessageWidget();
				msg.showMsg(this.i18nStrings.selectAtLeastOnePaymentType,msg.errorType);			
				return;
			}
		}
		
		if(dijit.byId('useCpf').attr('value')=='YES'){
			mealorder.cpf=dijit.byId('cpf').attr('value');
		}
		com.copacabana.util.hideLoading();
		if(this.discount!=null && this.discount.isValid==true){
			mealorder.discountInfo={
				code:this.discount.code,
				value:this.discount.discValue*100,
				type:this.discount.type
			}	
		}
		console.log("mealorder.discountInfo",mealorder.discountInfo)
		
		
		var orderform = dojo.create("form",{action:"/submitOrder.do",method:"post"},this.domNode);
		dojo.create("input",{type:"hidden",name:"mealOrder",value:dojo.toJson(mealorder)},orderform);
		var agreeWithTerms = new com.copacabana.MessageWidget();
		var optionsAgreement=[
		             {
		            	id:"yes",
		            	label:"Concordo"		            	
		             },
		             {
			            	id:"no",
			            	label:"N&atilde;o concordo"		            	
		             }
		         
		];		
		var confMsg1 = this.i18nStrings.termsagreement;
		agreeWithTerms.promptMsg(confMsg1,optionsAgreement,function(response){		
			if(response=='yes' ){
				com.copacabana.util.showLoading();
				orderform.submit();			
			}
			return;
		},"Termos de uso");
		return;
		


	},
	coords:null,
	userLocationFound:function(geolocation){
		this.coords={
			x:	geolocation.coords.longitude,
			y:	geolocation.coords.latitude
		};
	},
	customer:null,
	deliveryAddresss:null,
	setCustomer:function(person){
		this.customer=person;	
	},
	setDeliveryAddress:function(delAddress){
		this.deliveryAddress=delAddress;
	},
	moneyChangeUpdated:function(evt){
		console.log('incash',dojo.byId("InCash").checked);
		var fdom = dojo.query(".formaPagamento",this.domNode)[0]
		if(dojo.byId("InCash").checked==true){
			dojo.style(fdom,'visibility','visible');
		}else{
			dojo.style(fdom,'visibility','hidden');
		}
		
	},
	setClientCPF:function(cpf){
		this.clientCPF=cpf;
		this.currentCPF=this.clientCPF;
	},
	clientCPF:'',
	currentCPF:'',
	useCPFChanged:function(evt){
		var shouldUseCPF=dijit.byId('useCpf').attr('value');
		var fdom = dojo.query(".cpfField",this.domNode)[0];
		var cpfField = dijit.byId('cpf');
		if(shouldUseCPF=='YES'){
			dojo.cookie("useCpf", 'true', { expires: 100 });	
			dojo.style(fdom,'visibility','visible');
			cpfField.attr('value',this.currentCPF);
			cpfField.onBlur=dojo.hitch(this,this.checkCpf);
		}else{
			dojo.cookie("useCpf", 'false', { expires: 100 });
			this.currentCPF=cpfField.attr('value');
			dojo.style(fdom,'visibility','hidden');
			cpfField.attr('value','');
			try{
			dijit.hideTooltip( dijit.byId('cpf').domNode);
			}catch(e){
				
			}
		}
		console.log('useCPFChanged',dijit.byId('useCpf').attr('value'));
	},	
	checkCpf:function(){
		var cpf = dijit.byId('cpf');
		var cpfval =dojo.string.trim(cpf.attr('value'));
		cpfval=cpfval.replace(/\s/g,'');
		cpf.attr('value',cpfval);
		if(com.copacabana.util.isCpfValid(cpfval)==false){
			dijit.showTooltip(this.i18nStrings.cpfInvalid, cpf.domNode);
		}else{
			dijit.hideTooltip( cpf.domNode);
		}
	}
	

});
