package org.edupoll.band.dao;

import java.util.List;
import java.util.Map;

import org.edupoll.band.model.Album;

public interface AlbumDao {
	
	public int saveAlbum(Album album);
	
	public Album findByAlbumId(int albumId);
	
	//수정전
	public List<Album> findByBandRoomId(String bandRoomId);
	//수정중
	public List<Album> findAlbumWithAlbumImage(String bandRoomId);
	
	
	public int deleteByAlbumId(int albumId);
	
	public int update(Map<String, Object> one);

}
