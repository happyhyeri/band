package org.edupoll.band.dao;

import java.util.List;
import java.util.Map;

import org.edupoll.band.model.Image;

public interface ImageDao {

	public int saveImageFromPost(Image image);

	public List<Image> findAllByBandRoomId(String imageBandRoomId);
	
	// 최근이미지 6개만..(전체사진)
	public List<Image> findImageByBandRoomIdToSix(String imageBandRoomId);
	
	// 최근이미지 4개만..(앨범사진)
	public List<Image> findAlbumImageByBandRoomIdToFour(Map<String, Object> one);
	
	public List<Image> findAllByAlbumId(Integer imageAlbumId);
	
	public int saveImageForWhole(Image image);
	
	public int saveImageForAlbum(Image image);
	
	public int countImageTotal(String imageBandRoomId);
	
	public int countImageAlbumTotal(Integer imageAlbumId);
	
	public int deleteWholeImage(Integer imageId);
	
	public Image findImageByImageId(Integer imageId);

}
