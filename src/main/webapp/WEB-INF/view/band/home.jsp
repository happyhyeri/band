<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${bandRoom.bandRoomName }</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
</head>
<body>
	<c:set var="bandRoomName" value="501" />
	<c:set var="memberCnt" value="3" />
	<c:set var="bandRoomDescription" value="안녕하세요" />
	<c:set var="bandRoomColor" value="aliceblue" />
	<div class="container-lg d-flex align-items-start">
		<div class="pb-3 me-3" style="width: 208px; height: 157px;">
			<img src="${fn:startsWith(bandRoom.coverImageUrl, '/band-upload') ? contextPath:'' }${bandRoom.coverImageUrl }" alt="커버사진"
				style="min-width: 208px; min-height: 157px; background-color: aliceblue;">
			<div class="h4 pt-2">${bandRoomName }</div>
			<div class="mt-2">
				멤버 ${memberCnt } ㆍ <i class="bi bi-plus-circle"></i> 초대
			</div>
			<div class="mt-2">
				<small>${bandRoomDescription }</small>
			</div>
			<div class="mt-2">
				<c:choose>
					<c:when test="${member.memberStatus eq 'accept' }">
						<button type="button" class="btn w-100 text-center" style="background-color: ${bandRoomColor};" data-bs-toggle="modal"
							data-bs-target="#joinBandModal">글쓰기</button>
					</c:when>
					<c:when test="${member.memberStatus eq 'request' }">
						<button type="button" class="btn w-100 text-center" style="background-color: ${bandRoomColor};" data-bs-toggle="modal"
							data-bs-target="#joinBandModal">가입대기중</button>
					</c:when>
					<c:otherwise>
						<button type="button" class="btn w-100 text-center" style="background-color: ${bandRoomColor};" data-bs-toggle="modal"
							data-bs-target="#joinBandModal">가입신청하기</button>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		<div class="flex-grow-1 flex-column" style="min-width: 500px; background-color:aliceblue;">
			<input type="text" placeholder="글 내용,#태그,@작성자 검색" class="w-100" />
			<div style="min-height: 100px;">sfasdf</div>
			<div style="min-height: 100px;">asdfasdf</div>
		</div>
		<div class="pb-3 ms-3" style="min-width: 208px;">
			<div>다가오는 일정</div>
			<div>채팅</div>
			<div>파일</div>
			<div>최근 사진</div>
		</div>
	</div>
	<!-- join Modal -->
	<div class="modal fade" id="joinBandModal" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" style="width: 360px;">
			<div class="modal-content" style="height: 500px;">
				<div class="modal-header">
					<button type="button" class="btn-close position-absolute" style="top:10px; right:10px;" data-bs-dismiss="modal" aria-label="Close"></button>
					<div class="modal-title fs-5 text-center position-relative" id="staticBackdropLabel">
						<span class="h3">${bandRoomName }</span><br/>
						<small>이 밴드에 사용할 프로필을 선택하세요.<br/>선택한 프로필의 사진과 스토리를 이 밴드 멤버들도 볼 수 있게 돼요.</small>
					</div>
				</div>
				<form action="${contextPath }/${bandRoom.bandRoomId}/request" method="post">
					<div class="modal-body" style="min-height:270px;">
						<c:forEach var="one" items="${profiles }" varStatus="status">
							<div class="d-flex align-items-center">
								<div>
									<img src="${fn:startsWith(one.profileImageUrl, '/band-upload') ? contextPath:'' }${one.profileImageUrl }" class="rounded-circle">
								</div>
								<div class="flex-grow-1">
									${one.profileNickname }
								</div>
								<input type="radio" name="profileId" value="${one.profileId }" ${status.first ? 'checked' :'' }/>
							</div>
						</c:forEach>
						<div class="d-flex align-items-center">
							<div>
								<img alt="test" src="${fn:startsWith(one.profileImageUrl, '/band-upload') ? contextPath:'' }${one.profileImageUrl }" class="rounded-circle">
							</div>
							<div class="flex-grow-1">
								허원
							</div>
							<input type="radio" name="profileId" value="1"/>
						</div>
					</div>
					<div class="modal-footer justify-content-center">
						<button type="submit" class="btn" style="background-color: ${bandRoomColor};">밴드 가입하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>