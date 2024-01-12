package org.edupoll.band.dao;

import java.util.List;

import org.edupoll.band.model.Album;

public interface AlbumDao {
	
	public int saveAlbum(Album album);
	
	public Album findByAlbumId(int albumId);
	
	public List<Album> findByBandRoomId(String bandRoomId);
}
