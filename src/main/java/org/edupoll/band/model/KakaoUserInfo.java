package org.edupoll.band.model;

import com.google.gson.annotations.SerializedName;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class KakaoUserInfo {

	private long id;
	
	
	//사용자 정보 응답받을때 id는 필수고 나머지는 선택인데 거기서 properties부분 존재! 우리는 거기서 3개만 쓸거임 
	@SerializedName("properties")
	private KakaoProfile profile;
}


