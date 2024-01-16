package org.edupoll.band.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.edupoll.band.dao.ImageDao;
import org.edupoll.band.dao.PostDao;
import org.edupoll.band.model.Image;
import org.edupoll.band.model.Post;
import org.edupoll.band.model.PostAdd;
import org.edupoll.band.model.PostUpdate;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/band")
@RequiredArgsConstructor
public class PostController {

	private final PostDao postDao;
	private final ImageDao imageDao;

	@PostMapping("/post/add")
	public String proceedAddPost(@ModelAttribute PostAdd postAdd, @SessionAttribute User logonUser)
			throws IllegalStateException, IOException {
		Post post = Post.builder() //
				.content(postAdd.getContent()) //
				.postMemberId(postAdd.getPostMemberId()) //
				.postBandRoomId(postAdd.getPostBandRoomId()) //
				.build();
		postDao.savePost(post);

		MultipartFile[] images = postAdd.getImages();

		if (images.length > 0) {
			for (MultipartFile image : images) {
				if (image.isEmpty()) {
					continue;
				}
				String uuid = UUID.randomUUID().toString();
				Image postImage = Image.builder() //
						.imageUrl("/band/upload/" + postAdd.getPostBandRoomId() + "/" + uuid) //
						.imagePostId(post.getPostId()) //
						.imageMemberId(postAdd.getPostMemberId()) //
						.imageBandRoomId(postAdd.getPostBandRoomId()) //
						.build();

				File dir = new File("d:\\band\\upload\\", postAdd.getPostBandRoomId());
				dir.mkdirs();
				File target = new File(dir, uuid);
				image.transferTo(target);

				imageDao.saveImageFromPost(postImage);
			}
		}

		return "redirect:/band/" + postAdd.getPostBandRoomId();
	}

	@PostMapping("/post/update")
	public String proceedUpdatePost(@ModelAttribute PostUpdate postUpdate) throws IllegalStateException, IOException {

		Post post = postDao.findById(postUpdate.getPostId());
		
		Map<String, Object> criteria = new HashMap<>();
		criteria.put("content", postUpdate.getContent());
		criteria.put("postId", postUpdate.getPostId());
		postDao.updateContent(criteria);
		
		String[] imageUrls = postUpdate.getImageUrls();
		List<Image> existingImages = imageDao.findAllByPostId(postUpdate.getPostId());
		if (imageUrls != null) {
			for (Image one : existingImages) {
				for (String s : imageUrls) {
					if (one.getImageUrl().equals(s)) {
						continue;
					}
					imageDao.deleteById(one.getImageId());
				}
			}
		}
		
		MultipartFile[] images = postUpdate.getImages();
		if (images.length > 0) {
			for (MultipartFile image : images) {
				if (image.isEmpty()) {
					continue;
				}
				String uuid = UUID.randomUUID().toString();
				Image postImage = Image.builder() //
						.imageUrl("/band/upload/" + post.getPostBandRoomId() + "/" + uuid) //
						.imagePostId(post.getPostId()) //
						.imageMemberId(post.getPostMemberId()) //
						.imageBandRoomId(post.getPostBandRoomId()) //
						.build();

				File dir = new File("d:\\band\\upload\\", post.getPostBandRoomId());
				dir.mkdirs();
				File target = new File(dir, uuid);
				image.transferTo(target);

				imageDao.saveImageFromPost(postImage);
			}
		}

		return "redirect:/band/" + post.getPostBandRoomId();
	}
	
	@DeleteMapping("/post/delete")
	@ResponseBody
	public String proceedDeletePost(@RequestParam int postId) {
		imageDao.deleteById(postId);
		postDao.deleteById(postId);
		
		Map<String, Object> response = new HashMap<>();
		response.put("result", "success");
		Gson gson = new Gson();
		
		return gson.toJson(response);
	}
}
