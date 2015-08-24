var delRanges=[];
function queryAllDelRanges(callback) {
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM DELIVERYRANGE', [], function(tx,
				results) {
			
			
			var resultsJson=[];
			if (results.rows && results.rows.length) {				
				for (i = 0; i < results.rows.length; i++) {		
					var entry = convertDelRangeResultToJson(results.rows.item(i));
										
					resultsJson.push(
							entry						
					);					
				}				
			}
			callback(resultsJson);
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});

}
function queryAllNeighs(callback) {
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM NEIGHBORHOOD', [], function(tx,
				results) {
			
			
			var resultsJson=[];
			if (results.rows && results.rows.length) {				
				for (i = 0; i < results.rows.length; i++) {		
					var entry = convertNeighResultToJson(results.rows.item(i));
										
					resultsJson.push(
							entry						
					);					
				}				
			}
			callback(resultsJson);
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});

}
function setDelRangeCache(data){
	for ( var i = 0; i < data.length; i++) {
		var delRange = data[i];
		delRanges[data[i].neighborhoodId]={
				"id":delRange.id,
				"costInCents":delRange.costInCents,
				"minimumCostInCents":delRange.minimumCostInCents
		}
	}
}
function initDelRanges(){
	
	queryAllDelRanges(setDelRangeCache);
	initNeighCombo();
	$("#createAddress").click(createAddressAndContinue);
}
function initNeighCombo(){
	if(comboNLoaded==false){
	queryAllNeighs(setNeighComboValues);
	}
}
var comboNLoaded=false;
function setNeighComboValues(data){
	//neighborhood
	var outOfRange=[];
	for ( var i = 0; i < data.length; i++) {
		var n = data[i];
		if(delRanges[n.id]!=null){
			$("#neighborhood").append("<option value='"+n.id+"'>"+n.name+"</option>");
		}else{
			outOfRange.push(n);
		}
	}
	
	$("#neighborhood").append("<option value='-1'>--- Bairros fora da área de entrega --</option>");
	for ( var i = 0; i < outOfRange.length; i++) {
		var n = outOfRange[i];
		$("#neighborhood").append("<option value='"+n.id+"'>* "+n.name+"</option>");		
	}
	$("#neighborhood").change(function(event,ui){
		console.log("changed")
		if($(this).attr('value')==-1){
			return;
		}
		var delRange = delRanges[$(this).attr('value')];
		$("#status").empty();
		if(!delRange){
			var neigh=$(this).attr('value');
			
			var fct=function(){					
				showDeliveryRangeForm(neigh,$("option[value="+neigh+"]").html());
			}
			$("#statusDelRange").html("Fora da área de entrega!"); //<a href='#' >Adicionar região de entrega</a>");
			$("#statusDelRange").click(fct);
			
			$("#createAddress").attr('disabled',true);
		}else{
			$("#createAddress").attr('disabled',false);
			$("#statusDelRange").html("Taxa de entrega "+com.copacabana.util.moneyFormatter(delRange.costInCents/100.0));
			$("#newAddressDialog [name='deliveryRangeId']").attr("value",delRange.id);
			$("#newAddressDialog [name='deliveryRangeCostInCents']").attr("value",delRange.costInCents);
			
		}
		
	});
	comboNLoaded=true;
}

function showClientAddresses(clientAddresses){
	$("#addressListNotInRange").empty();
	$("#addressList").empty();
var html = "<table><thead><th>Endereço</th><th>Taxa</th></thead><tbody>";
		var htmlOut = "<table><thead><th>Endereço</th><th></th></thead><tbody>";
		var totalInRange=0;
		var totalOutOfRange=0;
		for(var id in clientAddresses){
			var address = clientAddresses[id];	
			var delRange =delRanges[address.neighborhood.id];
			if(delRange){
				totalInRange++;
				html+="<tr><td class='inRange clickable' addressId='"+id+"'>"+address.addressStr()+" </td><td>"+com.copacabana.util.moneyFormatter(delRange.costInCents/100.0)+"</td><tr>";
			}else{
				htmlOut+="<tr><td class='notInRange' >"+address.addressStr()+" </td><td neigh='"+address.neigh+"' class='notInRange'>  </td></tr>";
				totalOutOfRange++;
			}
		}
		html+="</tbody></table>";
		htmlOut+="</tbody></table>";
		if(totalInRange>0){
			$("#addressList").append("Endereços cadastrados: "+html);
		}else{
			$("#addressList").append("Não há endereços cadastrados para este cliente.");
		}
		if(totalOutOfRange>0){
			$("#addressListNotInRange").append("Endereços cadastrados fora da área de entrega: "+htmlOut);
		}
		
		var dialogCleanerFct = function(){
			$("#newAddressDialog [name='deliveryRangeId']").attr("value",'');
			$("#newAddressDialog [name='deliveryRangeCostInCents']").attr("value",'0');
			$("#newAddressDialog [name='address.phone']").attr('value',currentClient.phone);
			$("#newAddressDialog [name='address.number']").attr('value','');
			$("#newAddressDialog [name='address.additionalInfo']").attr('value','');
			$("#newAddressDialog [name='address.street']").attr('value','');
		}
		if(totalInRange==0 && totalOutOfRange==0){
			$("#newAddressDialog").dialog({
				autoOpen : true,
				width:750,
				open: dialogCleanerFct,	
				height:400
			});
		}else{
			$("#newAddressDialog").dialog({
				autoOpen : false,
				width:750,
				open: dialogCleanerFct,
				height:400
			});
			
		}
		$("#openNewAddressDialog").click(function(){$("#newAddressDialog").dialog("open");})
		$(".notInRange").click(function(){
			var neigh = $(this).attr("neigh");
			showDeliveryRangeForm(neigh,$("option[value="+neigh+"]").html());	
		});
		$(".inRange").click(function(){
			com.copacabana.util.showLoading("Aguarde...");
			var address = clientAddresses[$(this).attr("addressId")];
			createAddressAndContinue4step(address);
			com.copacabana.util.hideLoading();
			
		});
}

function createAddressAndContinue(){
	AddressManager.queryNeighborhoodById($("#newAddressDialog [name='address.neighborhood']").attr('value'),createAddressAndContinue2step);
	
}
var createAddressAndContinue2step=function (neighbor){
	neighbor=neighbor[0];
	var address = {};
	address.phone=$("#newAddressDialog [name='address.phone']").attr('value');	
	address.number=$("#newAddressDialog [name='address.number']").attr('value');	
	address.additionalInfo=$("#newAddressDialog [name='address.additionalInfo']").attr('value');
	address.neighborhood={};
	address.neighborhood.id=$("#newAddressDialog [name='address.neighborhood']").attr('value');
	address.neighborhood.name=neighbor.name;
	address.neighborhood.city=neighbor.city;
	
	address.street=$("#newAddressDialog [name='address.street']").attr('value');
	
	var deliveryRange = delRanges[address.neighborhood.id];
	address.clientId=currentOrder.client.id;	
	AddressManager.createOffLineAddress(address,createAddressAndContinue3step);
}
var createAddressAndContinue3step = function(addressId){
	AddressManager.queryById(addressId,createAddressAndContinue4step);
	
	
}
var createAddressAndContinue4step = function(addressCreated){
	$("#newAddressDialog").dialog("close");
	var deliveryRange = delRanges[addressCreated.neighborhood.id];
	selectOrderAddress(addressCreated,deliveryRange);
	startPlateSelection();
}
//ID TEXT UNIQUE,IDCLIENT TEXT, ADDITIONALINFO TEXT, NUMBER TEXT, STREET TEXT, PHONE TEXT, NEIGHBORHOOD_NAME TEXT,NEIGHBORHOOD_ID TEXT,NEIGHBORHOOD_CITY TEXT, LAST_UPDATE LONG
