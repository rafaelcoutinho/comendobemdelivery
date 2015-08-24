<%@page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="false" pageEncoding="UTF-8"%>

<%@ taglib prefix="cb" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ComendoBem - Cardápio Estabelecimento Almoço</title>

<cb:header />
<style>
.plateList table th {
	color: black;
	font-weight: bold;
	background-color: gray;
}

.statusPlate {
	color: red;
	font-weight: bold;
}

.optionsSection {
	display: none;
	border: 1px solid gray;
	max-height: 300px;
	max-width: 550px;
	padding: 4px;
	margin: 3px;
	border: 1px solid black;
	background-color: rgb(255, 223, 143);
	width: 500px
}
</style>
<link href="/styles/restaurant/profile.css" type="text/css"
	rel="stylesheet" />
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
	<link href="/styles/restaurant/profile_ie_7.css" type="text/css"
		rel="stylesheet" />
</c:if>
<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 8.0') != -1}">
	<link href="/styles/restaurant/profile_ie_8.css" type="text/css"
		rel="stylesheet" />
</c:if>

<link href="/styles/restaurant/menu.css" type="text/css"
	rel="stylesheet" />

<%@include file="/static/commonScript.html"%>
<script type="text/javascript">
<%BlobstoreService blobstoreService = BlobstoreServiceFactory
.getBlobstoreService();%>
		var formAction = '<%=blobstoreService.createUploadUrl("/uploadPlateImage")%>';
			dojo.require("com.copacabana.pages.ProfileMenu");
			dojo.addOnLoad(function() {			
				com.copacabana.pages.ProfileMenu.loadFoodCat();
				
				dojo.subscribe("addNewPlateOption",com.copacabana.pages.ProfileMenu.editPlateOption);
				dojo.subscribe("onDeletePlateOption",com.copacabana.pages.ProfileMenu.deleteOptionPlate);
				
				dojo.subscribe("editPlate",com.copacabana.pages.ProfileMenu.editPlate)
				var store= new dojo.data.ItemFileReadStore({
			        data: {
							identifier:'id',
							labelAttr:'name',
							
							items:[
									{ id:'UNAVAILABLE',name:'Não disponível'},
									{ id:'AVAILABLE',name:'Disponível'},
									{ id:'HIDDEN',name:'Oculto'}
									
									]
			        	}
			    });
				dijit.byId("plateStatus").store = store;
				dijit.byId('plateStatus').attr('value','AVAILABLE');				
				dijit.byId("plateOptionStatus").store = store;
				dijit.byId('plateOptionStatus').attr('value','AVAILABLE');
				
				
			});

		  </script>
<style>
.panel:hover{
background-color: silver;
}
.panel{
cursor: pointer;
}
.uploadBtn{
    border:1px solid #333333;
    background:url(buttonEnabled.png) #d0d0d0 repeat-x scroll 0px top;
    font-size:14px;
    width:201px;
    height:30px;
    vertical-align:middle; /* emulates a <button> if node is not */
    text-align:center;
}
.uploadHover{
    background-image:url(buttonHover.png);
    cursor:pointer;
    font-weight:bold;
}

.uploadPress{
    background-image:url(buttonActive.png);
}
.uploadDisabled{
    background-image:none;
    background-color:#666;
    color:#999;
    border:1px solid #999;
}

#cardapio ul{
height: 100%
}
</style>
</head>

<cb:body closedMenu="true">
	<jsp:include page="restheader.jsp"><jsp:param
			name="isMenu" value="true"></jsp:param></jsp:include>

	<div id="dadosCardapio">

	<div id="cardapio">
	<button baseClass="orangeButton" dojoType="dijit.form.Button"
		dojoAttachEvent="onclick:com.copacabana.pages.ProfileMenu.createNewPlate()" id="newPlate"
		onclick="com.copacabana.pages.ProfileMenu.createNewPlate()">+ Novo produto</button>
		<p>Configure aqui a lista de produtos que somente estão disponíveis durante o almoço.</p>
	<h2>Categorias</h2>
	<select dojoType="dijit.form.FilteringSelect"
		id="foodCategoriesSelection" name="foodCategory" autoComplete="true"
		invalidMessage="Categoria inv&aacute;lida" style="width: 12em;"></select>
	<div dojoType="com.copacabana.PlatesListWidget" baseClass="cardapio"  periodToFilter="'LUNCH'"
		key="id" id="plateListWidget"></div>
	</div>
	<div id="categoria"></div>

	<ul class="menu">
		<li><a href="/cardapio.do">Produtos</a></li>
		<li  class="selecionado"><a href="/cardapioAlmoco.do">Exclusivo almo&ccedil;o</a></li>
		<li><a href="/destaqueCardapio.do">Destaques</a></li>
	</ul>
	</div>
	<div dojoType="dijit.Dialog" id="dialog1" title="Novo prato"
		style="display: none; border: 1px solid black;" execute="teste">
	<form action="/createPlateJson.do" method="post" id="plateForm"
		name="plateForm" dojoType="dijit.form.Form"><input
		type="hidden" dojoType="dijit.form.TextBox" name="restaurant"
		id="restaurant" /> <input type="hidden" dojoType="dijit.form.TextBox"
		name="plate.id" id="id" />
		<input type="hidden" dojoType="dijit.form.TextBox"
		name="plate.availableTurn" value="LUNCH" />
	<table>
		<tr>
			<td><label for="name">Nome do prato: </label></td>
			<td><input required="true" class="mandatory"
				dojoType="dijit.form.ValidationTextBox" type="text" trim="true" properCase="true"
				name="plate.title" id="title"> <span class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="loc">Categoria: </label></td>
			<td><select dojoType="dijit.form.FilteringSelect"
				id="foodCategoriesSelectionForPlates" name="plate.foodCategory"
				autoComplete="true" invalidMessage="Categoria inv&aacute;lida"
				style="width: 12em;"></select></td>
		</tr>

		<tr>
			<td><label for="loc">Descri&ccedil;&atilde;o: </label></td>
			<td><textarea dojoType="dijit.form.SimpleTextarea" trim="true" 
				name="plate.description" id="description" rows=4 cols=25></textarea>
			</td>
		</tr>
		<tr>
			<td><label for="date">Valor: </label></td>
			<td><input type="text" name="plate.priceInCents" id="price" trim="true" selectOnClick="true" 
				value="0,00" dojoType="dijit.form.CurrencyTextBox" required="true" onchange="addCentsPlate" 
				class="mandatory" constraints="{fractional:true,required:true}"
				invalidMessage="Digite o valor com centavos, por exemplo 10,90">
			<span class="required">*</span></td>
		</tr>		
		<tr>
			<td><label for="name">Disponibilidade: </label></td>
			<td><input dojoType="dijit.form.FilteringSelect"  id="plateStatus" name="plate.status"></td>
		</tr>
		
		<tr>
			<td colspan="2" align="center">
			<button baseClass="orangeButton" dojoType="dijit.form.Button"
				onclick="com.copacabana.pages.ProfileMenu.savePlate()" onkeypress="com.copacabana.pages.ProfileMenu.savePlate()">Salvar</button>
			<button baseClass="orangeButton" dojoType="dijit.form.Button" id="deletebutton"
				onclick="com.copacabana.pages.ProfileMenu.deletePlate()" onkeypress="com.copacabana.pages.ProfileMenu.deletePlate()">Apagar</button>
		</tr>
	</table>
	</form>
	</div>



<div dojoType="dijit.Dialog" id="plateOptionDialog" title="Opção"
		style="display: none; border: 1px solid black;" execute="teste">
	<form action="/createPlateJson.do" method="post" id="plateOptionForm"
		name="plateOptionForm" dojoType="dijit.form.Form">
		<input type="hidden" dojoType="dijit.form.TextBox"
		name="plate.availableTurn" value="LUNCH" />
		<input type="hidden" dojoType="dijit.form.TextBox" name="restaurant" />
		<input type="hidden" dojoType="dijit.form.TextBox" name="plate.foodCategory"/> 
		<input type="hidden" dojoType="dijit.form.TextBox" name="plate.id"  />
		<input type="hidden" dojoType="dijit.form.TextBox" name="plate.extendsPlate"  />
	<table>
		<tr>
			<td><label for="name">Nome da opção: </label></td>
			<td><input required="true" class="mandatory"
				dojoType="dijit.form.ValidationTextBox" type="text" trim="true" properCase="true"
				name="plate.title" > <span class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="loc">Descri&ccedil;&atilde;o: </label></td>
			<td><textarea dojoType="dijit.form.SimpleTextarea" trim="true" 
				name="plate.description" rows=4 cols=25></textarea>
			</td>
		</tr>
		<tr>
			<td><label for="date">Valor: </label></td>
			<td><input type="text" name="plate.priceInCents"  trim="true" selectOnClick="true" 
				value="0,00" dojoType="dijit.form.CurrencyTextBox" required="true" onchange="addCentsOption"
				class="mandatory" constraints="{fractional:true,required:true}" id="plateOptionPrice"
				invalidMessage="Digite o valor com centavos, por exemplo 10,90">
			<span class="required">*</span></td>
		</tr>		
		<tr>
			<td><label for="name">Disponibilidade: </label></td>
			<td><input dojoType="dijit.form.FilteringSelect"   name="plate.status" id="plateOptionStatus"></td>
		</tr>
		
		<tr>
			<td colspan="2" align="center">
			<button baseClass="orangeButton" dojoType="dijit.form.Button"
				onclick="com.copacabana.pages.ProfileMenu.savePlateOption()" onkeypress="com.copacabana.pages.ProfileMenu.savePlateOption()">Salvar</button>						

		</tr>
	</table>
	</form>
	</div>

</cb:body>
<script>
function addCentsOption(who){
	if(dojo.byId('plateOptionPrice').value.indexOf(',')==-1){
		var val = dojo.byId('plateOptionPrice').value+",00";
		dijit.byId('plateOptionPrice').attr('value',val);
	}
}
function addCentsPlate(who){
	console.log(who)
	if(dojo.byId('price').value.indexOf(',')==-1){
		var val = dojo.byId('price').value+",00";
		dijit.byId('price').attr('value',val);
	}
}
function uploadFailed(error){
	com.copacabana.util.hideLoading();
	console.error('UPLOAD FAILED',error);
	var msg = new com.copacabana.MessageWidget();
	
	switch(error){
		case 'UPLOADEDIMGFORMATUNKNWON':
			msg.showMsg("Erro ao enviar imagem. Formato da imagem desconhecido. Utilize imagens do tipo JPG, PNG ou GIF.");
			break;
		case 'UPLOADEDFILELARGERTHANMAX':
			msg.showMsg("Erro ao enviar imagem. Tamanho do arquivo não deve exceder 10 megabytes.");
			break;
		default:
			msg.showMsg("Erro ao enviar imagem. Tente novamente.");
			break;
	
	}
	
}
</script>
</html>