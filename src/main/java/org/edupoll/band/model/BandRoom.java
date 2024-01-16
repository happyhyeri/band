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
public class BandRoom {

	private String bandRoomId;
	private String bandRoomName;
	private Date bandRoomMakeAt;
	private Integer leader;
	private String bandRoomDescription;
	private String coverImageUrl;
	private String bandRoomColor;
	private String type;

}
