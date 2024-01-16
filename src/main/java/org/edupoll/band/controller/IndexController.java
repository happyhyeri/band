package org.edupoll.band.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.ProfileDao;
import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.Profile;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/index")
@RequiredArgsConstructor
public class IndexController {
	
	private final UserDao userDao;
	private final BandMemberDao bandMemberDao;
	private final ProfileDao profileDao;
	
	
	@GetMapping("/{id}")
	public String showIndex(@PathVariable String id, HttpSession session, Model model) {
		
		User user = userDao.findUserById(id);
		
		session.setAttribute("logonUser", user);
		
		List<BandMember> bandList = bandMemberDao.findBandRoomsByMemberId(user.getUserId());
		//System.out.println("bandList의 사이즈--> "+bandList.size());
		List<Integer> bandMemberCnt = new ArrayList<>();
		for(BandMember one : bandList) {
			bandMemberCnt.add(bandMemberDao.countMembers(one.getMemberBandRoomId()));
		}
		
		for(int i = 0; i < bandList.size(); i++) {
			bandList.get(i).setCnt(bandMemberCnt.get(i));
		}
		
		List<Profile> profiles = profileDao.findProfileById(user.getUserId());
		model.addAttribute("profileImageUrl", profiles.get(0).getProfileImageUrl());
		
		model.addAttribute("bandList",bandList);
		return "index";
	}
}
