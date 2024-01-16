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
	<div style="background-color: #F0F0F0; min-height: 100vh">
		<!-- nav 들어갈 자리 -->
		<div class="sticky-top" style="background-color: black; height: 40px; font-size: 14px;">
			<ul class="nav justify-content-center gap-5 nav-underline">
				<li class="nav-item"><a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="${contextPath }/band/${bandRoomId}" style="padding-bottom: 1px">게시글</a></li>
				<li class="nav-item"><a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="${contextPath }/band/${bandRoomId}/album" style="padding-bottom: 1px">사진첩</a></li>
				<li class="nav-item"><a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="#" style="padding-bottom: 1px">일정</a></li>
				<li class="nav-item"><a class="nav-link link-light link-offset-2 link-underline-opa city-25 link-underline-opacity-100-hover" href="#" style="padding-bottom: 1px">첨부</a></li>
				<li class="nav-item"><a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="${contextPath }/band/${bandRoomId}/member" style="padding-bottom: 1px">멤버</a></li>
			</ul>
		</div>

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
					<button type="button" id="write" class="btn w-100 text-center" style="background-color: ${bandRoom.bandRoomColor};" data-bs-toggle="modal" data-bs-target="#postWriteModal">글쓰기</button>
				</div>
			</div>
			<!-- 2 -->
			<div class="flex-grow-1 flex-column" style="min-width: 500px;">
				<div class="d-flex align-items-center p-3 shadow-sm rounded-1" style="background-color: white;">
					<div class="fs-5 fw-bold me-3">멤버</div>
					<div>${memberCnt }</div>
				</div>
				<div class="d-flex align-items-center mt-1 p-3 shadow-sm rounded-1" style="background-color: white;">
					<div class="fw-bold" style="cursor:pointer" onclick="location.href='${contextPath }/band/${bandRoom.bandRoomId}/applications'">가입요청 목록 &gt;</div>
				</div>
				<div class="mt-1 p-3 shadow-sm rounded-1" style="background-color: white;">
					<div class="fw-bold">멤버</div>
					<div class="mt-3">
						<c:forEach var="one" items="${members }" varStatus="status">
							<div class="d-flex align-items-center border-bottom border-1 pb-3 ${status.first ? '' : 'mt-3' }">
								<div>
									<img src="${fn:startsWith(one.profile.profileImageUrl, 'http') ? '' : contextPath }${one.profile.profileImageUrl }" class="rounded-circle" width="48" height="48">
								</div>
								<div class="ms-3 fw-bold">
									${one.profile.profileNickName }
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
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
						<i class="bi bi-image fs-3 ps-1" style="cursor: pointer;" onclick="document.querySelector('#images').click();"></i>
						<input type="file" id="images" name="images" style="display: none;" multiple accept="image/**" />
						<input type="hidden" name="postMemberId" value="${member.memberId }" />
						<input type="hidden" name="postBandRoomId" value="${bandRoom.bandRoomId }" />
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
		
		function updateModalData(evt) {
			let targetPostId = evt.target.dataset.postid;
			let newContent = evt.target.dataset.content;
			let imagesData = evt.target.dataset.imates;
			
			let textarea = document.querySelector('#updateContent');
			textarea.textContent = newContent;
			document.querySelector('#updatePostId').value = targetPostId;
			
			const updatePostImageView = document.querySelector("#updatePostImageView");
			while (updatePostImageView.firstChild) {
				updatePostImageView.removeChild(updatePostImageView.firstChild);
			}
			
			imagesData.forEach(function(elm) {
				const div = document.createElement("div");
				div.className = "mx-1 rounded position-relative";
				div.style.overflow = "hidden";
				div.style.minWidth = "100px";
				
				const img = document.createElement("img");
				img.src = elm.imageUrl;
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
					updatePostImageView.removeChild(this.parentNode);
				}
				
				updatePostImageView.appendChild(div);				
			});
		}
		
	</script>
</body>
</html>