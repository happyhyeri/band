package org.edupoll.band.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.BandRoomDao;
import org.edupoll.band.dao.ProfileDao;
import org.edupoll.band.dao.ScheduleDao;
import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.BandRoom;
import org.edupoll.band.model.Profile;
import org.edupoll.band.model.Schedule;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.google.gson.Gson;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/band")
@RequiredArgsConstructor
public class MemberController {

	private final BandRoomDao bandRoomDao;
	private final BandMemberDao bandMemberDao;
	private final ProfileDao profileDao;
	private final UserDao userDao;
	private final ScheduleDao scheduleDao;
	
	@ModelAttribute("profileImageUrl")
	public String findProfileImageUrl(@SessionAttribute User logonUser) {
		User user = userDao.findUserById(logonUser.getUserId());
		List<Profile> profiles = profileDao.findProfileById(user.getUserId());
		return profiles.get(0).getProfileImageUrl();
	}
	
	@ModelAttribute("nextSchedule")
	public Schedule findNextSchedule() {
		return scheduleDao.findNextSchedule();
	}
	
	@PostMapping("/{bandRoomId}/request")
	public String proceedBandSign(@SessionAttribute User logonUser, @PathVariable String bandRoomId,
			@RequestParam int profileId) {

		Map<String, Object> criteria = new HashMap<>();
		criteria.put("memberBandRoomId", bandRoomId);
		criteria.put("memberUserId", logonUser.getUserId());
		BandMember found = bandMemberDao.findByRoomIdAndUserId(criteria);

		if (found == null) {
			BandMember member = BandMember.builder() //
					.memberBandRoomId(bandRoomId) //
					.memberUserId(logonUser.getUserId()) //
					.memberProfileId(profileId) //
					.memberStatus("request") //
					.build();
			bandMemberDao.saveMember(member);
		} else if (found.getMemberStatus().equals("reject") || found.getMemberStatus().equals("leave")) {
			criteria.clear();
			criteria.put("memberStatus", "request");
			criteria.put("memberId", found.getMemberId());
			bandMemberDao.updateStatus(criteria);
		}

		return "redirect:/band/" + bandRoomId; // 가입신청한 밴드룸으로
	}

	@GetMapping("/{bandRoomId}/applications")
	public String showRequests(@SessionAttribute(required = false) User logonUser, @PathVariable String bandRoomId,
			Model model) {

		Map<String, Object> criteria = new HashMap<>();
		criteria.put("memberBandRoomId", bandRoomId);
		criteria.put("memberUserId", logonUser.getUserId());
		BandMember member = bandMemberDao.findByRoomIdAndUserId(criteria);
		model.addAttribute("member", member);

		int memberCnt = bandMemberDao.countMembers(bandRoomId);
		model.addAttribute("memberCnt", memberCnt);

		BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
		model.addAttribute("bandRoom", bandRoom);

		List<BandMember> requests = bandMemberDao.findRequestByRoomId(bandRoomId);
		model.addAttribute("requests", requests);

		return "band/applications";
	}

	@PostMapping("/{bandRoomId}/applications")
	@ResponseBody
	public String proceedAccept(@SessionAttribute User logonUser, @PathVariable String bandRoomId,
			@RequestParam String type, @RequestParam int memberId, Model model) {

		Map<String, Object> criteria = new HashMap<>();
		criteria.put("memberStatus", type);
		criteria.put("memberId", memberId);
		bandMemberDao.updateStatus(criteria);

		Map<String, Object> response = new HashMap<>();
		response.put("result", "success");
		Gson gson = new Gson();

		return gson.toJson(response);
	}

	@GetMapping("/{bandRoomId}/member")
	public String showMember(@SessionAttribute(required = false) User logonUser, @PathVariable String bandRoomId,
			Model model) {

		Map<String, Object> criteria = new HashMap<>();
		criteria.put("memberBandRoomId", bandRoomId);
		criteria.put("memberUserId", logonUser.getUserId());
		BandMember member = bandMemberDao.findByRoomIdAndUserId(criteria);
		model.addAttribute("member", member);

		// 여기서 logonUser의 모든 프로필 정보를 담은 List<Profile> profiles 보내주기
		List<Profile> profiles = profileDao.findProfileById(logonUser.getUserId());
		model.addAttribute("profiles", profiles);

		int memberCnt = bandMemberDao.countMembers(bandRoomId);
		model.addAttribute("memberCnt", memberCnt);

		BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
		model.addAttribute("bandRoom", bandRoom);

		List<BandMember> members = bandMemberDao.findByRoomId(bandRoomId);
		model.addAttribute("members", members);
		
		return "band/member";
	}

}
