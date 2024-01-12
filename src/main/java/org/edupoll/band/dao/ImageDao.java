package org.edupoll.band.dao;

import java.util.List;
import org.edupoll.band.model.Image;

public interface ImageDao {
  public int saveImageFromPost(Image image);
	public List<Image> findAllByBandRoomId(String imageBandRoomId);

}
