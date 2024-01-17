<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/view/component/header.jspf"%>


	<div class="mx-auto d-flex align-items-start pt-3" style="width: 1034px;">
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
					<div class="text-secondary mt-2" style="cursor:pointer;" onclick="location.href='${contextPath}/band/${bandRoom.bandRoomId }/setting/cover-update'">
						<i class="bi bi-gear"></i> 밴드 설정
					</div>
				</c:if>
			</div>
		
		<!-- 2 -->
		<div class="flex-grow-1 flex-column shadow-sm rounded-1" style="position:sticky;min-width: 500px;  background-color: white">
			
				<div class="d-flex justify-content-between" style="height: 65px;  background-color: white">
					<div class="ps-3 pt-4">
						<span style="font-weight: bold; font-size: 17px">${foundAlbum.albumTitle } <span style="color: blue">${cntAlbumTotal }</span> </span>
					</div>
					<div class="pe-3 pt-3 d-flex">
						<div>
							<button id="" type="button" data-bs-toggle="modal" data-bs-target="#albumImageUpload"
										 style="border: 1px solid #272829;  width: 100px; height: 35px; ; font-size: 13px; background-color: white">
								사진 올리기
							</button>
						</div>
						<div class="dropdown">
							  <button class="btn dropdown-toggle" style="background: white; border: none; padding-left: 5px; padding-right: 5px"
							  			type="button" data-bs-toggle="dropdown" aria-expanded="false">
							  </button>
							  <ul class="dropdown-menu">
							    <li style="margin-left: 15px; cursor: pointer;" data-bs-toggle="modal" data-bs-target="#exampleModal"><span id="" style="font-size: 13px">앨범이름 수정</span></li>
							    <li style="margin-left: 15px; cursor: pointer;"><span id="albumDelete" style="font-size: 13px">앨범 삭제</span></li>
							  </ul>
						</div>
					</div>
				</div>
				<hr style="margin: 3px"/>
				<div class="d-flex justify-content-between shadow-sm bg-body-tertiary" style="margin-top: 6px; padding-bottom: 6px">
					<div style="font-size: 13px" class="ps-3">
						최신순 보기
					</div>
					<div class="pe-3">
						<button type="button" id="manageButton" style="font-size: 13px;border: none; display: block;">
							관리
						</button>
						<div style="display: none;" id="hiddenButton">
							<button style="font-size: 13px; border: none" id="saveImage" disabled="disabled">
								저장
							</button>
							<button style="font-size: 13px; border: none" id="deleteImage">
								삭제
							</button>
						</div>
					</div>
				</div>
				<form action="${contextPath }/band/${bandRoomId}/albumImage/save" method="post" id="control">
				<div class="row row-cols-3" style="margin-left: 10px; width: 99%; margin-top: 18px">
					<c:forEach var="one" items="${albumAllImages}">
						<div class="col position-relative" id="images" style="width: 190px; height: 190px; padding: 0.1rem">							
							<img alt="해당앨범사진" src="${contextPath }${one.imageUrl}" width="100%" height="100%" id="showImage"
									style="cursor:pointer;" data-bs-toggle="modal" data-bs-target="#imageModal" data-url="${one.imageUrl }" onclick="imageInsert(event);">
							<input class="position-absolute top-0 end-0" type="checkbox" id="checkInput" required name="checkInput" value="${one.imageId}"
									style="margin-top: 8px; margin-right: 8px; display: none"/>	
							<input type="hidden" name="memberId" value="${one.imageMemberId }"/>
							<input type="hidden" name="albumIdForUpdate" value="${albumId }"/>
						</div>
					</c:forEach>
				</div>
				</form>
				<div style="display: none;" id="stickyBottom" class="sticky-bottom">
					<div class="d-flex"  style="background-color: rgb(255,255,255,0.9); display: none;">
						<div class="p-2" style="width: 85%;font-size: 13px">
							<span style="color: blue" id="imageCnt">0</span>장의 사진을 선택하였습니다.
						</div>
						<div class="p-2 flex-shrink-1">
							<button type="button" id="exitManage" style="border: none; font-size: 13px">
								나가기
							</button>
						</div>
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
		
		<!-- image Modal -->
	    <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true" 
	    		style="background-color: rgba(0,0,0,0.75)">
	        <div class="modal-dialog modal-dialog-centered justify-content-center" id="innerModal" style="max-width: 680px; max-height: 420px">
	        
	        </div>
	    </div> 
		
		<!-- album name update modal -->
		
		<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered" style="width: 380px">
			    <div class="modal-content">
			      <div class="modal-header" >
			        <div style="font-size: 17px; font-weight: bold; padding-left: 125px">
			        앨범 이름 수정
			        </div>
			        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			      </div>
			      <div class="modal-body">
		
			         <form id="form" action="${contextPath }/band/${bandRoomId }/album/update" method="post">
			         <input type="hidden" id="albumId" name="albumId" value="${albumId }"/>
			          <div class="mb-3">
			            <input type="text" id="albumnameUpdate" name="albumnameUpdate" value="${foundAlbum.albumTitle }" style="width: 100%; height:38px ;border: 1px solid #E2E2E2;"/>
			          </div>
			        </form>
			      </div>
			      <div class="modal-footer justify-content-center" >
			        <button type="button" id="cancelUpdateAlbum" class="btn btn-white" data-bs-dismiss="modal"
			        		style="border: 1px solid #E2E2E2; font-size: 12px; width: 90px; height: 34px">취소</button>
			        <button id="updateAlbum" type="button" class="btn btn-secondary" 
			        		style="font-size: 12px; width: 90px; height: 34px">확인</button>
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
			     	 	<input type="hidden" id="albumId" name="albumId" value="${albumId }"/>
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
						            <select class="form-select" aria-label="Default select example" id="selectedAlbumId" name="selectedAlbumId">
									  <option style="font-size: 13px" value="0">앨범 지정하지 않음</option>
									  <c:forEach var="albumname" items="${albumList }">
										  <option id="selectAlbumId" style="font-size: 13px" ${albumname.albumId eq foundAlbum.albumId ? 'selected' : '' }
													value="${albumname.albumId }">${albumname.albumTitle }</option>						  
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
	
		function imageInsert(e) {
	        const modal = document.querySelector("#innerModal");
	        modal.innerHTML = '';
	        
	        const img = document.createElement("img");
	        img.className="p-2 border"
	        img.src = '${contextPath}' + e.target.dataset.url;
	    
	        modal.appendChild(img);
	    } 

	
		document.querySelector('#updateAlbum').onclick = function(e){
			document.querySelector('#form').submit();
		}
		
		document.querySelector('#albumDelete').onclick = function(e){
			var check = window.confirm("앨범을 삭제하시겠습니까?");
			if(check){
				location.href='${contextPath}/band/${bandRoomId}/album/delete?albumId=${albumId}'
			}
		}
	
		//let checkInput = document.querySelectorAll("#checkInput");
		//var checkeds = new Array();
			//체크박스 갯수확인
		//	checkInput.forEach(function(ee){
		//		if(ee.checked == true){
		//			checkeds
		//		}
				
		//	})
		document.querySelector("#deleteImage").onclick = function(e){
			
			document.querySelector("#control").action = "${contextPath }/band/${bandRoomId}/albumImage/delete";
			document.querySelector("#control").submit();
		}
		
		document.querySelector("#saveImage").onclick = function(e){
			document.querySelector("#control").submit();
		}
		
		
		const list = document.querySelectorAll('#checkInput');
		let cnt = 0;
			
		// 화면의 사진선택 개수 표기
		list.forEach(function(e){
			e.onclick = function(evt){
				if(e.checked == true){
					cnt++;
					document.querySelector("#imageCnt").innerHTML = cnt;
				}else{
					cnt--;
					document.querySelector("#imageCnt").innerHTML = cnt;
				}	
			}
	
		})
		
		document.querySelector("#manageButton").onclick = function(e){			
			document.querySelector("#manageButton").style.display = 'none';
			document.querySelector("#hiddenButton").style.display = 'block';
			document.querySelector("#stickyBottom").style.display = 'block';
			
			list.forEach(function(e){
				e.style.display = 'block';
			});
			
			
		}
		document.querySelector("#exitManage").onclick = function(e){
			document.querySelector("#manageButton").style.display = 'block';
			document.querySelector("#hiddenButton").style.display = 'none';
			document.querySelector("#stickyBottom").style.display = 'none';
			document.querySelector("#imageCnt").innerHTML = 0;
			cnt=0;
			list.forEach(function(evt){
				evt.checked = false;
			})
			
			list.forEach(function(e){
				e.style.display = 'none';
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
		
	
	
	</script>
</body>
</html>