package org.edupoll.band.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

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
import org.edupoll.band.model.Image;
import org.edupoll.band.model.Post;
import org.edupoll.band.model.Profile;
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
public class AlbumController {
	
	private final BandRoomDao bandRoomDao;
	private final BandMemberDao bandMemberDao;
	private final ProfileDao profileDao;
	private final PostDao postDao;
	private final AlbumDao albumDao;
	private final ImageDao imageDao;
	private final UserDao userDao;
	
	
	// 사진첩 메인
	@GetMapping("/band/{bandRoomId}/album")
	public String showAlbum(@PathVariable String bandRoomId,
							@SessionAttribute User logonUser ,Model model) {
		// 생성일자? 최근사진 업로드시기?
		Date now = new Date(System.currentTimeMillis());
		SimpleDateFormat simpleformat = new SimpleDateFormat("yyyy년 MM월");
		String nowdate = simpleformat.format(now);

		// 앨범 전체가지고오기
		List<Album> albumList = albumDao.findByBandRoomId(bandRoomId);
	
		// 이미지 전채개수
		int cntTotalImage = imageDao.countImageTotal(bandRoomId);
		model.addAttribute("cntTotalImage", cntTotalImage);
		
		// 전체 사진가지고오기(6개만)
		List<Image> imageList = imageDao.findImageByBandRoomIdToSix(bandRoomId);
		
		// 해당앨범 사진가지고오기
		
		List<Image> albumImageList = imageDao.findAllByBandRoomId(bandRoomId);

		BandRoom bandRoom = bandRoomDao.findByBandRoomId(bandRoomId);
		model.addAttribute("bandRoom", bandRoom);
		
		User user = userDao.findUserById(logonUser.getUserId());
		List<Profile> profiles = profileDao.findProfileById(user.getUserId());
		model.addAttribute("profileImageUrl", profiles.get(0).getProfileImageUrl());
		
		Map<String, Object> criteria = new HashMap<>();
		criteria.put("memberBandRoomId", bandRoomId);
		criteria.put("memberUserId", logonUser.getUserId());
		BandMember member = bandMemberDao.findByRoomIdAndUserId(criteria);
		model.addAttribute("member", member);

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
		
		Map<String, Object> criteria = new HashMap<>();
		criteria.put("memberBandRoomId", bandRoomId);
		criteria.put("memberUserId", logonUser.getUserId());
		BandMember member = bandMemberDao.findByRoomIdAndUserId(criteria);
		model.addAttribute("member", member);
		
		return "band/albumDetail";
	}

	// 앨범 삭제
	@GetMapping("/band/{bandRoomId}/album/delete")
	public void deleteAlbum(@RequestParam int albumId, @PathVariable String bandRoomId
								,HttpServletResponse response,@SessionAttribute User logonUser) throws IOException {
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberBandRoomId", bandRoomId);
		map.put("memberUserId", logonUser.getUserId());
		BandMember member = bandMemberDao.findByRoomIdAndUserId(map);
		
		Integer leader = bandRoomDao.findLeader(bandRoomId);
		
		List<Image> imageList = imageDao.findAllByAlbumId(albumId);
		
		if(member.getMemberId() == leader) {
			if(imageList.size() != 0) {
				for(int i =0; i<imageList.size(); i++) {
					imageDao.deleteById(imageList.get(i).getImageId());
				}
			}
			albumDao.deleteByAlbumId(albumId);
			out.println("<script>alert('"+"삭제 성공 했습니다."+"');location.href='/band/band/"+bandRoomId+"/album/';</script>");
			out.flush();
		}else {
			System.out.println("에러창을 띄워줘야 하는데...?");
			out.println("<script>alert('"+"삭제 권한이 없습니다."+"');history.back();</script>");
			out.flush();
		}
	
	}
	
	// 앨범이름 수정
	@PostMapping("/band/{bandRoomId}/album/update")
	public String updateAlbumTitle(@PathVariable String bandRoomId, @RequestParam int albumId,
									@RequestParam String albumnameUpdate) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("albumTitle", albumnameUpdate);
		map.put("albumId", albumId);
		
		albumDao.update(map);
		
		return "redirect:/band/"+bandRoomId+"/album/"+albumId;
	}
}
