package org.edupoll.band.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.edupoll.band.dao.AlbumDao;
import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.BandRoomDao;
import org.edupoll.band.dao.ImageDao;
import org.edupoll.band.dao.PostDao;
import org.edupoll.band.dao.ProfileDao;
import org.edupoll.band.dao.ScheduleDao;
import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.Album;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.BandRoom;
import org.edupoll.band.model.CreatBandRoom;
import org.edupoll.band.model.Image;
import org.edupoll.band.model.Post;
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
import org.springframework.web.bind.annotation.SessionAttribute;

import com.google.gson.Gson;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class BandController {

	private final BandRoomDao bandRoomDao;
	private final BandMemberDao bandMemberDao;
	private final ProfileDao profileDao;
	private final PostDao postDao;
	private final AlbumDao albumDao;
	private final ImageDao imageDao;
	private final ScheduleDao scheduleDao;
	private final UserDao userDao;
  
	@ModelAttribute("nextSchedule")
	public Schedule findNextSchedule() {
		return scheduleDao.findNextSchedule();
	}
	
	@ModelAttribute("profileImageUrl")
	public String findProfileImageUrl(@SessionAttribute User logonUser) {
		User user = userDao.findUserById(logonUser.getUserId());
		List<Profile> profiles = profileDao.findProfileById(user.getUserId());
		return profiles.get(0).getProfileImageUrl();
	}

	@GetMapping("/band/{bandRoomId}")
	public String showBandRoom(@SessionAttribute User logonUser, @PathVariable String bandRoomId,
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

			List<Post> posts = postDao.findByRoomIdWithImage(bandRoomId);
			Gson gson = new Gson();
			posts.stream().forEach(elm -> elm.setJson(gson.toJson(elm)));
			model.addAttribute("posts", posts);

		return "band/home";
  }
  
	// 전체사진 디테일 창
		@GetMapping("/band/{bandRoomId}/album/total")
		public String showAlbumTotalDetail(@PathVariable String bandRoomId,
											@SessionAttribute User logonUser ,Model model) {
			
			BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
			model.addAttribute("bandRoom", bandRoom);
			
			// 앨범 전체가지고오기
			List<Album> albumList = albumDao.findByBandRoomId(bandRoomId);
			model.addAttribute("albumList", albumList);
			
			List<Image> imageList = imageDao.findAllByBandRoomId(bandRoomId);
			model.addAttribute("imageList", imageList);
			
			int cntTotalImage = imageDao.countImageTotal(bandRoomId);
			model.addAttribute("cntTotalImage", cntTotalImage);
			model.addAttribute("bandRoomId", bandRoomId);	
			
			Map<String, Object> criteria = new HashMap<>();
			criteria.put("memberBandRoomId", bandRoomId);
			criteria.put("memberUserId", logonUser.getUserId());
			BandMember member = bandMemberDao.findByRoomIdAndUserId(criteria);
			model.addAttribute("member", member);
			
			return "band/totalImage";
		}
		
		// 밴드 수정폼
		@GetMapping("/band/{bandRoomId}/setting/cover-update")
		public String showBandRoomSettingForm(@PathVariable String bandRoomId,
											  @SessionAttribute User logonUser,Model model) {
			
			BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
			model.addAttribute("bandRoom", bandRoom);
			
			return "setting/cover-update";
		}
		// 밴드 수정페이지
		@PostMapping("/band/{bandRoomId}/setting/cover-update")

		public String updateBandRoom(@PathVariable String bandRoomId ,
									@ModelAttribute CreatBandRoom createBandRoom ,@SessionAttribute User logonUser
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
						
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("bandRoomId", bandRoomId);
			map.put("bandRoomName", createBandRoom.getBandRoomName());
			map.put("coverImageUrl", imageUrl);
			map.put("bandRoomColor", createBandRoom.getBandRoomColor());
			bandRoomDao.update(map);
			
			return "redirect:/band/"+bandRoomId;
		}

}
