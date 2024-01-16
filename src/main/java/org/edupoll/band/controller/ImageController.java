package org.edupoll.band.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;

import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.BandRoomDao;
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
	private final BandRoomDao bandRoomDao;

	// 전체사진에 사진올리기
	@PostMapping("/band/{bandRoomId}/wholeImage")
	public String wholeImageSave(@ModelAttribute MultipartFile[] wholeImages, @SessionAttribute User logonUser,
			@PathVariable String bandRoomId, Model model) throws IllegalStateException, IOException {
		// System.out.println("wholeImages 몇개야!?!?!?-->" + wholeImages.length);
		Map<String, Object> map = new HashMap<>();
		map.put("memberBandRoomId", bandRoomId);
		map.put("memberUserId", logonUser.getUserId());
		BandMember two = bandMemberDao.findByRoomIdAndUserId(map);

		File dir = new File("c:\\band\\upload\\", bandRoomId);
		dir.mkdirs();
		System.out.println("length-->" + wholeImages.length);
		for (MultipartFile image : wholeImages) {
			if (image.isEmpty()) {
				continue;
			}
			String fileName = UUID.randomUUID().toString();
			File target = new File(dir, fileName);
			image.transferTo(target);
			Image one = Image.builder().imageUrl("/band/upload/" + bandRoomId + "/" + fileName)
						.imageMemberId(two.getMemberId())
						.imageBandRoomId(bandRoomId)
						.build();

			imageDao.saveImageForWhole(one);

		}
		// 사진첩 메인
		return "redirect:/band/" + bandRoomId + "/album";
	}

	// 앨범에 사진올리기
	@PostMapping("/band/{bandRoomId}/albumImage")
	public String albumImageSave(@ModelAttribute MultipartFile[] albumImages, @SessionAttribute User logonUser,
			@PathVariable String bandRoomId, @RequestParam Integer albumId, Model model)
			throws IllegalStateException, IOException {
		// System.out.println("wholeImages 몇개야!?!?!?-->" + wholeImages.length);
		Map<String, Object> map = new HashMap<>();
		map.put("memberBandRoomId", bandRoomId);
		map.put("memberUserId", logonUser.getUserId());
		BandMember two = bandMemberDao.findByRoomIdAndUserId(map);

		File dir = new File("c:\\band\\upload\\" + bandRoomId + "\\" + albumId + "\\");
		dir.mkdirs();

		for (MultipartFile image : albumImages) {
			if (image.isEmpty()) {
				continue;
			}
			String fileName = UUID.randomUUID().toString();
			File target = new File(dir, fileName);
			image.transferTo(target);
			Image one = Image.builder().imageUrl("/band/upload/" + bandRoomId + "/" + albumId + "/" + fileName)
					.imageAlbumId(albumId).imageMemberId(two.getMemberId()).imageBandRoomId(bandRoomId).build();

			imageDao.saveImageForAlbum(one);
		}

		// 앨범디테일 메인으로
		return "redirect:/band/" + bandRoomId + "/album/" + albumId;
	}

	// 전체사진 저장/삭제
	@PostMapping("/band/{bandRoomId}/wholeImage/control")
	public String controlWholeImage(@PathVariable String bandRoomId, @RequestParam String type,
									HttpServletResponse response, @SessionAttribute User logonUser ,
									@RequestParam List<Integer> checkInput, @RequestParam int[] memberId) {
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberBandRoomId", bandRoomId);
		map.put("memberUserId", logonUser.getUserId());
		BandMember member = bandMemberDao.findByRoomIdAndUserId(map);
		
		//밴드 리더 찾기
		Integer leader = bandRoomDao.findLeader(bandRoomId);
		
		// 삭제
		if (type.equals("delete")) {
			for(int y = 0; y < checkInput.size(); y++) {
				
				if(memberId[y] == member.getMemberId() || member.getMemberId() == leader) {
					for (int i = 0; i < checkInput.size(); i++) {
						int x = imageDao.deleteWholeImage(checkInput.get(i));
						System.out.println("사진삭제 결과--> " + x);
					}
				}else {
					System.out.println("에러창을 띄워줘야 하는데...?");
				}
			}
		// 저장
		} else {
			List<String> fileName = new ArrayList<>();
			try {
				// 이미지를 찾아서 이미지파일 이름 알아내기
				for (Integer one : checkInput) {
					Image image = imageDao.findImageByImageId(one);
					String[] list = image.getImageUrl().split("/");
					// System.out.println(list[4]);
					fileName.add(list[4]);

					String filePath = "c:\\band\\upload\\" + bandRoomId + "\\";
					for (int x = 1; x < fileName.size(); x++) {
						File dFile = new File(filePath, fileName.get(x));
						int fSize = (int) dFile.length();

						if (fSize > 0) {
							for (int y = 1; y < fileName.size(); y++) {
								String encodedFilename = "attachment; filename*=" + "UTF-8" + "''"
										+ URLEncoder.encode(fileName.get(y), "UTF-8");
								response.setContentType("application/octet-stream; charset=utf-8");
								response.setHeader("Content-Disposition", encodedFilename);
								response.setContentLengthLong(fSize);

								BufferedInputStream in = null;
								BufferedOutputStream out = null;
								in = new BufferedInputStream(new FileInputStream(dFile));
								out = new BufferedOutputStream(response.getOutputStream());

								try {
									byte[] buffer = new byte[4096];
									int bytesRead = 0;

									while ((bytesRead = in.read(buffer)) != -1) {
										out.write(buffer, 0, bytesRead);
									}

									// 버퍼에 남은 내용이 있다면, 모두 파일에 출력
									out.flush();

								} finally {
									in.close();
									out.close();
								}
							}
						} else {
							throw new FileNotFoundException("파일이 없습니다");
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return "redirect:/band/" + bandRoomId + "/album/total";
	}

}
