<%@ page language="java" contentType="text/plain; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>dojo.require("dojo.io.script");
var cbApi={
		endpoint:"http://<%=request.getServerName() %>:<%=request.getServerPort() %>/lab/ext/jsonphandler.jsp",
		cache:{},
		loadPlates:function (id,callback,callbackerror){
			if(this.cache.plates!=null){
				callback(this.cache.plates);
			}
			var cacheObj = this.cache;
			dojo.io.script.get({
				url: this.endpoint+"?uri=/destaquesRestaurante.do&key="+id,
				callbackParamName: "callback",
				timeout:15000,
				load: function(data) {
					console.log("data was returned",data);
					cacheObj.plates=data;
					callback(data);
				}
			});
		},
		loadDeliveryRange:function (id,callback,callbackerror){
			if(this.cache.delRange!=null){
				callback(this.cache.delRange); 
			}
			var cacheObj = this.cache;
				dojo.io.script.get({
					url: this.endpoint+"?uri=/listDeliveryRangeForRestaurant.do&key="+id,
					callbackParamName: "callback",
					timeout:15000,
					load: function(data) {
						console.log("data was returned",data);
						cacheObj.delRange=data;
						callback(data);
					}
				});
		},
		loadClientsAddresses:function (callback,callbackerror){			
			dojo.io.script.get({
				url: this.endpoint+"?uri=/listDeliveryRangeForRestaurant.do&key="+id,
				callbackParamName: "callback",
				timeout:15000,
				load: function(data) {
					console.log("data was returned",data);	    	   
					callback(data);
				}
			});
	}
}