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
  		goList();
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
  		    $.each(data, function(i, obj){
  	  		    listHtml += "<tr>";
  	  		    listHtml += "<td>"+obj.idx+"</td>";
  	  		    listHtml += "<td id='t"+obj.idx+"'><a href='javascript:goContent("+obj.idx+")'>"+obj.title+"</td>";
  	  		    listHtml += "<td>"+obj.writer+"</td>";
  	  		    listHtml += "<td>"+obj.indate+"</td>";
  	  		    listHtml += "<td id='cnt"+obj.idx+"'>"+obj.count+"</td>";
  	  		    listHtml += "</tr>";
  	  		    
  	  		    /* 내용을 가지고 있는 자식 row */
  	  		    listHtml += "<tr id='trNm"+obj.idx+"' style='display:none'>";
  	  		     listHtml += "<td>내용</td>";
  	  		     listHtml += "<td colspan='4'>";
  	  		      listHtml += "<textarea id='ta"+obj.idx+"'readonly rows='7' class='form-control'></textarea>";
  	  		      /*listHtml += `<textarea id="ta${obj.idx}" readonly rows="7" class="form-control">${obj.content}</textarea>`;*/
  	  		     listHtml += "<br/>";
  	  		     listHtml += "<span id='ub" +obj.idx+ "'><button class='btn btn-success btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정화면</button></span>&nbsp;";
  	  		     listHtml += "<button class='btn btn-warning btn-sm' onclick='goDelete("+obj.idx+")'>삭제하기</button>&nbsp;";
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
  	    // 최초 화면에서는 상세보기 안보이기
  		if($("#trNm"+idx).css("display")=="none"){  
  			console.log("레코드idx_보이기: " + idx);
  			
  	    //34장 클릭했을 경우에, 상세보기 내용을 가지고 온다.
  		$.ajax({
  		    url: "boardContent.do",     //URI: "/api/data"
  		    type: "get",             //호출방식: GET, POST, PUT, DELETE 등
  		    data: {"idx":idx},  //서버로 보낼 데이터 직접세팅
  		   // dataType: "json", >> 필요없다. 
  		    success: function(data){
  		    	$("#ta"+idx).val(data.content)
  		    }, //콜백함수로 게시판리스트 조회 호출
  		    error: function(xhr, status, error) {
  		        alert("요청실패(상세조회)~~~: "+xhr);
  		    }  			
  		});
  			
  			$("#trNm"+idx).css("display","table-row"); //해당레코드(tr) show
  			$("#ta"+idx).attr("readonly",true); //읽을때(=열릴때)는 항상 읽기전용모드
  			
  		} else {
  		//상세보기 닫을 때 조회 카운트 증가
  	  	  console.log("레코드idx_숨기기: " + idx);
  	  	  $("#trNm"+idx).css("display","none"); //해당레코드(tr) hide
    	  $.ajax({
      		    url: "boardCount.do",     //URI: "/api/data"
      		    type: "get",             //호출방식: GET, POST, PUT, DELETE 등
      		    data: {"idx":idx},  //서버로 보낼 데이터 직접세팅
      		   // 조회수 취득
      		    success: function(data){
      		    	$("#cnt"+data.idx).text(data.count);
      		    }, 
      		    error: function(xhr, status, error) {
      		        alert("요청실패(카운트수정)~~~: "+xhr);
      		    }  			
      	  }); 
  		}
  	}
  	
  	/*수정버튼 클릭*/
 	function goUpdateForm(idx){
  		console.log("수정form: " + idx);
  		//1.쓰기가능
  		$("#ta"+idx).attr("readonly",false); //textArea 읽기전용 속성 해제 
  		$("#ta"+idx).focus();                // 커서 바로 이동 (선택사항)
  		
  		//2-1.수정시 제목도 수정되도록 변경한다.
  		//2-2.수정전의 제목을 저장한다
  		var befTitle = $("#t"+idx).text();  //변경전 제목
  		var newInput ="<input type='text' id='nt"+idx+"' class='form-control' value='"+befTitle+"'/>";
  		$("#t"+idx).html(newInput);    //'수정'
  		
  		//3.버튼캡션 변경 -> '수정화면' -> '수정' 
  		var newButton ="<button class='btn btn-info btn-sm' onclick='goUpdate("+idx+")'>수정</button>";
  		$("#ub"+idx).html(newButton);
  	}
  	
  	//수정하기
  	function goUpdate(idx){
  		alert("수정하기: " + idx);       //수정한 레코드 인덱스
  		var title = $("#nt"+idx).val();  //수정한 제목
  		var content = $("#ta"+idx).val();//수정한 내용
  		
  		$.ajax({
  		    url: "boardUpdate.do",     //URI: "/api/data"
  		    type: "post",             //호출방식: GET, POST, PUT, DELETE 등
  		    data: {"idx":idx ,"title":title ,"content":content},  //서버로 보낼 데이터 직접세팅
  		   // dataType: "json", >> 필요없다. 
  		    success: loadList, //콜백함수로 게시판리스트 조회 호출
  		    error: function(xhr, status, error) {
  		        alert("요청실패(수정)~~~: "+xhr);
  		    }  			
  		}); 
  		
  	}
  	
  	/*삭제하기*/
 	function goDelete(idx){
  		alert("삭제하기: " + idx);
  		
  		$.ajax({
  		    url: "boardDelete.do",     //URI: "/api/data"
  		    type: "get",             //호출방식: GET, POST, PUT, DELETE 등
  		    data: {"idx" : idx},  //서버로 보낼 데이터 직접세팅
  		   // dataType: "json", >> 필요없다. 
  		    success: loadList, //콜백함수로 게시판리스트 조회 호출
  		    error: function(xhr, status, error) {
  		        alert("요청실패(삭제)~~~: "+xhr);
  		    }  			
  		});  		
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
  </div>
</div>

</body>
</html>