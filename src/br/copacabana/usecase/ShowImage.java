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

public class ShowImage extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private String plateImageServerUrl = "/prato/";

	public void doGet(HttpServletRequest request, HttpServletResponse res) throws ServletException, IOException {

		System.out.println(request.getServletPath());
		Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(request);
		BlobKey blobKey = blobs.get("myFile");
		// System.out.println(k);
		// System.out.println(k.getKind());
		
	}
}
