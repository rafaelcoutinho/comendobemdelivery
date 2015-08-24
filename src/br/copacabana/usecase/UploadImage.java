package br.copacabana.usecase;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class UploadImage extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		UserService userService = UserServiceFactory.getUserService();
		String str = (String) req.getSession().getAttribute("isAdmin");
		if(str!=null && str.equals("fornow")){

				req.getSession().removeAttribute("isAdmin");
				Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
				BlobKey blobKey = blobs.get("myFile");

				if (blobKey == null) {
					res.sendRedirect("/");
				} else {
					res.sendRedirect("/img?blob-key=" + blobKey.getKeyString());
				}
			
		} else {
			res.getWriter().println("<p>Please <a href=\"" + userService.createLoginURL(req.getRequestURI()) + "\">sign in</a>.</p>");
		}
	}
}
