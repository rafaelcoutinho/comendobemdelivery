<%@tag import="java.net.URLEncoder"%>
<%@tag import="br.com.copacabana.web.Constants"%>
<%@tag import="br.com.copacabana.cb.entities.FoodCategory"%>
<%@tag import="br.com.copacabana.cb.entities.Restaurant"%>
<%@tag import="com.google.appengine.api.datastore.KeyFactory"%>
<%@tag import="br.copacabana.usecase.CityIdentifier"%>
<%@tag import="br.copacabana.CityIdentifierFilter"%>
<%@tag import="br.com.copacabana.cb.entities.mgr.JPAManager"%>
<%@tag import="br.copacabana.usecase.beans.PrepareHome"%>

<%@ tag pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="cb" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- Optional Attributes --%>
<%@ attribute name="closedMenu" required="false" rtexprvalue="true" %>
<%@ attribute name="showTwitter" required="false" rtexprvalue="true" %>
<c:if test="${empty closedMenu}">
	<c:set var="closedMenu" value="${false}" />
</c:if>
<c:if test="${empty showTwitter}">
	<c:set var="showTwitter" value="${false}" />
</c:if>
<style>
<c:choose>
			<c:when test="${sessionScope.userType == 'restaurant'}">
			.restaurantButtons{
				display: block;
			}			
			</c:when>	
			<c:when  test="${sessionScope.userType eq 'client'}">
			.clientButtons{
				display: block;
			}			
			</c:when>
			<c:when  test="${sessionScope.userType eq 'central'}">
			.centralButtons{
				display: block;
			}			
			</c:when>
			<c:otherwise>
			.unknownButtons{
				display: block;
			}
			</c:otherwise>
			</c:choose>
.followUsList{
list-style: none outside none; line-height: normal; margin-top: 0pt; margin-bottom: 0pt; margin-left: 0pt; float: right; padding: 0px 5px 0px 0px;
}
.btnLabel{
	float: left;
}
.addBtn{
display: block;height: 18px;margin: 0 0 0 8px;min-height:13px;padding-top: 2px;
}
.twitterBtn{
	background:url("/resources/img/ico_footer_sprite.png") no-repeat scroll 0 0 transparent;
	display:block;
	height:18px;
	width:17px
}
.facebookBtn{
	background:url("/resources/img/ico_footer_sprite.png") no-repeat scroll -17px 0 transparent;
	display:block;
	height:18px;
	width:17px
}


</style>

<body class="tundra">
	<div id="container">
	
		<%-- Topo da página --%>
		<div id="topo">			
			<div id="loginLinks" style="float: right; position: absolute; left: 470px;width:350px; margin-top: 10px;text-align: right;">
			<c:if test="${empty sessionScope.loggedUser}">
			<a href="/loginRegistro.do" style="position: relative;">Cadastro</a> | <a href="/loginRegistro.do" style="position: relative;" onclick="showLoginDialog();return false;">Login</a>
			</c:if>
			<c:if test="${not empty sessionScope.loggedUser}">
			Bem vindo ${sessionScope.userName}
			</c:if>
			</div>
			
			<c:if test="${showTwitter == true}">		 	
				<div id="tuit" style="float: right; position: absolute; left: 700px; margin-top: 37px;">
				<iframe src="http://www.facebook.com/plugins/like.php?href=http://www.comendobem.com.br&amp;layout=button_count&amp;show_faces=false&amp;width=450&amp;action=recommend&amp;colorscheme=light&amp;locale=pt_BR&amp;ref=comendobem&amp;height=21" class="fbiframe" allowtransparency="true" scrolling="no" frameborder="0"></iframe><br/>
				<a href="http://twitter.com/share" class="twitter-share-button" data-url="http://www.comendobem.com.br" data-text="Hum gostei de fazer pedidos de delivery pela internet em Campinas pelo ComendoBem" data-count="horizontal" data-via="comendobem_camp">Tweet</a>			
			</div>
			</c:if>
			<img id="imagemTopo" src="/resources/img/imagemTopo.png" />
			<a id="logo" href="/home.do">
				<img src="/resources/img/logo.png" title='Faça pedidos de delivery no www.Comendobem.com.br' alt='Faça pedidos de delivery no www.Comendobem.com.br'width="170" height="139"/>
			</a>
			
			
			<a id="pedidos" href="/pedidos.do" style="left:570px;top:85px;" class="restaurantButtons" title="Acompanhe os pedidos de delivery no www.comendobem.com.br">
				<img src="/resources/img/menu/rest_acompanhar.png" alt="acompanhar pedidos" />
			 </a>
			<a id="funcionalidades" href="/areaEntrega.do" style="left:460px;top:82px;" class="restaurantButtons" title="Configure o serviço de pedidos de delivery no www.comendobem.com.br">
				<img src="/resources/img/menu/rest_funcionalidade.png" alt="funcionalidades" />
			 </a>
			<a id="meusdados" href="/dados.do" style="left:360px;top:82px;" class="restaurantButtons" title="Altere seus dados no www.comendobem.com.br">
				<img src="/resources/img/menu/rest_meusdados.png" alt="meusdados" />
			 </a>
			
			<a id="logout" href="/logout.jsp" style="left:715px;top:93px;" class="restaurantButtons" title="Logout do sistema">
				<img src="/resources/img/menu/rest_logout.png" alt="logout" />
			 </a>
			 
			 <a id="funcionalidades" href="/central/configuracoes.do" style="left:460px;top:82px;" class="centralButtons" title="Configure o serviço de pedidos de delivery no www.comendobem.com.br">
				<img src="/resources/img/menu/rest_funcionalidade.png" alt="funcionalidades" />
			 </a>
			 <a id="pedidos" href="/central/monitorar.do" style="left:570px;top:85px;" class="centralButtons" title="Acompanhe os pedidos de delivery no www.comendobem.com.br">
				<img src="/resources/img/menu/rest_acompanhar.png" alt="monitorar pedidos" />
			</a>
			<a id="meusdados" href="/central/profile.do" style="left:360px;top:82px;" class="centralButtons" title="Altere seus dados no www.comendobem.com.br">
				<img src="/resources/img/menu/rest_meusdados.png" alt="meusdados" />
			 </a>
			 <a id="logout" href="/logout.jsp" style="left:715px;top:93px;" class="centralButtons" title="Logout do sistema">
				<img src="/resources/img/menu/rest_logout.png" alt="logout" />
			 </a>
			 
			 <a id="meusdados" href="/meusDados.do" style="left:370px;top:81px;" class="clientButtons" title="Altere seu cadastro no www.comendobem.com.br">
				<img src="/resources/img/menu/client_meusdados.png" alt="meusdados" />
			 </a>
			<a id="comoPedir"  href="/comopedir.do"  style="left:475px;top:82px;" class="clientButtons" title="Veja como pedir delivery no www.comendobem.com.br">
				<img src="/resources/img/menu/client_comopedir.png" alt="Como pedir" title="Como pedir" />
			</a>			
			<a href="/meusPedidos.do" style="left:568px;top:85px;" class="statusPedido clientButtons" title="Veja o status do pedido de delivery feito no www.comendobem.com.br">
				<img src="/resources/img/menu/client_acompanhar.png" alt="Status do pedido" title="Status do pedido" />
			 </a>
			 <a id="logout" href="/logout.jsp"  style="left:715px;top:92px;" class="clientButtons" title="Desconectar do sistema">
				<img src="/resources/img/menu/client_logout.png" alt="logout" title="Desconectar"/>
			 </a>
			
			
			<a id="cadastreSe" href="/loginRegistro.do" class="unknownButtons" title="Cadastre no comendobem e faça já pedidos de delivery no www.comendobem.com.br">
				<img src="/resources/img/opt/cadastreSe.png" alt="Cadastre-se" title="Cadastre-se" width="83" height="21"/>
			</a>
			
			<a id="comoPedir" href="/comopedir.do" class="unknownButtons"  title="Veja como pedir delivery no www.comendobem.com.br">
				<img src="/resources/img/opt/comoPedir.png" alt="Como pedir" />
			</a>			 		 	 
			 <a href="/meusPedidos.do" class="statusPedido unknownButtons" title="Veja o status do pedido de delivery feito no www.comendobem.com.br">
				<img src="/resources/img/opt/statusPedido.png" alt="Status do pedido" />
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
		 	<div title="Selecione a região de entrega do pedido para filtrar os restaurantes que a atendem." id="formularioBusca" dojoType="com.copacabana.search.SearchRestaurantsWidget" style="z-index: 150;margin-top: -50px;float:left"></div>
		 	<script>		 	
		 		var showCat=function(id){
		 			console.log(id)
		 			dojo.publish('onShowRestSelection',[id]);		 			
		 			return false;
		 		}
		 	</script>
		 		
		 		<div id="menuRestaurantesCategorias" dojoType="com.copacabana.RestaurantWheelWidget" loadedObject='foodCatList' ></div>
		 		<div id="menuRestaurantes">
		 		

		 		<div class="restSuggestions" dojoAttachPoint="restSuggestions" style="filter:alpha(opacity=70);position: absolute; width: 250px; left: 180px; top: 20px; height: 220px; z-index: 20; padding-top: 15px" dojoAttachEvent="onmouseout:hideRestaurants">
		 		<c:if test="${not empty preLoadedRestList}">
		 	<script>	
		 		var showRest = function(id){		 			
		 			loadRestaurant(id);
		 			return false;		 			
		 		}
		 	</script>		 	
		 		<c:forEach varStatus="index" var="rest" items="${preLoadedRestList}">		 		
			 		<div id="com_copacabana_FoodCategoryRestaurantResultWidget_${index.count}" widgetid="com_copacabana_FoodCategoryRestaurantResultWidget_${index.count}">
						<div class="restItem" onclick="showRest('<%=KeyFactory.keyToString(((Restaurant)getJspContext().getAttribute("rest")).getId())%>');">
						<a href="/${rest.uniqueUrlName}"  onclick="return false;" class="foodCatEntry">${rest.name}</a>
						<c:choose>
    						<c:when test="${rest.siteStatus eq 'TEMPUNAVAILABLE' or  rest.siteStatus eq 'BLOCKED'}">	
        						<span class="notActive">indisp.</span>
    						</c:when>
    						<c:when test="${rest.siteStatus eq 'SOON' }">	
        						<span class="notActive">breve</span>
    						</c:when>
    						<c:when test="${rest.siteStatus eq 'MUSTACCEPTTERMS'}">	
        						<span class="notActive">breve</span>
    						</c:when>
    						<c:when test="${rest.siteStatus eq 'NEW_RESTAURANT'}">	
        						<span class="notActive">breve</span>
    						</c:when>
    						<c:otherwise>        						
								<c:if test="${rest.siteStatus eq 'ACTIVE' }">
									<c:if test="${rest.open ==true}">
										<span class="aberto">aberto</span>
									</c:if>
									<c:if test="${rest.open ==false}">
										<span class="fechado">fechado</span>
									</c:if>
								</c:if>			
    						</c:otherwise>
    						</c:choose>
    					</div>	
					</div>
				</c:forEach>
				</c:if>
					<div class="noRestItem" style="display:none">N&atilde;o h&aacute; restaurantes.</div>
				</div>
				<c:set var="counter" value="1"/>
				<c:forEach varStatus="index" var="foodCat" items="${entity.foodCatObj}">
				<div id="<%=KeyFactory.keyToString(((FoodCategory)  getJspContext().getAttribute("foodCat")).getId())%>" >
					<c:if test="${index.count%2!=0}">
					<a href="/mostraCategorias/${foodCat.name}" onclick="showCat('<%=KeyFactory.keyToString(((FoodCategory)  getJspContext().getAttribute("foodCat")).getId())%>');return false;" style="top: <c:out value="${counter*35}"/>px; color:#605D5D" class="tipo esquerda cheio">${foodCat.name}</a>
					</c:if>
					<c:if test="${index.count%2==0}">
					
					<a href="/mostraCategorias/${foodCat.name}" onclick="showCat('<%=KeyFactory.keyToString(((FoodCategory)  getJspContext().getAttribute("foodCat")).getId())%>');return false;" style="top: <c:out value="${counter*35}"/>px; color:#605D5D" class="tipo direita cheio">${foodCat.name}</a>
					<c:set var="counter" value="${counter+1}"/>
					</c:if>
				</div>
				</c:forEach>
				
<div id="itens" class="categoryBackground"></div></div>
		 		
	
			 	</c:otherwise>
		 </c:choose>
		
		<div id="barraTopo"></div>
		
		<div id="conteudo">
			<jsp:doBody />
		</div>
	
		<%-- --%>
		<div id="pe">
			<br />
			
			<a href="/jsp/privacidade.jsp"> Pol&iacute;tica de Privacidade</a> | <a href="/quemsomos.do">Quem Somos</a> | <a href="/cidadescomdelivery.do">Cidades atendidas</a>  | <a href="/contato.do">Fale conosco</a> | <a href="/contatoRestaurante.do">Seu restaurante</a> 
			<ul class="followUsList">
			<li class="btnLabel">Siga-nos: </li><li style="float: left;">
				<a href="http://www.twitter.com/Comendobem_camp" class="addBtn twitterBtn" rel="nofollow" " onclick="window.open(this.href); return false;"></a>
			</li>
			<li style="float: left;">
				<a  rel="nofollow" class="addBtn facebookBtn" href="http://www.facebook.com/ComendoBem" onclick="window.open(this.href,'fb'); return false;"></a>
			</li>
			</ul>
			<Br/> ComendoBem Copyright &copy; 2010 - Todos os direitos reservados 
		</div>
	</div>
</body>
<c:if test="${not empty msgForUser}">
	<script>
	<!--
	dojo.addOnLoad(function(){		
		setTimeout(showWMsg,1000);
	} );
	var showWMsg=function(){		
		com.copacabana.util.warning('${msgForUser.id}','${msgForUser.msg}','${msgForUser.msgType}');
	}
	-->
	</script>
</c:if>
<c:if test="${empty sessionScope.loggedUser}">
<script>
function just4Chrome(fb,user){	
	executeLogin(fb,user)
}
</script>
<div id="loginDialog" dojoType="dijit.Dialog" title="Entrar" style="top:10px;;display: none;width: 400px;" onShow="dojo.style(dojo.byId('DeliveryBanner'),'visibility','hidden');" onHide="dojo.style(dojo.byId('DeliveryBanner'),'visibility','visible');">    
<div style="width: 100%;text-align: center; ">

<a class="fb_button fb_button_medium" target="_fbauth" href="/fbresponse.jsp"  ><span class="fb_button_text">Conectar com Facebook</span></a>
</div>
<br />
<div style="width: 100%;text-align: center; ">ou</div><br/>
<div
	style="margin-left: 1px;margin-bottom: 5px;" >E-mail:
	<input type="text" class="username" name="login" selectOnClick="true" dojoType="dijit.form.ValidationTextBox" required="true" style="width: 180px;" /><span class="loading"></span>
</div>
<div style="margin-bottom: 10px" >Senha: <input  style="width: 115px;"  type="password" class="password passwordFake" selectOnClick="true" name="passwordfake" dojoType="dijit.form.ValidationTextBox"  required="true" />
<button baseClass="orangeButton loginBtnClass"  dojoType="dijit.form.Button" onclick="executeLogin(null)"  >Entrar</button>
<br style="clear: both;" clear="both"/>
<span dojoType="dijit.form.DropDownButton" baseClass="rememberButton ieRememberBtn" style="margin-left:80px;">
    <span style="font-size: xx-small;">
        *esqueci minha senha 
    </span>
    <div dojoType="dijit.TooltipDialog" baseClass="lembrete" onExecute="executeReminder">
    	<p>Insira seu e-mail cadastrado e lhe enviaremos sua senha.</p>
        <label for="name2">
            E-mail cadastrado:
        </label>
        <form action="/lembreteSenha.do" method="post"  dojoType="dijit.form.Form" id="lembreteFormulario" onsubmit="return false;">        
        <input dojoType="dijit.form.TextBox" class="emailReminder" name="email" type="text"/>
        </form>
        <br>        
        <button dojoType="dijit.form.Button" type="submit" baseClass="orangeButton">
            Enviar senha
        </button>
    </div>
</span> 
</div><div class="loginMsgs" style="color: red;">&nbsp;</div>


</div>
</c:if>
<%@include file="/scripts/ganalytics.js" %>
<script type="text/javascript" src="http://platform.twitter.com/widgets.js">--</script>