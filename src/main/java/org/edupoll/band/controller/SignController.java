package org.edupoll.band.controller;

import javax.servlet.http.HttpSession;

import org.edupoll.band.dao.ProfileDao;
import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.KakaoOAuthToken;
import org.edupoll.band.model.KakaoUserInfo;
import org.edupoll.band.model.NaverOAuthToken;
import org.edupoll.band.model.NaverUserInfo;
import org.edupoll.band.model.Profile;
import org.edupoll.band.model.User;
import org.edupoll.band.service.KakaoAPIService;
import org.edupoll.band.service.NaverAPIService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;
@RequiredArgsConstructor
@Controller
public class SignController  {
	private final NaverAPIService naverAPIService;
	private final KakaoAPIService kakaoAPIService;
	private final UserDao userDao;
	private final ProfileDao profileDao;
	
	@Value("${kakao.client.id}")
	String kakaoClientId;
	@Value("${kakao.redirect.url}")
	String kakaoRedirectUrl;
	@Value("${naver.client.id}")
	String naverClientId;
	@Value("${naver.redirect.url}")
	String naverRedirectUrl;
	@Value("${naver.client.secret}")
	String naverClientSecret;
	
	
	@GetMapping("/signin")
	public String showSign(Model model) {
		//카카오
		String kakaoLoginLink = "https://kauth.kakao.com/oauth/authorize?";
		kakaoLoginLink += "client_id=${client_id}&response_type=code";
		kakaoLoginLink += "&redirect_uri=${redirect_uri}";
		
		kakaoLoginLink = kakaoLoginLink.replace("${client_id}", kakaoClientId);
		kakaoLoginLink = kakaoLoginLink.replace("${redirect_uri}", kakaoRedirectUrl);
		
		
		model.addAttribute("kakaoLoginLink", kakaoLoginLink);
		
		//네이버
		String NaverLoginLink = "https://nid.naver.com/oauth2.0/authorize?";
		NaverLoginLink += "client_id=${client_id}&response_type=code";
		NaverLoginLink += "redirect_uri=${redirect_uri}&state=${state}";
		
		NaverLoginLink = NaverLoginLink.replace("${client_id}", naverClientId);
		NaverLoginLink = NaverLoginLink.replace("${redirect_uri}", naverRedirectUrl);
		NaverLoginLink = NaverLoginLink.replace("${state}", "state");
		
		model.addAttribute("kakaoLoginLink", NaverLoginLink);
		return "signin";
	}

	
	
	//카카오 연동 로그인 
	@GetMapping("/callback/kakao")
	public String acceptCodeKaKao(@RequestParam String code, HttpSession session) {
		//카카오로부터 인가코드 받음.(signin.jsp파일에서 파라미터 값을 넘겨줌.)
		System.out.println("code =>" + code);
		
		//인가 코드를 이용해 토큰 받기
		//서버와 서버간 통신을 도움
		//String uri = "https://kauth.kakao.com/oauth/token";
		
		KakaoOAuthToken oAuthToken = kakaoAPIService.getOAuthToken(code);
		System.out.println(oAuthToken.getAccess_token());
		
		KakaoUserInfo kakaoUserInfo =
				kakaoAPIService.getUserInfo(oAuthToken.getAccess_token());
	
		String id = "k"+kakaoUserInfo.getId();
		
		User user = userDao.findUserById(id); //id값 곂치는거 방지하기 위해서
		if(user==null) {
			User one = User.builder().userId(id).platform("kakao").accessToken(oAuthToken.getAccess_token()).build();
			userDao.save(one);
			
			Profile p = Profile.builder().profileUserId(id).profileNickName(kakaoUserInfo.getProfile().getNickname()).profileImageUrl(kakaoUserInfo.getProfile().getProfileImage()).build();
			profileDao.profileSave(p);
			
			session.setAttribute("logonAccount", one);
			
		}else {
			user.setAccessToken(oAuthToken.getAccess_token());
//			account.setNickname(kakaoUserInfo.getProfile().getNickname());
//			account.setProfileImageUrl(kakaoUserInfo.getProfile().getProfileImage());
			
			System.out.println();
			userDao.userUpdate(user);
			
			session.setAttribute("logonAccount", user);
			
		}
		return "redirect:/index";
	}
	
		
	//네이버 연동 로그인 
		@GetMapping("/callback/naver")
		public String acceptCodeNaver(@RequestParam String code, HttpSession session) {
			//네이버로부터 인가코드 받음.(signin.jsp파일에서 파라미터 값을 넘겨줌.)
			System.out.println("code =>" + code);
			
			
			NaverOAuthToken oAuthToken = naverAPIService.getOAuthToken(code);
			
			System.out.println(oAuthToken.getAccess_token());
			System.out.println(oAuthToken.getError());
			System.out.println(oAuthToken.getErrorDescription());
			NaverUserInfo naverUserInfo =
					naverAPIService.getUserInfo(oAuthToken.getAccess_token());
		
			
			String id = "n"+naverUserInfo.getId();
			
			User user = userDao.findUserById(id); //id값 곂치는거 방지하기 위해서
			if(user==null) {
				User one = User.builder().userId(id).platform("naver").accessToken(oAuthToken.getAccess_token()).build();
				userDao.save(one);
				
				Profile p = Profile.builder().profileUserId(id).profileNickName(naverUserInfo.getNickname()).profileImageUrl(naverUserInfo.getProfileImage()).build();
				profileDao.profileSave(p);
				
				session.setAttribute("logonAccount", one);
				
			}else {
				user.setAccessToken(oAuthToken.getAccess_token());
				
				System.out.println();
				userDao.userUpdate(user);
				
				session.setAttribute("logonAccount", user);
				
			}
			return "redirect:/index";
		}
	
	@GetMapping("/signout") 
	public String proceedSignout(HttpSession session) {
		
		session.invalidate();
		return "redirect:/index";
	}
	
	
	
	
}
	

 