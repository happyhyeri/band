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
					<button type="button" id="write" class="py-2 border-0 w-100 text-center my-2 rounded-1 ${bandRoom.bandRoomColor }"  data-bs-toggle="modal" data-bs-target="#postWriteModal">글쓰기</button>
				</div>
				<div class="text-secondary border-bottom border-1 pb-2 lh-1">
					<small>누구나 밴드를 검색해 찾을 수 있고, 밴드 소개와 게시글을 볼 수 있습니다.</small>
				</div>
				<c:if test="${bandRoom.leader eq member.memberId }">
					<div class="text-secondary mt-2" style="cursor:pointer;">
						<i class="bi bi-gear"></i> 밴드 설정
					</div>
				</c:if>
			</div>
			<!-- 2 -->
			<div class="flex-grow-1 flex-column" style="min-width: 500px;">
				<div class="d-flex align-items-center p-3 shadow-sm rounded-1" style="background-color: white;">
					<div class="fs-5 fw-bold me-3">가입 신청자</div>
					<div>${empty requests ? '' : requests.size() }</div>
				</div>
				<div class="mt-1 p-3 shadow-sm rounded-1" style="background-color: #F5F5F5;">
					<div class="text-center text-secondary">
						<small>가입신청을 확인해주세요. 한 달이 지난 가입신청은 자동 거절 됩니다.</small>
					</div>
				</div>
				<div class="mt-1 p-3 shadow-sm rounded-1" style="background-color: white;">
					<div>
						<c:if test="${empty requests }">
							<div class="h3 text-center" style="min-height: 600px; padding-top: 300px;">가입신청자가 없습니다.</div>
						</c:if>
						<c:forEach var="one" items="${requests }">
							<div class="d-flex align-items-center border-bottom border-1 py-3">
								<div>
									<img src="${fn:startsWith(one.profile.profileImageUrl, 'http') ? '' : contextPath }${one.profile.profileImageUrl }" class="rounded-circle" width="48" height="48">
								</div>
								<div class="flex-grow-1 ms-3 fw-bold">${one.profile.profileNickName }</div>
								<div>
									<button type="button" class="btn border border-1 py-1 px-2" data-value="${one.memberId }" data-type="accept" onclick="processRequest(event)">수락</button>
								</div>
								<div class="ms-1">
									<button type="button" class="btn border border-1 py-1 px-2" data-value="${one.memberId }" data-type="reject" onclick="processRequest(event)">거절</button>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
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
	
		function processRequest(event) {
			const xhr = new XMLHttpRequest();
			xhr.open("post",
					"${contextPath}/band/${bandRoom.bandRoomId}/applications",
					true);
			xhr.setRequestHeader("content-type",
					"application/x-www-form-urlencoded");

			let target = event.target;
			xhr.send("type=" + target.dataset.type + "&memberId="
					+ target.dataset.value);
			xhr.onreadystatechange = function() {
				if (xhr.readyState == 4) {
					var response = JSON.parse(xhr.responseText);
					if (response.result == 'success') {
						target.parentNode.parentNode.parentNode.removeChild(target.parentNode.parentNode);
					}
				}
			}
		}
	</script>
</body>
</html>