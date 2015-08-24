package br.com.copacabana.cb.entities.mgr;

import br.com.copacabana.cb.entities.Picture;
import br.copacabana.raw.filter.Datastore;

import com.google.appengine.api.datastore.Blob;

public class PictureManager extends AbstractJPAManager<Picture> {

	public Picture getPicture(Long id) {
		return Datastore.getPersistanceManager().find(Picture.class, id);
	}

	public void delete(Long id) {
		Picture p = Datastore.getPersistanceManager().find(Picture.class, id);
		Datastore.getPersistanceManager().remove(p);
	}

	public Picture createPicture(byte[] imageData, byte[] thumbs, String filename) {
		Blob im = new Blob(imageData);

		Picture pic = new Picture(im, filename);
		pic.setSmall(new Blob(thumbs));
		Datastore.getPersistanceManager().getTransaction().begin();
		Datastore.getPersistanceManager().persist(pic);
		Datastore.getPersistanceManager().getTransaction().commit();
		return pic;
	}

	@Override
	public String getDefaultQueryName() {

		return "getPicture";
	}

	@Override
	protected Class getEntityClass() {
		// TODO Auto-generated method stub
		return Picture.class;
	}
}
