package org.edupoll.band.controller;

import java.sql.Date;
import java.util.regex.Pattern;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RequestMapping
@Controller
public class SignController {
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
	@Value("${naver.redirect.uri}")
	String naverRedirectUrl;
	@Value("${naver.client.secret}")
	String naverClientSecret;

	@GetMapping("/auth/login_page")
	public String showSign(@RequestParam(required =false) String userId, Model model) {
		// 카카오
		String kakaoLoginLink = "https://kauth.kakao.com/oauth/authorize?";
		kakaoLoginLink += "client_id=${client_id}&response_type=code";
		kakaoLoginLink += "&redirect_uri=${redirect_uri}";

		kakaoLoginLink = kakaoLoginLink.replace("${client_id}", kakaoClientId);
		kakaoLoginLink = kakaoLoginLink.replace("${redirect_uri}", kakaoRedirectUrl);

		model.addAttribute("kakaoLoginLink", kakaoLoginLink);

		// 네이버
		String NaverLoginLink = "https://nid.naver.com/oauth2.0/authorize?";
		NaverLoginLink += "client_id=${client_id}&response_type=code&";
		NaverLoginLink += "redirect_uri=${redirect_uri}&state=${state}";

		NaverLoginLink = NaverLoginLink.replace("${client_id}", naverClientId);
		NaverLoginLink = NaverLoginLink.replace("${redirect_uri}", naverRedirectUrl);
		NaverLoginLink = NaverLoginLink.replace("${state}", "state");

		model.addAttribute("NaverLoginLink", NaverLoginLink);
		
		model.addAttribute("userId", userId);

		// 수기
		return "signin";
	}
	
	@PostMapping("/auth/login_page")
	public String proceedLogin(@ModelAttribute User user, @RequestParam String password, HttpSession session,  Model model) {
		
		User foundUser = userDao.findUserById(user.getUserId());
		
		if(foundUser == null || !foundUser.getUserPassword().equals(password)) {
			model.addAttribute("error", true);
			return "signin";
		}
		
		session.setAttribute("logonUser", foundUser);

		return "redirect:/"; //구분해줘야할듯 로그인 인덱스와
	}
	
	

	// 카카오 연동 로그인
	@GetMapping("/callback/kakao")
	public String acceptCodeKaKao(@RequestParam String code, HttpSession session) {
		// 카카오로부터 인가코드 받음.(signin.jsp파일에서 파라미터 값을 넘겨줌.)
		System.out.println("code =>" + code);

		// 인가 코드를 이용해 토큰 받기
		// 서버와 서버간 통신을 도움
		// String uri = "https://kauth.kakao.com/oauth/token";

		KakaoOAuthToken oAuthToken = kakaoAPIService.getOAuthToken(code);
		System.out.println(oAuthToken.getAccess_token());

		KakaoUserInfo kakaoUserInfo = kakaoAPIService.getUserInfo(oAuthToken.getAccess_token());

		String id = "k" + kakaoUserInfo.getId();

		User user = userDao.findUserById(id); // id값 곂치는거 방지하기 위해서
		if (user == null) {
			User one = User.builder().userId(id).platform("kakao").accessToken(oAuthToken.getAccess_token()).build();
			userDao.save(one);

			Profile p = Profile.builder().profileUserId(id).profileNickName(kakaoUserInfo.getProfile().getNickname())
					.profileImageUrl(kakaoUserInfo.getProfile().getProfileImage()).build();
			profileDao.profileSave(p);

			session.setAttribute("logonUser", one);

		} else {
			user.setAccessToken(oAuthToken.getAccess_token());
//			account.setNickname(kakaoUserInfo.getProfile().getNickname());
//			account.setProfileImageUrl(kakaoUserInfo.getProfile().getProfileImage());

			System.out.println();
			userDao.userUpdate(user);

			session.setAttribute("logonUser", user);

		}
		return "redirect:/";
	}

	// 네이버 연동 로그인
	@GetMapping("/callback/naver")
	public String acceptCodeNaver(@RequestParam String code, HttpSession session) {
		// 네이버로부터 인가코드 받음.(signin.jsp파일에서 파라미터 값을 넘겨줌.)
		System.out.println("code =>" + code);

		NaverOAuthToken oAuthToken = naverAPIService.getOAuthToken(code);

		System.out.println(oAuthToken.getAccess_token());
		System.out.println(oAuthToken.getError());
		System.out.println(oAuthToken.getErrorDescription());
		NaverUserInfo naverUserInfo = naverAPIService.getUserInfo(oAuthToken.getAccess_token());

		String id = "n" + naverUserInfo.getNaverProfile().getId();

		User user = userDao.findUserById(id); // id값 곂치는거 방지하기 위해서
		if (user == null) {
			User one = User.builder().userId(id).platform("naver").accessToken(oAuthToken.getAccess_token()).build();
			userDao.save(one);

			Profile p = Profile.builder().profileUserId(id)
					.profileNickName(naverUserInfo.getNaverProfile().getNickname())
					.profileImageUrl(naverUserInfo.getNaverProfile().getProfileImage()).build();
			profileDao.profileSave(p);

			session.setAttribute("logonUser", one);

		} else {
			user.setAccessToken(oAuthToken.getAccess_token());

			System.out.println();
			userDao.userUpdate(user);

			session.setAttribute("logonUser", user);

		}
		return "redirect:/";
	}

	@GetMapping("/auth/sign_up_form")
	public String showRegister() {

		return "register";
	}

	@PostMapping("/auth/sign_up_form")
	public String proceedRegister(@ModelAttribute User user, @RequestParam String profileNickName,
			@RequestParam String birthParam, Model model) {

		User foundUser = userDao.findUserById(user.getUserId());
		if (foundUser != null) {
			model.addAttribute("error", true);
			return "/auth/sign_up_form";
		}
		
		
		String birthday = birthParam.substring(0,4) + "-" + birthParam.substring(4,6) + "-" + birthParam.substring(6,8);
		System.out.println(birthday);
		Date b = Date.valueOf(birthday);

		System.out.println(profileNickName);

		System.out.println();
		User newUser = User.builder().userId(user.getUserId()).userPassword(user.getUserPassword())
				.gender(user.getGender()).phoneNumber(user.getPhoneNumber()).birth(b).platform("자체회원가입").build();
		userDao.save(newUser);

		Profile NewProfile = Profile.builder().profileNickName(profileNickName).profileUserId(user.getUserId())
				.profileImageUrl("/resource/registericon/default.jpg").build();
		profileDao.profileSave(NewProfile);

		return "redirect:/auth/login_page?userId=" + user.getUserId();
	}

	@GetMapping("/auth/sign_up_form/idcheck")
	@ResponseBody
	public String proceedIdAvailable(@RequestParam String userId, Model model) {

		User foundUser = userDao.findUserById(userId);
		if (foundUser == null) {
			return "YYYY";
		} else {
			return "NNNN";
		}

	}

	@GetMapping("/auth/sign_up_form/phoneNumberCheck")
	@ResponseBody
	public String proceedPhoneNumberAvailable(@RequestParam String phoneNumber, Model model) {
		String pattern = "(010|011|016|017|018|019)(.+)(.{4})";
				
		if (Pattern.matches(pattern, phoneNumber)) {
			return "OK";
		} else {

			return "NO";
		}
	}
	
	@GetMapping("/auth/sign_up_form/birthCheck")
	@ResponseBody
	public String proceedBirthAvailable(@RequestParam String birthParam, Model model) {
		String pattern = "(19[0-9][0-9]|20\\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])";
				
		if (Pattern.matches(pattern, birthParam)) {
			return "OK";
		} else {

			return "NO";
		}
	}

	@GetMapping("/signout")
	public String proceedSignout(HttpSession session) {

		session.invalidate();
		return "redirect:/indexhome";
	}

}
