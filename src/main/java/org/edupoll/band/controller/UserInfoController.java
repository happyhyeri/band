package org.edupoll.band.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.edupoll.band.dao.ProfileDao;
import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.Profile;
import org.edupoll.band.model.UpdateUserInfo;
import org.edupoll.band.model.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import lombok.RequiredArgsConstructor;

@RequestMapping("/my/profile")
@Controller
@RequiredArgsConstructor
public class UserInfoController {

	@Value("${upload.profileImage.dir}")
	String uploadProfileImageDir;
	
	private final UserDao userDao;
	private final ProfileDao profileDao;

	@GetMapping
	public String showMyProfile (@SessionAttribute User logonUser, Model model) {
		List<Profile> one = profileDao.findProfileById(logonUser.getUserId());
		
		Profile p = one.get(0);

		model.addAttribute("profile",p);
		model.addAttribute("profileImgUrl",p.getProfileImageUrl());
		
		User user = userDao.findUserById(logonUser.getUserId());
		model.addAttribute("findUser",user);
		
		return "mypage/mypageForm";
	}
	
	
	@PostMapping("/imageNickname")
	public String updateImgFileNickname(@ModelAttribute UpdateUserInfo updateUserInfo, @SessionAttribute User logonUser, HttpSession session ,Model model) throws IllegalStateException, IOException {
		
	
	if(!updateUserInfo.getProfileImage().isEmpty()) {
		File dir = new File(uploadProfileImageDir, logonUser.getUserId());
		dir.mkdirs();
		
		File target = new File(dir, "img.jpg"); 
		
		updateUserInfo.getProfileImage().transferTo(target);
		
		Profile profile = Profile.builder().profileUserId(logonUser.getUserId()).profileImageUrl("/band/upload/profileImage/"+logonUser.getUserId()+"/img.jpg").profileNickName(updateUserInfo.getNickname()).build();
		profileDao.profileUpdate(profile);
		
		model.addAttribute("profileImgUrl",profile.getProfileImageUrl());
		List<Profile> pf = profileDao.findProfileById(profile.getProfileUserId());
		Profile p = pf.get(0);
		System.out.println(p);
		User one = userDao.findUserById(logonUser.getUserId());
		one.setProfile(p);
		
		session.setAttribute("logonUser",one);
		
		return "redirect:/my/profile";
		
	}
	
		Profile profile = Profile.builder().profileUserId(logonUser.getUserId()).profileNickName(updateUserInfo.getNickname()).build();
		profileDao.profileUpdate(profile);
	
	
	return "redirect:/my/profile";
	}
	
	@PostMapping("/defaultChange")
	public String updatedefaultChange(@RequestParam String phoneNumber,@SessionAttribute User logonUser, HttpSession session ,Model model) {
		
		User user = userDao.findUserById(logonUser.getUserId());
		user.setPhoneNumber(phoneNumber);
		userDao.userUpdate(user);
		session.setAttribute("logonUser",user);
		
		return "redirect:/my/profile";
	}
	
	


}
