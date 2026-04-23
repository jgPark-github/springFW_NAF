<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>     
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Spring MVC02</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <script type="text/javascript">
  	$(document).ready(function(){
  		loadList();
  	});
  	function loadList(){
  		//서버와 통신 : 게시판 리스트 가져오기
  		$.ajax({
  		    url: "boardList.do",     //URI: "/api/data"
  		    type: "get",             //호출방식: GET, POST, PUT, DELETE 등
  		    data: { key: "value" },  //서버로 보낼 데이터
  		    dataType: "json",        //받는 타입: json, xml, html, text 등
  		    //success: function(response) {
  		    //    alert("response_data: "+ response.length+"\nTitle: "+response[0].title);
  		    //},
  		    success: makeView, //콜백함수
  		    error: function(xhr, status, error) {
  		        alert("요청실패~~~: "+xhr);
  		    }
  		});
  	}
  	
  	//리스트 
  	function makeView(data){
  		var listHtml = "<table class='table table-bordered'>";
  		/*테이블의 header*/
  		    listHtml += "<tr>";
  		    listHtml += "<td>번호</td>";
  		    listHtml += "<td>제목</td>";
  		    listHtml += "<td>작성자</td>";
  		    listHtml += "<td>작성일</td>";
  		    listHtml += "<td>조회수</td>";
  		    listHtml += "</tr>";
  		    
  		    //테이블의 body(데이터)
  		    $.each(data, function(idx, obj){
  	  		    listHtml += "<tr>";
  	  		    listHtml += "<td>"+obj.idx+"</td>";
  	  		    listHtml += "<td><a href='javascript:goContent("+obj.idx+")'>"+obj.title+"</td>";
  	  		    listHtml += "<td>"+obj.writer+"</td>";
  	  		    listHtml += "<td>"+obj.indate+"</td>";
  	  		    listHtml += "<td>"+obj.count+"</td>";
  	  		    listHtml += "</tr>";
  	  		    
  	  		    /* 내용을 가지고 있는 자식 row */
  	  		    listHtml += "<tr id='trNm"+obj.idx+"' style='display:none'>";
  	  		     listHtml += "<td>내용</td>";
  	  		     listHtml += "<td colspan='4'>";
  	  		      listHtml += "<textarea rows='7' class='form-control'>"+obj.content+"</textarea>";
  	  		     listHtml += "</td>";
  	  		    listHtml += "</tr>";
  		    });
	  		listHtml+="<tr>";
	  		listHtml += "<td colspan='5'>";
	  		  listHtml += "<button class='btn btn-primary btn-sm' onclick='goForm()'>게시판쓰기</button>";
	  		listHtml += "</td>";
	  		listHtml +="</tr>";
  		  
  		  listHtml+="</table>";

  		  $("#view").html(listHtml);
  	}
  	
  	goList();
  	
  	/* 게시판목록 숨김, 게시판글쓰기 block 처리 */
  	function goForm(){
  		$("#view").css("display","none");   //게시판목록 숨기기
  		$("#wform").css("display","block"); //게시판쓰기 보이기
  	}
  	
  	/* 게시판목록 block, 게시판글쓰기 숨김 처리 */  	
  	function goList(){
  		$("#view").css("display","block"); //게시판목록 보이기
  		$("#wform").css("display","none"); //게시판쓰기 숨기기
  	}
  	
  	/* 게시판 글쓰기함수 */  	
  	function goInsert(){	  
  		/*form 안에 있는 모든 요소를 직렬화시켜서(=serialize) 한번에 가져오기*/
  		var fData = $("#frm").serialize();
  		
  		$.ajax({
  		    url: "boardInsert.do",     //URI: "/api/data"
  		    type: "post",             //호출방식: GET, POST, PUT, DELETE 등
  		    data: fData,  //서버로 보낼 데이터
  		   // dataType: "json", >> 필요없다. 
  		    success: loadList, //콜백함수로 게시판리스트 조회 호출
  		    error: function(xhr, status, error) {
  		        alert("요청실패~~~: "+xhr);
  		    }  			
  		});
  		
  		// 등록후 form의 입력요소들 개별 초기화
		 /* $("#title").val("");   //게시판 제목
		    $("#content").val(""); //게시판 내용
		    $("#writer").val("");  //게시판 작성자
		 */
		 // 등록후 form의 입력요소들 한번에 초기화 
		  $("#btnClear").trigger("click");
  	}
  	/*컬럼 클릭시 내용보이기*/
  	function goContent(idx){
  		console.log("레코드idx: " + idx);
  		$("#trNm"+idx).css("display","table-row"); //해당레코드(tr) show
  	}
  	
  	
  </script>
</head>
<body>
 
<div class="container">
  <h2>Spring MVC02</h2>
  <div class="panel panel-default">
    <div class="panel-heading">BOARD</div>
    <!--  게시판 목록 조회 -->
    <div class="panel-body" id="view">Panel Content</div>
    <!--  게시판쓰기, 최초 form load시에는 게시판쓰기는 숨긴다 -->
    <div class="panel-body" id="wform" style="display:none">
    
    	<!-- 하나의 화면에서 처리를 위해 action은 없앤다!!
    	     <form action="boardInsert.do" method="post"> -->
    	     
    	<form id="frm">
	      <table class="table">
	         <tr>
	           <td>제목</td>
	           <td><input type="text" class="form-control" id="title" name="title" /></td>
	         </tr>
	         <tr>
	           <td>내용</td>
	           <td><textarea rows="7" class="form-control" id="content" name="content"></textarea> </td>
	         </tr>
	         <tr>
	           <td>작성자</td>
	           <td><input type="text" class="form-control" id="writer" name="writer" /></td>
	         </tr>
	         <tr>
	           <td colspan="2" align="center">
	               <button type="submit" class="btn btn-success btn-sm" onclick="goInsert()">등록</button>
	               <button type="reset"  class="btn btn-warning btn-sm" id="btnClear">취소</button>
	               <button type="button" class="btn btn-warning btn-sm" onclick="goList()">리스트</button>
	           </td>
	         </tr>
	      </table>
        </form>
    </div>    
    <div class="panel-footer">인프런_스프1탄_Jun</div>
   	<div id="parent">
  		<button id="child">클릭</button>
	</div>
  </div>
</div>

</body>
</html>