package br.copacabana.usecase;

// file Serve.java

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.Picture;
import br.com.copacabana.cb.entities.mgr.PictureManager;

import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

public class ServePicture extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
		ServletContext context = getServletContext();
		WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
		PictureManager picMan = (PictureManager) applicationContext.getBean("pictureManager");
		String picId = req.getParameter("id");
		boolean isSmall =false;
		if (picId == null) {
			String path = req.getPathInfo();
			if (path.length() > 1) {
				picId = path.substring(1);
				if(picId.endsWith(".small")){
					picId=picId.substring(0,picId.indexOf(".small"));
					isSmall=true;
				}
			}
		}
		if (picId != null) {
			Picture p = picMan.getPicture(Long.parseLong(picId));
			if (p != null) {
				res.setContentType("image/jpeg");
				res.setHeader("Cache-Control", "max-age=1209600"); // Cache for
																	// two weeks
				if(isSmall){
					res.getOutputStream().write(p.getSmall().getBytes());
				}else{
					res.getOutputStream().write(p.getBlob().getBytes());
				}
			}
		}
	}
}
