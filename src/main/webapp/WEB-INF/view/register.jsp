<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
  <style>
	  input::-webkit-inner-spin-button {
	  appearance: none;
	  -moz-appearance: none;
	  -webkit-appearance: none;
	}
	  .no_dot {
	  list-style-type: none;
	}
  </style>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.1/font/bootstrap-icons.css">
  </head>
<body>
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
	<c:set var="rootPath"
			value="${pageContext.servletContext.contextPath }" />
		<form action="${pageContext.servletContext.contextPath }/register" method="post">
		<div class="container text-center">
			<h1 class="text-center">회 원 가 입</h1>
				<div class="card mx-auto"  style="width: 40rem; height: 50rem ;">
				  <div class="card-body" >
					<h4>기본 정보 입력</h4>
						
						<div class="input-group mb-3">
				 			 <span class="input-group-text" id="inputGroup-sizing-default-id" ><i class="bi bi-person"></i></span>
				  				<input type="text" name="userId" id="id" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default-id" placeholder="아이디" required>
						 		<span id="id_result"></span>
						</div>
				
						<div class="input-group mb-3">
				 			 <span class="input-group-text" id="inputGroup-sizing-default"><i class="bi bi-lock"></i></span>
				  				<input type="password" name="userPassword" id="pass" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default" placeholder="비밀번호" required>
						</div>
						
					
						<div class="input-group mb-3">
							<span class="input-group-text" id="inputGroup-sizing-default"><i class="bi bi-check-circle"></i></span>
				  			<input  id="passCheck" type="password" name="passwordCheck" class="form-control" aria-label="Recipient's username" aria-describedby="button-addon2" placeholder="비밀번호 확인"required>
				  			<button class="btn btn-outline-secondary" type="button" onclick="test()" >확인</button>
						</div>
					
					<h4>추가 정보 입력</h4>
					
						<div class="input-group mb-3">
				 			 <span class="input-group-text" id="inputGroup-sizing-default"><i class="bi bi-person-video"></i></span>
				  				<input type="text" name="profileNickName" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default" placeholder="닉네임" id="nickname" required>
						 		<span id="nickname_result"></span>
						</div>
					
						
						<div class="input-group mb-3">
				 			 <span class="input-group-text" id="inputGroup-sizing-default"><i class="bi bi-telephone"></i></span>
				  				<input type="number" name="phoneNumber" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default" placeholder="휴대폰번호"  id="phoneNumber" maxlength="11" oninput="numbermaxLength(this);"required>
						 		<span id="phoneNumber_result"></span>
						</div>
								
						<div class="input-group mb-3">
				 			 <span class="input-group-text" id="inputGroup-sizing-default"><i class="bi bi-calendar-event"></i></span>
				  				<input type="number" name="birthParam" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default" placeholder="생년월일 8자리"  id="birth" maxlength="8" required oninput="numbermaxLength(this);">
						 		<span id="birth_result"></span>
						</div>
				
						<div class="input-group mb-3"> <label class="input-group-text" for="inputGroupSelect01"><i class="bi bi-gender-ambiguous"></i></label>
								  <select class="form-select" id="gender" name="gender">
								    <option selected>성별</option>
								    <option value="f">여성</option>
								    <option value="m">남성</option>
								  </select>
						</div>
												
						
						<div class="position-relative ">
							<button type="submit" class="btn btn-outline-secondary position-absolute top-100 start-50 translate-middle">회원가입</button>
						</div>
			 	 </div>
		 	 </div>
			</div>
				</form>

	<script>	
	
	 function test() {
	      var $pass = document.getElementById('pass').value;
	      var $passCheck = document.getElementById('passCheck').value;
	      if( $pass != $passCheck ) {
	        alert("비밀번호가 일치 하지 않습니다");
	        return false;
	      } else{
	        alert("비밀번호가 일치합니다");
	        return true;
	      }

	    }
		

		const $id=document.querySelector("#id")
		const $idReulst = document.querySelector("#id_result")
		
		document.querySelector("#id").addEventListener("blur", function(evt){
			const value =evt.target.value;
			
			if(value==""||value==null){
				$idReulst.innerHTML = "아이디를 입력해주세요";
				$idReulst.className ="blank";
			}
			
			
			
			const xhr =new XMLHttpRequest();
		
			xhr.open("get", "${pageContext.servletContext.contextPath }/register/idcheck?userId=" + value, true);
		
			xhr.onreadystatechange = function() {
				
				if(this.readyState==4) {
					const response = this.responseText;
					const $idReulst = document.querySelector("#id_result")
					
					if(response == "YYYY") {
						$idReulst.innerHTML = "사용가능한 아이디입니다.";
						$idReulst.className ="success";
					}else if(response == "NNNN"){
						$idReulst.innerHTML = "이미 사용중인 아이디입니다.";
						$idReulst.className ="fail";
					}
				}	
			};
				
			xhr.send();
		});
		</script> 
		
		<script>
		const $phoneNumber=document.querySelector("#phoneNumber")
		const $phoneNumber_result = document.querySelector("#phoneNumber_result")
		
		document.querySelector("#phoneNumber").addEventListener("blur", function(evt){
			const value =evt.target.value;
			
			const xhr =new XMLHttpRequest();
		
			xhr.open("get", "${pageContext.servletContext.contextPath }/register/phoneNumberCheck?phoneNumber=" + value, true);
		
			xhr.onreadystatechange = function() {
				
				if(this.readyState==4) {
					const response = this.responseText;
					const $phoneNumber_result = document.querySelector("#phoneNumber_result")
					
					if(response == "NO") {
						$phoneNumber_result.innerHTML = "올바른 형식의 휴대폰 번호가 아닙니다.";
						$phoneNumber_result.className ="fail";
					}else{
						$phoneNumber_result.innerHTML = "";
						$phoneNumber_result.className ="pass";
					}
						
					}
			};
				
			xhr.send();
		});
		
	
		</script>
			
		
		<script>
		
	
		document.querySelector("#birth").addEventListener("blur", function(evt){
		const value =evt.target.value;
		
		const xhr =new XMLHttpRequest();
	
		xhr.open("get", "${pageContext.servletContext.contextPath }/register/birthCheck?birthParam=" + value, true);
	
		xhr.onreadystatechange = function() {
			
			if(this.readyState==4) {
				const response = this.responseText;
				const $phoneNumber_result = document.querySelector("#birth_result")
				
				if(response == "NO") {
					$phoneNumber_result.innerHTML = "올바른 형식의 생년월일이 아닙니다.";
					$phoneNumber_result.className ="fail";
				}else{
					$phoneNumber_result.innerHTML = "";
					$phoneNumber_result.className ="pass";
				}
					
				}
		};
			
		xhr.send();
	});
	x
		
		</script>
		
		<script>
		function numbermaxLength(num) { 
			 if(num.value.length > num.maxLength) {  
				 num.value = num.value.slice(0, num.maxLength);  }}
		
		</script>
		
		
</body>
</html>