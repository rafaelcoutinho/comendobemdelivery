<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Comendo Bem</title>
	<cb:header />
	
	<link href="../../styles/main/main.css" type="text/css" rel="stylesheet" />
	<link href="../../styles/main/main_busca.css" type="text/css" rel="stylesheet" />
	<link href="../../styles/main/pedido.css" type="text/css" rel="stylesheet" />
</head>
<cb:body>
	<div id="mensagem">Olá boa noite!</div>
	
	<div id="conteudo_busca">
	
		<div id="topoResultado">
			<div class="canto cantoSupDir"></div>
			<div class="canto cantoInfDir"></div>
			
			<h2>Resultado da busca</h2>
			
			<p id="resultadoMensagem">
				<span>Encontramos 22 restaurantes e 328 ítens com a palavra 'hamburguer'.</span>
				<br />
				<span>Mostrando de 1 até 5</span>
			</p>
		</div>
		
		<div id="itensBusca">
			<div class="item">
				<span class="status">Aberto</span>
				<span class="titulo">Burdog</span>
				<br />
				<span class="quantidade">12 ítens encontrados</span>
			</div>
			
			<div class="item">
				<span class="status">Aberto</span>
				<span class="titulo">Chico Hamburguer</span>
				<br />
				<span class="quantidade">21 ítens encontrados</span>
			</div>
			
			
			<div class="item">
				<span class="status">Aberto</span>
				<span class="titulo">Freitas</span>
				<br />
				<span class="quantidade">18 ítens encontrados</span>
			</div>
			
			<div class="item">
				<span class="status">Fechado</span>
				<span class="titulo">ZéBurgão</span>
				<br />
				<span class="quantidade">29 ítens encontrados</span>
			</div>
			
			<div class="item">
				<span class="status">Fechado</span>
				<span class="titulo">Hamburgueria</span>
				<br />
				<span class="quantidade">31 ítens encontrados</span>
			</div>
		</div>
		
		<div id="paginacao">
			<span class="voltar">Primeira | Anterior</span>
			<span class="paginas">1, <span class="selecionado">2</span>, 3, 4</span>
			<span class="avancar">Próxima | Última</span>
		</div>
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