<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<meta charset="UTF-8">
<title>sign in</title>
</head>
<body>
	<div
		class="container py-5 d-flex justify-content-center align-items-center">
		<div class="card" style="width: 20rem; height: 30rem;">
			<div class="card-body d-flex flex-column justify-content-start">
				<h5 class="card-title" style="word-break: keep-all;">band에 오신걸 환영합니다.</h5>
				<div class="mb-3 flex-grow-1">
					<form action = "${pageContext.servletContext.contextPath }/auth/login_page" method="post">
						<div class="mb-3 form-gruop">
							<label for="login" class="form-label">로그인</label> <input
								class="form-control" name="userId" id="login" type="text"
								aria-label="default input example" value=""> 
								
						<label for="pass" class="form-label">비밀번호</label> 
						<input class="form-control" name="password" id="pass" type="password" aria-label="default input example">
						</div>
						<div class="">
							<button type="submit"
								class="btn btn-outline-secondary form-control">로그인 하기</button>
						</div>
					</form>
				</div>
				<div>
					<p style="text-align: center;border-radius: 12px; background-color: #FEE500; cursor: pointer;"
						onclick="location.href='${kakaoLoginLink}'">
						<img
							src="${pageContext.servletContext.contextPath }/resource/icon/kakao_login.png"
							alt="카카오로 로그인하기" />
					</p>
					<p style="text-align: center;border-radius: 12px; background-color: #03c75a; cursor: pointer;"
						onclick="location.href='${NaverLoginLink}'">
						<img
							src="${pageContext.servletContext.contextPath }/resource/icon/naver_login.png"
							style="width: 183px; height: 45px" alt="네이버로 로그인하기" />
					</p>
				</div>
			</div>
		</div>
	</div>

	<div style="text-align: center; margin-top: 0px">
		<p>band회원이 아니신가요?</p>
		<a href="${pageContext.servletContext.contextPath }/auth/sign_up_form"><p>회원가입하러가기</p></a>
	</div>
</body>
<script>
	
	var $userId = "${userId}";
	
	if ($userId !=null) {
		document.querySelector("#login").value = $userId;
	}
	
	

</script>
</html>

