package org.edupoll.band.dao;

import org.edupoll.band.model.BandRoom;

public interface BandRoomDao {

	public int saveBandroom(BandRoom one);
	
	public BandRoom findByBandRoomId(String bandRoomId);

	public BandRoom findByBandRoomId(String id);
}
