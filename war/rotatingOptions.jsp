<%@page import="br.copacabana.util.TimeController"%><%@page import="java.util.Calendar"%><%!int counter = 0;int total=5;%>
<%counter++;
Calendar c= Calendar.getInstance(TimeController.getDefaultTimeZone());
int hour = c.get(Calendar.HOUR_OF_DAY);
int dow = c.get(Calendar.DAY_OF_WEEK);
if(hour>17 || hour<6){
	if((dow==c.MONDAY||dow==c.TUESDAY) && counter%3==0){		
			%>
		<div style="height: 250px;overflow: hidden;" id="DeliveryBanner" title="Papagaios Promoção">
		<object id="embeddedSwf" type="application/x-shockwave-flash" data="/resources/swf/Pizzarias_papagaios.swf" width="240" height="240">
		<param name="allowScriptAccess" value="always" />
		<param name="movie" value="/resources/swf/Pizzarias.swf" />
		<param name="allowFullScreen" value="true" />
		<param name="bgcolor" value="#333333" />
		<param value="transparent" />
		</object>
		<noscript><img src="/resources/swf/noscript.gif"></noscript>
		</div>
			<%
		
	}else{
		System.out.println("counter "+counter);
	
	if(counter%total==0){ %>
		<div style="height: 250px;overflow: hidden;" id="DeliveryBanner" title="Pizzarias">
			<object id="embeddedSwf" type="application/x-shockwave-flash" data="/resources/swf/Pizzarias.swf" width="240" height="240">
			<param name="allowScriptAccess" value="always" />
			<param name="movie" value="/resources/swf/Pizzarias.swf" />
			<param name="allowFullScreen" value="true" />
			<param name="bgcolor" value="#333333" />
			<param value="transparent" />
			</object>
			<noscript><img src="/resources/swf/noscript.gif"></noscript>
		</div>
	<%}else if(counter%total==1){
	%>
	<div style="height: 240px;overflow: hidden;" id="DeliveryBanner" title="Temakis">
		<object id="embededBannersnackFlash_42ea4b8c77f6e81d62203475b2658673" type="application/x-shockwave-flash" data="/resources/swf/temakis240x240.swf" width="240" height="240">
		<param name="allowScriptAccess" value="always" />
		<param name="movie" value="/resources/swf/temakis240x240.swf" />
		<param name="allowFullScreen" value="true" /><param name="bgcolor" value="#333333" />
		<param value="transparent" />
		</object>
		<noscript><img src="/resources/swf/noscript.gif"></noscript>
		</div>
	
	<%
	}else{
		%>
		<div style="height: 225px;overflow: hidden;" id="DeliveryBanner" title="Vila Ré">
	<object id="embededBannersnackFlash_42ea4b8c77f6e81d62203475b2658673" type="application/x-shockwave-flash" data="http://files.bannersnack.net/app/swf2/EmbedPlayerV2.swf?hash_id=42ea4b8c77f6e81d62203475b2658673&amp;bgcolor=#333333&amp;clickTag=null&amp;t=1307388674" width="240" height="240">
	<param name="allowScriptAccess" value="always" />
	<param name="movie" value="http://files.bannersnack.net/app/swf2/EmbedPlayerV2.swf?hash_id=42ea4b8c77f6e81d62203475b2658673&amp;bgcolor=#333333&amp;clickTag=null&amp;t=1307388674" />
	<param name="allowFullScreen" value="true" /><param name="bgcolor" value="#333333" />
	<param value="transparent" />
	</object>
	<noscript><img src="/resources/swf/noscript.gif"></noscript>
	</div>
		<%
	}
}
	
}else{	
	if(dow==c.WEDNESDAY && counter%3==0){%>
		<div style="height: 240px;overflow: hidden;" id="DeliveryBanner" title="Feijoada">
			<object id="embededBannersnackFlash_beccd87fd631f239bc210978b2658568" type="application/x-shockwave-flash" data="/resources/swf/feijoadas.swf" width="240" height="240">
			<param name="allowScriptAccess" value="always" />
			<param name="movie" value="/resources/swf/feijoadas.swf" />
			<param name="allowFullScreen" value="true" /><param name="bgcolor" value="#333333" />
			<param value="transparent" />
			</object>
			<noscript><img src="/resources/swf/noscript.gif"></noscript>
		</div>
		<%
	}else if(dow==c.WEDNESDAY && counter%2==0){
		%>
		<object id="embededBannersnackFlash_bffb456d44def1d675e12b49b2667428"
			type="application/x-shockwave-flash"
			data="http://files.bannersnack.net/app/swf2/EmbedPlayerV2.swf?hash_id=bffb456d44def1d675e12b49b2667428&amp;bgcolor=#333333&amp;clickTag=null&amp;t=1307540761"
				width="240" height="240">
				<param name="allowScriptAccess" value="always" />
				<param name="movie"
				value="http://files.bannersnack.net/app/swf2/EmbedPlayerV2.swf?hash_id=bffb456d44def1d675e12b49b2667428&amp;bgcolor=#333333&amp;clickTag=null&amp;t=1307540761" />
				<param name="allowFullScreen" value="true" />
				<param name="bgcolor" value="#333333" />
			</object>
		<noscript><img src="/resources/swf/noscript.gif"></noscript>
<%
		
	}else{
	
	if(counter%total==0){ %>	
	<div style="height: 235px;overflow: hidden;" id="DeliveryBanner" title="Bife de ancho">
	<object id="embededBannersnackFlash_beccd87fd631f239bc210978b2658568" type="application/x-shockwave-flash" data="http://files.bannersnack.net/app/swf2/EmbedPlayerV2.swf?hash_id=beccd87fd631f239bc210978b2658568&amp;bgcolor=#333333&amp;clickTag=null&amp;t=1307387607" width="240" height="240">
	<param name="allowScriptAccess" value="always" />
	<param name="movie" value="http://files.bannersnack.net/app/swf2/EmbedPlayerV2.swf?hash_id=beccd87fd631f239bc210978b2658568&amp;bgcolor=#333333&amp;clickTag=null&amp;t=1307387607" />
	<param name="allowFullScreen" value="true" /><param name="bgcolor" value="#333333" />
	<param value="transparent" />
	</object>
	<noscript><img src="/resources/swf/noscript.gif"></noscript>
	</div>
	<%
	}else{
		%><div style="height: 240px;overflow: hidden;" id="DeliveryBanner" title="Picanha Arroz Carreteiro">		
		
		<object id="embededBannersnackFlash_30366f9162721d8ab39d28deb2658643" type="application/x-shockwave-flash" data="/resources/swf/picanha240x240.swf" width="240" height="240">
		<param name="allowScriptAccess" value="always" />
		<param name="movie" value="/resources/swf/picanha240x240.swf" />
		<param name="allowFullScreen" value="true" />
		<param name="bgcolor" value="#333333" />
		<param value="transparent" />
		</object>
		<noscript><img src="/resources/swf/noscript.gif"></noscript>
		</div>
		<%
		
	}
	}
}
%>