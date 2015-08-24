<%@ tag body-content="scriptless" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- Required parameters --%>
<%@ attribute name="width" required="true" rtexprvalue="true" %>

<%-- Optional parameters --%>
<%@ attribute name="backgroundImage" required="false" rtexprvalue="true" %>
<%@ attribute name="cssClass" required="false" rtexprvalue="true" %>
<%@ attribute name="height" required="false" rtexprvalue="true"  %>
<%@ attribute name="inputName" required="false" rtexprvalue="true" %>
<%@ attribute name="inputValue" required="false" rtexprvalue="true" %>
<%@ attribute name="inputType" required="false" rtexprvalue="true" %>
<%@ attribute name="tagId" required="false" rtexprvalue="true" %>
<%@ attribute name="dojoType" required="false" rtexprvalue="true" %>



<%-- Set default value for height --%>
<c:if test="${empty height}">
	<c:set var="height" value="20" />
</c:if>

<%-- Set default value for inputType --%>
<c:if test="${empty inputType}">
	<c:set var="inputType" value="text" />
</c:if>

<%-- Set the value for the name field --%>
<c:if test="${not empty tagId && empty inputName}">
	<c:set var="inputName" value="${tagId}" />
</c:if>

<%-- Set default value for bg image --%>
<c:if test="${empty backgroundImage}">
	<c:choose>
		<c:when test="${width <= 50}">
			<c:choose>
				<c:when test="${inputType == 'button' || inputType == 'submit'}">
					<c:set var="backgroundImage" value="${initParam['botao50']}" />
				</c:when>
				<c:otherwise>
					<c:set var="backgroundImage" value="${initParam['texto50']}" />
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:when test="${width <= 100}">
			<c:choose>
				<c:when test="${inputType == 'button' || inputType == 'submit'}">
					<c:set var="backgroundImage" value="${initParam['botao100']}" />
				</c:when>
				<c:otherwise>
					<c:set var="backgroundImage" value="${initParam['texto100']}" />
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:when test="${width <= 150}">
			<c:choose>
				<c:when test="${inputType == 'button' || inputType == 'submit'}">
					<c:set var="backgroundImage" value="${initParam['botao150']}" />
				</c:when>
				<c:otherwise>
					<c:set var="backgroundImage" value="${initParam['texto150']}" />
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${inputType == 'button' || inputType == 'submit'}">
					<c:set var="backgroundImage" value="${initParam['botao250']}" />
				</c:when>
				<c:otherwise>
					<c:set var="backgroundImage" value="${initParam['texto250']}" />
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
</c:if>

<span <c:if test="${not empty tagId}">id="${tagId}Wrap"</c:if> class="roundedInput ${inputType}" style="height:${height}px;width:${width}px;">	
	<img src="${backgroundImage}" height="${height}" width="${width}" />
	<input dojoType="${dojoType}" type="${inputType}" 
		style="height:${height}px;width:${width - '5'}px;"
		<c:if test="${not empty tagId}">id="${tagId}"</c:if> <c:if test="${not empty inputName}">name="${inputName}"</c:if>
		<c:if test="${not empty cssClass}">class="${cssClass}"</c:if>
		<c:if test="${dojoType eq 'dijit.form.ValidationTextBox'}"> regExpGen="dojox.validate.regexp.emailAddress"
    trim="true"
    required="true"
    invalidMessage="Email inválido."</c:if>
		<c:if test="${not empty inputValue}">value="${inputValue}"</c:if> />
</span>