package org.edupoll.band.dao;

import java.util.List;
import org.edupoll.band.model.Image;

public interface ImageDao {

	public int saveImageFromPost(Image image);

	public List<Image> findAllByBandRoomId(String imageBandRoomId);
	
	// 최근이미지 4개만..
	public List<Image> findImageByBandRoomIdToFour(String imageBandRoomId);
	
	public List<Image> findAllByAlbumId(Integer imageAlbumId);
	
	public int saveImageForWhole(Image image);
	
	public int saveImageForAlbum(Image image);
	
	public int countImageTotal(String imageBandRoomId);
	
	public int countImageAlbumTotal(Integer imageAlbumId);
	

}
