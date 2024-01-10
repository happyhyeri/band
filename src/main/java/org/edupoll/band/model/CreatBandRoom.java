package org.edupoll.band.model;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CreatBandRoom {
	private String bandRoomName;
	private MultipartFile bandimage;
	private String bandRoomColor;
	private String type;
	
}
