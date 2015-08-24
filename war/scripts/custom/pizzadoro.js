dojo.addOnLoad(function() {
	console.log("Carregou pizzadoro")
	
	
	var xhrParams = {
			error : function(error){console.error("problemas ao carregar logica da pizzadoro pizza",error)},
			handleAs : 'json',
			load : loadedPizzadoroData,
			url : '/custom/pizzadoro.jsp'
	};
	dojo.xhrGet(xhrParams);
});



var pizzadoroCustomUpdateTotals=function(){
	
	if(currentppdelInfo){
		pizzadoroLogic(currentppdelInfo);
		this.deliveryCost=currentppdelInfo.cost;
		this.deliveryCostInCents=currentppdelInfo.costInCents;
	}
	
	
	
}
var pizzadoroCustomUpdateDeliveryCost=function(){	
	if(currentppdelInfo){
		pizzadoroLogic(currentppdelInfo);	
		this.deliveryCost=currentppdelInfo.cost;
		this.deliveryCostInCents=currentppdelInfo.costInCents;
	}else{
		dijit.byId('deliveryManager').checkIfAddressInRange();
	}
	//console.log("this.deliveryCost",this.updateDeliveryCost(currentppdelInfo.cost,currentppdelInfo.costInCents))
}

var delayedFunction=function(){
	console.log("checking again");
	dijit.byId('deliveryManager').checkIfAddressInRange();	
}

var currentppdelInfo=null;
/** para cada pizza da promoção devo adicionar 11% a mais no preço dela e colocar como taxa de entrega **/
var pizzadoroLogic=function(deliveryInfo,takeaway){
	
	if(pizzadoroConf.loaded==false){
		oldDelRage=deliveryInfo;
		console.log("delaying");
		setTimeout("delayedFunction",1000);
		return;
	}
	
	currentppdelInfo=deliveryInfo;
	console.log(deliveryInfo);	
	var idNeigh = deliveryInfo.neighborhood;
	console.log("pizzadoroConf: ",pizzadoroConf.loaded);
	var orderManager = dijit.byId('com_copacabana_order_OrderManagerWidget_0');	
	var totalOrderCost = 0;
	var deliveryCost= 0;
	var hasNonPromotional=false;
	for(var i =0;i<orderManager.plateList.length;i++){
		var plate = orderManager.plateList[i];
		if(plate.qty==0){
			continue;
		}
		var plateId;
		if(plate.isFraction==true){
			if(pizzadoroConf.plates[plate.fractionPlates[0]] || pizzadoroConf.plates[plate.fractionPlates[1]]){

				plateId=plate.fractionPlates[0]
				if(pizzadoroConf.plates[plate.fractionPlates[0]] && pizzadoroConf.plates[plate.fractionPlates[1]]){
					deliveryCost+=(plate.priceInCents*plate.qty*pizzadoroConf.pctInt);
				}else{
					deliveryCost+=(plate.priceInCents*plate.qty*pizzadoroConf.pctInt/2);				
				}			
			}else{
				hasNonPromotional=true;
			}
		}else{
			plateId=plate.plate;
			if(pizzadoroConf.plates[plateId]){
				deliveryCost+=plate.priceInCents*plate.qty*pizzadoroConf.pctInt;
			}else{
				hasNonPromotional=true;
			}
		}	
		
		totalOrderCost+=plate.priceInCents*plate.qty;
	}
	if(!deliveryInfo.originalCost){
		deliveryInfo.originalCost=deliveryInfo.cost;
		deliveryInfo.originalCostInCents=deliveryInfo.costInCents;
	}
	if(hasNonPromotional==true){
		deliveryCost+=deliveryInfo.originalCostInCents
	}
	deliveryInfo.cost=(deliveryCost)/100;
	deliveryInfo.costInCents=deliveryCost;
	
	console.log("delivery info",deliveryInfo);
}
var pizzadoroConf={
		loaded:false
};
var loadedPizzadoroData=function(data){
	pizzadoroConf=data;
	pizzadoroConf.pctInt=parseInt(pizzadoroConf.pct)/100.0;
	pizzadoroConf.loaded=true;	
	dijit.byId('deliveryManager').customDeliveryCostFct=pizzadoroLogic
	dijit.byId('com_copacabana_order_OrderManagerWidget_0').customUpdateDeliveryCost=pizzadoroCustomUpdateDeliveryCost;
	dijit.byId('com_copacabana_order_OrderManagerWidget_0').customUpdateTotals=pizzadoroCustomUpdateTotals;
	dijit.byId('com_copacabana_order_OrderManagerWidget_0').updateTotals();
	dijit.byId('deliveryManager').checkIfAddressInRange();	
}