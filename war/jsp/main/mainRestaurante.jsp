<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Comendo Bem</title>
	<cb:header />
	
	<link href="../../styles/main/main.css" type="text/css" rel="stylesheet" />
	<link href="../../styles/main/main_restaurante.css" type="text/css" rel="stylesheet" />
	<link href="../../styles/main/pedido.css" type="text/css" rel="stylesheet" />
	<c:if test="${fn:indexOf(header['User-Agent'], 'MSIE 7.0') != -1}">
		<link href="../../styles/main/pedido_ie_7.css" type="text/css" rel="stylesheet" />
	</c:if>
</head>
<cb:body>
	<div id="mensagem">Olá boa noite!</div>
	
	<div id="conteudo_restaurante" style="display: block;">
		<div id="tituloRestaurante">
			<div class="canto cantoSupDir"></div>
			<div class="canto cantoInfDir"></div>
			
			<div class="imagem">
				<img src="/ComendoBem//resources/img/restaurants/subway.png" alt="Logo do Subway"/>
			</div>
			<h2>Subway</h2>
			<p>
				Com mais de 31 mil locais em 91 países, a marca SUBWAY® é a maior franquia do mundo em sanduíches 
				estilo submarino; e se tornou líder internacional no desenvolvimento da indústria de restaurantes 
				de comida rápida.
			</p>
		</div>
		
		<h2>Cardápio</h2>
		
		<ul id="categorias">
			<li class="selecionado">Classics</li>
			<li>Hot Sub</li>
		</ul>
		
		<table id="cardapio">
			<thead>
				<tr>
					<th>Descrição</th>
					<th>Preço Unitário</th>
					<th>Quantidade</th>
					<th>Acompanhamentos e Observações</th>
					<th> </th>
				</tr>
			</thead>
			<tbody>
				<tr id="450">
					<td class="descricao"><span>B.M.T.</span> - Clássico sub com salame, peperoni e presunto</td>
					<td>R$ 11,00</td>
					<td class="quantidade">
						<span>- </span>
						<cb:roundedInput width="25" inputName="quantidade" height="15"/>
						<span> +</span>
					</td>
					<td><a href="#">Selecionar</a></td>
					<td><img alt="Pedir" src="../../resources/img/btPedir.png"/></td>
				</tr>
				<tr id="455">
					<td class="descricao"><span>Atum</span> - Sub especial com patê de atum</td>
					<td>R$ 13,00</td>
					<td class="quantidade">
						<span>- </span>
						<cb:roundedInput width="25" inputName="quantidade" height="15"/>
						<span> +</span>
					</td>
					<td><a href="#">Selecionar</a></td>
					<td><img alt="Pedir" src="../../resources/img/btPedir.png"/></td>
				</tr>
				<tr id="456">
					<td class="descricao"><span>Vegetariano</span> - Para os que não gostam de carne, o vegetariano não fica pra trás no sabor</td>
					<td>R$ 11,00</td>
					<td class="quantidade">
						<span>- </span>
						<cb:roundedInput width="25" inputName="quantidade" height="15"/>
						<span> +</span>
					</td>
					<td><a href="#">Selecionar</a></td>
					<td><img alt="Pedir" src="../../resources/img/btPedir.png"/></td>
				</tr>
				<tr id="457">
					<td class="descricao"><span>Frango</span> - Simples e clássico frango, também conhecido como frangão</td>
					<td>R$ 11,00</td>
					<td class="quantidade">
						<span>- </span>
						<cb:roundedInput width="25" inputName="quantidade" height="15"/>
						<span> +</span>
					</td>
					<td><a href="#">Selecionar</a></td>
					<td><img alt="Pedir" src="../../resources/img/btPedir.png"/></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div id="pedido">
		<div id="pedidoWrapper" style="right: 0px;">
			<div class="canto cantoSupEsq"></div>
			<div class="canto cantoInfEsq"></div>
		
			<h2>Seu Pedido</h2>
		
			<ul>
				<li id="450">2 B.M.T.<span title="Remover">X</span></li>
				<li id="452" class="selecionado">1 Subway Melt<span title="Remover">X</span></li>
				<li id="455">1 Atum<span title="Remover">X</span></li>
			</ul>
		
			<p>
				Selecionado:<br/>
				<span id="itemSelecionado">Subway Melt</span><br/>
				Unitário: <span id="valorUnitario">R$ 15,00</span><br/>
				Qtd.: 
				<span class="quantidade">-</span>
				<span style="height: 15px; width: 30px;" class="roundedInput text" id="quantidadeWrap">	
					<img height="15" width="30" src="../../resources/img/campo50px.png"/>
					<input type="text" name="quantidade" id="quantidade" style="height: 15px; width: 25px;" value="1"/>
				</span>
				<span class="quantidade">+</span><br/>
				<input type="button" value="Acomp e Obs" id="acompanhamentosEObservacoes" class=""/>
			</p>
		
			<hr/>
		
			<p>
				Total de Pratos: <span id="totalPratos">3</span><br/>
				Sub-Total: <br/>
				<span id="subTotal">R$ 50,00</span><br/>
				Taxa de Entrega: <br/> 
				<span id="taxaDeEntrega">R$ 3,50</span>
			</p>
		
			<a id="confirmarPedido" href="#">
				<img alt="Confirmar Pedido" src="../../resources/img/btConfirmar.png"/>
			</a>
		</div>
	</div>
</cb:body>
</html>