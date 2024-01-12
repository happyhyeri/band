package org.edupoll.band.dao;

import java.util.List;
import java.util.Map;

import org.edupoll.band.model.BandMember;

public interface BandMemberDao {
	public int saveMember(BandMember bandMember);

	public BandMember findByRoomIdAndUserId(Map<String, Object> criteria);

	public BandMember findByMemberId(int memberId);

	public int updateStatus(Map<String, Object> criteria);
	
	public int countMembers(String bandRoomId);
	
	public List<BandMember> findRequestByRoomId(String bandRoomId);
}
