package org.edupoll.band.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.edupoll.band.dao.ImageDao;
import org.edupoll.band.dao.PostDao;
import org.edupoll.band.model.Image;
import org.edupoll.band.model.Post;
import org.edupoll.band.model.PostAdd;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

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

				File dir = new File("c:\\band\\upload\\", postAdd.getPostBandRoomId());
				dir.mkdirs();
				File target = new File(dir, uuid);
				image.transferTo(target);

				imageDao.saveImageFromPost(postImage);
			}
		}

		return "redirect:/band/" + postAdd.getPostBandRoomId();
	}
}
