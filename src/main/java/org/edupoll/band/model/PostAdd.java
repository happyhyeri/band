package org.edupoll.band.model;

import org.springframework.web.multipart.MultipartFile;

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
public class PostAdd {
	private String content;
	private int postMemberId;
	private String postBandRoomId;
	private MultipartFile[] images;
}
