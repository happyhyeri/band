<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${bandRoom.bandRoomName }</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
<style type="text/css">
	a {
	text-decoration: none;
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

	<div style="background-color: black; height: 40px; font-size: 14px;">
		<ul class="nav justify-content-center gap-5 nav-underline" >
		  <li class="nav-item">
		    <a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="#" style="padding-bottom: 1px">게시글</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="${contextPath }/band/${bandRoomId}/album" style="padding-bottom: 1px">사진첩</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="#" style="padding-bottom: 1px">일정</a>
		  </li>
		  <li class="nav-item">
		    <a class="nav-link link-light link-offset-2 link-underline-opa city-25 link-underline-opacity-100-hover" href="#"  style="padding-bottom: 1px">첨부</a>
		  </li>
		   <li class="nav-item">
		    <a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="#" style="padding-bottom: 1px">멤버</a>
		  </li>
		</ul>
	</div>	

	
	<div class="container-lg d-flex align-items-start mt-3">
		<div class="pb-3 me-3" style="width: 208px; height: 157px;">
			<!-- 
			<img src="${fn:startsWith(bandRoom.coverImageUrl, '/band/upload') ? contextPath:'' }${bandRoom.coverImageUrl }" alt="커버사진"
				style="min-width: 208px; min-height: 157px; background-color: aliceblue;">
			 -->
			 <img src="${contextPath }/resource/bandIcon/1.jpg" alt="커버사진"
				style="min-width: 208px; min-height: 157px; background-color: aliceblue;">
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
						<button type="button" class="btn w-100 text-center" style="background-color: ${bandRoom.bandRoomColor};" data-bs-toggle="modal"
							data-bs-target="#joinBandModal">글쓰기</button>
					</c:when>
					<c:when test="${member.memberStatus eq 'request' }">
						<button type="button" class="btn w-100 text-center" style="background-color: ${bandRoom.bandRoomColor};" data-bs-toggle="modal"
							data-bs-target="#joinBandModal">가입대기중</button>
					</c:when>
					<c:otherwise>
						<button type="button" class="btn w-100 text-center" style="background-color: ${bandRoom.bandRoomColor};" data-bs-toggle="modal"
							data-bs-target="#joinBandModal">가입신청하기</button>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		
		
		
		
		<div style="min-width: 500px;">
			<div class="d-flex justify-content-between" style="background-color: aliceblue; height: 65px">
				<div class="ps-3 pt-3">
					<span style="font-weight: bold; font-size: 19px">사진첩</span>
				</div>
				<div class="pe-3 pt-3" >
					<!-- <input type="file" id="albumImage" style="display: none;"/> -->
					<button id="album" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal"
								 style="border: 1px solid #272829;  width: 100px; height: 35px;  padding-bottom: 4px">
						<span style="font-size: 14px;">앨범 만들기</span> 
					</button>
				</div>
			</div>
			<hr style="color: #BFCFE7; border: 1px solid">
			<div>
				<div class="d-flex justify-content-between">
					<div class="ps-3 pt-3">
						<div style="font-weight: bold; font-size: 15px">전체사진</div>
						<div style="font-size: 11px; color: #73777B;">${now }</div>
					</div>
					<div class="pe-3 pt-3">
						<button type="button" data-bs-toggle="modal" data-bs-target="#imageUpload"
								style="border: none; background-color: white;">
							<i class="bi bi-plus-lg"></i>
						</button>
					</div>
				</div>
		
			</div>
			<hr style="color: #BFCFE7; border: 1px solid">
			<div>
				<div class="d-flex justify-content-between">
					<div class="ps-3 pt-3">
						<div style="font-weight: bold; font-size: 15px">앨범</div>
					</div>
					<div class="pe-3 pt-3">업데이트순!!(수정)</div>
				</div>
			</div>
			<div>	
				<c:forEach var="one" items="${albumList }">
					<div style="border: 1px solid #B2B1B9; margin-top: 20px">
						<div class="d-flex justify-content-between pt-2" >
							<div class="ps-3 pt-1">
								<a href="${contextPath }/band/${bandRoomId}/album/${one.albumId}" >
								<div style="font-weight: bold; font-size: 15px">${one.albumTitle }</div></a>
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
						<ul>
							<c:forEach var="two" items="${imageList }">
								<li>
									<a href="${contextPath }/band/${bandRoomId}/album/${two.imageAlbumId}">
										<img alt="앨범사진" src="">
									</a>
								</li>
							</c:forEach>
						</ul>	
					</div>
				</c:forEach>
			</div>		
		</div>
		
		
		
		
		<div class="pb-3 ms-3" style="min-width: 208px;">
			<div>다가오는 일정</div>
			<div>채팅</div>
			<div>파일</div>
			<div>최근 사진</div>
		</div>
	</div>
	
	
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
			        <form action="${contextPath }/band/${bandRoomId}/whole" method="post" enctype="multipart/form-data" >
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
			        <form action="" method="post" enctype="multipart/form-data" >
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
						            <select class="form-select" aria-label="Default select example" id="selectAlbum">
									  <option style="font-size: 13px" selected value="" id="selectAlbumName"></option>
									  <option style="font-size: 13px" value="0">앨범 지정하지 않음</option>
									  <c:forEach var="albumname" items="${albumList }">
										  <option style="font-size: 13px" value=${albumname.albumId }>${albumname.albumTitle }</option>						  
									  </c:forEach>							  					
									</select>
			         			</div>
			          		</div>
			     		</div>
			        </form>
			      </div>
			      
			      
			      <div class="modal-footer justify-content-center" >
			        <button type="button" id="addImageCancel" class="btn btn-white" data-bs-dismiss="modal" 
			        		style="border: 1px solid #E2E2E2; font-size: 12px; width: 90px; height: 34px">취소</button>
			        <button type="button" id="addImageButton"  class="btn"
			        		style="background-color:#424769;font-size: 12px; width: 90px; height: 34px; color: white">올리기</button>
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
			         <form id="form" action="${contextPath }/band/ACA07E9B/album" method="post">
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
					div.className = "p-1 col";
					
					const img = document.createElement("img");
					img.src = e.target.result;
					img.width = 90;
					img.height = 90;
					img.className = "object-fit-cover";
					div.appendChild(img);
					
					const button = document.createElement("button");
					button.type = "button";
				    button.className = "btn-close top-0 end-0";
					button.ariaLabel = "Close";
					div.appendChild(button);
					
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
					div.className = "p-1 col";
					
					const img = document.createElement("img");
					img.src = e.target.result;
					img.width = 90;
					img.height = 90;
					img.className = "object-fit-cover";
					div.appendChild(img);
					
					const button = document.createElement("button");
					button.type = "button";
				    button.className = "btn-close top-0 end-0";
					button.ariaLabel = "Close";
					div.appendChild(button);
					
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