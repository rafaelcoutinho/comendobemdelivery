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
<body>
	<div id="container">
	
		<%-- Topo da página --%>
		<div id="topo">
			<img id="bordaAtras" src="${pageContext.request.contextPath}/resources/img/bordasAtras.png" />
			<img id="imagemTopo" src="${pageContext.request.contextPath}/resources/img/imagemTopo.png" />
			<a id="logo" href="${pageContext.request.contextPath}/">
				<img src="${pageContext.request.contextPath}/resources/img/logo.png" alt="logo comendo bem" />
			</a>
			
			<a id="cadastreSe" href="${pageContext.request.contextPath}/jsp/user/login.jsp">
				<img src="${pageContext.request.contextPath}/resources/img/cadastreSe.png" alt="Cadastre-se"/>
			</a>
			
			<a id="comoPedir" href="#comoPedir">
				<img src="${pageContext.request.contextPath}/resources/img/comoPedir.png" alt="Como pedir" />
			</a>
			
			 <a id="faleConosco" href="#faleConosco">
			 	<img src="${pageContext.request.contextPath}/resources/img/faleConosco.png" alt="Fale conosco" />
		 	 </a>
		 	 
			 <a id="statusPedido" href="${pageContext.request.contextPath}/jsp/user/order.jsp">
				<img src="${pageContext.request.contextPath}/resources/img/opt/statusPedido.png" alt="Status do pedido" />
			 </a>
		</div>
		
		<%-- 
			Esta parte é o menu que pode ficar fechado dependendo da página, por isso
			carrega diferente se for ficar fechado ou aberto.
		--%>
		 <c:choose>
		 	<%-- Menu fechado --%>
		 	<c:when test="${closedMenu == true}">
		 		
		 	</c:when>
		 	
		 	<%-- Menu aberto --%>
		 	<c:otherwise>
		 		<div id="formularioBusca">
		 			<img id="filtrosBuscaImg" 
		 				src="${pageContext.request.contextPath}/resources/img/filtrosDeBusca.png" 
		 				alt="Filtros de Busca" />
		 				
		 			<img id="cantoFormularioImg" 
		 				src="${pageContext.request.contextPath}/resources/img/bordaFormulario.png" />
		 				
			 		<form id="busca" onsubmit="return false;">
			 			<label for="neighbor">Bairro</label><br />
			 			<cb:roundedInput tagId="bairro" width="180" />
			 			<br />
			 			
			 			<label for="zip">CEP</label><br />
			 			<cb:roundedInput tagId="zip" width="180" />
			 			<br />
			 			
			 			<label for="word">Palavra Chave</label><br />
			 			<cb:roundedInput tagId="palavra" width="180" />
			 			<br />
			 			
			 			<input type="checkbox" name="isOpen" id="isOpen" />Só abertos
			 			<cb:roundedInput tagId="buscar" width="60" 
			 					inputType="button" inputValue="Buscar" />
			 		</form>
		 		</div>
		 		
		 		<div id="menuRestaurantes">
		 			<div class="tipo esquerda cheio" style="top: 35px;">Chinesa</div>
		 			<div class="tipo esquerda cheio" style="top: 70px;">Hamburguer</div>
		 			<div class="tipo esquerda cheio" style="top: 105px;">Indiana</div>
		 			<div class="tipo esquerda cheio" style="top: 140px;">Japonesa</div>
		 			<div class="tipo esquerda cheio selecionado" style="top: 175px;">Pizza</div>
		 			<div class="tipo esquerda cheio" style="top: 210px;">Sanduíche</div>
		 			
		 			<div class="tipo direita cheio" style="top: 35px;">Tailandesa</div>
		 			<div class="tipo direita cheio" style="top: 70px;">Árabe</div>
		 			<div class="tipo direita" style="top: 105px;"> </div>
		 			<div class="tipo direita" style="top: 140px;"> </div>
		 			<div class="tipo direita" style="top: 175px;"> </div>
		 			<div class="tipo direita" style="top: 210px;"> </div>
		 			
		 			<div id="itens">
		 				<div id="tipo_Pizza" class="item selecionado" style="background: rgb(210, 208, 208) url(../../resources/img/bgMenu/pizza.jpg) repeat scroll 0% 0%; top: 0px;">
							<div id="1113" class="restaurante ladoA" style="top: 30px;">1900 <span class="aberto">Aberto</span></div>
							<div id="427" class="restaurante ladoA" style="top: 60px;">A Esperança <span class="aberto">Aberto</span></div>
							<div id="386" class="restaurante ladoA" style="top: 90px;">Bendita Hora <span class="aberto">Aberto</span></div>
							<div id="510" class="restaurante ladoA" style="top: 120px;">Chaplin <span class="fechado">Fechado</span></div>
							<div id="347" class="restaurante ladoA" style="top: 150px;" title="Don Peppe Di Napoli">Don Peppe D... <span class="fechado">Fechado</span></div>
							<div id="1054" class="restaurante ladoA" style="top: 180px;">Habib's <span class="fechado">Fechado</span></div>
							<div id="450" class="restaurante ladoA" style="top: 210px;">Monte Verde <span class="fechado">Fechado</span></div>
							<div id="535" class="restaurante ladoB" style="top: 30px;" title="Quintal do Brás">Quintal do ... <span class="aberto">Aberto</span></div>
						</div>
		 			</div>
		 		</div>
		 	</c:otherwise>
		 </c:choose>
		
		<div id="barraTopo"></div>
		
		<div id="conteudo">
			<div id="mensagem">Boa noite!</div>
			
			<div  id="conteudo_main">
				<div id="dica_do_dia" class="quadrado">
					<h2>Dica do Dia</h2>
					<div class="conteudo">
						<img class="imagem" src="../../resources/img/highlights/espaguete.jpg" />
					</div>
				</div>
				
				<div id="novidade_da_semana" class="quadrado">
					<h2>Novidade da Semana</h2>
					<div class="conteudo">
						<img class="imagem" src="../../resources/img/highlights/tonhoi.png" />
					</div>
				</div>
				
				<div id="login" class="quadrado">
					<h2>Login</h2>
					
					<p>
						Para ter acesso total ao Comendo Bem efetue seu login.
					</p>
					
					<form id="loginForm" action="${initParam['loginUrl']}" method="post">
						E-mail:<br />
						<cb:roundedInput tagId="user" width="200" />
						<br />
						Senha:<br />
						<cb:roundedInput tagId="password" inputType="password" width="145" />
						<input type="hidden" id="redirect" name="redirect" value="/jsp/main/main.jsp" />
						<cb:roundedInput tagId="btLogin" inputType="submit" width="60" inputValue="Entrar" />
					</form>
				</div>
				
				<div id="empty">
				</div>
			</div>
		</div>
	
		<!-- Pé da página -->
		<div id="pe">
			<br />
			Política de Privacidade | Quem Somos | ComendoBem Copyright &copy; 2009 - Todos os direitos reservados
		</div>
	</div>
</body>
</html>