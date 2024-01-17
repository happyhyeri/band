package org.edupoll.band.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
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
import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.Album;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.BandRoom;
import org.edupoll.band.model.CreatBandRoom;
import org.edupoll.band.model.Image;
import org.edupoll.band.model.Post;
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
	private final UserDao userDao;

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

	// 사진첩 메인
	@GetMapping("/band/{bandRoomId}/album")
	public String showAlbum(@PathVariable String bandRoomId,
							@SessionAttribute User logonUser ,Model model) {
		
		Date now = new Date(System.currentTimeMillis());
		SimpleDateFormat simpleformat = new SimpleDateFormat("yyyy년 MM월");
		String nowdate = simpleformat.format(now);

		// 앨범 전체가지고오기
		List<Album> albumList = albumDao.findByBandRoomId(bandRoomId);
		
		// 이미지 전채개수
		int cntTotalImage = imageDao.countImageTotal(bandRoomId);
		model.addAttribute("cntTotalImage", cntTotalImage);
		
		// 전체 사진가지고오기(4개만)
		List<Image> imageList = imageDao.findImageByBandRoomIdToSix(bandRoomId);
		
		// 해당앨범 사진가지고오기(4개만)
		
		List<Image> albumImageList = imageDao.findAllByBandRoomId(bandRoomId);

		BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
		model.addAttribute("bandRoom", bandRoom);
		
		User user = userDao.findUserById(logonUser.getUserId());
		List<Profile> profiles = profileDao.findProfileById(user.getUserId());
		model.addAttribute("profileImageUrl", profiles.get(0).getProfileImageUrl());

		model.addAttribute("albumList", albumList);
		model.addAttribute("imageList", imageList);
		model.addAttribute("albumImageList", albumImageList);
		model.addAttribute("now", nowdate);
		model.addAttribute("logonUser", logonUser);
		
		return "band/album";
	}

	// 앨범 생성
	@PostMapping("/band/{bandRoomId}/album")
	public String createAlbum(@PathVariable String bandRoomId,@SessionAttribute User logonUser ,
							  @RequestParam String albumname,@RequestParam String confirm
							  ,Model model) {

		Map<String, Object> memberMap = new HashMap<>();
		memberMap.put("memberBandRoomId", bandRoomId);
		memberMap.put("memberUserId", logonUser.getUserId());
		
		BandMember member = bandMemberDao.findByRoomIdAndUserId(memberMap);
		
		if(confirm.equals("true")) {
			//게시글로 등록 후 앨범상세페이지로 이동
			Post post = Post.builder()
						.content("["+albumname+"] 앨범을 만들었습니다.")
						.postMemberId(member.getMemberId())
						.postBandRoomId(bandRoomId)
						.build();
			postDao.savePost(post);
		}
		Album one = Album.builder().albumBandRoomId(bandRoomId).albumTitle(albumname).build();
		albumDao.saveAlbum(one);

		// 해당 앨범으로 보내준다아아....
		// one.albumId로 앨범상세페이지 보내주기
		return "redirect:/band/" + bandRoomId + "/album/" + one.getAlbumId();
	}

	// 앨범 디테일 창
	@GetMapping("/band/{bandRoomId}/album/{albumId}")
	public String showAlbumDetail(@PathVariable int albumId,@SessionAttribute User logonUser ,
									@PathVariable String bandRoomId, Model model) {
		
		List<Image> albumAllImages = imageDao.findAllByAlbumId(albumId);
		model.addAttribute("albumAllImages", albumAllImages);
		
		// 앨범 전체가지고오기
		List<Album> albumList = albumDao.findByBandRoomId(bandRoomId);
		model.addAttribute("albumList", albumList);
		
		int cntAlbumTotal = imageDao.countImageAlbumTotal(albumId);
		model.addAttribute("cntAlbumTotal", cntAlbumTotal);
		
		BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
		model.addAttribute("bandRoom", bandRoom);
		
		Album foundAlbum = albumDao.findByAlbumId(albumId);
		model.addAttribute("foundAlbum", foundAlbum);
		model.addAttribute("bandRoomId", bandRoomId);
		
		User user = userDao.findUserById(logonUser.getUserId());
		List<Profile> profiles = profileDao.findProfileById(user.getUserId());
		model.addAttribute("profileImageUrl", profiles.get(0).getProfileImageUrl());
		model.addAttribute("albumId", albumId);
		
		return "band/albumDetail";
	}
  
	// 앨범 전체사진 디테일 창
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
			
			User user = userDao.findUserById(logonUser.getUserId());
			List<Profile> profiles = profileDao.findProfileById(user.getUserId());
			model.addAttribute("profileImageUrl", profiles.get(0).getProfileImageUrl());
			
			return "band/totalImage";
		}
		
		// 밴드 수정폼
		@GetMapping("/band/{bandRoomId}/setting/cover-update")
		public String showBandRoomSettingForm(@PathVariable String bandRoomId,
											  @SessionAttribute User logonUser,Model model) {
			
			
			User user = userDao.findUserById(logonUser.getUserId());
			List<Profile> profiles = profileDao.findProfileById(user.getUserId());
			model.addAttribute("profileImageUrl", profiles.get(0).getProfileImageUrl());
			
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
