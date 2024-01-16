package org.edupoll.band.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BandMember {
	private int memberId;
	private String memberBandRoomId;
	private String memberUserId;
	private int memberProfileId;
	private String memberStatus;
	private int cnt;
	
	private Profile profile;
	private BandRoom bandRoom;
}
