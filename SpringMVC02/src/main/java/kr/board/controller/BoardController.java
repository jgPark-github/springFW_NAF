package kr.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class BoardController{
	
	@RequestMapping("/")
	public String main() {
		return "main";  //view(jsp 화면명) 리턴
	}
	
}
