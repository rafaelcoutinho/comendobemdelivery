<%@ tag body-content="scriptless" pageEncoding="UTF-8" isELIgnored="false" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ attribute name="flashFile" required="true" rtexprvalue="true" %>
<%@ attribute name="tagId" required="true" rtexprvalue="true" %>

<%-- Optional attributes --%>
<%@ attribute name="width" required="false" rtexprvalue="true" %>
<%@ attribute name="height" required="false" rtexprvalue="true" %>

<c:choose>
	<c:when test="${fn:indexOf( header['User-agent'],'MSIE') >= 0}">
		<object
				classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
				id="${tagId}" height="${height}" width="${width}">
			<param name="movie" value="${flashFile}" />
	</c:when>
	
	<c:otherwise>
		<object
			data="${flashFile}" id="${tagId}" 
			height="${height}" width="${width}"
			type="application/x-shockwave-flash">
	</c:otherwise>
</c:choose>

	<param name="quality" value="high" />
	<param value="transparent" name="wMode"/>
	<jsp:doBody />
</object>