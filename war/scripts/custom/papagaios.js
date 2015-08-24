/**
 * Custom js for Papagaios
 */


var pptrigger=false;
var papagaiosCustomUpdateTotals=function(){
	/*if(pptrigger==false){
		pptrigger=true;
		this.updateDeliveryCost(currentppdelInfo.cost,currentppdelInfo.costInCents)
	}else{
		pptrigger=false;
	}*/
	if(currentppdelInfo){
		papagaiosLogic(currentppdelInfo);
		this.deliveryCost=currentppdelInfo.cost;
		this.deliveryCostInCents=currentppdelInfo.costInCents;
	}
	
	
	
}
var papagaiosCustomUpdateDeliveryCost=function(){
	
	if(currentppdelInfo){
		papagaiosLogic(currentppdelInfo);	
		this.deliveryCost=currentppdelInfo.cost;
		this.deliveryCostInCents=currentppdelInfo.costInCents;
	}
	//console.log("this.deliveryCost",this.updateDeliveryCost(currentppdelInfo.cost,currentppdelInfo.costInCents))
}
var currentppdelInfo={};
var papagaiosLogic = function(deliveryInfo,takeaway){
	currentppdelInfo=deliveryInfo;
	console.log(deliveryInfo);	
	var idNeigh = deliveryInfo.neighborhood;
	console.log("papagaiosConf: ",papagaiosConf.loaded);
	
	var orderManager = dijit.byId('com_copacabana_order_OrderManagerWidget_0');
	var totalPizzas=0;
	for(var i =0;i<orderManager.plateList.length;i++){
		var plate = orderManager.plateList[i];
		var plateId;
		if(plate.isFraction){
			plateId=plate.fractionPlates[0]
		}else{
			plateId=plate.plate;
		}
		console.log("plateId:"+papagaiosConf.plates[plateId],plateId)
		
		if(papagaiosConf.plates[plateId]==true){
			totalPizzas+=parseInt(plate.qty);
		}
	}
	console.log('total de pizzas',totalPizzas);
	var ppDelCost = papagaiosConf.delivery[idNeigh];
	console.log('taxa '+idNeigh,papagaiosConf.delivery[idNeigh])
	if(ppDelCost){
		var totalTaxes=parseInt(ppDelCost['1']);
		console.info("1 pizza "+ppDelCost['1']);
		if(totalPizzas>1){
			console.info("2 pizzas +"+ppDelCost['2']);	
			totalTaxes+=ppDelCost['2']			
		}
		
		if(totalPizzas>2){
			console.info("2 pizzas +"+ppDelCost['3']);
			totalTaxes+=ppDelCost['3'];
		}
		if(totalPizzas>3){
			console.info("4 ou mais pizzas +"+ppDelCost['4']+" * "+(totalPizzas-3));
			totalTaxes+=ppDelCost['4']*(totalPizzas-3);
		}
			console.info("total "+totalTaxes);
			
		
		deliveryInfo.cost=totalTaxes/100;
		deliveryInfo.costInCents=totalTaxes;
	}
	
	
}
var papagaiosConf={
	delivery:{},
	plates:{},
	loaded:false
}

var loadedPapagaiosData=function(data){
	papagaiosConf=data;
	papagaiosConf.loaded=true;
	dijit.byId('com_copacabana_order_OrderManagerWidget_0').updateTotals();
}
dojo.addOnLoad(function() {
	console.log("Carregou papagaios")
	dijit.byId('deliveryManager').customDeliveryCostFct=papagaiosLogic;
	dijit.byId('com_copacabana_order_OrderManagerWidget_0').customUpdateDeliveryCost=papagaiosCustomUpdateDeliveryCost;
	dijit.byId('com_copacabana_order_OrderManagerWidget_0').customUpdateTotals=papagaiosCustomUpdateTotals;
	
	var xhrParams = {
			error : function(error){console.error("problemas ao carregar logica da Papagaios pizza",error)},
			handleAs : 'json',
			load : loadedPapagaiosData,
			url : '/custom/papagaios.jsp'
	};
	dojo.xhrGet(xhrParams);
});