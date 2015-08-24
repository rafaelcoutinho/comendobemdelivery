<%@page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%BlobstoreService blobstoreService = BlobstoreServiceFactory
						.getBlobstoreService();%>
<script>
parent.dojo.publish('imageUploaded',['<%=request.getParameter("pid")%>','<%=request.getParameter("imgUrl")%>','<%=blobstoreService.createUploadUrl("/uploadPlateImage")%>']);
</script>