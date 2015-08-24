var paymentRegionInit=false;
var i18nPayments= {
	INCASH:"Dinheiro",
	CHEQUE:"Cheque",
	PAYPAL:"Online",
	UNKNOWN:"Desconhecido",
	VISAMACHINE:"Visa",
	VISADEBITMACHINE:"Visa Electron",
	MASTERMACHINE:"MasterCard",
	MASTERDEBITMACHINE:"Maestro/Redeshop",
	AMEXMACHINE:"Amex",
	VISAVOUCHERMACHINE:"VisaVale",
	TRMACHINE:"TR TicketRestaurante",	
	TRSODEXHO:"Sodexho",
	VRSMART:"VRSmart",
	TRVOUCHER:"TR em papel"
	
}
var initPaymentSection=function(){
	if(paymentRegionInit==false){
		var types = restaurant.acceptedPaymentTypes.split("|");
		for ( var i = 0; i < types.length; i++) {
			
			if(types[i]!='PAYPAL' && types[i]!="INCASH"){
				var checkBox = "<input type='radio' name='paymentType' value='"+types[i]+"'>";
				checkBox+=" <label for='"+types[i]+"'>"+i18nPayments[types[i]];					
				checkBox+="<br>";				
				$("#acceptedPaymentTypes").append(checkBox);
			}
		}
		$("#submitOrder").button();
		$("#submitOrder").click(sendOrder);
		paymentRegionInit=true;
	}
	$("#amountInCash").attr("value","0,00");
	
}
var validate=function(){
	try{
		var paymentType = $("[name='paymentType']:checked==checked");
		if(paymentType.attr('value')=="INCASH"){
			if(dijit.byId('amountInCash').validate()==false){
				dijit.byId('amountInCash').displayMessage(dijit.byId('amountInCash').invalidMessage);
				return false;
			}
			if(dijit.byId('amountInCash').attr('value')< currentOrder.totalCost){
				alert("Valor em dinheiro deve ser maior que valor total do pedido");
				return false;
			}
			
		}
		
		if(dijit.byId('cpf').attr('value').length>0 && dijit.byId('cpf').validate()==false){
			alert("CPF Inválido.");
			return false;
		}
	}catch(e){
		console.error(e);
	}	
	return true;
}
var sendOrder=function(){
	if(validate()==true){
		setOrderPayment($("[name='paymentType']:checked==checked").attr('value'),dijit.byId('amountInCash').attr("value"));
		setOrderExtra(dijit.byId('cpf').attr('value'),$("[name='observation']").attr('value'));
		setPaymentComplete();
	}
}