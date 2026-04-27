package kr.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.board.entity.Board;
import kr.board.mapper.BoardMapper;

@Controller
public class BoardController{
	@Autowired
	BoardMapper boardMapper;
	
	@RequestMapping("/")
	public String main() {
		return "main";  //view(jsp 화면명) 리턴
	}
	
	// @ResponseBody-> jackson-databind 라이브러리 호출(객체를-> JSON 데이터포맷으로 변환해줌) 
	@RequestMapping("/boardList.do")
	public @ResponseBody List<Board> boardList(){
		List<Board> list = boardMapper.getLists();
		return list;  //JSON 데이터 객체리턴
	}
	//게시판등록
	@RequestMapping("/boardInsert.do")
	public @ResponseBody void boardInsert(Board vo){
		boardMapper.boardInsert(vo);  
	}
	//게시판삭제(파라미터를 get방식으로 호출)
	@RequestMapping("/boardDelete.do")
	public @ResponseBody void boardDelete(@RequestParam("idx") int idx){
		boardMapper.boardDelete(idx);  
	}
	//게시판수정(파라미터를 post방식으로 호출)
	@RequestMapping("/boardUpdate.do")
	public @ResponseBody void boardUpdate(Board vo){
		boardMapper.boardUpdate(vo);  
	}
	//게시판 상세조회(파라미터를 get방식으로 호출 및 json으로 변환하여 반환한다.)
	@RequestMapping("/boardContent.do") 
	public @ResponseBody Board boardContent(@RequestParam("idx") int idx){
		Board vo = boardMapper.boardContent(idx);  // vo -> JSON
		return vo;
	}
	//게시판 상세조회(파라미터를 get방식으로 호출 및 json으로 변환하여 반환한다.)
	@RequestMapping("/boardCount.do") 
	public @ResponseBody Board boardCount(@RequestParam("idx") int idx){
		boardMapper.boardCount(idx); //조회 count +1 증가, update
		Board vo = boardMapper.boardContent(idx);  // vo -> JSON, 조회수 멤버변수(count)
		return vo;
	}
}
