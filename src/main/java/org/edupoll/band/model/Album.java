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
public class Album {
	private int albumId;
	private String albumBandRoomId;
	private String albumTitle;
	private Date albumMakeAt;
	private String imageUrl;
}
