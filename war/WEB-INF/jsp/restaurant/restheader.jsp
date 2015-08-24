<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="barraWelcome">
<script>
var loggedUser = ${sessionScope.loggedUser};
var loggedRestaurant = loggedUser.entity;
var id=loggedRestaurant.id;
dojo.addOnLoad(function() {
	
	dojo.byId("restName").innerHTML=loggedRestaurant.name;
	try{
		console.log("is IE",dojo.isIE);
		if(dojo.isIE>0){
			dijit.showTooltip("O Internet Explorer não é recomendado para as funções de restaurante. <br>Por favor utilize o FireFox ou Chrome.", dojo.byId("restName"));
					
		}
	}catch(e){}
});
</script>
<h2>Olá <span id="restName" style="font-size: large;"></span>, <c:if test="${sessionScope.isERPClient eq true}">	
	<button  title="Acessar Gerenciador de Pedidos" style="background: #EB7D4B !important;color: white;font-size: small;padding: 0px 2px 0px 2px;border: 1px outset;" onclick="window.location='/lab/buscarCliente.html'">+ Fazer pedido</button>
	</c:if>	</h2>
</div>

<div id="abas" class="fundoCinza">
	<a href="/dados.do" id="dadosLink" title="Editar dados do meu estabelecimento"
	<c:if test="${param.isProfile}">class="active"</c:if><c:if test="${!param.isProfile}">class="inactive"</c:if>>Meus dados</a> <a
	href="/areaEntrega.do" id="funcionalidadesLink" title="Alterar funcionalidades como área de entrega"
	<c:if test="${param.isFunctions}">class="active"</c:if><c:if test="${!param.isFunctions}">class="inactive"</c:if>>Funcionalidades</a> 
	<a href="/cardapio.do" title="Atualizar minha lista de produtos"
	id="cardapioLink" <c:if test="${param.isMenu}">class="active"</c:if><c:if test="${!param.isMenu}">class="inactive"</c:if>>Cardápio</a>
	
	<a href="/pedidos.do" title="Ver pedidos atuais"
	id="cardapioLink" <c:if test="${param.isOrders}">class="active"</c:if><c:if test="${!param.isOrders}">class="inactive"</c:if>>Pedidos</a>
	<a href="/historicoPedidos.do"
	id="cardapioLink" <c:if test="${param.isOldOrders}">class="active"</c:if><c:if test="${!param.isOldOrders}">class="inactive"</c:if>>Histórico</a>
	<a href="/faturas.do"
	id="cardapioLink" <c:if test="${param.isFaturas}">class="active"</c:if><c:if test="${!param.isFaturas}">class="inactive"</c:if>>Faturas</a>
	<a href="/fechamento.do"
	id="cardapioLink" <c:if test="${param.isClosing}">class="active"</c:if><c:if test="${!param.isClosing}">class="inactive"</c:if>>Fechamento</a>
	<a href="/trocarSenha.do"
	id="cardapioLink" <c:if test="${param.isPwd}">class="active"</c:if><c:if test="${!param.isPwd}">class="inactive"</c:if>>Trocar senha</a>
	
</div>
	
	
