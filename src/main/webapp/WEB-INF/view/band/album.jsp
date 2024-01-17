<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/view/component/header.jspf"%>

	<div class="mx-auto d-flex align-items-start pt-3" style="width: 1034px;">
		<!-- 1 -->		
			<div class="pb-3 me-3 " style="width: 208px; height: 157px; position: sticky; top: 115px;">

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
					<div class="text-secondary mt-2" style="cursor:pointer;" onclick="location.href='${contextPath}/band/${bandRoom.bandRoomId }/setting/cover-update'">
						<i class="bi bi-gear"></i> 밴드 설정
					</div>
				</c:if>
			</div>

		<!-- 2 -->
		<c:choose>
			<c:when test="${logonUser ne null }">
			
				<div class="flex-grow-1 flex-column shadow-sm rounded-1" style="position:sticky;  ;min-width: 500px; background-color: white">
				
					<div class="d-flex justify-content-between" style="height: 65px; background-color: white;">
						<div class="ps-3 pt-3">
							<span style="font-weight: bold; font-size: 19px">사진첩</span>
						</div>
						<div class="pe-3 pt-3" >
							<button id="album" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal"
										 style="border: 1px solid #272829;  width: 100px; height: 35px;  padding-bottom: 4px; background-color: white">
								<span style="font-size: 13px;">앨범 만들기</span> 
							</button>
						</div>
					</div>
					<hr style="color: #BFCFE7; border: 1px solid ;margin: 3px">
					<div style="padding-right: 13px; margin-top: 6px;">
						<div class="d-flex justify-content-between" style="margin-bottom: 10px">
							<div class="ps-3 pt-3">
								<div style="font-weight: bold; font-size: 15px; cursor: pointer;" onclick="location.href='${contextPath}/band/${bandRoomId }/album/total'"
										>전체사진 <span style="color: #B2B2B2; font-size: 14px">${cntTotalImage }</span></div>
								<div style="font-size: 11px; color: #73777B;">${now }</div>
							</div>
							<div class="pe-3 pt-3">
								<button type="button" data-bs-toggle="modal" data-bs-target="#imageUpload"
										style="border: none; background-color: white;">
									<i class="bi bi-plus-lg"></i>
								</button>
							</div>
						</div>
						<div class="row row-cols-3" style="margin-left: 10px;width: 100%">
							<c:forEach var="one" items="${imageList }" varStatus="status">
								<c:choose>
									<c:when test="${status.last }">
										<div class="col lb-wrap" style="width: 190px; height: 190px; padding: 0.1rem">									
											<a href="${contextPath }/band/${bandRoomId}/album/total">
												<img class="lb-image" alt="전체사진" src="${contextPath }${one.imageUrl}" width="100%" height="100%">
												<c:if test="${cntTotalImage gt 6 }">
													<span class="lb-text" style="width: 185px; height: 188px; padding-top: 80px;">더보기 +</span>
												</c:if>
											</a>									
										</div>
									</c:when>
									<c:otherwise>
										<div class="col" style="width: 190px; height: 190px;padding: 0.1rem">
											<a href="${contextPath }/band/${bandRoomId}/album/total">
												<img alt="전체사진" src="${contextPath }${one.imageUrl}" width="100%" height="100%">
											</a>
										</div>
									</c:otherwise>
								</c:choose>										
							</c:forEach>				
						</div>	
					</div>
					<hr style="color: #BFCFE7; border: 1px solid">
					<div>
						<div class="d-flex justify-content-between">
							<div class="ps-3 pt-3">
								<div style="font-weight: bold; font-size: 15px">앨범</div>
							</div>
							<div class="pe-3 pt-3">업데이트순</div>
						</div>
					</div>
					<div class="ps-3 pe-3">	
						<c:forEach var="one" items="${albumList }">
							<div style="border: 1px solid #B2B1B9; margin-top: 20px">
								<div class="d-flex justify-content-between pt-2 mb-2" >
									<div class="ps-3 pt-1">
										<a href="${contextPath }/band/${bandRoomId}/album/${one.albumId}" >
											<div style="font-weight: bold; font-size: 15px">${one.albumTitle }</div>
										</a>
										<div style="font-size: 11px; color: #B2B1B9;">${now }</div>
									</div>
									<div class="pe-3 pt-2">
										<input type="hidden" value="${one.albumId }"/>
										<input type="hidden" value="${one.albumTitle }"/>
										<button type="button" data-bs-toggle="modal" data-bs-target="#albumImageUpload"
												style="border: none; background-color: white;" class="albumAddImageButton">
											<i class="bi bi-plus-lg"></i>
										</button>
									</div>
								</div>
								<!-- 앨범 나열 -->
								<ul class="row row-cols-3" style="list-style: none; padding-left: 12px; margin-bottom: 0; width: 102%">
									<c:forEach var="two" items="${albumImageList }">
										<c:choose>
											<c:when test="${one.albumId eq two.imageAlbumId }">													
												<li class="p-1 col" style="width: 100px; height: 100px">
													<a href="${contextPath }/band/${bandRoomId}/album/${two.imageAlbumId}">
														<img alt="앨범사진" src="${contextPath }${two.imageUrl}" width="100%" height="100%">
													</a> 
												</li>																					
											</c:when>
										</c:choose>
									</c:forEach>
								</ul>	
							</div>
						</c:forEach>
					</div>		
				</div>
			</c:when>
			<c:otherwise>
				<div class="flex-grow-1 flex-column shadow-sm rounded-1" style="min-width: 500px; background-color: white">
					<div style="height: 547px; position: relative; cursor: pointer;" data-bs-toggle="modal" data-bs-target="#joinBandModal">
						<div style="position : absolute;top : 50%; left: 45%;margin: -50px 0 0 -50px">
							<div style="text-align: center">
								<div style="font-size: 35px"><i class="bi bi-door-open"></i></div>
								<div>멤버만 볼 수 있습니다.</div>
								<div style="font-size: 13px">밴드에 가입해보세요!</div>
							</div>
						</div>
					</div>
				</div>
			</c:otherwise>
		</c:choose>
		<!-- 3 -->
		<div class="pb-3 ms-3 " style="min-width: 208px; position: sticky; top: 50px">
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
	<!-- ============================================================================================================================== -->
	
	<!-- 전체사진 image upload modal -->
		
		<div class="modal fade" id="imageUpload" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered" style="width: 500px">
			    <div class="modal-content" style="height: 500px">
			      <div class="modal-header" style="padding-left: 205px" >
			        <div style="font-size: 16px; font-weight: bold; text-align: center">
			   		     사진 올리기
			        </div>
			      </div>
			      <div style="width: 500px; height: 374px; padding-left: 20px; padding-right: 20px">
			        <form action="${contextPath }/band/${bandRoomId}/wholeImage" method="post" enctype="multipart/form-data" >
			     	 	<div>
				      		<div style="overflow: scroll;overflow-x:hidden; min-height:270px ; max-height: 270px">	
			      				<div id="imageView" class="row row-cols-5" style="padding-left: 9px; padding-right: 9px" >
			      				
			      					<div class="p-1 col">
							     		<input type="file" style="display: none" multiple="multiple" id="wholeImages" name="wholeImages"/>
							     		<button type="button" onclick="document.querySelector('#wholeImages').click();" style="width: 90px; height: 90px">
							     			<i class="bi bi-plus-lg"></i>
							     		</button>
			      					</div>
			      				</div>					     		
					     	</div>
				            <div>
				           		<div style="font-size: 13px;" class="mb-2">앨범 선택하기</div>
			          			<div>
						            <select class="form-select" aria-label="Default select example" id="selectAlbum">
									  <option style="font-size: 13px" selected value="0">앨범 지정하지 않음</option>
									  <c:forEach var="albumname" items="${albumList }">
										  <option style="font-size: 13px" value=${albumname.albumId }>${albumname.albumTitle }</option>						  
									  </c:forEach>							  					
									</select>
			         			</div>
			          		</div>
			     		</div>
				      <div class="modal-footer justify-content-center" >
				        <button type="button" id="addImageCancel" class="btn btn-white" data-bs-dismiss="modal" 
				        		style="border: 1px solid #E2E2E2; font-size: 12px; width: 90px; height: 34px">취소</button>
				        <button type="submit" id="addImageButton"  class="btn"
				        		style="background-color:#424769;font-size: 12px; width: 90px; height: 34px; color: white">올리기</button>
				      </div>
			   		 </form>
			      </div>
			    </div>
			  </div>
		</div>
		
		<!-- 앨범사진 image upload modal -->
		
		<div class="modal fade" id="albumImageUpload" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered" style="width: 500px">
			    <div class="modal-content" style="height: 500px">
			      <div class="modal-header" style="padding-left: 205px" >
			        <div style="font-size: 16px; font-weight: bold; text-align: center">
			   		     사진 올리기
			        </div>
			      </div>
			      <div style="width: 500px; height: 374px; padding-left: 20px; padding-right: 20px">
			        <form action="${contextPath }/band/${bandRoomId}/albumImage" method="post" enctype="multipart/form-data" >
			     	 	<input type="hidden" id="albumId" name="albumId" value=""/>
			     	 	<div>
				      		<div style="overflow: scroll;overflow-x:hidden; min-height:270px ; max-height: 270px">	
			      				<div id="albumImageView" class="row row-cols-5" style="padding-left: 9px; padding-right: 9px" >
			      				
			      					<div class="p-1 col">
							     		<input type="file" style="display: none" multiple="multiple" id="albumImages" name="albumImages"/>
							     		<button type="button" onclick="document.querySelector('#albumImages').click();" style="width: 90px; height: 90px">
							     			<i class="bi bi-plus-lg"></i>
							     		</button>
			      					</div>
			      				</div>					     		
					     	</div>
				            <div>
				           		<div style="font-size: 13px;" class="mb-2">앨범 선택하기</div>
			          			<div>
						            <select class="form-select" aria-label="Default select example" id="selectedAlbumId">
									  <option style="font-size: 13px" selected value="" id="selectAlbumName"></option>
									  <option style="font-size: 13px" value="0">앨범 지정하지 않음</option>
									  <c:forEach var="albumname" items="${albumList }">
										  <option id="selectAlbumId" style="font-size: 13px" value=${albumname.albumId }>${albumname.albumTitle }</option>						  
									  </c:forEach>							  					
									</select>
			         			</div>
			          		</div>
			     		</div>
				      <div class="modal-footer justify-content-center" >
				        <button type="button" id="addAlbumImageCancel" class="btn btn-white" data-bs-dismiss="modal" 
				        		style="border: 1px solid #E2E2E2; font-size: 12px; width: 90px; height: 34px">취소</button>
				        <button type="submit" id="addAlbumImageButton"  class="btn" 
				        		style="background-color:#424769;font-size: 12px; width: 90px; height: 34px; color: white">올리기</button>
				      </div>
			        </form>
			      </div>
			    </div>
			  </div>
		</div>
	
	
	
	
	
	<!-- create album modal -->
		
		<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered" style="width: 380px">
			    <div class="modal-content">
			      <div class="modal-header" >
			        <div style="font-size: 17px; font-weight: bold; padding-left: 125px">
			        앨범 만들기
			        </div>
			        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			      </div>
			      <div class="modal-body">
			          <div class="mb-3">
			            사진을 올려서 보관! 사진UP!<br/>
			            함께 찍은 사진을 모아보세요
			          </div>
			         <form id="form" action="${contextPath }/band/${bandRoomId }/album" method="post">
			         <input type="hidden" value="" name="confirm" id="confirm"/>
			          <div class="mb-3">
			            <input type="text" id="albumname" name="albumname" style="width: 100%; height:38px ;border: 1px solid #E2E2E2;"/>
			          </div>
			        </form>
			      </div>
			      <div class="modal-footer justify-content-center" >
			        <button type="button" id="cancelCreateAlbum" class="btn btn-white" data-bs-dismiss="modal"
			        		style="border: 1px solid #E2E2E2; font-size: 12px; width: 90px; height: 34px">취소</button>
			        <button id="createAlbum" type="button" class="btn btn-secondary" disabled="disabled"
			        		style="font-size: 12px; width: 90px; height: 34px">확인</button>
			      </div>
			    </div>
			  </div>
		</div>

	<!-- join Modal -->
	<div class="modal fade" id="joinBandModal" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" style="width: 360px;">
			<div class="modal-content" style="height: 500px;">
				<div class="modal-header">
					<button type="button" class="btn-close position-absolute" style="top:10px; right:10px;" data-bs-dismiss="modal" aria-label="Close"></button>
					<div class="modal-title fs-5 text-center position-relative" id="staticBackdropLabel">
						<span class="h3">${bandRoom.bandRoomName }</span><br/>
						<small>이 밴드에 사용할 프로필을 선택하세요.<br/>선택한 프로필의 사진과 스토리를 이 밴드 멤버들도 볼 수 있게 돼요.</small>
					</div>
				</div>
				<form action="${contextPath }/band/${bandRoom.bandRoomId}/request" method="post">
				
					<div class="modal-body" style="min-height:270px;">
						<c:forEach var="one" items="${profiles }" varStatus="status">
							<div class="d-flex align-items-center">
								<div>
									<img src="${fn:startsWith(one.profileImageUrl, '/band/upload') ? contextPath:'' }${one.profileImageUrl }" class="rounded-circle">
								</div>
								<div class="flex-grow-1">
									${one.profileNickname }
								</div>
								<input type="radio" name="profileId" value="${one.profileId }" ${status.first ? 'checked' :'' }/>
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
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		// 특정앨범 사진 추가 시 앨범ID 넘기기
		document.querySelector('#addAlbumImageButton').onclick = function(e){
			document.querySelector("#albumId").value = document.querySelector("#selectedAlbumId").value;
			//console.log(document.querySelector("#selectAlbumId").value);
			//console.log(document.querySelector("#albumId").value);
		}
		
		// 앨범이름 미기입시 확인버튼 비활성화
		const target = document.querySelector("#createAlbum");
		
		document.querySelector("#albumname").onchange = function(e) {
			
			console.log(e.target.value);
			if(!e.target.value){
				target.disabled = true;
			}else{
				target.disabled = false;
			}
		}
		
		//앨범생성 시 게시글 업로드 질문
		document.querySelector("#createAlbum").onclick = function(e){
			document.querySelector("#confirm").value = confirm("앨범을 만들었습니다.\n멤버들에게 게시글로 공유하겠습니까?");
			document.querySelector("#form").submit();
		}
		//전체사진첩에 사진 추가
		
		document.querySelector("#wholeImages").onchange = function(e) {
			const files = [...document.querySelector("#wholeImages").files];
		
			files.forEach(function(file){
				const fileReader = new FileReader();
				
				fileReader.readAsDataURL(file);
				fileReader.onload = function(e){
					const div = document.createElement("div");
					div.className = "p-1 col rounded position-relative";
					
					const img = document.createElement("img");
					img.src = e.target.result;
					img.width = 90;
					img.height = 90;
					img.className = "object-fit-cover";
					div.appendChild(img);
					
			
					const button = document.createElement("button");
					button.type = "button";
				    button.className = "position-absolute top-0 end-0";
					button.ariaLabel = "Close";
					button.style.border = "none";
					button.style.backgroundColor = "transparent";
					button.style.padding = 0;
					button.style.paddingTop = "5px";				
					button.style.margin = 0;
					div.appendChild(button);
				
					const i = document.createElement("i");
					i.className = "bi bi-x-circle";
					i.style.color = "white";
					button.appendChild(i);
					
					button.onclick = function() {
						document.querySelector("#imageView").removeChild(this.parentNode);
					}
					
					document.querySelector("#imageView").appendChild(div);
				}	
			});		
		}
		
		//앨범사진첩에 사진 추가
		
		document.querySelector("#albumImages").onchange = function(e) {
			const files = [...document.querySelector("#albumImages").files];
		
			files.forEach(function(file){
				const fileReader = new FileReader();
				
				fileReader.readAsDataURL(file);
				fileReader.onload = function(e){
					const div = document.createElement("div");
					div.className = "p-1 col rounded position-relative";
					
					const img = document.createElement("img");
					img.src = e.target.result;
					img.width = 90;
					img.height = 90;
					img.className = "object-fit-cover";
					div.appendChild(img);
					
					const button = document.createElement("button");
					button.type = "button";
				    button.className = "position-absolute top-0 end-0";
					button.ariaLabel = "Close";
					button.style.border = "none";
					button.style.backgroundColor = "transparent";
					button.style.padding = 0;
					button.style.paddingTop = "5px";				
					button.style.margin = 0;
					div.appendChild(button);
				
					const i = document.createElement("i");
					i.className = "bi bi-x-circle";
					i.style.color = "white";
					button.appendChild(i);
					
					button.onclick = function() {
						document.querySelector("#albumImageView").removeChild(this.parentNode);
					}
					
					document.querySelector("#albumImageView").appendChild(div);
				}	
			});		
		}
		
		// 특정앨범 사진추가 클릭시 selected 설정
		let one = document.querySelector("#selectAlbumName");
		[...document.querySelectorAll(".albumAddImageButton")].forEach(function(e){
		
			e.addEventListener('click', function(evt){
				//console.log(evt);
				one.innerHTML = evt.target.parentElement.previousElementSibling.value;
				one.value = evt.target.parentElement.previousElementSibling.previousElementSibling.value;
				//console.log(evt.target.parentElement.previousElementSibling.previousElementSibling.value);
			})
						
		});
		
	</script>
</body>
</html>