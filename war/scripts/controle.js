var showNewClient = function(){ 
	$("[name=phone]").attr('value',$("[name=search]").attr('value'));
	$("#newClientForm").dialog('open')
}
	var cache = {},
	lastXhr;
	function checkDB(callback) {
		db.transaction(function(tx) {
			tx.executeSql('SELECT count(*) as totalClients FROM CLIENT', [], function(tx,
					results) {
				console.log("results ", results.rows);
				var resultsJson=[];
				if (results.rows && results.rows.length) {
					console.log('loading from DB');
					callback(results.rows.item(0).totalClients);
										
									
				}else{
					console.error("failed", "no results found")	
				}
				
			}, function(tx, ee) {
				console.error("failed", ee)
			})
		});

	}
	var localTotal=-1;
	function localResults(totalLocal){
		localTotal=totalLocal;
		loadServerData(null,serverTotal);
		
		loadAddressServerData(null);
	}
	function serverTotal(obj){
		console.log(obj.clients.length,localTotal);
		if(obj.clients.length==localTotal){
			$(resultSection).append("Base ok.");
		}else{
			if(obj.clients.length>localTotal){
				$(resultSection).append("Base diferente, recomendado sincronizar.");	
			}else{
				$(resultSection).append("Base local com mais dados que o servidor, recomendado sincronizar.");
			}
		}
	}
	
	var checkDatabase=function(){
		
	}
	var restaurant;
	var  displayStatus=function(updates){
		$("#status_db").empty();
		var text = "";
		var startSync = function(callback){	
			$("#status_db").empty();
			$("#status_db").html("<div><div style='float:left' class='ui-button-icon-primary ui-icon ui-icon-check'></div>ok</div>");
		}
		text+="<div><div style='float:left' class='ui-button-icon-primary ui-icon ui-icon-alert'></div>"
		if(updates.clients.length>0){
			text += " Há "+updates.clients.length+" clientes que precisam ser sincronizados!";
			$("#status_must_sync").html("Favor sincronizar");
		}else if(updates.addresses.length>0){
			text += " Há "+updates.addresses.length+" endereços que precisam ser sincronizados!";
			$("#status_must_sync").html("Favor sincronizar");
		}else if(updates.orders.length>0){
			text += " Há "+updates.orders.length+" pedidos que precisam ser enviadas para o servidor!";
			$("#status_must_sync").html("Favor sincronizar");
			
		}else{
			text="<div><div style='float:left' class='ui-button-icon-primary ui-icon ui-icon-check'></div> Todos os dados locais estão no servidor.</div>";
			$("#status_must_sync").empty();
		}
		text+="</div>";
		$("#status_db").html(text);
		
	}
	$(document).ready(
			
			function() {
				initOffLineControls();
				initDb();
				checkIsLogged();
				
				$("button").button();
				$( "#updateBtn").click(
						function(){
							console.log("sincronizar");
							$("#status_must_sync").empty();
							SyncerManager.checkForChanges(displayUpdateStatus);
						}						
					);				
				$( "#refresh").click(loadServerData)
				$( "#clearDB").click(
						function(){
							if(confirm("Esta ação irá apagar todos os dados locais. Será então necessário recarregar os dados remotos.")){
								clearDB();	
							}							
						}
				)

				var btnParams = {
					icons: {
						primary: "ui-icon-arrowrefresh-1-n"
					},
					text: false
				};
				$("#refMenu").button(btnParams);				
				$("#refMenu").click(
					function(){						
						plateAlreadyLocal=0;
						PlateManager.loadServerData(null);
					}
				);
				
				
				$("#refClients").button(btnParams);				
				$("#refClients").click(
					function(){
						clientAlreadyLocal=0;
						loadClientData(null);
					}
				);
				$("#refDelRange").button(btnParams);				
				$("#refDelRange").click(
					function(){
						delRangeAlreadyLocal=0;
						loadDelRangeServerData(null);
					}
				);
				
				$("#refAddresses").button(btnParams);				
				$("#refAddresses").click(
					function(){
						addressAlreadyLocal=0;
						loadAdressServerData(null);
					}
				);
				
				$("#refRest").button(btnParams);				
				$("#refRest").click(
					function(){						
						RestaurantManager.reloadDataFromServer(notifyRestauranteUpdate);
					}
				);
				
				$("#refNeigh").button(btnParams);				
				$("#refNeigh").click(
					function(){						
						neighAlreadyLocal=0;
						loadNeighborhoodServerData(null);
					}
				);
				
				var cb = function(date){
					if(!date || date.getTime()==0){
						$("#menuStatus").html("nunca foi atualizado.");
					}else{
						$("#menuStatus").html("Última atualização: "+date.getDate()+"/"+date.getMonth()+" às "+date.getHours()+":"+date.getMinutes());
					}
				}
				
				
				PlateManager.whenPlatesWereUpdated(cb);
				
				
				
				SyncerManager.checkForChanges(displayStatus);
				
			});
		
	
	
	

	var status = document.getElementById("status");
	var status2 = document.getElementById("status2");
	var resultSection = document.getElementById("resultSection");
	
