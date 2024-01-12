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
public class Image {
	private int imageId;
	private String imageUrl;
	private Integer imageAlbumId;
	private Integer imagePostId;
	private Date imageUploadAt;
	private String imageBandRoomId;
}
