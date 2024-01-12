<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${bandRoom.bandRoomName }</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
</head>
<c:set var="contextPath" value="${pageContext.servletContext.contextPath }" />
<body>
	<div style="background-color: #F0F0F0;">
		<!-- nav 들어갈 자리 -->
		<div class="mx-auto d-flex align-items-start pt-3 " style="width: 1034px;">
			<!-- 1 -->
			<div class="pb-3 me-3 sticky-top" style="width: 208px; height: 157px;">
				<img src="${contextPath }/${bandRoom.coverImageUrl}" alt="커버사진" style="min-width: 208px; min-height: 157px; background-color: white;" class="rounded-1">
				<div class="h4 pt-2">${bandRoom.bandRoomName }</div>
				<div class="mt-2">
					멤버 ${memberCnt } ㆍ <i class="bi bi-plus-circle"></i> 초대
				</div>
				<div class="mt-2">
					<small>${bandRoom.bandRoomDescription }</small>
				</div>
				<div class="mt-2">
					<c:choose>
						<c:when test="${member.memberStatus eq 'accept' }">
							<button type="button" id="write" class="btn w-100 text-center" style="background-color: ${bandRoom.bandRoomColor};" data-bs-toggle="modal" data-bs-target="#postWriteModal">글쓰기</button>
						</c:when>
						<c:when test="${member.memberStatus eq 'request' }">
							<button type="button" class="btn w-100 text-center" style="background-color: ${bandRoom.bandRoomColor};">가입대기중</button>
						</c:when>
						<c:otherwise>
							<button type="button" class="btn w-100 text-center" style="background-color: ${bandRoom.bandRoomColor};" data-bs-toggle="modal" data-bs-target="#joinBandModal">가입신청하기</button>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<!-- 2 -->
			<div class="flex-grow-1 flex-column" style="min-width: 500px;">
				<div>
					<input type="text" placeholder="글 내용,#태그,@작성자 검색" class="w-100 border-0 px-3 py-2 shadow-sm rounded-1" style="outline: none;" />
				</div>
				<div class="mt-3 p-3 text-secondary shadow-sm rounded-1" style="height: 100px; background-color: white; cursor: pointer;" onclick="document.querySelector('#write').click();">
					<p>새로운 소식을 남겨보세요.</p>
				</div>
				<c:forEach var="one" items="${posts }">
					<div class="mt-3 p-3 shadow-sm rounded-1" style="min-height: 100px; background-color: white;">
						<div class="d-flex align-items-center">
							<div>
								<img src="${fn:startsWith(one.profile.profileImageUrl, 'http') ? '' : contextPath }${one.profile.profileImageUrl }" width="48" height="48" class="rounded-circle me-3">
							</div>
							<div>
								<div class="fw-bold">${one.profile.profileNickName }</div>
								<div class="text-secondary">
									<small><fmt:formatDate value="${one.postWriteAt }" pattern="yyyy년 MM월 dd일 a hh:mm" /></small>
								</div>
							</div>
						</div>
						<div class="my-4">${one.content }</div>
						<div>
							<div class="row g-0">
								<c:forEach var="image" items="${one.images }">
									<div class="col" style="margin: 1px;">
										<div class="card rounded-1 border border-1" style="height: 200px;">
											<img src="${contextPath }/${image.imageUrl }" class="h-100 object-fit-cover overflow-hidden">
										</div>
									</div>
								</c:forEach>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
			<!-- 3 -->
			<div class="pb-3 ms-3 sticky-top" style="min-width: 208px;">
				<div>다가오는 일정</div>
				<div>채팅</div>
				<div>파일</div>
				<div>최근 사진</div>
			</div>
		</div>
	</div>

	<!-- ========================================================================================================== -->

	<!-- join Modal -->
	<div class="modal fade" id="joinBandModal" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" style="width: 360px;">
			<div class="modal-content" style="height: 500px;">
				<div class="modal-header">
					<button type="button" class="btn-close position-absolute" style="top: 10px; right: 10px;" data-bs-dismiss="modal" aria-label="Close"></button>
					<div class="modal-title text-center position-relative" id="staticBackdropLabel">
						<span class="h3">${bandRoom.bandRoomName }</span><br /> <small>이 밴드에 사용할 프로필을 선택하세요.<br />선택한 프로필의 사진과 스토리를 이 밴드 멤버들도 볼 수 있게 돼요.
						</small>
					</div>
				</div>
				<form action="${contextPath }/band/${bandRoom.bandRoomId}/request" method="post">
					<div class="modal-body" style="min-height: 270px;">
						<c:forEach var="one" items="${profiles }" varStatus="status">
							<div class="d-flex align-items-center">
								<div>
									<img src="${fn:startsWith(one.profileImageUrl, 'http') ? '' : contextPath }${one.profileImageUrl }" class="rounded-circle">
								</div>
								<div class="flex-grow-1">${one.profileNickName }</div>
								<input type="radio" name="profileId" value="${one.profileId }" ${status.first ? 'checked' :'' } />
							</div>
						</c:forEach>
					</div>
					<div class="modal-footer justify-content-center">
						<button type="submit" class="btn" style="background-color: ${bandRoom.bandRoomColor};">밴드 가입하기</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- postWrite Modal -->
	<div class="modal fade" id="postWriteModal" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" style="width: 600px;">
			<div class="modal-content" style="min-height: 500px;">
				<div class="modal-header justify-content-center">
					<button type="button" class="btn-close position-absolute" style="top: 10px; right: 10px;" data-bs-dismiss="modal" aria-label="Close"></button>
					<div class="modal-title text-center position-relative" id="staticBackdropLabel">
						<span class="fw-bold">글쓰기</span>
					</div>
				</div>
				<form action="${contextPath }/band/post/add" method="post" enctype="multipart/form-data">
					<div class="modal-body" style="min-height: 320px;">
						<textarea class="w-100 p-3 border border-1" style="resize: none; outline: none; height: 320px" placeholder="새로운 소식을 남겨보세요." name="content"></textarea>
						<div class="d-flex" style="overflow-x: auto;" id="imageView">
							<!-- script로 채워줄 부분 -->
						</div>
					</div>
					<div class="modal-footer justify-content-between align-items-center">
						<i class="bi bi-image fs-3 ps-1" style="cursor: pointer;" onclick="document.querySelector('#images').click();"></i> <input type="file" id="images" name="images" style="display: none;" multiple accept="image/**" /> <input type="hidden" name="postMemberId" value="${member.memberId }" /> <input type="hidden" name="postBandRoomId" value="${bandRoom.bandRoomId }" />
						<button type="submit" class="btn px-5 text-white" style="background-color: #000033;">게시</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		document.querySelector("#images").onchange = function(e) {
			
			// 이전에 선택되어있던 것들 삭제
			const imageView = document.querySelector("#imageView");
			while (imageView.firstChild) {
				imageView.removeChild(imageView.firstChild);
			}
			
			const files = [...document.querySelector("#images").files];
			
			files.forEach(function(file) {
				const fileReader = new FileReader();
				
				fileReader.readAsDataURL(file);
				fileReader.onload = function(e) {
					const div = document.createElement("div");
					div.className = "mx-1 rounded position-relative";
					div.style.overflow = "hidden";
					div.style.minWidth = "100px";
					
					const img = document.createElement("img");
					img.src = e.target.result;
					img.width = 100;
					img.height = 100;
					img.className = "object-fit-cover";
					div.appendChild(img);
					
					const button = document.createElement("button");
					button.type = "button";
					button.className = "btn-close position-absolute top-0 end-0";
					button.ariaLabel = "Close";
					div.appendChild(button);
					
					button.onclick = function() {
						document.querySelector("#imageView").removeChild(this.parentNode);
					}
					
					document.querySelector("#imageView").appendChild(div);
				}
			});
		}
	</script>
</body>
</html>