package br.copacabana.usecase;

import java.io.IOException;
import java.util.Map;
import java.util.logging.Logger;

import javax.cache.Cache;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import br.com.copacabana.cb.entities.Picture;
import br.com.copacabana.cb.entities.Plate;
import br.com.copacabana.cb.entities.mgr.PictureManager;
import br.copacabana.Authentication;
import br.copacabana.CacheController;
import br.copacabana.JsonViewItemFileReadStoreController;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;
import br.copacabana.spring.PlateManager;

import com.google.appengine.api.blobstore.BlobInfoFactory;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.images.Image;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.Transform;

public class UploadPlateImage extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private final static String plateImageServerUrl = "/prato/img/";
	protected static final Logger log = Logger.getLogger("copacabana.Commands");
	public void doPost(HttpServletRequest request, HttpServletResponse res) throws ServletException, IOException {
		try {
			Key k = Authentication.getLoggedUserKey(request.getSession());
			Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(request);
			BlobKey blobKey = blobs.get("myFile");
			// System.out.println(k);
			// System.out.println(k.getKind());
			if (k.getKind().equalsIgnoreCase("Restaurant")) {
				Key pid = KeyFactory.stringToKey(request.getParameter("pid"));
				ImagesService imagesService = ImagesServiceFactory.getImagesService();

				Image oldImage = ImagesServiceFactory.makeImageFromBlob(blobKey);
				Transform resize = ImagesServiceFactory.makeResize(300, 300);
				Image newImage = imagesService.applyTransform(resize, oldImage);			
				
				Image oldImage2 = ImagesServiceFactory.makeImageFromBlob(blobKey);
				Transform resizeSmall = ImagesServiceFactory.makeResize(60, 50);				
				Image newSmallImage = ImagesServiceFactory.getImagesService().applyTransform(resizeSmall, oldImage2);				
				PlateManager rman = new PlateManager();
				PictureManager picManager = new PictureManager();

				Picture pic = picManager.createPicture(newImage.getImageData(),newSmallImage.getImageData(),new BlobInfoFactory().loadBlobInfo(blobKey).getFilename());
				
				Long imageKey = pic.getId();
				String imageUrl = plateImageServerUrl + pic.getId();
				Plate p = rman.find(pid, Plate.class);
				if (p.getImageKey() != null) {
					picManager.delete(p.getImageKey());
				}				
				p.setImageUrl(imageUrl);
				
				p.setImageKey(imageKey);
				rman.update(p);

				res.sendRedirect("/imageUploadReturn.jsp?pid=" + request.getParameter("pid") + "&imgUrl=" + p.getImageUrl());
				Cache cache = CacheController.getCache();

				JsonViewItemFileReadStoreController.invalidateCacheValue("listRestaurantPlatesFast", KeyFactory.keyToString(p.getRestaurant().getId()));
				blobstoreService.delete(blobKey);
			} else {
				blobstoreService.delete(blobKey);
				JsonException exception = new JsonException("Must have a logged in restaurant");
				throw exception;
			}

		} catch (IllegalArgumentException e) {
			log("failed ti upload plate img", e);
			if (e.getMessage().contains("larger than maximum size")) {

				JsonException exception = new JsonException(e.getMessage(), ErrorCode.UPLOADEDFILELARGERTHANMAX);
				request.setAttribute("exception", exception);
				exception.setErrorCallback("parent.uploadFailed('"+ErrorCode.UPLOADEDFILELARGERTHANMAX.name()+"');");
				throw new ServletException(exception);
			}else{
				if (e.getMessage().contains("Failed to read image")) {
					JsonException exception = new JsonException(e.getMessage(), ErrorCode.UPLOADEDIMGFORMATUNKNWON);
					exception.setErrorCallback("parent.uploadFailed('"+ErrorCode.UPLOADEDIMGFORMATUNKNWON.name()+"');");
					request.setAttribute("exception", exception);
					throw new ServletException(exception);
				}else{
					JsonException exception = new JsonException(e.getMessage(), ErrorCode.UNKNOWN);
					exception.setErrorCallback("parent.uploadFailed('"+ErrorCode.UNKNOWN.name()+"');");
					request.setAttribute("exception", exception);
					throw new ServletException(exception);
				}
			}
		} catch (br.copacabana.spring.JsonException e) {
			e.printStackTrace();
			e.setErrorCallback("parent.uploadFailed('"+e.getErrorCode().name()+"');");
			request.setAttribute("exception", e);
			throw new ServletException(e);
		} catch (Exception e) {
			log(e.getMessage());
			e.printStackTrace();
			JsonException exception = new JsonException(e.getMessage());
			exception.setErrorCallback("parent.uploadFailed('"+exception.getErrorCode().name()+"');");
			request.setAttribute("exception", exception);
			throw new ServletException(exception);
		}

	}
}
