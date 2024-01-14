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
<style type="text/css">
	
	img:hover {
		box-shadow: 1px 1px 20px #ddd;	
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
		    <a class="nav-link link-light link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" href="#"  style="padding-bottom: 1px">첨부</a>
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
		
		
		
		
		<div class="flex-grow-1 flex-column" style="min-width: 500px;">
			
				<div class="d-flex justify-content-between" style=" height: 65px">
					<div class="ps-3 pt-4">
						<span style="font-weight: bold; font-size: 17px">전체 사진 <span style="color: blue">${cntTotalImage }</span></span>
					</div>
					<div class="pe-3 pt-3">
					<form action="" method="post" enctype="multipart/form-data" >
						<input type="file" id="albumImages" multiple="multiple" style="display: none;"/>
						<button id="" type="button" data-bs-toggle="modal" data-bs-target="#imageUpload"
									 style="border: 1px solid #272829;  width: 100px; height: 35px; font-size: 13px">
							사진 올리기
						</button>
					</form>
					</div>
				</div>
				<hr style="margin: 3px"/>
				<div class="d-flex justify-content-between shadow-sm bg-body-tertiary" style="margin-top: 6px; padding-bottom: 6px">
					<div style="font-size: 13px" class="ps-3">
						최신순 보기(구현전)
					</div>
					<div class="pe-3">
						<button type="button" id="manageButton" style="font-size: 13px;border: none; display: block;">
							관리
						</button>
						<div style="display: none;" id="hiddenButton">
							<button style="font-size: 13px; border: none">
								저장
							</button>
							<button style="font-size: 13px; border: none">
								삭제
							</button>
						</div>
					</div>
				</div>
				<div class="row row-cols-3" style="margin-left: 10px;width: 99%; margin-top: 18px">
					<c:forEach var="one" items="${imageList}">
						<div class="p-1 col" style="width: 164px; height: 164px">
							<img alt="해당밴드전체사진" src="${contextPath }${one.imageUrl}" width="100%" height="100%">
						</div>
					
					</c:forEach>
				</div>
				<div class="d-flex sticky-bottom" id="stickyBottom" style="background-color: rgb(255,255,255,0.9); display: none;">
					<div class="p-2" style="width: 85%;font-size: 13px">
						<span style="color: blue">0장</span>의 사진을 선택하였습니다.
					</div>
					<div class="p-2 flex-shrink-1">
						<button type="button" id="exitManage" style="border: none; font-size: 13px">
							나가기
						</button>
					</div>
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
		document.querySelector("#manageButton").onclick = function(e){			
			document.querySelector("#manageButton").style.display = 'none';
			document.querySelector("#hiddenButton").style.display = 'block';
			document.querySelector("#stickyBottom").style.display = 'block';
			
		}
		
		document.querySelector("#exitManage").onclick = function(e){
			document.querySelector("#manageButton").style.display = 'block';
			document.querySelector("#hiddenButton").style.display = 'none';
			document.querySelector("#stickyBottom").style.display = 'none';
			
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
	</script>
</body>
</html>