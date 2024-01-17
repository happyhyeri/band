package org.edupoll.band.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.BandRoomDao;
import org.edupoll.band.dao.ProfileDao;
import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.BandRoom;
import org.edupoll.band.model.Profile;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class IndexController {
	
	private final BandMemberDao bandMemberDao;
	private final ProfileDao profileDao;
	private final BandRoomDao bandRoomDao;
	
	
	@GetMapping("/index")
	public String showShowIndex(@SessionAttribute(required = false) User logonUser, Model model) {
		
		if(logonUser == null) {
			return "redirect:/band/signin";
		}
	
		List<BandMember> bandList = bandMemberDao.findBandRoomsByMemberId(logonUser.getUserId());
		//System.out.println("bandList의 사이즈--> "+bandList.size());
		List<Integer> bandMemberCnt = new ArrayList<>();
		for(BandMember one : bandList) {
			bandMemberCnt.add(bandMemberDao.countMembers(one.getMemberBandRoomId()));
		}
		
		for(int i = 0; i < bandList.size(); i++) {
			bandList.get(i).setCnt(bandMemberCnt.get(i));
		}
		
		List<Profile> profiles = profileDao.findProfileById(logonUser.getUserId());
		model.addAttribute("profileImageUrl", profiles.get(0).getProfileImageUrl());
		
		model.addAttribute("bandList",bandList);
		
		// logonUser가 가입하지 않은 밴드룸
		List<BandRoom> roomList = bandRoomDao.findBandRoomNotIncludeByUserId(logonUser.getUserId());
		model.addAttribute("roomList", roomList);
		
		return "index";
	}
	
	@GetMapping("/indexhome")
	public String showBandMain() {
		
		return "indexhome";
	}
}
