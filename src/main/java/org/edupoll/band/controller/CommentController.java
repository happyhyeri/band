package org.edupoll.band.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.edupoll.band.dao.CommentDao;
import org.edupoll.band.model.Comment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/band")
@RequiredArgsConstructor
public class CommentController {

	private final CommentDao commentDao;

	@GetMapping(value = "/comment/get", produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String showComment(@RequestParam int postId) {
		List<Comment> comments = commentDao.findByPostId(postId);

		Map<String, Object> response = new HashMap<>();
		response.put("result", "success");
		response.put("comments", comments);
		Gson gson = new Gson();

		return gson.toJson(response);
	}
	
	@PostMapping(value = "/comment/add", produces = "application/text; charset=UTF-8")
	@ResponseBody
	public String proceedCommentAdd(@ModelAttribute Comment comment) {
		commentDao.saveComment(comment);
		
		Map<String, Object> response = new HashMap<>();
		response.put("result", "success");
		Gson gson = new Gson();

		return gson.toJson(response);
	}
}
