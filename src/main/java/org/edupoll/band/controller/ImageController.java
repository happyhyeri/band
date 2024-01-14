package org.edupoll.band.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.ImageDao;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.Image;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class ImageController {
	
	private final ImageDao imageDao;
	private final BandMemberDao bandMemberDao;
	
	
	// 전체사진에 사진올리기
	@PostMapping("/band/{bandRoomId}/wholeImage")
	public String wholeImageSave(@ModelAttribute MultipartFile[] wholeImages, @SessionAttribute User logonUser,
								 @PathVariable String bandRoomId ,Model model) throws IllegalStateException, IOException {
		//System.out.println("wholeImages 몇개야!?!?!?-->" + wholeImages.length);	
		Map<String, Object> map = new HashMap<>();
		map.put("memberBandRoomId", bandRoomId);
		map.put("memberUserId", logonUser.getUserId());
		BandMember two = bandMemberDao.findByRoomIdAndUserId(map);
		
		File dir = new File("c:\\band\\upload\\", bandRoomId);
		dir.mkdirs();
		
		for(MultipartFile image : wholeImages) {
			if(image.isEmpty()) {
				continue;
			}
			String fileName = UUID.randomUUID().toString();
			File target = new File(dir, fileName);
			image.transferTo(target);
			Image one =  Image.builder()
						.imageUrl("/band/upload/" + bandRoomId + "/" + fileName)
						.imageMemberId(two.getMemberId())
						.imageBandRoomId(bandRoomId).build();
			
			imageDao.saveImageForWhole(one);
			
		}
		//사진첩 메인
		return "redirect:/band/"+bandRoomId+"/album";
	}
	
	// 앨범에 사진올리기
	@PostMapping("/band/{bandRoomId}/albumImage")
	public String albumImageSave(@ModelAttribute MultipartFile[] albumImages, @SessionAttribute User logonUser,
								 @PathVariable String bandRoomId ,
								 @RequestParam Integer albumId ,Model model) throws IllegalStateException, IOException {
		//System.out.println("wholeImages 몇개야!?!?!?-->" + wholeImages.length);	
		Map<String, Object> map = new HashMap<>();
		map.put("memberBandRoomId", bandRoomId);
		map.put("memberUserId", logonUser.getUserId());
		BandMember two = bandMemberDao.findByRoomIdAndUserId(map);
		
		File dir = new File("c:\\band\\upload\\"+ bandRoomId +"\\" + albumId +"\\");
		dir.mkdirs();
		
		for(MultipartFile image : albumImages) {
			if(image.isEmpty()) {
				continue;
			}
			String fileName = UUID.randomUUID().toString();
			File target = new File(dir, fileName);
			image.transferTo(target);
			Image one =  Image.builder()
						.imageUrl("/band/upload/" + bandRoomId + "/" + albumId + "/" + fileName)
						.imageAlbumId(albumId)
						.imageMemberId(two.getMemberId())
						.imageBandRoomId(bandRoomId).build();
			
			imageDao.saveImageForAlbum(one);
			
		}
		
		//앨범디테일 메인으로
		return "redirect:/band/"+bandRoomId+"/album/"+albumId;
	}
	
}
