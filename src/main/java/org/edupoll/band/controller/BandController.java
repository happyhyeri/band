package org.edupoll.band.controller;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.edupoll.band.dao.AlbumDao;
import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.BandRoomDao;
import org.edupoll.band.dao.ImageDao;
import org.edupoll.band.model.Album;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.BandRoom;
import org.edupoll.band.model.Image;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class BandController {

	private final BandRoomDao bandRoomDao;
	private final BandMemberDao bandMemberDao;
	private final AlbumDao albumDao;
	private final ImageDao imageDao;

	@GetMapping("/band/{bandRoomId}")
	public String showBandRoom(@SessionAttribute(required = false) User logonUser, @PathVariable String bandRoomId,
			Model model) {

		if (logonUser != null) {
			Map<String, Object> criteria = new HashMap<>();
			criteria.put("memberBandRoomId", bandRoomId);
			criteria.put("memberUserId", logonUser.getUserId());
			BandMember member = bandMemberDao.findByRoomIdAndUserId(criteria);
			model.addAttribute("member", member);
			
			// 여기서 logonUser의 모든 프로필 정보를 담은 List<Profile> profiles 보내주기
		}

		return "band/home";
	}
	// 사진첩 메인
	@GetMapping("/band/{bandRoomId}/album")
	public String showAlbum(@PathVariable String bandRoomId, Model model) {
		Date now = new Date(System.currentTimeMillis());
		SimpleDateFormat simpleformat = new SimpleDateFormat("yyyy년 MM월");
		String nowdate = simpleformat.format(now);
		
		// 앨범 전체가지고오기
		List<Album> albumList = albumDao.findByBandRoomId(bandRoomId);
		// 전체 사진가지고오기
		List<Image> imageList = imageDao.findAllByBandRoomId(bandRoomId);
		
		BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
		
		
		model.addAttribute("albumList", albumList);
		model.addAttribute("imageList", imageList);
		model.addAttribute("bandroom", bandRoom);		
		model.addAttribute("now", nowdate);		
		return "band/album";
	}
	
	// 앨범 생성
	@PostMapping("/band/{bandRoomId}/album")
	public String createAlbum(@PathVariable String bandRoomId, 
							  @RequestParam String albumname,@RequestParam String confirm
							  ,Model model) {
		System.out.println("albumname---> "+albumname);
		System.out.println("bandRoomId---> "+bandRoomId);
		System.out.println("confirm---> "+confirm);
		
		if(confirm.equals("true")) {
			//게시글로 등록 후 앨범상세페이지로 이동
		}
		Album one = Album.builder().albumBandRoomId(bandRoomId).albumTitle(albumname).build();
		albumDao.saveAlbum(one);
		
		BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
		model.addAttribute("bandroom", bandRoom);		
		//해당 앨범으로 보내준다아아....
		//one.albumId로 앨범상세페이지 보내주기
		return "redirect:/band/"+bandRoomId+"/album/"+one.getAlbumId();
	}
	
	// 앨범 디테일 창
	@GetMapping("/band/{bandRoomId}/album/{albumId}")
	public String showAlbumDetail(@PathVariable int albumId,
									@PathVariable String bandRoomId , Model model) {
		
		Album foundAlbum = albumDao.findByAlbumId(albumId);
		model.addAttribute("foundAlbum", foundAlbum);
		model.addAttribute("bandRoomId", bandRoomId);	
		return "band/albumDetail";
	}
	
	
	
}
