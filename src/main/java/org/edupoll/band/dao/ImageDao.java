package org.edupoll.band.dao;

import java.util.List;

import org.edupoll.band.model.Image;

public interface ImageDao {

	public List<Image> findAllByBandRoomId(String imageBandRoomId);
}
