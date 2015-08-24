<%@page import="br.copacabana.Authentication"%>
<script type="text/javascript" src="/_ah/channel/jsapi"></script>
<%@include file="/static/commonScript.html"%>
<script>
	dojo.addOnLoad(function() {
		var xhrParams = {
			error : function(error) {
				alert(error);
			},
			handleAs : 'json',
			load : gotChannelKey,
			url : '/lab/getKey'
		};
		dojo.xhrGet(xhrParams);
		console.log('aa');
	});

	gotChannelKey = function(json) {
		console.log(json);
		
		channel = new goog.appengine.Channel(json.token);
		socket = channel.open();
		socket.onopen = onOpened;
		socket.onmessage = onMessage;
		socket.onerror = onError;
		socket.onclose = onClose;

	}

	sendMessage = function(path, opt_param) {
		path += '?msg=' + '{restId:"ag5jb21lbmRvYmVtYmV0YXIRCxIKUkVTVEFVUkFOVBjqCAw"}';
		path +="&user="+dojo.byId('userToReceive').value
		var xhr = new XMLHttpRequest();
		xhr.open('POST', path, true);
		xhr.send();
	};

	onOpened = function() {
		connected = true;

	};
	onMessage = function(msg) {
		console.log(msg);
		dojo.create('div',{innerHTML:msg.data},dojo.byId('msgSection'));
	}
	onError = function(err) {
		console.error(err)
	}
	onClose = function() {
		console.log('close');
	}
</script>
<%try{ %>
<%=Authentication.getLoggedUser(session) %><br>
<%}catch(Exception e) {}%>
<input type="text" id="userToReceive" value="admin">
<button onClick="sendMessage('/lab/notifyUser')">Testa</button>
<div id="msgSection"></div>