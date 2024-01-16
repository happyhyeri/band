package org.edupoll.band.model;

import java.sql.Date;
import java.util.List;

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
public class Post {
	private int postId;
	private String content;
	private int postMemberId;
	private Date postWriteAt;
	private int viewCnt;
	private String postBandRoomId;

	private BandMember member;
	private List<Image> images;
	private Profile profile;

	private transient String json;
}
