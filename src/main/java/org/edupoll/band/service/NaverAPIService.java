package org.edupoll.band.service;

import java.net.URI;

import org.edupoll.band.model.NaverOAuthToken;
import org.edupoll.band.model.NaverUserInfo;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;

@Service
public class NaverAPIService {
	
	@Value("${naver.client.id}")
	String naverClientId;
	@Value("${naver.redirect.uri}")
	String naverRedirectUrl;
	@Value("${naver.client.secret}")
	String naverClientSecret;
	

	public NaverOAuthToken getOAuthToken(String code) {
		MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
		headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

		MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
		// 하나의 키에 여러개의 밸류가 들어감. add로 계속 추가하면 같은 이름으로 값이 여러개가 들어가는게 가능함.(리스트형태로 관리 가능함)
		body.add("grant_type", "authorization_code");
		body.add("client_id", naverClientId);
		body.add("client_secret", naverClientSecret);
		body.add("state", "state");
		body.add("code", code);
		//인가 코드 받기 요청으로 받은 인가코드
		var request = new RequestEntity<>(body, headers, HttpMethod.POST,
				URI.create("https://nid.naver.com/oauth2.0/token"));
		//RequestEntity: http요청을 표현하는 클래스 
		
		
		
		// 우리가 보낸 요청을 가지고 응답을 받아오는 객체 -->RestTemplate객체
		RestTemplate template = new RestTemplate();
		var response = template.exchange(request, String.class);

		Gson gson = new Gson();
		NaverOAuthToken oAuthToken = gson.fromJson(response.getBody(), NaverOAuthToken.class);
	

		//인가코드를 통해 얻은 토큰 객체 반환
		return oAuthToken;
	}
	
	//유저 정보 가져오기
	public  NaverUserInfo getUserInfo(String accseToken) {
		
		MultiValueMap<String, String> headers = new LinkedMultiValueMap<>();
		
		headers.add("Authorization","Bearer "+accseToken);
		
		var request = new RequestEntity<>(headers, HttpMethod.GET,
				URI.create("https://openapi.naver.com/v1/nid/me"));

		// 우리가 보낸 요청을 가지고 응답을 받아오는 객체
		RestTemplate template = new RestTemplate();
		var response = template.exchange(request, String.class);

		Gson gson = new Gson();
		gson.fromJson(response.getBody(), NaverUserInfo.class);
		
		return gson.fromJson(response.getBody(), NaverUserInfo.class);
		
	}
	
}
