package org.edupoll.band.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.BandRoomDao;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.BandRoom;
import org.edupoll.band.model.CreatBandRoom;
import org.edupoll.band.model.Profile;
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
public class BandSignController {

	private final BandRoomDao bandRoomDao;
	private final BandMemberDao bandMemberDao;

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

	@PostMapping("/{bandRoomId}/applications/accept")
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

	@GetMapping("/band-create")
	public String showFormForBandCerate() {

		return "band/band-create";
	}

	@PostMapping("/band-create")

	public String createBandRoom(
								@ModelAttribute CreatBandRoom createBandRoom 
								,@RequestParam String coverImageUrl ,Model model) throws IllegalStateException, IOException {
		
		String uuid = UUID.randomUUID().toString();
		String[] uuids = uuid.split("-");

		String imageUrl;
		// System.out.println("데이터 넘어온것 확인--> "+createBandRoom.getBandRoomName());
		if (coverImageUrl.startsWith("http")) {
			String[] a = coverImageUrl.split("8080/band");
			// System.out.println(a[1]);
			imageUrl = a[1];
		} else {
			imageUrl = "\\band\\upload\\coverImage\\" + uuids[0].toUpperCase() + "\\img.jpg";
		}

		if (!createBandRoom.getBandimage().isEmpty()) {
			File dir = new File("c:\\band\\upload\\coverImage\\", uuids[0].toUpperCase());
			dir.mkdirs();
			File target = new File(dir, "img.jpg");
			createBandRoom.getBandimage().transferTo(target);
		}

		BandRoom one = BandRoom.builder().bandRoomId(uuids[0].toUpperCase()) //
				.bandRoomName(createBandRoom.getBandRoomName()) //
				.coverImageUrl(imageUrl) //
				.bandRoomColor("green") //
				.type(createBandRoom.getType()) //
				.build();

		int x = bandRoomDao.saveBandroom(one);
		// System.out.println("밴드룸생성 결과--> "+x);

		return "redirect:/band/" + one.getBandRoomId();
	}

}
