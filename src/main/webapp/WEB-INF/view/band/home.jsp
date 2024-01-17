<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/view/component/header.jspf"%>

		<div class="mx-auto d-flex align-items-start pt-3 " style="width: 1034px;">
			<!-- 1 -->
			<div class="pb-3 me-3 " style="width: 208px; height: 157px; position: sticky; top: 115px">
				<img src="${contextPath }/${bandRoom.coverImageUrl}" alt="커버사진" style="width: 208px; height: 157px; background-color: white; overflow: hidden;" class="rounded-1 object-fit-cover">
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
							<button type="button" id="write" class="py-2 border-0 w-100 text-center my-2 rounded-1 ${bandRoom.bandRoomColor }"  data-bs-toggle="modal" data-bs-target="#postWriteModal">글쓰기</button>
						</c:when>
						<c:when test="${member.memberStatus eq 'request' }">
							<button type="button" class="py-2 border-0 w-100 text-center my-2 rounded-1 ${bandRoom.bandRoomColor }" style="cursor:default;">가입대기중</button>
						</c:when>
						<c:otherwise>
							<button type="button" class="py-2 border-0 w-100 text-center my-2 rounded-1 ${bandRoom.bandRoomColor }" data-bs-toggle="modal" data-bs-target="#joinBandModal">가입신청하기</button>
						</c:otherwise>
					</c:choose>
				</div>
				<div class="text-secondary border-bottom border-1 pb-2 lh-1">
					<small>누구나 밴드를 검색해 찾을 수 있고, 밴드 소개와 게시글을 볼 수 있습니다.</small>
				</div>
				<c:if test="${bandRoom.leader eq member.memberId }">
					<div class="text-secondary mt-2" style="cursor:pointer;" onclick="location.href='${contextPath}/band/${bandRoom.bandRoomId }/setting/cover-update'">
						<i class="bi bi-gear"></i> 밴드 설정
					</div>
				</c:if>
			</div>
			<!-- 2 -->
			<div class="flex-grow-1 flex-column" style="min-width: 500px;" id="wrap">
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
											<img src="${contextPath }${image.imageUrl }" class="h-100 object-fit-cover overflow-hidden" style="cursor:pointer;" data-bs-toggle="modal" data-bs-target="#imageModal" data-url="${image.imageUrl }" onclick="imageInsert(event);">
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
			<div class="pb-3 ms-3 " style="min-width: 208px; position: sticky; top: 115px">
				<div class="p-2 shadow-sm rounded-1" style="background-color: white;">
					<div class="fw-bold border-bottom border-1 p-1"><small>다가오는 일정</small></div>
					<div class="d-flex align-items-center mt-2" onclick="location.href='${contextPath}/band/${bandRoom.bandRoomId }/calendar'" style="cursor: pointer;">
						<div class="ms-1">
							<div class="fw-bold text-center"><fmt:formatDate value="${nextSchedule.scheduleDate }" pattern="dd"/></div>
							<div class="text-center"><small><fmt:formatDate value="${nextSchedule.scheduleDate }" pattern="MM월"/></small></div>
						</div>
						<div class="flex-grow-1 fw-bold ms-3">${nextSchedule.scheduleTitle }</div>
					</div>
				</div>
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
									<img src="${fn:startsWith(one.profileImageUrl, 'http') ? '' : contextPath }${one.profileImageUrl }" class="rounded-circle" width="32" height="32">
								</div>
								<div class="flex-grow-1 ms-3">${one.profileNickName }</div>
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
						<div>
							<i class="bi bi-image fs-3 ps-1" style="cursor: pointer;" onclick="document.querySelector('#images').click();"></i>
						</div>
						<input type="file" id="images" name="images" style="display: none;" multiple accept="image/**" /> <input type="hidden" name="postMemberId" value="${member.memberId }" /> <input type="hidden" name="postBandRoomId" value="${bandRoom.bandRoomId }" />
						<button type="submit" class="btn px-5 text-white" style="background-color: #000033;">게시</button>
					</div>
				</form>
			</div>
		</div>
	</div>
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
	<!-- image Modal -->
	<div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true" 
	style="background-color: rgba(0,0,0,0.75)">
		<div class="modal-dialog modal-dialog-centered justify-content-center" id="innerModal">
			
		</div>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		function imageInsert(e) {
			const modal = document.querySelector("#innerModal");
			modal.innerHTML = '';
			
			const img = document.createElement("img");
			img.className="p-2 border"
			img.src = '${contextPath}' + e.target.dataset.url;
			modal.appendChild(img);
		}
		
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
			if(window.confirm("게시물을 삭제하시겠습니까?")) {
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
			if (message.trim() == '' || message == null) {
				window.alert("댓글을 입력해주세요");
				e.preventDefault();
			} else {
			
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
		}
		
	</script>
</body>
</html>