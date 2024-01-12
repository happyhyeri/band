package org.edupoll.band.controller;

import java.io.File;

import org.edupoll.band.dao.ImageDao;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping
@RequiredArgsConstructor
public class ImageController {
	
	private final ImageDao imageDao;
	
	
	// 전체사진에 사진올리기
	@PostMapping("/band/{bandRoomId}/whole")
	public String wholeImageSave(@ModelAttribute MultipartFile[] wholeImages, Model model) {
		//System.out.println("wholeImages 몇개야!?!?!?-->" + wholeImages.length);
		
		File dir = new File("c:\\band\\upload\\");
		
		//사진첩 메인
		return null;
	}
	
	// 앨범에 사진올리기
	@PostMapping
	public String albumImageSave() {
		
		//앨범디테일 메인
		return null;
	}
	
}
