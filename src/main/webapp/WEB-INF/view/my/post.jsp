<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>band</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/resource/style/style.css">
</head>
<c:set var="contextPath" value="${pageContext.servletContext.contextPath }" />
<body>
	<div class="position-relative" style="min-height:100vh; background-color: #F0F0F0;">
		<!-- nav 들어갈 자리 -->

		<div class="mx-auto d-flex align-items-start pt-3 " style="width: 1034px;">
			<!-- 1 -->
			<div class="pb-3 me-3 " style="width: 208px; height: 157px; position: sticky; top: 50px">
				<ul class="list-group" style="width: 208px;">
					<li class="list-group-item fw-bold fs-5">가입된 밴드</li>
					<c:forEach var="one" items="${bandrooms }">
						<li class="list-group-item" onclick="location.href='${contextPath}/band/${one.bandRoomId}'" style="cursor:pointer;">${one.bandRoomName }</li>
					</c:forEach>
				</ul>
			</div>
			<!-- 2 -->
			<div class="flex-grow-1 flex-column" style="min-width: 500px;" id="wrap">
				<div class="p-3 shadow-sm rounded-1 fw-bold" style="background-color: white;">내가 쓴 글</div>
				<c:forEach var="one" items="${posts }">
					<div class="mt-3 p-3 shadow-sm rounded-1" style="min-height: 100px; background-color: white;">
						<div class="fw-bold m-2 mb-4 py-2 border-bottom border-1" onclick="location.href='${contextPath}/band/${one.bandRoom.bandRoomId}'" style="cursor:pointer;">
							${one.bandRoom.bandRoomName }
						</div>
						<div class="d-flex align-items-center">
							<div>
								<img src="${fn:startsWith(one.profile.profileImageUrl, 'http') ? '' : contextPath }${one.profile.profileImageUrl }" width="48" height="48" class="rounded-circle me-3">
							</div>
							<div class="flex-grow-1">
								<div class="fw-bold">${one.profile.profileNickName }</div>
								<div class="text-secondary">
									<small><fmt:formatDate value="${one.postWriteAt }" pattern="yyyy년 MM월 dd일 a hh:mm" /></small>
								</div>
							</div>
							<c:if test="${sessionScope.logonUser.userId eq one.member.memberUserId }">
								<div>
									<button onclick="updateModalData(event);" class="btn border border-1 py-1 px-2" data-bs-toggle="modal" data-bs-target="#postUpdateModal" data-json='${one.json }'>수정</button>
								</div>
								<div class="ms-1">
									<button class="btn border border-1 py-1 px-2" data-post-id="${one.postId }" onclick="deletePost(event);">삭제</button>
								</div>
							</c:if>
						</div>
						<div class="my-4" style="white-space: pre-wrap;">${one.content }</div>
						<div>
							<div class="row g-0">
								<c:forEach var="image" items="${one.images }" varStatus="vs">
									<div class="${vs.last and vs.count %2 ne 0? 'col-12' : 'col-6' }" style="padding: 1px;">
										<div class="card rounded-1 border border-1" style="height: 200px;">
											<img src="${contextPath }${image.imageUrl }" class="h-100 object-fit-cover overflow-hidden">
										</div>
									</div>
								</c:forEach>
							</div>
						</div>
						<div class="d-flex justify-content-between mx-2 mt-3 align-items-center">
							<div>
								<span>댓글</span>
								<button class="ms-1" style="background-color: transparent; border: none;" data-post-id="${one.postId }" onclick="toggleComment(event);">
									<i class="bi bi-caret-down-square"></i>
								</button>
							</div>
							<div class="d-flex align-items-center">
								<i class="bi bi-eye"></i><span class="text-secondary ms-1">${one.viewCnt }</span>
							</div>
						</div>
						<div class="pt-1 mt-1 rounded-1 border-top" style="display: none; background-color: white;">
							<div class="commentContainer">
								<!-- script 로 댓글 넣기 -->
							</div>
							<div class="d-flex align-items-center px-2 py-1">
								<div>
									<img src="${fn:startsWith(member.profile.profileImageUrl, 'http') ? '' : contextPath }${member.profile.profileImageUrl}" class="rounded-circle" width="30" height="30">
								</div>
								<div class="flex-grow-1 ms-2">
									<input type="text" class="w-100 border border-1 px-3 py-1 rounded-5" style="outline: none;" placeholder="댓글을 남겨주세요" data-post-id="${one.postId }" data-member-id="${member.memberId }" name="message" />
								</div>
								<div class="ms-2">
									<button type="button" class="btn border border-1 rounded-5 py-1" onclick="addComment(event);">저장</button>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
			<!-- 3 -->
			<div class="pb-3 ms-3 " style="min-width: 208px; position: sticky; top: 50px">
				오른쪽
			</div>
		</div>
	</div>
	
	<!-- ================================================================================================================================= -->
	
	<!-- postUpdate Modal -->
	<div class="modal fade" id="postUpdateModal" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" style="width: 600px;">
			<div class="modal-content" style="min-height: 500px;">
				<div class="modal-header justify-content-center">
					<button type="button" class="btn-close position-absolute" style="top: 10px; right: 10px;" data-bs-dismiss="modal" aria-label="Close"></button>
					<div class="modal-title text-center position-relative" id="staticBackdropLabel">
						<span class="fw-bold">글수정하기</span>
					</div>
				</div>
				<form action="${contextPath }/band/post/update" method="post" enctype="multipart/form-data">
					<div class="modal-body" style="min-height: 320px;">
						<textarea class="w-100 p-3 border border-1" style="resize: none; outline: none; height: 320px" name="content" id="updateContent"></textarea>
						<input type="hidden" name="postId" id="updatePostId" />
						<div class="d-flex" style="overflow-x: auto;" id="updatePostImageView">
							<!-- script로 채워줄 부분 -->
						</div>
					</div>
					<div class="modal-footer justify-content-between align-items-center">
						<div>
							<i class="bi bi-image fs-3 ps-1" style="cursor: pointer;" onclick="document.querySelector('#updateImages').click();"></i>
						</div>
						<input type="file" id="updateImages" name="images" style="display: none;" multiple accept="image/**" /> <input type="hidden" name="postMemberId" value="${member.memberId }" /> <input type="hidden" name="postBandRoomId" value="${bandRoom.bandRoomId }" />
						<button type="submit" class="btn px-5 text-white" style="background-color: #000033;">게시</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- ========================================================================================================== -->
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
		
		document.querySelector("#updateImages").onchange = function(e) {
			
			const imageView = document.querySelector("#updatePostImageView");
			
			const files = [...document.querySelector("#updateImages").files];
			
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
						document.querySelector("#updatePostImageView").removeChild(this.parentNode);
					}
					
					document.querySelector("#updatePostImageView").appendChild(div);
				}
			});
		}
		
		function updateModalData(evt) {
			let json = evt.target.dataset.json;
			let obj = JSON.parse(json);
			
			let textarea = document.querySelector('#updateContent');
			textarea.textContent = obj.content;
			document.querySelector('#updatePostId').value = obj.postId;
			
			const updatePostImageView = document.querySelector("#updatePostImageView");
			while (updatePostImageView.firstChild) {
				updatePostImageView.removeChild(updatePostImageView.firstChild);
			}
			
			obj.images.forEach(function(elm) {
				const div = document.createElement("div");
				div.className = "mx-1 rounded position-relative";
				div.style.overflow = "hidden";
				div.style.minWidth = "100px";
				
				const input = document.createElement("input");
				input.type="hidden";
				input.name="imageUrls";
				input.value=elm.imageUrl;
				div.appendChild(input);
				
				const img = document.createElement("img");
				img.src = "/band" + elm.imageUrl;
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
		
		function deletePost(e) {
			const xhr = new XMLHttpRequest();
			xhr.open("delete", "${contextPath}/band/post/delete?postId=" + e.target.dataset.postId, true);
			xhr.setRequestHeader("content-type", "application/x-www-form-urlencoded");
			xhr.send();
			xhr.onreadystatechange = function() {
				if(xhr.readyState == 4) {
					var response = JSON.parse(xhr.responseText);
					if (response.result == 'success') {
						document.querySelector("#wrap").removeChild(e.target.parentElement.parentElement.parentElement);
					}
				}
			}
		}
		
		function toggleComment(e) {
			const xhr = new XMLHttpRequest();
			xhr.open("get", "${contextPath}/band/comment/get?postId=" + e.currentTarget.dataset.postId, true);
			xhr.send();
			
		//	console.log(e.currentTarget);
		//	console.log(e.currentTarget.parentNode);
		//	console.log(e.currentTarget.parentNode.parentNode);
		//	console.log(e.currentTarget.parentNode.parentNode.parentNode);
		//	console.log(e.currentTarget.parentNode.parentNode.parentNode.querySelector(".commentContainer"));
			const container = e.currentTarget.parentNode.parentNode.parentNode.querySelector(".commentContainer");
			xhr.onreadystatechange = function() {
				if(xhr.readyState == 4) {
					var response = JSON.parse(xhr.responseText);
					if (response.result == 'success' && response.comments.length > 0) {
						const comments = response.comments;
						container.innerHTML = '';
						comments.forEach((comment) => {
							
							let div = document.createElement("div");
							div.className = "d-flex align-items-start px-1 py-2 border-bottom border-1 mx-3";
							
							let img = document.createElement("img");
							let imageUrl = comment.member.profile.profileImageUrl;
							if (!imageUrl.startsWith('http')) {
								imageUrl = "${contextPath}" + imageUrl;
							}
							img.src = imageUrl;
							img.className = "rounded-circle me-2";
							img.width = "36";
							img.height = "36";
							div.appendChild(img);
							
							let innerDiv = document.createElement("div");
								let innerDiv1 = document.createElement("div");
								innerDiv1.className = "fw-bold";
								innerDiv1.textContent = comment.member.profile.profileNickName;
								innerDiv.appendChild(innerDiv1);
								
								let innerDiv2 = document.createElement("div");
								innerDiv2.textContent = comment.message;
								innerDiv.appendChild(innerDiv2);
								
								let innerDiv3 = document.createElement("div");
									let small = document.createElement("small");
									small.className = "text-secondary";
									small.textContent = comment.commentWriteAt;
									innerDiv3.appendChild(small);
								innerDiv.appendChild(innerDiv3);
							div.appendChild(innerDiv);
							
							container.appendChild(div);
						});
					}
				}
			}
			console.log();
			const target =container.parentNode;
			if (target.style.display == "block") {
				target.style.display = "none";
			} else {
				target.style.display = "block";
			}
			
		}
		
		function addComment(e) {
			const input = e.target.parentElement.previousElementSibling.firstElementChild;
			let postId = input.dataset.postId;
			let memberId = input.dataset.memberId;
			let message = input.value;
			
			const xhr = new XMLHttpRequest();
			xhr.open("post", "${contextPath}/band/comment/add", true);
			xhr.setRequestHeader("content-type", "application/x-www-form-urlencoded");
			xhr.send("commentPostId=" + postId + "&commentMemberId=" + memberId + "&message=" + message);
			xhr.onreadystatechange = function() {
				if (xhr.readyState == 4) {
					var response = JSON.parse(xhr.responseText);
					if (response.result == 'success') {
						e.target.parentElement.parentElement.parentElement.style.display = 'none';
						input.value='';
						
					}
				}
			}
		}
		
	</script>
</body>
</html>