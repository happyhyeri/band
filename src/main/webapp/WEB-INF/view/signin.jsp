<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<div class="container py-5 d-flex justify-content-center align-items-center">
	<div class="card" style="width: 20rem; height: 24rem;">
		<div class="card-body d-flex flex-column justify-content-between">
			<h5 class="card-title"  style="word-break: keep-all;">band에 오신걸 환영합니다.</h5>

			<div class="card-text text-center">
				<p
					style="border-radius: 12px; background-color: #FEE500; cursor: pointer;"
					onclick="location.href='${kakaoLoginLink}'">
					<img src="${pageContext.servletContext.contextPath }/resource/icon/kakao_login.png"
						alt="카카오로 로그인하기" />
				</p>
				<p
					style="border-radius: 12px; background-color: #03c75a; cursor: pointer"
					onclick="location.href='${kakaoLoginLink}'">
					<img src="${contextPath }/resource/icon/naver_login.png"
						alt="네이버로 로그인하기" />
				</p>

			</div>
		</div>
	</div>
</div>
</body>
</html>

