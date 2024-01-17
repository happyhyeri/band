package org.edupoll.band.controller;

import java.util.List;

import org.edupoll.band.dao.BandRoomDao;
import org.edupoll.band.dao.PostDao;
import org.edupoll.band.model.BandRoom;
import org.edupoll.band.model.Post;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.google.gson.Gson;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/my")
@RequiredArgsConstructor
public class MyController {

	private final PostDao postDao;
	private final BandRoomDao bandRoomDao;

	@GetMapping("/post")
	public String showMyPost(@SessionAttribute User logonUser, Model model) {
		List<Post> posts = postDao.findMyPost(logonUser.getUserId());
		Gson gson = new Gson();
		posts.stream().forEach(elm -> elm.setJson(gson.toJson(elm)));
		model.addAttribute("posts", posts);
		
		List<BandRoom> bandrooms = bandRoomDao.findJoinedBandRoom(logonUser.getUserId());
		model.addAttribute("bandrooms", bandrooms);
		
		return "my/post";
	}
}
