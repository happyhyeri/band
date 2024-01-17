package org.edupoll.band.model;

import java.sql.Date;

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
public class Schedule {
	private int scheduleId;
	private String scheduleTitle;
	private String scheduleDescription;
	private Date scheduleDate;
	private int scheduleMemberId;
	private String scheduleBandRoomId;
	
	private BandMember member;
}
