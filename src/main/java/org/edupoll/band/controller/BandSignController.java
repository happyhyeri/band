package org.edupoll.band.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.BandRoomDao;
import org.edupoll.band.dao.ProfileDao;
import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.BandRoom;
import org.edupoll.band.model.CreatBandRoom;
import org.edupoll.band.model.Profile;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/band")
@RequiredArgsConstructor
public class BandSignController {

	private final BandRoomDao bandRoomDao;
	private final BandMemberDao bandMemberDao;
	private final ProfileDao profileDao;
	private final UserDao userDao;

	@ModelAttribute("profileImageUrl")
	public String findProfileImageUrl(@SessionAttribute User logonUser) {
		User user = userDao.findUserById(logonUser.getUserId());
		List<Profile> profiles = profileDao.findProfileById(user.getUserId());
		return profiles.get(0).getProfileImageUrl();
	}

	@GetMapping("/band-create")
	public String showFormForBandCerate(@SessionAttribute User logonUser, Model model) {
		User user = userDao.findUserById(logonUser.getUserId());
		List<Profile> profiles = profileDao.findProfileById(user.getUserId());
		model.addAttribute("profileImageUrl", profiles.get(0).getProfileImageUrl());

		return "band/band-create";
	}

	@PostMapping("/band-create")

	public String createBandRoom(@ModelAttribute CreatBandRoom createBandRoom, @SessionAttribute User logonUser,
			@RequestParam String coverImageUrl, Model model) throws IllegalStateException, IOException {

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

		// 밴드룸 insert
		BandRoom one = BandRoom.builder().bandRoomId(uuids[0].toUpperCase()) //
				.bandRoomName(createBandRoom.getBandRoomName()) //
				.coverImageUrl(imageUrl) //
				.bandRoomColor("cF85C8E") //
				.bandRoomDescription("저희 밴드에 놀러오세요 :").type(createBandRoom.getType()) //
				.build();

		bandRoomDao.saveBandroom(one);
		// System.out.println("밴드룸생성 결과--> "+x);

		// User로 profile을 찾아서 0번째
		List<Profile> profile = profileDao.findProfileById(logonUser.getUserId());
		// 밴드멤버 insert
		BandMember member = BandMember.builder().memberBandRoomId(one.getBandRoomId())
				.memberUserId(logonUser.getUserId()).memberProfileId(profile.get(0).getProfileId())
				.memberStatus("accept").build();

		bandMemberDao.saveMember(member);
		// one.setLeader(member.getMemberId());

		Map<String, Object> roomMap = new HashMap<String, Object>();
		roomMap.put("bandRoomId", one.getBandRoomId());
		roomMap.put("leader", member.getMemberId());
		bandRoomDao.update(roomMap);

		return "redirect:/band/" + one.getBandRoomId();
	}

}
