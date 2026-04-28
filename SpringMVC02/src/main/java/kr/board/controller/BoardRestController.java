package kr.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.board.entity.Board;
import kr.board.mapper.BoardMapper;

@RequestMapping("/board") //URL주소에 "/board"가 포함돼 있으면 해당 콘트롤러에서 관리한다는 의미
@RestController  //@ResponseBody(=JSON응답으로 응답)가 기본기능이므로 생략할 수 있다
public class BoardRestController {
	
	@Autowired
	BoardMapper boardMapper;
	    //게시판전체조회(Rest API 전체조회)
		@GetMapping("/all")
		public List<Board> boardList(){
			List<Board> list = boardMapper.getLists();
			return list;  //JSON 데이터 객체리턴
		}
		//게시판등록(Rest API 등록)
		@PostMapping("/new")
		public void boardInsert(Board vo){
			boardMapper.boardInsert(vo);  
		}
		//게시판삭제(Rest API 삭제)
		@DeleteMapping("/{idx}")
		public void boardDelete(@PathVariable("idx") int idx){
			boardMapper.boardDelete(idx);  
		}
		//게시판 내용수정(Rest API 수정)
		@PutMapping("/update")
	    public void boardUpdate(@RequestBody Board vo) { //핵심 수정 부분: @RequestBody 추가
	        boardMapper.boardUpdate(vo);  
	    }
		//게시판 상세조회(파라미터를 get방식으로 호출 및 json으로 변환하여 반환한다.)
		@GetMapping("/{idx}") 
		public Board boardContent(@PathVariable("idx") int idx){
			Board vo = boardMapper.boardContent(idx);  // vo -> JSON
			return vo;
		}
		//게시판 상세조회 카운트 증가(+1)및 카운트수 조회
		@PutMapping("/count/{idx}") 
		public Board boardCount(@PathVariable("idx") int idx){
			boardMapper.boardCount(idx); //조회 count +1 증가, update
			Board vo = boardMapper.boardContent(idx);  // vo -> JSON, 조회수 멤버변수(count)
			return vo;
		}

}
