<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>BAND</title>
<link rel="styleshee" href="${pageContext.servletContext.contextPath }/resource/style/style.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
   <style type="text/css">
   	
   	a {
	text-decoration-line: none;
	}
	a:link{
		color: black;
	}
	a:visited {
		color: black;
	}
	a:hover {
		color: black;
		text-decoration: underline;
	}
	a:active {
		color: black;
	}
   </style>
</head>
<c:set var="contextPath" value="${pageContext.servletContext.contextPath }"/>
<body>
	
			<div class="sticky-top" style="background-color: #F0F0F0">
				<div class="mx-auto" style="width: 1034px;">
					<div class="">
						<div class="d-flex justify-content-between" style="height: 55px;">
							<div
								class="d-flex justify-content-start gap-4 align-items-center">
								<div
									style="font-size: 20px; font-weight: bold; margin-top: 6px;">
									<a class="navbar-brand" href="${contextPath }/index"> 
										<img alt="밴드로고" src="${contextPath }/resource/band.png" width="80px" height="40">
									</a>
								</div>
								<div class="input-group">
									<input type="text" class="form-control"
										placeholder="밴드, 페이지, 게시글 검색"
										aria-label="Recipient's username"
										aria-describedby="button-addon2"
										style="font-size: 12px; width: 260px; height: 30px; margin-top: 5px">
									<button class="btn btn-outline-secondary" type="button"
										id="button-addon2"
										style="font-size: 12px; height: 29px; margin-top: 5px; border: none; background-color: white">
										<i class="bi bi-search"></i>
									</button>
								</div>
							</div>
							<div class="d-flex justify-content-end gap-4 align-items-center"
								style="color: black;">
								<div style="font-size: 13px">새글 피드</div>
								<div style="font-size: 13px">찾기</div>
								<div>
									<i class="bi bi-bell-fill"></i>
								</div>
								<div>
									<i class="bi bi-chat-dots-fill"></i>
								</div>
								<div class="dropdown">
									<button
										class="btn  dropdown-toggle rounded-circle"
										type="button" data-bs-toggle="dropdown" aria-expanded="false"
										style="width: 35px; height: 50px; background-color: transparent; border: none;">
										<img
											src="${fn:startsWith(profileImageUrl, '/resource') ? contextPath:'' }${profileImageUrl}"
											class="rounded-circle" alt="프로필" width="35" height="35">
									</button>
									<ul class="dropdown-menu">
										<li><a class="dropdown-item" href="${contextPath }/my/profile" style="font-size: 13px">내 정보</a></li>
										<li><a class="dropdown-item" href="${contextPath }/my/post" style="font-size: 13px">내가 쓴 글</a></li>
										<li><a class="dropdown-item" href="${contextPath }/signout" style="font-size: 13px">로그아웃</a></li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
	<div class ="mx-auto pt-3" style="width: 1034px;">
		<div style="margin-bottom: 30px">
			<h3>내 밴드</h3>
		</div>
		<div class="d-flex justify-content-center gap-3" style="height: 190px">		
			<div class="card rounded-4 d-flex justify-content-center align-items-center" style="width: 186px; height: 210px ;">
				<div class="mb-2">
					<i style="font-size: 30px" class="bi bi-plus-circle"></i>
				</div>
				<div>
					<a href="${contextPath }/band/band-create" class="stretched-link" >
						<span style="font-weight: bold; font-size: 18px">만들기</span>
					</a>
				</div>
			</div>
			<c:forEach var="one" items="${bandList }" >
				<div class="card rounded-4" style="width: 186px; height: 210px ; overflow: hidden;">
					<div style="width: 184px; height: 139px ">
						<img class="" alt="밴드커버" src="${contextPath }${one.bandRoom.coverImageUrl}" width="100%" height="100%">
					</div>
					<div class="mt-1 ps-2">
						<a href="${contextPath }/band/${one.memberBandRoomId}" class="stretched-link">
							<span style="font-size: 14px">${one.bandRoom.bandRoomName}</span>
						</a>
					</div>
					<div class="ps-2" style="font-size: 12px">멤버  ${one.cnt }</div>
				</div>
			</c:forEach>		
		</div>
	</div>
	<div  style=" background-color: #F0F0F0; margin-top: 60px; height: 500px">
		<div class="mx-auto" style="width: 1034px;">
			<div style="font-size: 19px; padding-top: 20px; padding-bottom: 15px">
				이런 밴드는 어때요 <i class="bi bi-patch-question-fill"></i>
			</div>
			<div class="container text-center">
			  <div class="row row-cols-2">
			  	<c:forEach var="one" items="${roomList }">
				    <div class="col d-flex gap-4" style="padding: 10px">
				  	  	<div class="rounded-3" style="width: 80px; height: 80px; overflow: hidden;">
				  	  		<a href="${contextPath }/band/${one.bandRoomId}">
				  	  			<img alt="밴드커버" src="${contextPath }${one.coverImageUrl }" width="100%" height="100%">
				  	  		</a>
				  	  	</div>
				  	  	<div>
				  	  		<div style="font-weight: bold;text-align: left;">
				  	  			<a href="${contextPath }/band/${one.bandRoomId}">
				  	  				${one.bandRoomName }
				  	  			</a>
				  	  		</div>
				  	  		<div class="mt-1" style="font-size: 14px">
				  	  			${one.bandRoomDescription }
				  	  		</div>
				  	  		<div style="text-align: left">
				  	  			<button type="button" class="btn btn-light btn-sm rounded-3"  style="height: 25px"
				  	  						onclick="location.href='${contextPath }/band/${one.bandRoomId}'">
				  	  				<div style="color: #A9A9A9; font-size: 12px">밴드 더보기 ></div>
				  	  			</button>
				  	  		</div>
				  	  	</div>
				    </div>
			  	</c:forEach>
			  </div>
			</div>
		</div>
	
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>
</body>
</html>