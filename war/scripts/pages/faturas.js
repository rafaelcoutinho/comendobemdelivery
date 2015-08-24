dojo.require("com.copacabana.util");
dojo.require("dojo.currency");
dojo.require("dijit.form.Textarea");
dojo.require("com.copacabana.RoundedButton");	        
dojo.require("com.copacabana.order.RestaurantOrdersWidget");
dojo.require("dijit.form.Select");
dojo.require("dojo.parser"); 
dojo.require("dojo.data.ItemFileReadStore");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.TextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("dijit.Dialog");
dojo.require("dijit.form.TimeTextBox");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.DateTextBox");

function createHeader(table){
	var line = dojo.create('TR',null,table);
	dojo.create('th',{innerHTML:'&nbsp;'},line);
	dojo.create('th',{innerHTML:'N&#250;mero do pedido'},line);				
	dojo.create('th',{innerHTML:'Data'},line);
	dojo.create('th',{innerHTML:'Tipo Pagamento'},line)
	var vrest = dojo.create('th',{innerHTML:'Valor Restaurante'},line);
	dojo.create('sup',{innerHTML:'1'},vrest);
	dojo.create('th',{innerHTML:'Comiss&#227;o'},line);
	
	
	return line;
	
}
var restaurantName="";
function fillFactureData(data){
	console.log("fatur",data);
	com.copacabana.util.cleanNode(dojo.byId('factureTable'));
	dojo.style(dojo.byId('finalSection'),'display','block');
	createHeader(dojo.byId('factureTable'));
	var totalRest = 0;
	var totalOnlineRest = 0;
	var totalOfflineRest = 0;
	var convOnline = 0;
	var counterOnline = 0;
	var convOffline = 0;
	var counterOffline = 0;
	var counter=0;
	counter=data.length;
	var table=dojo.byId('factureTable');
	if(restaurantName){
	}
	for(var i=0;i<data.length;i++){
		var order=data[i];
		createFactureLine(order,table);
		var restAmt = (order.paymentTotalValue-order.convenienceTax)/100;
		totalRest+=	restAmt;
		if(order.paymentType=='PAYPAL'){
			convOnline+=order.convenienceTax/100;
			counterOnline++;
			totalOnlineRest+=restAmt;
		}else{
			convOffline+=order.convenienceTax/100;
			counterOffline++;
			
			totalOfflineRest+=restAmt;
			
		}										
	}
	console.log("totalOfflineRest",totalOfflineRest)
	console.log("totalOnlineRest",totalOnlineRest)
	console.log("totalRest",totalRest)
	createFinalLine(counter,totalRest,totalOnlineRest,totalOfflineRest,counterOnline,counterOffline,convOnline,convOffline,dojo.byId('factureTable'));
	
	
}


function createFinalLine(counter,totalRest,totalOnlineRest,totalOfflineRest,counterOn,counterOff,convOnline,convOffline,table){
	try{
		
	var line = dojo.create('TR',null,table);
	dojo.create('td',{style:{width: 'auto'},colSpan:6,innerHTML:'&nbsp;'},line);
	line = dojo.create('TR',null,table);
	dojo.create('td',{innerHTML:'Totais:'},line);				
	dojo.create('td',{innerHTML:counter+' pedidos'},line);
	dojo.create('td',{innerHTML:'&nbsp;'},line);
	dojo.create('td',{innerHTML:'&nbsp;'},line);
	dojo.create('td',{innerHTML:com.copacabana.util.moneyFormatter(totalRest)},line);
	dojo.create('td',{innerHTML:com.copacabana.util.moneyFormatter((convOnline+convOffline))},line);
	line = dojo.create('TR',null,table);				
	dojo.create('td',{innerHTML:'Detalhes:'},line);
	dojo.create('td',{innerHTML:'&nbsp;'},line);
	dojo.create('td',{innerHTML:'&nbsp;'},line);
	dojo.create('td',{innerHTML:counterOn+' online<br>'+counterOff+' tradicional'},line);
	dojo.create('td',{innerHTML:'Online<sup>2</sup>:'+com.copacabana.util.moneyFormatter(totalOnlineRest)+'<br> Tradicional<sup>3</sup>:'+com.copacabana.util.moneyFormatter(totalOfflineRest)},line);
	
	dojo.create('td',{innerHTML:'Online<sup>4</sup>:'+com.copacabana.util.moneyFormatter(convOnline)+'<br> Tradicional<sup>5</sup>:'+com.copacabana.util.moneyFormatter(convOffline)},line);
	line = dojo.create('TR',null,table);

	
	var finalTd = dojo.create('td',{colSpan:6,style:{width: 'auto'}},line);
	
	var tb = dojo.create('table',{className:'totais'},finalTd);
	
	var t = dojo.create('tbody',{className:'totais'},tb);
	var tr = dojo.create('tr',null,t);
	dojo.create('td',{innerHTML:'Total devido ao restaurante:'},tr);
	dojo.create('td',{innerHTML: com.copacabana.util.moneyFormatter(totalOnlineRest)},tr);
	 tr = dojo.create('tr',null,t);
	dojo.create('td',{innerHTML:'Total devido ao ComendoBem:'},tr);
	dojo.create('td',{innerHTML: com.copacabana.util.moneyFormatter(-1*convOffline)},tr);

	var totalFinal = (totalOnlineRest-convOffline)
	tr = dojo.create('tr',null,t);
	if(totalFinal>0){					
		dojo.create('td',{innerHTML:'<b>Total a receber:</b>'},tr);					
	}else{					
		dojo.create('td',{innerHTML:'<b>Total a pagar:</b>'},tr);
		totalFinal*=-1;					
	}	
	dojo.create('td',{innerHTML: "<b>"+com.copacabana.util.moneyFormatter(totalFinal)+"</b>",className:'totalFinal'},tr);
	console.log('ok');
	}catch(e){
	console.error('falo',e);	
	}
}


var traduzPgto ={'CHEQUE':'Cheque','INCASH':'Dinheiro','PAYPAL':'Online',VISAMACHINE:"VISA",VISADEBITMACHINE:"VisaElectron",AMEXMACHINE:"M&aacute;quina AMEX",MASTERMACHINE:"MASTERCARD",VISAVOUCHERMACHINE:"VisaVale",MASTERDEBITMACHINE:"Maestro/Redeshop",TRMACHINE:"M&aacute;quina TR",VRSMART:"M&aacute;quina VRSmart",TRVOUCHER:"Vale papel TR"};
function createFactureLine(order,table){
	var line = dojo.create('TR',null,table);
	dojo.create('td',{innerHTML:'&nbsp;'},line);
	dojo.create('td',{innerHTML:order.idXlated},line);
	dojo.create('td',{innerHTML:order.orderedTime},line);
	dojo.create('td',{innerHTML:""+traduzPgto[order.paymentType]},line);
	var restAmt = (order.paymentTotalValue-order.convenienceTax)/100;
	dojo.create('td',{innerHTML:com.copacabana.util.moneyFormatter(restAmt)},line);
	//dojo.create('td',{innerHTML:"c:"+com.copacabana.util.moneyFormatter(order.convenienceTax/100)+" t:"+com.copacabana.util.moneyFormatter(order.tax)},line);
	dojo.create('td',{innerHTML:com.copacabana.util.moneyFormatter(order.convenienceTax/100)},line);
	
	return line;
}
var currentFacture = {
	monthName:'',
	monthNum:''
}

function loadFacture(monthNum,id){	        		        	 
	
	currentFacture.monthName = monthNames[monthNum];
	currentFacture.monthNum = monthNum;
	var m =monthNum;
	var dateStartStr = "00:00:00 01-"+m+"-2011";
	var dateEndStr = "00:00:00 01-"+(m+1)+"-2011";
	dojo.byId('start').value=dateStartStr;
	dojo.byId('end').value=dateEndStr;
	dojo.byId('restId').value=id;
	
	var xhrArgs = {
            form: dojo.byId('factureForm'),
            handleAs: "json",
            load: function(data) {
            	fillFactureData(data);
            	dojo.publish('factureLoaded');
            },
            error: function(error) {
           	 console.log('error',error);
           	 alert('Falha ao carregar dados');
            }
        }
	var deferred = dojo.xhrPost(xhrArgs);
	console.log('enviado');
	return false;
}
var monthNames ={1:'Janeiro',2:'Fevereiro',3:'Março',4:'Abril',5:'Maio',6:'Junho',7:'Julho',8:'Agosto',9:'Setembro',10:'Outubro',11:'Novembro',12:'Dezembro'}; 
function loadDataByDateRange(dateStartStr,dateEndStr,id){	        		        	 
	
	
	dojo.byId('start').value=dateStartStr;
	dojo.byId('end').value=dateEndStr;
	dojo.byId('restId').value=id;
	console.log("consultando para "+dateStartStr+" ate "+dateEndStr+" de "+id);
	var xhrArgs = {
            form: dojo.byId('factureForm'),
            handleAs: "json",
            load: function(data) {
            	fillFactureData(data);
            	dojo.publish('factureLoaded');
            },
            error: function(error) {
           	 console.log('error',error);
           	 alert('Falha ao carregar dados');
            }
        }
	var deferred = dojo.xhrPost(xhrArgs);
	console.log('enviado');
	return false;
}

