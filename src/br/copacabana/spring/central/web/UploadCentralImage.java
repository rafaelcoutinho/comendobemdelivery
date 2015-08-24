package br.copacabana.spring.central.web;

import java.io.IOException;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import br.com.copacabana.cb.entities.Central;
import br.com.copacabana.cb.entities.Picture;
import br.com.copacabana.cb.entities.mgr.CentralManager;
import br.com.copacabana.cb.entities.mgr.PictureManager;
import br.copacabana.Authentication;
import br.copacabana.spring.JsonException;
import br.copacabana.spring.JsonException.ErrorCode;

import com.google.appengine.api.blobstore.BlobInfoFactory;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.images.Image;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.Transform;

public class UploadCentralImage extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private final static String deliveryImgUrl = "/delivery/img/";
	protected static final Logger log = Logger.getLogger("copacabana.Commands");

	public void doPost(HttpServletRequest request, HttpServletResponse res) throws ServletException, IOException {
		try {
			Key k = Authentication.getLoggedUserKey(request.getSession());
			Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(request);
			BlobKey blobKey = blobs.get("myFile");
			if (k.getKind().equalsIgnoreCase("Central")) {
				ServletContext context = getServletContext();
				WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(context);
				ImagesService imagesService = ImagesServiceFactory.getImagesService();

				Image oldImage = ImagesServiceFactory.makeImageFromBlob(blobKey);
				Transform resize = ImagesServiceFactory.makeResize(300, 300);
				Image largeImage = imagesService.applyTransform(resize, oldImage);

				Image oldImage2 = ImagesServiceFactory.makeImageFromBlob(blobKey);
				Transform resizeSmall = ImagesServiceFactory.makeResize(70, 70);
				Image newSmallImage = ImagesServiceFactory.getImagesService().applyTransform(resizeSmall, oldImage2);

				PictureManager picManager = (PictureManager) applicationContext.getBean("pictureManager");
				Picture pic = picManager.createPicture(largeImage.getImageData(), newSmallImage.getImageData(), new BlobInfoFactory().loadBlobInfo(blobKey).getFilename());

				CentralManager cman = (CentralManager) applicationContext.getBean("centralManager");

				Central central = cman.get(k);
				if (central.getImageKey() != null) {
					picManager.delete(Long.parseLong(central.getImageKey()));
				}
				central.setImageUrl(deliveryImgUrl + pic.getId());
				central.setImageKey(pic.getId().toString());

				cman.update(central);

				if (blobKey == null) {
					res.sendRedirect("/");
				} else {
					res.sendRedirect("/central/configuracoes.do");
				}
				blobstoreService.delete(blobKey);

			} else {
				blobstoreService.delete(blobKey);
				JsonException exception = new JsonException("Must have a logged in restaurant");
				throw exception;
			}

		} catch (IllegalArgumentException e) {
			log("failed ti upload central img", e);
			if (e.getMessage().contains("larger than maximum size")) {

				JsonException exception = new JsonException(e.getMessage(), ErrorCode.UPLOADEDFILELARGERTHANMAX);
				request.setAttribute("exception", exception);
				exception.setErrorCallback("parent.uploadFailed('" + ErrorCode.UPLOADEDFILELARGERTHANMAX.name() + "');");
				throw new ServletException(exception);
			} else {
				if (e.getMessage().contains("Failed to read image")) {
					JsonException exception = new JsonException(e.getMessage(), ErrorCode.UPLOADEDIMGFORMATUNKNWON);
					exception.setErrorCallback("parent.uploadFailed('" + ErrorCode.UPLOADEDIMGFORMATUNKNWON.name() + "');");
					request.setAttribute("exception", exception);
					throw new ServletException(exception);
				} else {
					JsonException exception = new JsonException(e.getMessage(), ErrorCode.UNKNOWN);
					exception.setErrorCallback("parent.uploadFailed('" + ErrorCode.UNKNOWN.name() + "');");
					request.setAttribute("exception", exception);
					throw new ServletException(exception);
				}
			}
		} catch (br.copacabana.spring.JsonException e) {
			e.printStackTrace();
			e.setErrorCallback("parent.uploadFailed('" + e.getErrorCode().name() + "');");
			request.setAttribute("exception", e);
			throw new ServletException(e);
		} catch (Exception e) {
			log(e.getMessage());
			e.printStackTrace();
			JsonException exception = new JsonException(e.getMessage());
			exception.setErrorCallback("parent.uploadFailed('" + exception.getErrorCode().name() + "');");
			request.setAttribute("exception", exception);
			throw new ServletException(exception);
		}

	}
}
