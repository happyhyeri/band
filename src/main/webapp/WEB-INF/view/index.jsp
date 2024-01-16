<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/view/component/header.jspf"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
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
	
	<div class ="mx-auto pt-3" style="width: 1034px;">
		<div style="margin-bottom: 30px">
			<h3>내 밴드</h3>
		</div>
		<div class="d-flex justify-content-center gap-3" style="height: 190px">		
			<div class="card rounded-4 d-flex justify-content-center align-items-center" style="width: 10rem">
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
				<div class="card rounded-4" style="width: 10rem">
					<div >
						<img class="" alt="밴드커버" src="${contextPath }${one.bandRoom.coverImageUrl}" width="100%">
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
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>