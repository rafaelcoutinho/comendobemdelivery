<%@page import="br.com.copacabana.web.Constants"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="com.google.gson.JsonElement"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="br.copacabana.util.HttpUtils"%>
<%@page import="br.copacabana.Authentication"%>
<%@page import="java.text.MessageFormat"%>
<%@page import="java.util.Formatter"%>
<%
	Logger log = Logger.getLogger("copacabana.fbjsp");
	String inviter = "";
	try {

		String gettoken = "https://graph.facebook.com/oauth/access_token?client_id="
				+ Constants.FBID
				+ "&client_secret="
				+ Constants.FBSECRET + "&grant_type=client_credentials";
		log.info("tokenUrl: " + gettoken);
		String str = HttpUtils.getHttpContent(gettoken);
		log.info("token: " + str);

		String a = "https://graph.facebook.com/"
				+ request.getParameter("request_ids") + "";

		log.info("access_token="
				+ str.substring("access_token=".length()));
		Map mmm = new HashMap();
		mmm.put("access_token", str.substring("access_token=".length()));
		a+="?"+str;
		String invitationdataStr = HttpUtils.getHttpContent(a);

		log.info("invitationdataStr="
				+ invitationdataStr);
		//invitationdataStr = "{ \"id\": \"102865503142451\", \"application\": {    \"name\": \"Alternative\",    \"id\": \"8704263086\" }, \"to\": {    \"name\": \"Karen Ambegkeigha Adeagbostein\",     \"id\": \"100002570059781\"  },  \"from\": {     \"name\": \"Carol Ambefeiaifee Sadanberg\", \"id\": \"100002565919655\"  },     \"data\": \"{\\\"inviter\\\":\\\"ag5jb21lbmRvYmVtYmV0YXINCxIGQ0xJRU5UGIlQDA\\\"}\", \"message\": \"Pe\u00e7a pizzas, almo\u00e7os e etc online pelo ComendoBem, o site mais gostoso da Internet\",   \"created_time\": \"2011-06-29T15:23:44+0000\"}";

		JsonObject ob = new JsonParser().parse(invitationdataStr)
				.getAsJsonObject();
		log.info("ob="
				+ ob);
		JsonObject inv = new JsonParser().parse(
				ob.get("data").getAsString()).getAsJsonObject();
		log.info("inv="
				+ inv);
		inviter = inv.get("inviter").getAsString();

	} catch (Exception e) {
		e.printStackTrace();

		log.log(Level.SEVERE, "Erro ao completar entrada via FB", e);
	}
%><script>
window.parent.location='/fbresponse.jsp?inviter=<%=inviter%>&request_ids=<%=request.getParameter("request_ids")%>';
</script>Se esta p&aacute;gina n&atilde;o não redirecionar automaticamente <a href="/fbresponse.jsp?inviter=<%=inviter%>&request_ids=<%=request.getParameter("request_ids")%>">clique aqui</a>