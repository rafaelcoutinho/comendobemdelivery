<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem.com.br - Troca de senha</title>

<cb:header />

<link href="/styles/user/profile.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/user/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<%@include file="/static/commonScript.html" %>

</head>
<cb:body closedMenu="true">

	<jsp:include page="centralheader.jsp"><jsp:param
			name="isPwd" value="true"></jsp:param></jsp:include>
			
<h2 style="color: #EB7D4B">Trocar senha</h2>			
	<form action="/changePwd.do" method="post" id="changePwd"
		name="changePwd" dojoType="dijit.form.Form" style="margin: 5px">
	<div dojoType="dojox.form.PasswordValidator" name="newPwd"
		required="true" invalidMessage="Confirmacao de senha incorreta" id="pwdVal"
	>
		<script type="dojo/method" event="pwCheck" args="pwdVal">                
                return password != ""
            </script>
	<table >
		<tr>
			<td><label for="name">Senha atual: </label></td>
			<td><input dojoType="dijit.form.TextBox" type="password"
				name="currentPwd" class="dijitTextBox  dijitComboBox dijitSpinner"
				style="margin: 0px;" id="currentPwd"> <span class="required">*</span>
			</td>
		</tr>
		<tr>
			<td><label for="name">Nova senha: </label></td>
			<td><input dojoType="dijit.form.TextBox" type="text"
				name="newPasswd" pwType="new"> <span class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="name">Confirme nova senha: </label></td>
			<td><input dojoType="dijit.form.TextBox" type="text" 
				name="confirmNewPwd" pwType="verify"> <span class="required">*</span>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><img
				src="/resources/img/btOk.png" alt="salvar"
				onclick="javascript:submitPwdChange()" /></td>
		</tr>
	</table>
	</div>
	</form>
	<script type="text/javascript">

     
	        
	        dojo.require("dojox.form.PasswordValidator");	        
	        dojo.require("dijit.form.FilteringSelect");
	        dojo.require("dojo.parser"); 
	        dojo.require("dojo.data.ItemFileReadStore");
	        dojo.require("dijit.form.Button");
	        dojo.require("dijit.form.TextBox");
	        dojo.require("dijit.form.CheckBox");
	        dojo.require("dijit.InlineEditBox");
	        
	        dojo.require("com.copacabana.MessageWidget");
	        dojo.addOnLoad(function() {			

			});


	      var submitPwdChange = function(){
	    	  if(dijit.byId("pwdVal").validate(true)==false){
	    		  var msg = new com.copacabana.MessageWidget();
             	  msg.showMsg("Por favor verifique se a senha &eacute; vazia ou a confirmação corresponde à nova senha.");
				  return false;
	    	  }
				var xhrArgs = {
	                    form: dojo.byId("changePwd"),
	                    handleAs: "json",
	                    load: function(data) {	                    	
	                    	var entity= data;
	                        console.log("Form created ",data);	                        
	                        dojo.byId("changePwd").reset();
	                        var msg = new com.copacabana.MessageWidget();
	                        msg.showMsg("Senha trocada. Lembre-se de trocar a senha do monitorador.");
	                    },
	                    error: function(error) {
	                        console.log("Form error ",error);
	                        try{
	                        	var msg = new com.copacabana.MessageWidget();
	                        	var appError=dojo.fromJson(error.responseText);
	                        	if(appError.errorCode=="EMPTYPWD"){
	                        		msg.showMsg("Nova senha não deve ser em branco.");
	                        	}else{
	                        		if(appError.errorCode=="OLDPWDDOESNTMATCH"){
		                        		msg.showMsg("Senha atual incorreta.");
		                        	}
	                        		else{
	    	                        	msg.showMsg("Erro ao trocar senha.");
	                        		}
	                        	}
	                        }catch(e){
	                        	var msg = new com.copacabana.MessageWidget();
	                        	msg.showMsg("Erro ao trocar senha.");
	                        }
	                    }
	                }
	                	                
	                var deferred = dojo.xhrPost(xhrArgs);
			}
						
			
</script>
</cb:body>