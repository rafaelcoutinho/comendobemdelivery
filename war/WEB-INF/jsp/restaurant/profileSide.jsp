<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="false"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<ul class="menu">
	<li <c:if test="${param.isArea==true}">class="selecionado"</c:if>><a href="/areaEntrega.do">Atendimento - &Aacute;rea e Taxa</a></li>
	<li <c:if test="${param.isTime==true}">class="selecionado"</c:if>><a href="/horarios.do">Hor&aacute;rio de Funcionamento</a></li>
	<li <c:if test="${param.isPaymentType==true}">class="selecionado"</c:if>><a href="/formasPgto.do">Formas de Pagamento</a></li>
	<li <c:if test="${param.isPicture=='true'}">class="selecionado"</c:if>><a href="/pictureManager.do">Editar Foto</a></li>
	<li <c:if test="${param.isDirectAccess==true}">class="selecionado"</c:if>><a href="/acessoDireto.do">Acesso Direto</a></li>
	<li <c:if test="${param.isFractionPlate==true}">class="selecionado"</c:if>><a href="/fractionPlate.do">Pre&ccedil;o meia/meia</a></li>
</ul>