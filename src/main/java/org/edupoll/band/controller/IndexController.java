package org.edupoll.band.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/index")
public class IndexController {
	
	@GetMapping
	public String showIndex() {
		
		System.out.println("컨트롤러 ???");
		
		return "index";
	}
}
