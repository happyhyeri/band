package org.edupoll.band.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class KakaoOAuthToken {
	private String access_token;
	private String token_type;
	private String refresh_token;
	//사용자 인증 토큰이 만료되었을 때, 새로운 토큰을 발급해주는 기술
	private int expired_in;
}
	

