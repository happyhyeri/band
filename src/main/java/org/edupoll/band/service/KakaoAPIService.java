package org.edupoll.band.service;

import java.net.URI;

import org.edupoll.band.model.KakaoOAuthToken;
import org.edupoll.band.model.KakaoUserInfo;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;

@Service
public class KakaoAPIService {
	
	@Value("${kakao.client.id}")
	String kakaoClientId;
	@Value("${kakao.redirect.url}")
	String kakaoRedirectUrl;
	

	public KakaoOAuthToken getOAuthToken(String code) {
		MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
		headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

		MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
		// 하나의 키에 여러개의 밸류가 들어감. add로 계속 추가하면 같은 이름으로 값이 여러개가 들어가는게 가능함.(리스트형태로 관리 가능함)
		body.add("grant_type", "authorization_code");
		body.add("client_id", kakaoClientId);
		body.add("redirect_uri", kakaoRedirectUrl);
		body.add("code", code);
		//인가 코드 받기 요청으로 받은 인가코드
		var request = new RequestEntity<>(body, headers, HttpMethod.POST,
				URI.create("https://kauth.kakao.com/oauth/token"));
		//RequestEntity: http요청을 표현하는 클래스 
		
		
		
		// 우리가 보낸 요청을 가지고 응답을 받아오는 객체 -->RestTemplate객체
		RestTemplate template = new RestTemplate();
		var response = template.exchange(request, String.class);

		//System.out.println("난 Body 다 -->" + response.getBody());// 카카오로부터 받아온 응답을 확인할 수 있다. 우리는 받아온 access_token을 가지고 다시
																// 정보를 받아와야함.
		// access_token 을 통해 소유자 정보를 얻어올 수 있음. 이걸 카카오톡에 날려주면 카카오톡에서 사용자 정보를 알려줌.

		Gson gson = new Gson();
		KakaoOAuthToken oAuthToken = gson.fromJson(response.getBody(), KakaoOAuthToken.class);
	

		//인가코드를 통해 얻은 토큰 객체 반환
		return oAuthToken;
	}
	
	//유저 정보 가져오기
	public  KakaoUserInfo getUserInfo(String accseToken) {
		
		MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
		headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
		headers.add("Authorization","Bearer "+accseToken);
		
		var request = new RequestEntity<>(headers, HttpMethod.GET,
				URI.create("https://kapi.kakao.com/v2/user/me"));

		// 우리가 보낸 요청을 가지고 응답을 받아오는 객체
		RestTemplate template = new RestTemplate();
		var response = template.exchange(request, String.class);

		Gson gson = new Gson();
		gson.fromJson(response.getBody(), KakaoUserInfo.class);
		
		return gson.fromJson(response.getBody(), KakaoUserInfo.class);
		
	}
	
}
