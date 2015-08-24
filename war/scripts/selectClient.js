var prepareAutocomplete=function (data){		
		$("input#autocomplete").keyup(filterchars);
		
		for(var id in data ){
			var item = data[id];
			var str = item.phone.replace(/-/g,"");
			str = str.replace(/\s/g,"");
			//console.log(item.phone,str)
			item.value=str+""+item.name;
			if(item.id<0.0){
				console.log(item)
			}
		}
		$("input#autocomplete").autocomplete(
				{
					minLength: 4,
					delay: 500,
					search: function(event, ui) { 
						console.log("evet",event);
						console.log("ui",ui);
						
					},
					 select: function(event, ui) {						 
						if(ui.item.value!=null){
							showClients([ui.item]);								
							$("input#autocomplete").attr("value",ui.item.phone);							
					 	}
						return false; 
					 },
					 focus: function( event, ui ) {			
						 	$( "#project" ).val( ui.item.phone );
							return false;
					},
					source : data
				}).data( "autocomplete" )._renderItem = function( ul, item ) {
					
					return $( "<li></li>" )
					.data( "item.autocomplete", item )
					.append( "<a>" + item.phone+ " "+ item.name+"</a>" )
					.appendTo( ul );
			};
	}