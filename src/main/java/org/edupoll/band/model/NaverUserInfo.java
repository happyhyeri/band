package org.edupoll.band.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class NaverUserInfo {
	private String id;
	private String gender;
	private String profileImage;
	private String birth;
	private String mobile;
	private String nickname;


}
