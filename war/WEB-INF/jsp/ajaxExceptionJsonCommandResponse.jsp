<%@ page language="java" contentType="text/html; charset=utf-8"
	isELIgnored="false" pageEncoding="UTF-8" isErrorPage="true"%><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%><%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%><%@page import="br.copacabana.spring.JsonException"%><%@page import="java.util.logging.Logger"%><%@page import="java.util.logging.Level"%>
<%
	response.setStatus(500);
	Logger log = Logger.getLogger("copacabana.Controllers");
try{
%>
<c:choose>
	<c:when test="${not empty requestScope.exception}">
		<%
		
			try {
						log.info("Exception: ");
						JsonException th = (JsonException) request.getAttribute("exception");
						if(th.getErrorCallback()!=null){
							out.println("<script>"+th.getErrorCallback()+"</script>");
						}else{
							out.println(th.getJson());
						}
					} catch (Exception e) {
						log.log(Level.SEVERE,"ajaxExceptionFailed ",e);

					}
		%>
	</c:when>
	<c:otherwise>
	{error:true,errorMsg:"unknown",errorCode:-1}
</c:otherwise>
</c:choose>
<%}catch(Throwable e){
	e.printStackTrace();
	out.println("{errorMsg:"+e.getMessage()+"}");
}%>