var db;

/**
 * Inicializa banco local
 * @param log
 */
function initDb(log) {
		
		console.log('initialising database');
		try {
			if (window.openDatabase) {
				db = openDatabase("cbdb", "1.0",
						"ComendoBem ERP", 200000);
				if (db) {
					db
							.transaction(function(tx) {
								tx
										.executeSql(
												"CREATE TABLE IF NOT EXISTS CLIENT (ID TEXT UNIQUE, NAME TEXT, PHONE  TEXT, EMAIL TEXT,KIND TEXT, REGISTEREDON LONG, LAST_UPDATE LONG)",
												[],
												function(tx, result) {
													//clear();
													console.log('CLIENT Table was created');
												});
							});
					db
					.transaction(function(tx) {
						tx
								.executeSql(
										"CREATE TABLE IF NOT EXISTS ADDRESS (ID TEXT UNIQUE,IDCLIENT TEXT, ADDITIONALINFO TEXT, NUMBER TEXT, STREET TEXT, PHONE TEXT, NEIGHBORHOOD_NAME TEXT,NEIGHBORHOOD_ID TEXT,NEIGHBORHOOD_CITY TEXT, LAST_UPDATE LONG)",
										[],
										function(tx, result) {
											//clear();
											console.log('ADDRESS table was created');
										});
					});
					db
					.transaction(function(tx) {
						tx
								.executeSql(
										"CREATE TABLE IF NOT EXISTS NEIGHBORHOOD (ID TEXT UNIQUE,NAME TEXT, CITYNAME TEXT)",
										[],
										function(tx, result) {
											//clear();
											console.log('NEIGHBORHOOD table was created');
										});
					});
					db
					.transaction(function(tx) {
						tx
								.executeSql(
										"CREATE TABLE IF NOT EXISTS DELIVERYRANGE (ID TEXT UNIQUE,IDNEIGHBORHOOD TEXT, COSTINCENTS LONG, MINIMUMCOSTINCENTS LONG)",
										[],
										function(tx, result) {
											//clear();
											console.log('DELIVERYRANGE table was created');
										});
					});
					
					db
					.transaction(function(tx) {
						tx
								.executeSql(
										"CREATE TABLE IF NOT EXISTS PLATE (ID TEXT UNIQUE,EXTENDSPLATE TEXT,TITLE TEXT, PLATESIZE TEXT, FOODCATEGORY TEXT, PRICEINCENTS LONG, ALLOWSFRACTION NUMERIC, ISAVAILABLE NUMERIC)",
										[],
										function(tx, result) {
											//clear();
											console.log('PLATE table was created');
										});
					});
					db
					.transaction(function(tx) {
						tx
								.executeSql( 
										"CREATE TABLE IF NOT EXISTS RESTAURANT (ID TEXT UNIQUE,NAME TEXT, FRACTIONPRICETYPE TEXT, CURRENTDELAY TEXT,ACCEPTEDPAYMENTTYPES TEXT)",
										[],
										function(tx, result) {
											//clear();
											console.log('RESTAURANT table was created');
										},
										function(error){
											console.log("err",error);
										});
					});
					
					db
					.transaction(function(tx) {
						tx
								.executeSql(
										"CREATE TABLE IF NOT EXISTS LOCALORDER (ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, " +
										"ADDRESS_STREET TEXT,ADDRESS_NUMBER TEXT,ADDRESS_ADDITIONALINFO TEXT,ADDRESS_NEIGHBORHOOD_ID TEXT,ADDRESS_PHONE TEXT," +
										"CPF TEXT,AMOUNTINCASH TEXT,PAYMENTTYPE TEXT,DELAYFORECAST TEXT,CLIENT_ID TEXT,OBSERVATION TEXT," +
										"DELIVERY_ID TEXT, PLATEBLOB TEXT)",
										[],
										function(tx, result) {
											//clear();
											console.log('LOCALORDER Table was created');
										});
					});
					
					db
					.transaction(function(tx) {
						tx
								.executeSql( 
										"CREATE TABLE IF NOT EXISTS CONTROL (ID TEXT UNIQUE,VALUE TEXT)",
										[],
										function(tx, result) {
											//clear();
											console.log('CONTROL table was created');
										},
										function(error){
											console.log("err",error);
										});
					});
					
				} else {
					console.log('error occurred trying to open DB');
				}
			} else {
				alert("Este navegador não suporta desconexão.")
				console.log('Web Databases not supported');
			}
		} catch (e) {
			console.log('error occurred during DB init, Web Database supported?',e);
		}
}
function convertPlateResultToJson(item){
	return {
	"id":item.ID,
	"title":item.TITLE,
	"plateSize":item.PLATESIZE,
	"allowsFraction":item.ALLOWSFRACTION,
	"foodCategory":item.FOODCATEGORY,
	"priceInCents":item.PRICEINCENTS,
	"isAvailable":item.ISAVAILABLE,
	"extendsPlate":item.EXTENDSPLATE
	
	};
}
function convertResultToJson(item){
return {
"id":item.ID,
"name":item.NAME,
"email":item.EMAIL,
"phone":item.PHONE,
"kind":item.KIND,
"registeredOn":item.REGISTEREDON,
"lastUpdate":item.LAST_UPDATE
};
}

function convertNeighResultToJson(item){
	return {
	"id":item.ID,
	"name":item.NAME,
	"city":item.CITYNAME
	
	};
}
function queryAllPhones(callback) {
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM CLIENT', [], function(tx,
				results) {
			
			
			var resultsJson=[];
			if (results.rows && results.rows.length) {				
				for (i = 0; i < results.rows.length; i++) {		
					var entry = convertResultToJson(results.rows.item(i));
										
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
var convertAddressResultToJson=function(item){
	
	return {
		"id":item.ID,
		"street":item.STREET,
		"number":item.NUMBER,
		"clientId":item.IDCLIENT,
		"additionalInfo":item.ADDITIONALINFO,
		"neighborhood":{
			"name":item.NEIGHBORHOOD_NAME,
			"id":item.NEIGHBORHOOD_ID,
			"city":item.NEIGHBORHOOD_CITY,
		},
		"phone":item.PHONE,
		"addressStr":function(){
			
			var addstr = this.street+", "+this.number;
			if(this.addtionalInfo){
				addstr+=", "+this.addtionalInfo
			}
			if(this.neighborhood && this.neighborhood.name){
				addstr+=" - "+this.neighborhood.name
			}
			return addstr;
		}
		
		};
}
function queryAddressesById(id,callback){
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM ADDRESS WHERE ID=?', [id], function(tx,
				results) {
			console.log("results ", results.rows);
			var resultsJson=[];
			if (results.rows && results.rows.length) {
				console.log('loading from DB');
				for (i = 0; i < results.rows.length; i++) {
					console.log(results.rows.item(i))
											
					resultsJson=convertAddressResultToJson(results.rows.item(i));						
									
				}				
			}
			callback(resultsJson);
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});
}
function queryAddressesByClient(idclient,callback){
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM ADDRESS WHERE IDCLIENT=?', [idclient], function(tx,
				results) {
			console.log("results ", results.rows);
			var resultsJson=[];
			if (results.rows && results.rows.length) {
				console.log('loading from DB');
				for (i = 0; i < results.rows.length; i++) {
					console.log(results.rows.item(i))
					resultsJson.push(						
							convertAddressResultToJson(results.rows.item(i))						
					);					
				}				
			}
			callback(resultsJson);
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});
}
function queryById(id,callback) {
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM CLIENT WHERE ID=?', [id], function(tx,
				results) {
			console.log("results ", results.rows);
			var resultsJson=[];
			if (results.rows && results.rows.length) {
				console.log('loading from DB');
				for (i = 0; i < results.rows.length; i++) {
					console.log(results.rows.item(i))
					resultsJson.push(						
							convertResultToJson(results.rows.item(i))						
					);					
				}				
			}
			callback(resultsJson);
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});

}
function queryByPhone(phone,callback) {
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM CLIENT WHERE PHONE=?', [phone], function(tx,
				results) {
			console.log("results ", results.rows);
			var resultsJson=[];
			if (results.rows && results.rows.length) {
				console.log('loading from DB');
				for (i = 0; i < results.rows.length; i++) {
					console.log(results.rows.item(i))
					resultsJson.push(
						
							convertResultToJson(results.rows.item(i))
						
					);					
				}				
			}
			callback(resultsJson);
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});

}
var defaultError=function(tx,err){
	console.error("tx err",err);
}
/**
 * limpa banco local
 * @returns
 */
var clearDB = function() {
	console.log('resetting database');
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE IF EXISTS CLIENT', [], function() {
			console.log('database has been cleared - please reload');			
		});
	});
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE IF EXISTS ADDRESS', [], function() {
			console.log('database has been cleared - please reload');			
		});
	});
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE IF EXISTS DELIVERYRANGE', [], function() {
			console.log('database has been cleared - please reload');			
		});
	});
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE IF EXISTS NEIGHBORHOOD', [], function() {
			console.log('database has been cleared - please reload');			
		});
	});
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE IF EXISTS PLATE', [], function() {
			console.log('database has been cleared - please reload');			
		});
	});
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE IF EXISTS CONTROL', [], function() {
			console.log('database has been cleared - please reload');			
		});
	});
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE IF EXISTS RESTAURANT', [], function() {
			console.log('database has been cleared - please reload');			
		});
	});
	db.transaction(function(tx) {
		tx.executeSql('DROP TABLE IF EXISTS LOCALORDER', [], function() {
			console.log('database has been cleared - please reload');			
		});
	});
	
	
};



var syncedClient=function(oldid,data){
	console.log(oldid,data);
	clientManager.setLocalClientSynced(oldid,data);
}
var syncLocalAndServer=function(){
		console.log("iniciando sync local->sevidor");
		db.transaction(function(tx) {
			tx.executeSql('SELECT * FROM CLIENT WHERE LAST_UPDATE>-1', [], function(tx,
					results) {				
				console.info("atualizando "+results.rows.length+" clientes...");
				if (results.rows && results.rows.length>0) {		
					for (i = 0; i < results.rows.length; i++) {
					var json = convertResultToJson(results.rows.item(i))
					var ret = function(data,textStatus,jqXHR){
						syncedClient(json.id,data);
						uploadAddresses();
					}										
					$.post("/lab/disconnected/criaRestClient.jsp", json, ret,"json");
					}
				}				
				
			}, function(tx, ee) {
				console.error("failed", ee)
			})
		});
		
		
		
}

var uploadAddressesDEPRECATED=function(){
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM ADDRESS WHERE LAST_UPDATE>-1', [], function(tx,
				results) {				
			console.info("atualizando "+results.rows.length+" enderecos...");
			if (results.rows && results.rows.length>0) {		
				for (i = 0; i < results.rows.length; i++) {
				var json = convertAddressResultToJson(results.rows.item(i))
				var ret = function(data,textStatus,jqXHR){
					if(data.status!="ok"){
						alert("Falhou");
						return;
					}
					db
					.transaction(function(tx) {		
							tx.executeSql('UPDATE ADDRESS SET ID=? LAST_UPDATE=? WHERE ID=?',
											[ data.id, -1,json.id ],
											function(tx, rs) {
												console.log("ok address");								
											}, function(tx, error) {
												console.log("error", error);
											}
							);
					});
				}										
				$.post("/lab/disconnected/criaAddressClient.jsp", json, ret,"json");
				}
			}else{
				dataSynced();
			}				
			
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});
}

var deleteClient = function(id,callback){
	db.transaction(function(tx) {
	tx.executeSql('DELETE FROM CLIENT WHERE ID=?', [id], 
			function(tx,results) {
			if(callback){
				callback();
			}
		},defaultError
		)})
		
}

function queryAllClients(callback) {	
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM CLIENT', [], function(tx, results) {
			console.log("results ", results.rows);
			var resultsJson=[];
			if (results.rows && results.rows.length) {			
				for (i = 0; i < results.rows.length; i++) {		
					console.log(results.rows.item(i));
					resultsJson.push(convertResultToJson(results.rows.item(i)));					
				}				
			}
			callback(resultsJson);				
		
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});
}
var clientAlreadyLocal=0;
var notifyClientUpdate=function(counter,total,error){
	if(error){
		if(error.code==1){
			clientAlreadyLocal++;			
		}else{
			console.error("erro loading client ",error);
			return;
		}
	}
	$("#clientStatus").html("carregados "+(counter)+"/"+total+" - "+(clientAlreadyLocal)+"*");
	
}
var neighAlreadyLocal=0;
var notifyNeighUpdate=function(counter,total,error){
	if(error){
		if(error.code!=1){
			console.error("erro loading neighAlreadyLocal ",error);
			return;			
		}	
		neighAlreadyLocal++;
	}
	$("#neighStatus").html("carregados "+(counter)+"/"+total+"  - "+neighAlreadyLocal+"*");
	
}
var addressAlreadyLocal=0;
var notifyAddressUpdate=function(counter,total,error){
	if(error){
		if(error.code!=1){
			console.error("erro loading address ",error);
			return;			
		}	
		addressAlreadyLocal++;
	}
	$("#addressStatus").html("carregados "+(counter)+"/"+total+"  - "+addressAlreadyLocal+"*");
	
}
var delRangeAlreadyLocal=0;
var notifyDeliveryRangeUpdate=function(counter,total,error){
	if(error){
		if(error.code!=1){
			console.error("erro loading delrange ",error);
			return;			
		}	
		delRangeAlreadyLocal++;
	}
	$("#deliveryStatus").html("carregados "+(counter)+"/"+total+" - "+delRangeAlreadyLocal+"*");
}
var plateAlreadyLocal=0;
var notifyPlatesRangeUpdate=function(counter,total,error){
	try{
	if(error){
		if(error.code!=1){
			console.error("erro loading plateAlreadyLocal ",error);
			return;			
		}	
		plateAlreadyLocal++;
	}
	$("#menuStatus").html("carregados "+(counter)+"/"+total+" - "+plateAlreadyLocal+"*");
	}catch(e){
		console.error("failed to log progress",counter)
	}
}
var notifyRestauranteUpdate=function(){
	$("#restaurantStatus").html("OK");
}

/**
 * 
 * @param data
 * @returns
 */
var bulkUpdate = function(data) {
	db
			.transaction(function(tx) {
				var i;
				for (i = 0; i < data.length; i++) {
					tx.executeSql('INSERT INTO CLIENT (ID, NAME, PHONE, EMAIL, KIND,REGISTEREDON,LAST_UPDATE) VALUES (?, ?, ?, ?,?,?,?)',
									[ data[i].id, data[i].name,
											data[i].phone, data[i].email,data[i].kind,data[i].registeredOn,-1 ],
									function(tx, rs) {
										notifyClientUpdate(i,data.length);
									}, function(tx, error) {
										if(error.code!=1){
											console.log("error", error);
										}
										notifyClientUpdate(i,data.length,error);
									}
							);
				}
			});
}
/**
 * 
 * @param data
 * @returns
 */
function convertDelRangeResultToJson(item){
	return {
		"id":item.ID,
		"neighborhoodId":item.IDNEIGHBORHOOD,
		"costInCents":item.COSTINCENTS,
		"minimumCostInCents":item.MINIMUMCOSTINCENTS	
	};
}
var bulkDelRangeUpdate = function(data) {
	db
			.transaction(function(tx) {
				var i;
				for (i = 0; i < data.length; i++) {
					tx.executeSql('INSERT INTO DELIVERYRANGE (ID, IDNEIGHBORHOOD, COSTINCENTS, MINIMUMCOSTINCENTS) VALUES (?, ?, ?, ?)',
									[ data[i].id, data[i].neighborhoodId,data[i].costInCents,data[i].minimumCostInCents],
									function(tx, rs) {
										notifyDeliveryRangeUpdate(i,data.length);
									}, function(tx, error) {
										if(error.code!=1){
											console.log("error", error);
										}
										notifyDeliveryRangeUpdate(i,data.length,error);
									}

							);
				}
			});
}


var loadDelRangeServerData = function(variavel,callback) {
	$.ajax({
		  url: "listDeliveryRange.jsp",		  
		  success: function(data){
			  var obj = jQuery.parseJSON(data);
		    if (obj.status == "online") {
		    	bulkDelRangeUpdate(obj.delRanges);				
			}				    
		  },
		  error:function(e){
			  console.error("erro deve estar desconectado",e);
			  
		  }
		
	});
	
}
var loadNeighborhoodServerData = function(variavel,callback) {
	$.ajax({
		  url: "listNeighborhoods.jsp",		  
		  success: function(data){
			  var obj = jQuery.parseJSON(data);
		    if (obj.status == "online") {		    	
		    	bulkNeighborhoodUpdate(obj.neighborhoods);
			}				    
		  },
		  error:function(e){
			  console.error("erro deve estar desconectado",e);
			  
		  }
		
	});
		
}

var loadAdressServerData = function(variavel,callback) {
	
	$.ajax({
		  url: "listClientAddresses.jsp",		  
		  success: function(data){
			  var obj = jQuery.parseJSON(data);
		    if (obj.status == "online") {		    	
				bulkAddressUpdate(obj.addresses);
			}				    
		  },
		  error:function(e){
			  console.error("erro deve estar desconectado",e);
			  
		  }
		
	});
	
}
var loadServerData = function(data,callback) {
	addressAlreadyLocal=0;
	loadAdressServerData(null);
	clientAlreadyLocal=0;
	
	delRangeAlreadyLocal=0;
	plateAlreadyLocal=0;
	RestaurantManager.reloadDataFromServer(notifyRestauranteUpdate);
	neighAlreadyLocal=0;
	loadNeighborhoodServerData(null);
	loadDelRangeServerData(null);
	PlateManager.loadServerData(null);
	loadClientData(data,callback);
	
}
var loadClientData=function(data,callback){
	var client = new XMLHttpRequest();
	client.onreadystatechange = function() {
		if (client.readyState == 4) {
			var obj = jQuery.parseJSON(client.responseText);
			console.log(obj);
			if (obj.status == "online") {
				if(callback){
					callback(obj);
				}else{
					bulkUpdate(obj.clients);
				}
			}
			console.log(client.responseText);
		}
	};
	//client.onerror = function(err){console.error("err",err)};
	client.open("GET", "listClients.jsp", true);

	client.send();
}

var bulkAddressUpdate = function(data) {
	db
			.transaction(function(tx) {
				var i;
				for (i = 0; i < data.length; i++) {
					
					tx.executeSql('INSERT INTO ADDRESS (ID, IDCLIENT,ADDITIONALINFO,NUMBER,STREET, PHONE,NEIGHBORHOOD_NAME,NEIGHBORHOOD_ID,NEIGHBORHOOD_CITY,LAST_UPDATE) VALUES (?, ?, ?, ?,?,?,?,?,?,?)',
									[ data[i].id, data[i].idClient,
											data[i].additionalInfo, data[i].number,data[i].street,data[i].phone,data[i].neighborhood.name,data[i].neighborhood.id,data[i].neighborhood.city,-1 ],
									function(tx, rs) {
										notifyAddressUpdate(i,data.length);
									}, function(tx, error) {
										if(error.code!=1){
											console.log("error", error);
										}
										notifyAddressUpdate(i,data.length,error);
									}

							);
				}

			});
}
var bulkNeighborhoodUpdate = function(data) {
	db
			.transaction(function(tx) {
				var i;
				for (i = 0; i < data.length; i++) {
					
					tx.executeSql('INSERT INTO NEIGHBORHOOD (ID, NAME,CITYNAME) VALUES (?,?,?)',
									[ data[i].id, data[i].name,
											data[i].city],
									function(tx, rs) {
										//console.log("tx", tx);
										//console.log("rs", rs)
										notifyNeighUpdate(i,data.length);
										
									}, function(tx, error) {
										if(error.code!=1){
											console.log("error", error);
										}
										notifyNeighUpdate(i,data.length,error);
									}

							);
				}

			});
}

var userData;
var checkIsLogged = function(data,callback) {
	$.ajax({
		  url: "/lab/disconnected/checkAuthentication.jsp",		  
		  success: function(data){
		    console.info(data);
		    data=jQuery.parseJSON(data);
		    if(data.status=='notlogged'){
		    	alert('Você não está logado. Somente a base local esta disponivel.')
		    }else{
		    	userData = data.loginData;
		    }
		  },
		  error:function(e){
			  console.error("erro deve estar desconectado",e);
			  
		  }
		});
}

/*****************************************/

var initOffLineControls=function(){
(function() {

	var displayOnlineStatus = document.getElementById("online-status"), isOnline = function() {
		displayOnlineStatus.innerHTML = "Online";
		displayOnlineStatus.className = "online";
	}, isOffline = function() {
		displayOnlineStatus.innerHTML = "Offline";
		displayOnlineStatus.className = "offline";
	};

	if (window.addEventListener) {
		/*
			Works well in Firefox and Opera with the 
			Work Offline option in the File menu.
			Pulling the ethernet cable doesn't seem to trigger it
		 */
		console.log("events added ")
		window.addEventListener("online", isOnline, false);
		window.addEventListener("offline", isOffline, false);
	} else {
		/*
			Works in IE with the Work Offline option in the 
			File menu and pulling the ethernet cable
		 */
		console.log("events NOT added ")
		document.body.ononline = isOnline;
		document.body.onoffline = isOffline;
	}
	console.log("checking 2!!")
})();
if(document.querySelector('#update')){
addEvent(document.querySelector('#update'), 'click', function() {
	window.applicationCache.update();
});
}
if(document.querySelector('#swap')){
addEvent(document.querySelector('#swap'), 'click', function() {
	window.applicationCache.swapCache();
});
}

var events = "checking,error,noupdate,downloading,progress,updateready,cached,obsolete"
		.split(',');
var i = events.length;

while (i--) {
	addEvent(window.applicationCache, events[i], updateCacheStatus);
}
}
var cacheStates = [
		"Aplicação não suporta desconexão (0)",
		"Aplicação permite desconexão (1)",
		"Checando status da aplicação (2)",
		"Baixando novos dados da aplicação (3)",
		"Há novos dados para esta aplicação, <a href='"+window.location+"'>clique aqui</a> e recarregue a página (4)",
		"A base atual está obsoleta (5)"];

function updateCacheStatus() {
	document.querySelector('#status').innerHTML = cacheStates[window.applicationCache.status];
	if(window.applicationCache.status==4){
		window.location=window.location;
	}
}


var filterchars=function(ui,event){
	ui.currentTarget.value=ui.currentTarget.value.replace(/\s/g,'');
	ui.currentTarget.value=ui.currentTarget.value.replace(/-/g,'');
	
}

var onLocalChanges=function(action,data){	
	
}
var dataSynced=function(){
	
}



function queryNeighById(id,callback) {
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM NEIGHBORHOOD WHERE ID=?', [id], function(tx,
				results) {
			console.log("results ", results.rows);
			var resultsJson=[];
			if (results.rows && results.rows.length) {
				console.log('loading from DB');
				for (i = 0; i < results.rows.length; i++) {
					console.log(results.rows.item(i))
					resultsJson.push(						
							convertNeighResultToJson(results.rows.item(i))						
					);					
				}				
			}
			callback(resultsJson);
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});

}

var AddressManager = {
		
		callBackFct:null,
		queryResult:function(data){
			AddressManager.callBackFct(data);
		},
		queryByClient:function(clientId,callback){
			AddressManager.callBackFct=callback;
			queryAddressesByClient(clientId,this.queryResult);	
		},		
		queryById:function(id,callback){
			AddressManager.callBackFct=callback;
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM ADDRESS WHERE ID=?', [id], function(tx,
						results) {					
					var resultsJson={};
					if (results.rows && results.rows.length) {						
						for (i = 0; i < results.rows.length; i++) {																				
							resultsJson=convertAddressResultToJson(results.rows.item(i));											
						}
						callback(resultsJson);
					}else{
						callback(null,"no result found");
					}					
					
				}, function(tx, ee) {
					console.error("failed", ee)
					callback(null,ee);
				})
			});
				
		},
		queryNeighborhoodById:function(id,callback){
			AddressManager.callBackFct=callback;
			queryNeighById(id,this.queryResult);	
		},
		getUpdates:function(callback){
			clientManager.callBackFct=callback;
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM ADDRESS WHERE LAST_UPDATE>-1 OR ID<0', [], function(tx, results) {
					var list = [];
					if (results.rows && results.rows.length) {					
						for (i = 0; i < results.rows.length; i++) {													
							var changeds = convertAddressResultToJson(results.rows.item(i));
							list.push(changeds);											
						}
						if(callback){
							callback(list);
						}
					}else{
						if(callback){
							callback([],"no result found");
						}
						console.log("noresult found")
					}
					
				}, function(tx, ee) {
					console.error("failed", ee)
					if(callback){
						callback(null,ee);
					}
				})
			});
		},
		assignAddressesToSyncedClient:function(oldId,newId,callback){
			console.log("setar oldClientID "+oldId+" - > "+newId);
			db.transaction(function(tx) {
				tx.executeSql('UPDATE ADDRESS SET IDCLIENT=? WHERE IDCLIENT=?',
								[ newId, oldId],
									function(tx, rs) {												
										if(callback){
											callback(rs);
										}
									}, function(tx, error) {
										console.log("error", error);
										if(callback){
											callback(null,error);
										}
									});
					
			});
		},
		setAddressSynced:function(oldId,newId,callback){
			db.transaction(function(tx) {
				tx.executeSql('UPDATE ADDRESS SET ID=? WHERE ID=?',
								[ newId, oldId],
									function(tx, rs) {												
										if(callback){
											callback(rs);
										}
									}, function(tx, error) {
										console.log("error", error);
										if(callback){
											callback(null,error);
										}
									});
					
			});
		},
		syncAddress:function(address,callback){
			AddressManager.callBackFct=callback;
			if(address.clientId<0){
				console.error("Client was not sync'ed hierarchy is not done yet...");
				callback(null,"Hierarchy error");
				return;
			}
			var ret= function(data){
				console.log(data);
				console.log(address);
				AddressManager.setAddressSynced(data.oldId,data.id,callback);
				
			}
			console.log("address to send ",address);
			$.post("/lab/syncAddress.jsp", address, ret,"json");
		},
		createOffLineAddress: function(address,callback) {
			
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM ADDRESS WHERE ID<0 ORDER BY ID', [], function(tx,
						results) {
					var lowest=0.0;
					if (results.rows && results.rows.length>0) {
						console.log("lowest",results.rows.item(0).ID);
						lowest = parseInt(results.rows.item(0).ID);					
					}
					lowest--;
					console.log("lowest is "+parseInt(lowest))
					
					db.transaction(function(tx) {
						tx.executeSql('INSERT INTO ADDRESS (ID, IDCLIENT, ADDITIONALINFO, NUMBER,STREET,PHONE,NEIGHBORHOOD_NAME,NEIGHBORHOOD_ID,NEIGHBORHOOD_CITY,LAST_UPDATE) VALUES (?, ?, ?, ?,?,?,?,?,?,?)',
											[ lowest, address.clientId,address.additionalInfo,address.number,address.street,address.phone,address.neighborhood.name, address.neighborhood.id,address.neighborhood.city, -1 ],
													function(tx, rs) {												
														onLocalChanges();
													}, function(tx, error) {
														console.log("error", error);
											});
							if(callback){
								callback(lowest);
							}
							});
					
					
				}, function(tx, ee) {
					console.error("failed", ee)
				})
			});
			
		}
		
		
}
var PlateManager = {
		listDistinctCategories:function(callback){
			db.transaction(function(tx) {
				tx.executeSql('SELECT DISTINCT FOODCATEGORY FROM PLATE', [], function(tx,
						results) {
					
					
					var resultsJson=[];
					if (results.rows && results.rows.length) {				
						for (i = 0; i < results.rows.length; i++) {		
							var entry = results.rows.item(i).FOODCATEGORY												
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
		},
		listPlateExtensions:function(callback){
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM PLATE WHERE EXTENDSPLATE IS NOT NULL', [], function(tx,
						results) {
					
					
					var resultsJson=[];
					if (results.rows && results.rows.length) {				
						for (i = 0; i < results.rows.length; i++) {		
							var entry = convertPlateResultToJson(results.rows.item(i));												
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
		},
		listMainPlates:function(callback){
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM PLATE WHERE (EXTENDSPLATE IS NULL OR EXTENDSPLATE=?) AND ISAVAILABLE=1 ORDER BY FOODCATEGORY', [""], function(tx,
						results) {
					
					
					var resultsJson=[];
					if (results.rows && results.rows.length) {				
						for (i = 0; i < results.rows.length; i++) {		
							var entry = convertPlateResultToJson(results.rows.item(i));												
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
		},
		platesWereUpdated:function(){
			ControlManager.register("LastMenuUpdate",""+new Date().getTime());
		},
		whenPlatesWereUpdated:function(callback){			
			ControlManager.getDate("LastMenuUpdate",callback);
			
		},
		loadServerData:function(callback) {
			$.ajax({
				  url: "listRestaurantPlates.jsp",		  
				  success: function(data){
					  var obj = jQuery.parseJSON(data);
				    if (obj.status == "online") {
				    	PlateManager.bulkUpdate(obj.plates);
				    	
					}				    
				  },
				  error:function(e){
					  console.error("erro deve estar desconectado",e);					  
				  }
				
			});
			
		},
		
		bulkUpdate:function(data,callback) {
			db
					.transaction(function(tx) {
						var i;
						for (i = 0; i < data.length; i++) {							
							tx.executeSql('INSERT INTO PLATE (ID, EXTENDSPLATE, TITLE, PLATESIZE,FOODCATEGORY,PRICEINCENTS,ALLOWSFRACTION,ISAVAILABLE) VALUES (?, ?, ?, ?,?,?,?,?)',
											[ data[i].id, data[i].extendsPlate,data[i].title,data[i].plateSize,data[i].foodCategory,data[i].priceInCents,data[i].allowsFraction,data[i].isAvailable],
											function(tx, rs) {
												notifyPlatesRangeUpdate(i,data.length);
											}, function(tx, error) {
												if(error.code!=1){
													console.log("error", error);
												}
												notifyPlatesRangeUpdate(i,data.length,error);
											}

									);
							
							
								
						}
						PlateManager.platesWereUpdated();
						if(callback){
							callback(data.length);
						}
					});
		}
}

var RestaurantManager = {
		reloadDataFromServer:function(callback){
			RestaurantManager.callBackFct=callback
			db.transaction(function(tx) {
				tx.executeSql('DELETE FROM RESTAURANT', [], 
						function(tx,results) {
						RestaurantManager.retrieveServerData(RestaurantManager.createLocalData);
					},defaultError
				)})			
		},
		createLocalData:function(data){
		  	var obj = jQuery.parseJSON(data);	
		  	if(obj==null){
		  		obj=data;
		  	}
		  	if (obj.status == "online") {
		  		db
				.transaction(function(tx) {							
						tx.executeSql('INSERT INTO RESTAURANT (ID, NAME, FRACTIONPRICETYPE, CURRENTDELAY,ACCEPTEDPAYMENTTYPES) VALUES (?, ?, ?, ?,?)',
										[ obj.id, obj.name,obj.fractionPriceType,obj.currentDelay,obj.acceptedPaymentTypes],
										function(tx, rs) {
											console.log("tx", tx);
											console.log("rs", rs);
											RestaurantManager.finishCallingBack(data);
										}, function(tx, error) {
											console.log("error", error);
											RestaurantManager.finishCallingBack(null,error);
										}

								);
					
				});			
		  	}				    
	  
		},
		retrieveServerData:function(callback){
			$.ajax({
				  url: "getRestaurantData.jsp",		  
				  success: function(data){
					  data = jQuery.parseJSON(data);
					  console.log("restadata",data);
					  
					  callback(data);
				  },
				  error:function(e){
					  console.error("erro deve estar desconectado",e);
					  
				  }
				
			});
		},
		updateWithServerData:function(callback){
			RestaurantManager.callBackFct=callback;
			RestaurantManager.retrieveServerData(RestaurantManager.updateLocalData);
		},
		callBackFct:null,
		updateLocalData:function(data){
			db
			.transaction(function(tx) {		
					tx.executeSql('UPDATE RESTAURANT SET CURRENTDELAY=?, FRACTIONPRICETYPE=?,ACCEPTEDPAYMENTTYPES=?',
									[ data.currentDelay, data.fractionPriceType,data.acceptedPaymentTypes],
									function(tx, rs) {
										console.log("ok");		
										RestaurantManager.finishCallingBack(data);
									}, function(tx, error) {
										console.log("error", error);
									}
					);
			});
		},
		finishCallingBack:function(data){
			if(RestaurantManager.callBackFct){
				RestaurantManager.callBackFct(data);
			}
		},
		convertDataIntoJson:function(data){
			return {"name":data.NAME,
			"fractionType":data.FRACTIONPRICETYPE,
			"id":data.ID,
			"acceptedPaymentTypes":data.ACCEPTEDPAYMENTTYPES,
			"currentDelay":data.CURRENTDELAY
			}
		},
		get:function(callback){
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM RESTAURANT', [], function(tx,
						results) {					
					
					var resultsJson=[];
					if (results.rows && results.rows.length) {				
						var entry=	RestaurantManager.convertDataIntoJson(results.rows.item(0));										
						callback(entry);			
					}else{
						alert("dados nao foram carregados");
					}
					
				}, function(tx, ee) {
					console.error("failed", ee)
					callback(null,ee);
				})
			});
		}
		
}


var createOffLineClient = function(name,email,phone,callback) {
	
	db.transaction(function(tx) {
		tx.executeSql('SELECT * FROM CLIENT WHERE ID<0 ORDER BY ID DESC', [], function(tx,
				results) {
			var lowest=0;
			if (results.rows && results.rows.length>0) {
				console.log("lowest",results.rows.item(0).ID);
				lowest = results.rows.item(0).ID;					
			}
			lowest=parseInt(lowest);
			lowest--;
			console.log("lowest is "+parseInt(lowest))
			var registeredOn = new Date().getTime();
			db.transaction(function(tx) {
				tx.executeSql('INSERT INTO CLIENT (ID, NAME, PHONE, EMAIL,KIND,REGISTEREDON,LAST_UPDATE) VALUES (?, ?, ?, ?,?,?,?)',
									[ lowest, name,	phone, email,'RESTAURANTCLIENT',registeredOn, -1 ],
											function(tx, rs) {												
												onLocalChanges();
											}, function(tx, error) {
												console.log("error", error);
									});
					if(callback){
						callback(lowest,{id:lowest,phone:phone,name:name,email:email,kind:'RESTAURANTCLIENT',registeredOn:registeredOn});
					}
					});
			
			
		}, function(tx, ee) {
			console.error("failed", ee)
		})
	});
	
}
var IO_ERROR = 2;
var LocalOrderManager = {
		callBackFct:null,
		listOrders:function(callback){
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM LOCALORDER', [], function(tx,
						results) {
					var list =[];
					if (results.rows && results.rows.length) {
						
						for (i = 0; i < results.rows.length; i++) {							
													
							var order = LocalOrderManager.convertOrderResultToJson(results.rows.item(i));
							list.push(order);
						}
						
					}
					if(callback){
						callback(list);
					}
				}, function(tx, ee) {
					console.error("failed", ee)
					if(callback){
						callback(null,ee);
					}
				})
			});	
		},
		syncOrder:function(order,callback){
			if(order.clientId<0){
				console.error("Order cannot be sync'ed since its client was not yet...");
				callback(null,"Hierarchy error");
				return;
			}
			var ret= function(data){
				console.log(data);
				console.log(order);
				db.transaction(function(tx) {
					tx.executeSql('DELETE FROM LOCALORDER WHERE ID=?', [data.oldId], 
						function(tx,results) {
							if(callback){
								callback(data);
							}
						},function(error){
							callback(null,error);
						}
				)});		
				
			}
			console.log("submitting order ",order);
			$.post("/lab/syncOrder.jsp", order, ret,"json").error(
					function() { 
						 console.error("erro ao enviar pedido para servidor, está conectado?");
						 callback(null,{errorCode:IO_ERROR});
					}
				);
		},
		convertOrderResultToJson:function(item){
			var order= {
				"id":item.ID,
				"address":{
					"street":item.ADDRESS_STREET,
					"additionalInfo":item.ADDRESS_ADDITIONALINFO,
					"neighborhood":{
						"id":item.ADDRESS_NEIGHBORHOOD_ID
					},
					"phone":item.ADDRESS_PHONE,
					"number":item.ADDRESS_NUMBER
					
				},
				"cpf":item.CPF,
				"amountInCash":item.AMOUNTINCASH,
				"paymentType":item.PAYMENTTYPE,
				"delayForecast":item.DELAYFORECAST,
				"clientId":item.CLIENT_ID,
				"observation":item.OBSERVATION,
				"deliveryRangeId":item.DELIVERY_ID	
			}
			var plates = jQuery.parseJSON(item.PLATEBLOB);
			order.plates=plates;
			return order;
			
		},
		assignOrdersToSyncedClient:function(oldClientId,newClientId,callback){
			LocalOrderManager.callBackFct=callback;
			db.transaction(function(tx) {
				tx.executeSql('UPDATE LOCALORDER SET CLIENT_ID=? WHERE CLIENT_ID=?',
								[ newClientId, oldClientId],
									function(tx, rs) {												
										if(callback){
											callback(rs);
										}
									}, function(tx, error) {
										console.log("error", error);
										if(callback){
											callback(null,error);
										}
									});
					
			});
		},
		saveOrder:function(order,callback){
			var plateBlob = dojo.toJson(currentOrder.plateList);
			db.transaction(function(tx) {
			tx.executeSql('INSERT INTO LOCALORDER (ADDRESS_STREET, ADDRESS_ADDITIONALINFO,ADDRESS_NEIGHBORHOOD_ID,ADDRESS_PHONE,ADDRESS_NUMBER,CPF,PAYMENTTYPE,AMOUNTINCASH,DELAYFORECAST,CLIENT_ID,OBSERVATION,DELIVERY_ID,PLATEBLOB) VALUES (?, ?, ?, ?,?,?,?,?,?,?,?,?,?)',
							[ order.address.street, order.address.additionalInfo, order.address.neighborhood.id,order.address.phone,order.address.number,
							  order.cpf,order.paymentType,order.amountInCash,order.delayForecast,order.client.id,order.observation,order.deliveryRange.id,plateBlob],
							function(tx, rs) {
								if(callback){
									callback(rs);
								}
							}, function(tx, error) {
								console.log("error", error);
								if(callback){
									callback(null,error);
								}
							}
					);
			});		
		},
		byId:function(id,callback){
			LocalOrderManager.callBackFct=callback;
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM LOCALORDER WHERE ID=?', [id], function(tx,
						results) {
					if (results.rows && results.rows.length) {
						console.log('loading from DB');
						for (i = 0; i < results.rows.length; i++) {							
													
							var order = LocalOrderManager.convertOrderResultToJson(results.rows.item(i));
							if(callback){
								callback(order);
							}
												
						}				
					}else{
						if(callback){
							callback(null,"no result found");
						}
						console.log("noresult found")
					}
					
				}, function(tx, ee) {
					console.error("failed", ee)
					if(callback){
						callback(null,ee);
					}
				})
			});	
		}
}

var ControlManager = {		
		getDate:function(id,callback){
			var c1 = function(conf){
				if(!conf){
					callback(new Date(0));
				}else{
					var date = new Date(parseInt(conf.value));
					callback(date);
				}
			}
			ControlManager.get(id,c1);
		},
		register:function(id,name){
			db.transaction(function(tx) {
				tx.executeSql('INSERT INTO CONTROL (ID,VALUE) VALUES (?, ?)',
								[id,name],
								function(tx, rs) {
									
								}, function(tx, error) {
									if(error.code==1){
										ControlManager.update(id,name);
									}
								}
						);
				});	
		},
		update:function(id,name){
			db.transaction(function(tx) {
				tx.executeSql('UPDATE CONTROL SET VALUE=? WHERE ID=?',
								[name,id],
								function(tx, rs) {
									
								}, function(tx, error) {
									console.error("regster",error)
								}
						);
				});	
		},
		get:function(id,callback){
			db.transaction(function(tx) {
				tx.executeSql('SELECT * FROM CONTROL WHERE ID=?', [id], function(tx,
						results) {					
					
					if (results.rows && results.rows.length) {				
						var entry=	{
								id:results.rows.item(0).ID,
								value:results.rows.item(0).VALUE
															
						}
						callback(entry);			
					}else{
						callback(null);
					}
					
				}, function(tx, ee) {
					console.error("failed", ee)
					callback(null,ee);
				})
			});
		}
		
}

var clientManager = {
	/**
	 * Re carrega dados de clientes de produção localmente
	 */
	loadDataFromServer:function(){
		$.ajax({
			  url: "listClients.jsp",		  
			  success: function(data){
				  	var obj = jQuery.parseJSON(data);				  
				  	if (obj.status == "online") {
				  		bulkUpdate(obj.clients);				
				  	}				    
			  },
			  error:function(e){
				  console.error("erro deve estar desconectado",e);
				  
			  }
			
		});
	},
	callBackFct:null,
	queryResult:function(data){
		clientManager.callBackFct(data[0]);
	},
	queryClient:function(clientId,callback){
		clientManager.callBackFct=callback;
		queryById(clientId,this.queryResult);	
	},
	finishCallingBack:function(data){
		console.log("finishCallingBack",data);
		if(clientManager.callBackFct){
			clientManager.callBackFct(data);
		}
	},
	getUpdates:function(callback){
		clientManager.callBackFct=callback;
		db.transaction(function(tx) {
			tx.executeSql('SELECT * FROM CLIENT WHERE LAST_UPDATE>-1 OR ID<0', [], function(tx, results) {
				var list = [];
				if (results.rows && results.rows.length) {					
					for (i = 0; i < results.rows.length; i++) {													
						var clientChanged = convertResultToJson(results.rows.item(i));
						list.push(clientChanged);											
					}
					if(callback){
						callback(list);
					}
				}else{
					if(callback){
						callback([],"no result found");
					}
					console.log("noresult found")
				}
				
			}, function(tx, ee) {
				console.error("failed", ee)
				if(callback){
					callback(null,ee);
				}
			})
		});
	},
	updateClientLocally:function(client,callback){
		db
		.transaction(function(tx) {		
				tx.executeSql('UPDATE CLIENT SET NAME=?, PHONE=?, EMAIL=?, LAST_UPDATE=? WHERE ID=?',
						[ client.name,client.phone,client.email, new Date().getTime(),client.id ],
							function(tx, rs) {
								if(callback){
									callback(rs);
								}
							}, function(tx, error) {
								console.log("error", error);
								if(callback){
									callback(null,error);
								}
							}
				);
		});
	},
	syncClient:function(client,callback){
		clientManager.callBackFct=callback;	
		var ret= function(data){			
			var propagateClientOnline = function(rs,error){
				console.log("setting addressses and orders the right client id",error)
				var localCallback = function(addressData){
					var secLevelCallback=function(orderData){
						callback(data);
					}
					LocalOrderManager.assignOrdersToSyncedClient(data.oldId,data.id,secLevelCallback);
				}
				if(!error){
					//update addreses	
					AddressManager.assignAddressesToSyncedClient(data.oldId,data.id,localCallback);
									
				}else{
					console.log(error);
				}				
			}
			if(client.isNew==true){
				clientManager.setLocalClientSynced(data.oldId,data.id,propagateClientOnline);
			}else{
				clientManager.setLocalClientSynced(data.oldId,data.id,callback);			
			}			
		}
		console.log("Client to send ",client);
		if(client.id<0){
			client.isNew=true;
		}
		$.post("/lab/syncClient.jsp", client, ret,"json").error(
					function() { 
						 console.error("erro ao enviar cliente para servidor, está conectado?");
						 callback(null,{errorCode:IO_ERROR});
					}
			);
	},
	setLocalClientSynced:function(oldId,newId,callback){
		db
		.transaction(function(tx) {		
				tx.executeSql('UPDATE CLIENT SET ID=?, LAST_UPDATE=? WHERE ID=?',
								[ newId, -1,oldId ],
								function(tx, rs) {											
									if(callback){
										callback(rs);
									}
								}, function(tx, error) {
									console.error("error", error);
									if(callback){
										callback(null,error);
									}
								}
				);
		});
	}
}

var SyncerManager = {
		
		checkForChanges:function(callback){
			var updates = {
					clients:[],
					addresses:[],
					orders:[]
			}			
			var finishNCallback = function(orders,error){
				updates.orders=orders;
				callback(updates);
			}
			var continueToOrders=function(addresses,error){
				updates.addresses=addresses;
				LocalOrderManager.listOrders(finishNCallback)				
			}
			var continueToAddresses=function(clients,error){				
					updates.clients=clients;
					AddressManager.getUpdates(continueToOrders)				
			}
			clientManager.getUpdates(continueToAddresses);			
		}
		
		
}

var checkForUpdatesAndDisplay=function(error){
	if(!error){
		SyncerManager.checkForChanges(displayUpdateStatus);
	}else{
		alert("Houve um erro na sincronização dos dados")
	}
}
var displayUpdateStatus=function(updates){
	$("#status_db").empty();
	var text = "";
	var startSync = function(callback){	
		$("#status_db").empty();
		$("#status_db").html("<div><div style='float:left' class='ui-button-icon-primary ui-icon ui-icon-check'></div>ok</div>");
	}
	if(updates.clients.length>0){
		text += " Há "+updates.clients.length+" clientes que precisam ser sincronizados!";
		startSync = function(callback){
			startSyncingClients(callback,updates.clients);
		}
	}else if(updates.addresses.length>0){
		text += " Há "+updates.addresses.length+" endereços que precisam ser sincronizados!";
		startSync = function(callback){
			startSyncingAddresses(callback,updates.addresses);
		}
	}else if(updates.orders.length>0){
		text += " Há "+updates.orders.length+" pedidos que precisam ser enviadas para o servidor!";
		startSync = function(callback){
			startSyncingOrders(callback,updates.orders);
		}
		
	}
	text="<div><div style='float:left' class='ui-button-icon-primary ui-icon ui-icon-alert'></div>"+text+"</div>";
	$("#status_db").html(text);
	
	startSync(checkForUpdatesAndDisplay);
	
}
var startSyncingAddresses=function(callback,items){
	$("#status_db").append("<div id='startSyncingAddresses'><div>");
	var nextitem = function(data,error){
		console.error(error);
		console.log("resultado?",data);
		var item = items.pop();
		if(item){
			$("#startSyncingAddresses").html("Enviando endereço "+item.street+"...");			
			console.log("proximo?",item);
			AddressManager.syncAddress(item,nextitem);
		}else{
			$("#startSyncingAddresses").html("Todos endereços enviados!");			
			callback();
		}
	}
	nextitem(null);	
}
var startSyncingOrders=function(callback,items){
	$("#status_db").append("<div id='startSyncingOrders'><div>");
	var nextitem = function(data,error){
		console.error(error);
		console.log("resultado?",data);
		var item = items.pop();
		if(item){
			$("#startSyncingOrders").html("Enviando pedido "+item.id+"...");			
			console.log("proximo?",item);
			LocalOrderManager.syncOrder(item,nextitem);
		}else{
			$("#startSyncingOrders").html("Pedidos enviados!");			
			callback();
		}
	}
	nextitem(null);	
}
var startSyncingClients=function(callback,clients){
	$("#status_db").append("<div id='startSyncingClients'><div>");
	var nextclient = function(data){
		console.log("resultado?",data);
		client = clients.pop();
		if(client){
			$("#startSyncingClients").html("Enviando cliente "+client.name+"...");			
			console.log("proximo?",client);
			clientManager.syncClient(client,nextclient);
		}else{
			$("#startSyncingClients").html("Todos clientes enviados!");
			
			callback();
		}
	}
	nextclient(null);	
}
var currentOrder = {
		client:null,
		address:null,
		deliveryRange:null
}


