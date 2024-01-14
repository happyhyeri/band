package org.edupoll.band.controller;

import javax.servlet.http.HttpSession;

import org.edupoll.band.dao.UserDao;
import org.edupoll.band.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/index")
@RequiredArgsConstructor
public class IndexController {
	
	private final UserDao userDao;
	
	@GetMapping("/{id}")
	public String showIndex(@PathVariable String id, HttpSession session) {
		
		//System.out.println("컨트롤러 ???");
		User user = userDao.findUserById(id);
		
		session.setAttribute("logonUser", user);
		
		return "index";
	}
}
