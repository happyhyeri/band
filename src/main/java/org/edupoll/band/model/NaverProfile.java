package org.edupoll.band.model;

import com.google.gson.annotations.SerializedName;

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
public class NaverProfile {

	private String id;
	private String nickname;
	
	@SerializedName("profile_image")
	private String profileImage;
	private String gender;
	@SerializedName("birthday")
	private String birth;
	private String mobile;
	
	}
	

