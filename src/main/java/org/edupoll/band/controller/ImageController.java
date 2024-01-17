package org.edupoll.band.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletResponse;

import org.edupoll.band.dao.BandMemberDao;
import org.edupoll.band.dao.BandRoomDao;
import org.edupoll.band.dao.ImageDao;
import org.edupoll.band.model.BandMember;
import org.edupoll.band.model.Image;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StreamUtils;
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

		File dir = new File("d:\\band\\upload\\", bandRoomId);
		dir.mkdirs();
		// System.out.println("length-->" + wholeImages.length);
		for (MultipartFile image : wholeImages) {
			if (image.isEmpty()) {
				continue;
			}
			String fileName = UUID.randomUUID().toString();
			File target = new File(dir, fileName);
			image.transferTo(target);
			Image one = Image.builder().imageUrl("/band/upload/" + bandRoomId + "/" + fileName)
					.imageMemberId(two.getMemberId()).imageBandRoomId(bandRoomId).build();

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

	// 전체사진 중 삭제
	@PostMapping("/band/{bandRoomId}/wholeImage/delete")
	public void deleteWholeImage(@PathVariable String bandRoomId, HttpServletResponse response,
			@SessionAttribute User logonUser, @RequestParam List<Integer> checkInput, @RequestParam int[] memberId)
			throws IOException {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("memberBandRoomId", bandRoomId);
		map.put("memberUserId", logonUser.getUserId());
		BandMember member = bandMemberDao.findByRoomIdAndUserId(map);

		// 밴드 리더 찾기
		Integer leader = bandRoomDao.findLeader(bandRoomId);

		for (int y = 0; y < checkInput.size(); y++) {

			if (memberId[y] == member.getMemberId() || member.getMemberId() == leader) {
				for (int i = 0; i < checkInput.size(); i++) {
					int x = imageDao.deleteWholeImage(checkInput.get(i));
					System.out.println("사진삭제 결과--> " + x);
				}
				out.println("<script>alert('" + "삭제 성공 했습니다." + "');location.href='/band/band/" + bandRoomId
						+ "/album/total';</script>");
				out.flush();
			} else {
				System.out.println("에러창을 띄워줘야 하는데...?");
				out.println("<script>alert('" + "삭제 권한이 없습니다." + "');history.back();</script>");
				out.flush();
			}
		}
		// return "redirect:/band/"+bandRoomId+"/album/total";
	}

	// 전체사진 중 저장
	@PostMapping("/band/{bandRoomId}/wholeImage/save")
	public void controlWholeImage(@PathVariable String bandRoomId, HttpServletResponse response,
			@SessionAttribute User logonUser, @RequestParam List<Integer> checkInput, @RequestParam int[] memberId)
			throws IOException {

		// 이미지를 찾아서 이미지파일 이름 알아내기

		// 파일 하나만 선택시
		if (checkInput.size() == 1) {
			System.out.println("파일을 하나만 선택했지롱!!!!");
			try {
				List<String> fileName = new ArrayList<>();
				for (Integer one : checkInput) {

					Image image = imageDao.findImageByImageId(one);
					String[] list = image.getImageUrl().split("/");
					// System.out.println(list[4]);
					fileName.add(list[4]);
					String filePath = "c:\\band\\upload\\" + bandRoomId + "\\";
					for (int x = 0; x < fileName.size(); x++) {
						File dFile = new File(filePath, fileName.get(x));
						int fSize = (int) dFile.length();
						System.out.println(fSize);
						if (fSize > 0) {
							// for (int y = 0; y < fileName.size(); y++) {
							String encodedFilename = "attachment; filename*=" + "UTF-8" + "''"
									+ URLEncoder.encode(fileName.get(x), "UTF-8");
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
							// }
						} else {
							throw new FileNotFoundException("파일이 없습니다");
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			// 파일 하나이상 선택시
		} else {

			// System.out.println("너가 파일을 두개 이상 골랐구나!?!?!?");
			// for(Integer a : checkInput) {
			// System.out.println("체크인풋-->"+ a);
			// }

			FileOutputStream fos = null;
			ZipOutputStream zipOut = null;
			FileInputStream fis = null;

			response.setContentType("application/zip");
			response.addHeader("Content-Disposition", "attachment; filename=\"allToOne.zip\"");

			try {
				zipOut = new ZipOutputStream(response.getOutputStream());

				List<String> filePath = new ArrayList<>();
				List<String> fileName = new ArrayList<>();
				for (Integer one : checkInput) {

					Image image = imageDao.findImageByImageId(one);

					String[] list = image.getImageUrl().split("/");

					if (image.getImageAlbumId() == null) {
						filePath.add("c:\\band\\upload\\" + bandRoomId + "\\");
						fileName.add(list[4]);
					} else {
						filePath.add("c:\\band\\upload\\" + bandRoomId + "\\" + list[4]);
						// System.out.println("filePaht ::: " + filePath);
						fileName.add(list[5]);
					}

				}
				File[] listFiles = new File[fileName.size()];
				for (int x = 0; x < fileName.size(); x++) {
					File dFile = new File(filePath.get(x), fileName.get(x));
					listFiles[x] = dFile;
				}

				for (File file : listFiles) {
					zipOut.putNextEntry(new ZipEntry(file.getName()));
					fis = new FileInputStream(file);

					StreamUtils.copy(fis, zipOut);

					fis.close();
					zipOut.closeEntry();
				}
				zipOut.close();
			} catch (Exception e) {
				System.out.println(e.getMessage());
				try {
					if (fis != null)
						fis.close();
				} catch (IOException e1) {
					System.out.println(e1.getMessage());
					/* ignore */}
				try {
					if (zipOut != null)
						zipOut.closeEntry();
				} catch (IOException e2) {
					System.out.println(e2.getMessage());
					/* ignore */}
				try {
					if (zipOut != null)
						zipOut.close();
				} catch (IOException e3) {
					System.out.println(e3.getMessage());
					/* ignore */}
				try {
					if (fos != null)
						fos.close();
				} catch (IOException e4) {
					System.out.println(e4.getMessage());
					/* ignore */}
			}

		}

	}

	// 앨범사진 중 삭제
	@PostMapping("/band/{bandRoomId}/albumImage/delete")
	public void deleteAlbumImage(@PathVariable String bandRoomId, HttpServletResponse response,
			@SessionAttribute User logonUser, @RequestParam(required = false) List<Integer> checkInput,
			@RequestParam int albumIdForUpdate, @RequestParam int[] memberId) throws IOException {

		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=utf-8");
		PrintWriter out = response.getWriter();

		if (checkInput == null || checkInput.isEmpty()) {
			out.println("<script>alert('" + "사진을 선택해주세요." + "');location.href='/band/band/" + bandRoomId + "/album/"
					+ albumIdForUpdate + "';</script>");
			out.flush();
		} else {

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("memberBandRoomId", bandRoomId);
			map.put("memberUserId", logonUser.getUserId());
			BandMember member = bandMemberDao.findByRoomIdAndUserId(map);

			// 밴드 리더 찾기
			Integer leader = bandRoomDao.findLeader(bandRoomId);

			for (int y = 0; y < checkInput.size(); y++) {

				if (memberId[y] == member.getMemberId() || member.getMemberId() == leader) {
					for (int i = 0; i < checkInput.size(); i++) {
						// ------------여기 DAO 수정하기----------------//
						int x = imageDao.deleteWholeImage(checkInput.get(i));
						System.out.println("사진삭제 결과--> " + x);
					}
					out.println("<script>alert('" + "삭제 성공 했습니다." + "');location.href='/band/band/" + bandRoomId
							+ "/album/" + albumIdForUpdate + "';</script>");
					out.flush();
				} else {
					System.out.println("에러창을 띄워줘야 하는데...?");
					out.println("<script>alert('" + "삭제 권한이 없습니다." + "');history.back();</script>");
					out.flush();
				}
			}
		}

	}

}
