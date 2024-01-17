package org.edupoll.band.dao;

import java.util.List;
import java.util.Map;

import org.edupoll.band.model.BandRoom;

public interface BandRoomDao {

	public int saveBandroom(BandRoom one);
	
	public BandRoom findByBandRoomId(String bandRoomId);
	
	public int update(Map<String, Object> one);
	
	
	public Integer findLeader(String bandRoomId);
	
	public List<BandRoom> findBandRoomNotIncludeByUserId(String userId);
}
