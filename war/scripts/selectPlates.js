var initSelectPlatesExecuted=false;
var initSelectPlates=function(){
	if(initSelectPlatesExecuted==false){
		initSelectPlatesExecuted=true;		
		$("#customPlate").dialog({
			autoOpen : false
		});
		$("#setPaymentDataBtn").button();
		$("#setPaymentDataBtn").click(continueToPayment);
		$("#halfSize").change(updateHalfPlates);
		
		
		$("#criaPrato").click(function(){$("#customPlate").dialog("open");});
		$("#createCustomButton").click(criarPratoEspecial);
		
		
		$("#createHalfPizza").button();
		$("#createHalfPizza").click(createHalfPizza);
		
		$("#editDeliveryTimeLink").click(toggleForeCast);
		
		PlateManager.listPlateExtensions(loadExtensions);
		
	}
}
var isCPFValid=function(data){
	return com.copacabana.util.isCpfValid(data);
}
var continueToPayment=function(){
	var plateList=[];
	for ( var id in order.plateList) {
		var item = order.plateList[id];
		plateList.push(item);
	}
	if(plateList.length>0){
		setOrderPlates(plateList,order.total);
	}else{
		alert("Selecione pelo menos 1 produto para completar o pedido.");
	}
}
var extensionPlates=[];
var loadExtensions=function(data){
	extensionPlates=data;
	PlateManager.listMainPlates(initAccordionPlates);
}
var getExtensions=function(main){
	var exts=[];
	for ( var i = 0; i < extensionPlates.length; i++) {
		var p = extensionPlates[i];
		if(p.extendsPlate==main.id){
			exts.push(p);
		}
	}
	return exts;
}

var editingForecast=false;
var toggleForeCast = function(){

	if(editingForecast==false){
		editingForecast=true;
		$("#delayForecast").css("backgroundColor","white");
		$("#delayForecast").focus();
		$("#editDeliveryTimeLink").html("Ok");
	}else{
		editingForecast=false;
		$("#delayForecast").css("backgroundColor","F7F7F7");			
		$("#editDeliveryTimeLink").html("Editar");
	}
}


var createTableEntry=function(id,title,priceFmt,priceInCents){
	var currentAccSection='<tr><td>';
	currentAccSection+=title;
	currentAccSection+='</td><td>';
	currentAccSection+=priceFmt;
	currentAccSection+='</td><td><button class="addCartButton" plateId="'+id+'" plateName="'+title+'" platePrice="'+priceInCents+'">Pedir</button>';
	currentAccSection+='</td></tr>';
	return currentAccSection;
}
var smallPlates = [];
var mediumPlates = [];
var regularPlates = [];
var initAccordionPlates = function(plates){
	var lastCategory="-1";
	var currentAccSection = "";

	for ( var i = 0; i < plates.length; i++) {
		var plate = plates[i];
		if(plate.foodCategory!=lastCategory){
			lastCategory=plate.foodCategory;
			if(currentAccSection!=""){
				currentAccSection+="</tbody></table></div>";
			}
			$("#accordion").append(currentAccSection);
			currentAccSection='<h3><a href="#section">'+plate.foodCategory+'</a></h3><div>';
			if(plate.foodCategory.indexOf('Pizza')>-1){
				currentAccSection+='<div id="halfOrder">Criar pizza meio a meio</div>';
			}
			currentAccSection+='<table><thead><tr><th>Nome</th>	<th>Preço</th><th></th></tr></thead><tbody>';
		}
		currentAccSection+=createTableEntry(plate.id,plate.title,(plate.priceInCents/100.0),plate.priceInCents);
		var exts = getExtensions(plate);
		for ( var j = 0; j < exts.length; j++) {
			var ext = exts[j];
			currentAccSection+=createTableEntry(ext.id,plate.title+" "+ext.title,(ext.priceInCents/100.0),ext.priceInCents);
			ext.extendsTitle=plate.title;
			if(ext.foodCategory.toLowerCase().indexOf('pizza')>-1){
			if(ext.allowsFraction){
				switch(ext.plateSize){
				case "SMALL":
					smallPlates.push(ext);
					break;
				case "MEDIUM":
					mediumPlates.push(ext);
					break;
				default:	
					regularPlates.push(ext);		
				}
			}
			}
		}
		if(plate.foodCategory.toLowerCase().indexOf('pizza')>-1 && plate.allowsFraction=='true'){
			regularPlates.push(plate);
		}
		
	
	}
	if(currentAccSection!=""){
		currentAccSection+="</tbody></table></div>";
		$("#accordion").append(currentAccSection);
	}

	$("#accordion").accordion({
		autoHeight : false,
		navigation : true,
		collapsible : true,
		active : -1
	});
	$(".addCartButton").button();
	$(".addCartButton").click(function() {
		var newPlate;
		if (order.plateList[$(this).attr("plateId")] != null) {
			newPlate = order.plateList[$(this).attr("plateId")];
			newPlate.qty++;
		} else {
			newPlate = {
					id : $(this).attr("plateId"),
					name : $(this).attr("plateName"),
					priceInCents : parseInt($(this).attr("platePrice")),
					qty : 1,
					fraction : false,
					fractionId : -1,
					custom : false
			}
		}
		order.plateList[$(this).attr("plateId")] = newPlate;
		updatePlateList();

	});
	$("#halfOrder").button();
	$("#halfOrder").click(startHalfOrder);
	updateHalfPlates();
}

var addPlate=function(plate){
	var html = '<ul><li class="itemprice"><div class="totalItemPrice">';
	html+=com.copacabana.util.moneyFormatter((plate.priceInCents/100.0)*plate.qty);
	
	html+='<a href="javascript:removePlate(\''+plate.id+'\')" title="Apagar item" class="deleteLink"></a></div></li>';
	html+='<li>'+plate.qty+' '+plate.name+'</li></ul>';
	
	html+="<input name='plateQty' type='hidden' value='"+plate.qty + "'><input name='plateId' type='hidden' value='"+plate.id + "'><input name='plateName' type='hidden' value='"
	+plate.name + "'><input name='platePrice' type='hidden' value='"
	+plate.priceInCents + "'><input name='plateCustom' type='hidden' value='"
	+plate.custom + "'><input name='plateFraction' type='hidden' value='"
	+plate.fraction + "'><input name='plateFractionId' type='hidden' value='"
	+plate.fractionId + "'>";
	
	
	$("#OrderDetails").append(html);	
	
}
var setNoEntries=function(){
	var html = '<ul><li class="itemprice"><div class="totalItemPrice">';		
	html+='</div></li>';
	html+='<li>Nenhum item adicionado...</li></ul>';
	
	$("#OrderDetails").append(html);	
}
var updatePlateList = function() {
	$("#OrderDetails").empty();	
	$("#plates").empty();
	var total = 0;
	var counter=0;
	for ( var id in order.plateList) {
		counter++;
		var plate = order.plateList[id];
		addPlate(plate);
		total += plate.priceInCents*plate.qty;
	}
	$("#subTotalSection").empty();
	$("#platesTotal").empty();
	if(counter==0){
		setNoEntries();
	}else{
		var subTotal = (total / 100);
		var totalWithDelivery = subTotal+(currentOrder.deliveryRange.costInCents/100.0);
		currentOrder.totalCost=totalWithDelivery;
		$("#platesTotal").append(com.copacabana.util.moneyFormatter(subTotal));
		$("#subTotalSection").append(com.copacabana.util.moneyFormatter(totalWithDelivery));
		
		order.total=totalWithDelivery;
		
	}

}
var removePlate = function(pid) {		
	for ( var id in order.plateList) {
		var plate = order.plateList[id];
		if (plate.id == pid) {
			if (plate.qty > 1) {
				plate.qty--;
			} else {
				delete order.plateList[id];
			}
			break;
		}
	}
	updatePlateList();
}


var currEspPlatIndex = -1;
	var criarPratoEspecial = function() {
		if (dijit.byId("custom.name").attr("value").length == 0) {
			dijit.byId('custom.name').displayMessage(
					dijit.byId('custom.name').invalidMessage);
			return;
		}
		if (dijit.byId("custom.price").length == 0
				|| dijit.byId("custom.price").validate() == false) {
			dijit.byId('custom.price').displayMessage(
					dijit.byId('custom.price').invalidMessage);
			return;
		}
		var newPlate = {
			id : currEspPlatIndex,
			name : dijit.byId("custom.name").attr('value'),
			priceInCents : parseInt(dijit.byId('custom.price').attr("value") * 100),
			qty : 1,
			fraction : false,
			fractionId : -1,
			custom : true
		}
		order.plateList[currEspPlatIndex--] = newPlate;
		updatePlateList();
		$("#customPlate").dialog("close");
		dijit.byId("custom.name").attr("value", "");
		dijit.byId("custom.price").attr("value","0,00");
		
	}
	var localPlates =[];
	var updateHalfPlates=function(arg){
		var plates=[];
		switch($("#halfSize").attr("value")){
		case "SMALL":
			plates=smallPlates;
			break;
		case "MEDIUM":
			plates=mediumPlates;
			break;
		default:	
			plates=regularPlates;			
		}
	
		halfPlates = {
				plate1:null,
				plate2:null
		}
		$("#halfOne").empty();$("#halfTwo").empty();
		$("#halfOne").append("<option value='-1'>Selecione uma opção</option>");
		$("#halfTwo").append("<option value='-1'>Selecione uma opção</option>");
		for ( var id in plates) {
			var plate = plates[id];
			localPlates[plate.id]=plate;
			
			var pname=plate.title;
			if(plate.extendsTitle){
				pname=plate.extendsTitle+" "+plate.title;
			}
			localPlates[plate.id].fullName=	pname;
			$("#halfOne").append("<option value='"+plate.id+"'>"+pname+"</option>");
			$("#halfTwo").append("<option value='"+plate.id+"'>"+pname+"</option>");
		}	
		$("#halfOne").change(setHalfOne);
		$("#halfTwo").change(setHalfTwo);
	}
	var halfPlates = {
			plate1:null,
			plate2:null
	}
	function setHalfOne(){
		var value = $("#halfOne").attr('value');
		if(value!="-1"){
			$("#priceHalfOne").html(com.copacabana.util.moneyFormatter(localPlates[value].priceInCents/100.0));
			halfPlates.plate1=localPlates[value];
		}
		updateTotalHalfs();
	}
	function setHalfTwo(){
		var value = $("#halfTwo").attr('value');
		if(value!="-1"){
			$("#priceHalfTwo").html(com.copacabana.util.moneyFormatter(localPlates[value].priceInCents/100.0));
			halfPlates.plate2=localPlates[value];
		}
		updateTotalHalfs();
	}
	function updateTotalHalfs(){
		if(halfPlates.plate1!=null && halfPlates.plate2!=null){
			var price = parseInt(halfPlates.plate1.priceInCents);
			if(restaurant.fractionType!='MOREEXPENSIVEWINS'){
				price=(parseInt(halfPlates.plate1.priceInCents)+parseInt(halfPlates.plate2.priceInCents))/2;
			}
			if(parseInt(halfPlates.plate1.priceInCents)<parseInt(halfPlates.plate2.priceInCents)){
				price = parseInt(halfPlates.plate2.priceInCents);
			}
			halfPlates.price=price;
			$("#totalHalf").html(com.copacabana.util.moneyFormatter(price/100.0));
		}
	}
	
	var createHalfPizza=function (){
		
		var cost = halfPlates.price;
		var newPlate = {
				id : halfPlates.plate1.id,
				name : "1/2 "+halfPlates.plate1.fullName+" 1/2 "+halfPlates.plate2.fullName,
				priceInCents : cost,
				qty : 1,
				fraction : true,
				fractionId : halfPlates.plate2.id,
				custom : false
			};
			order.plateList[currEspPlatIndex--] = newPlate;
			updatePlateList();
			$("#halfOrderDialog").dialog("close");
				
	}
	function startHalfOrder(){
		$("#halfOrderDialog").dialog({
			autoOpen : false,
			width:540
		});
		$("#halfOrderDialog").dialog("open");
	}
	
	function validate(){
		var counter = 0;
		for ( var id in order.plateList) {
			counter++;
			break;
		}
		if(counter==0){
			alert("Por favor selecione ao menos 1 item para o pedido");
			return false;
		}
		return true;
	}