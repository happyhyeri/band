<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BAND</title>
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/resource/style/style.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
</head>
<c:set var="contextPath" value="${pageContext.servletContext.contextPath }"></c:set>
<body>
	<div style="background-color: #F0F0F0">
		<div class="d-flex justify-content-between align-items-center pt-3 ps-3 pe-5">
			<div>
				<a href="${contextPath }/indexhome"> 
					<img alt="밴드로고" src="${contextPath }/resource/band.png" width="80px" height="44">
				</a>
			</div>
			<div class="d-flex">
				<div style="padding-top:8px;text-align: center; border: none; background-color: #F0F0F0; margin-right: 13px; font-size: 14px; width: 90px;height: 37px">
					<a href="${contextPath }/auth/sign_up_form" style="text-decoration-line: none ">
						회원가입
					</a>
				</div>
				<div style="padding-top:8px;text-align: center; background-color: #00c73c; border: none; font-size: 14px; width: 90px;  height: 37px">
					<a href="${contextPath }/auth/login_page" style="text-decoration-line: none;font-weight: bold; color: white; ">
						로그인
					</a>
				</div>
			</div>
		</div>
		<div class="container-lg" style="margin-top: 20px">
			<div class="d-flex justify-content-center" style="gap:140px; margin-top: 20px" >
				<div style="width: 500px; height: 600px">
					<img alt="밴드메인사진" src="${contextPath }/resource/bandmain.png" style="background-color: #F0F0F0" width="100%" height="100%">
				</div>
				<div style="width: 350px;margin-top: 100px">
					<div>
						<div style="font-size: 45px;">모임이 쉬워진다!</div>
						<div style="font-size: 45px;">우리끼리 밴드</div>
						<div class="mt-2 mb-2" style="font-size: 15px">당신의 모임도 BAND로 시작하세요.</div>
						<a href="${contextPath }/auth/login_page" style="text-decoration-line: none;color: white;" class="">
							<div style="margin-bottom: 12px;width: 100%; background-color: #00c73c; text-align: center;  height: 45px; padding-top: 8px">
								로그인
							</div>
						</a>
						<a href="${contextPath }/auth/sign_up_form" style="text-decoration-line: none" class="">
							<div style="width: 100%; background-color: white; text-align: center; height: 45px; padding-top: 8px">
								회원가입
							</div>
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>