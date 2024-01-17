<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>band create</title>
<style type="text/css">
::placeholder {
	color: #E2E2E2;
	opacity: 1; /* Firefox */
}
</style>
<link rel="styleshee" href="${pageContext.servletContext.contextPath }/resource/style/style.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
	integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.2/font/bootstrap-icons.min.css">
</head>
<c:set var="contextPath" value="${pageContext.servletContext.contextPath }"/>
<body>

	<div class="sticky-top" style="background-color: #F0F0F0">
		<div class="mx-auto" style="width: 1034px;">
			<div class="">
				<div class="d-flex justify-content-between" style="height: 55px;">
					<div
						class="d-flex justify-content-start gap-4 align-items-center">
						<div
							style="font-size: 20px; font-weight: bold; margin-top: 6px;">
							<a class="navbar-brand" href="${contextPath }/index"> 
								<img alt="밴드로고" src="${contextPath }/resource/band.png" width="80px" height="40">
							</a>
						</div>
						<div class="input-group">
							<input type="text" class="form-control"
								placeholder="밴드, 페이지, 게시글 검색"
								aria-label="Recipient's username"
								aria-describedby="button-addon2"
								style="font-size: 12px; width: 260px; height: 30px; margin-top: 5px">
							<button class="btn btn-outline-secondary" type="button"
								id="button-addon2"
								style="font-size: 12px; height: 29px; margin-top: 5px; border: none; background-color: white">
								<i class="bi bi-search"></i>
							</button>
						</div>
					</div>
					<div class="d-flex justify-content-end gap-4 align-items-center"
						style="color: black;">
						<div style="font-size: 13px">새글 피드</div>
						<div style="font-size: 13px">찾기</div>
						<div>
							<i class="bi bi-bell-fill"></i>
						</div>
						<div>
							<i class="bi bi-chat-dots-fill"></i>
						</div>
						<div class="dropdown">
							<button
								class="btn  dropdown-toggle rounded-circle"
								type="button" data-bs-toggle="dropdown" aria-expanded="false"
								style="width: 35px; height: 50px; background-color: transparent; border: none;">
								<img
									src="${fn:startsWith(profileImageUrl, '/resource') ? contextPath:'' }${profileImageUrl}"
									class="rounded-circle" alt="프로필" width="35" height="35">
							</button>
							<ul class="dropdown-menu">
								<li><a class="dropdown-item" href="${contextPath }/my/profile" style="font-size: 13px">내 정보</a></li>
								<li><a class="dropdown-item" href="${contextPath }/my/post" style="font-size: 13px">내가 쓴 글</a></li>
								<li><a class="dropdown-item" href="${contextPath }/signout" style="font-size: 13px">로그아웃</a></li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container mt-2">
		<div style="width: 750px; margin: auto">
			<form action="${pageContext.servletContext.contextPath }/band/band-create" method="post" enctype="multipart/form-data">
			<input type="hidden" value="" name="coverImageUrl" id="coverImageUrl">
				<div style="width: 100%" class="mb-3">
					<div class="mb-3">
						<span style="font-size: 14px" class="fw-bold">밴드 이름</span>
					</div>
					<div>
						<input type="text" name="bandRoomName" placeholder="밴드 이름 입력" id="bandRoomName"
							class="border-bottom"
							style="border: none; width: 100%; outline: none; line-height: 54px; font-size: 30px; font-weight: 400;"
							maxlength="50">
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div style="overflow-x: auto; margin-top: 7px">
							<img
								src="${pageContext.servletContext.contextPath }/resource/bandIcon/1.jpg"
								width="300" height="235" id="imageView">
						</div>
					</div>
					<div class="col">
						<div>
							<div>
								<span style="font-size: small">커버 선택</span>
							</div>
							<div class="row row-cols-2 row-cols-lg-4 g-2 g-lg-3">
								<div class="col">
									<input type="file" id="bandimage" style="display: none;" name="bandimage">
									
									<button type="button" class="rounded-1" onclick="document.querySelector('#bandimage').click();"
										style="width:90px; height : 102px ; border: none;
												color: black">
										<i class="bi bi-camera-fill" style="font-size: 25px; color: #A9A9A9 "></i><br/>
										<span style="font-size: 13px; color: #A9A9A9 ">사진추가</span>
									</button>
								</div>
								<c:forEach var="one" begin="1" end="7">
									<div class="col">
										<button class="defaultButton" type="button"
											style="-bs-btn-padding-y: 3.2rem; - -bs-btn-padding-x: 2.9rem; - -bs-btn-font-size: 1.5rem; border: none;"
											class="rounded-1">
											<img alt="기본배경"
												src="${pageContext.servletContext.contextPath }/resource/bandIcon/${one}.jpg"
												width="100" height="100" class="rounded-1" id="defaultImage">
										</button>
									</div>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
				<div class="mt-1 mb-5" style="width: 100%">
					<span style="font-size: small">밴드이름과 사진은 개설 후에도 변경할 수 있어요</span>
				</div>
				<div class="mb-4">
					<div>
						<span style="font-size: 14px" class="fw-bold">밴드 공개</span>
					</div>
					<div style="background-color: #FBF9F1; height: 130px" class="row">
						<div class="col" style="padding-left: 70px">
							<div class="d-flex flex-column">
								<div class="d-flex justify-content-start gap-3 pt-4" >
									<div>
										<input type="radio" value="secret" name="type" id="secret" /> 
									</div>
									<div>
										<label for="secret" style="cursor: pointer;">
											<Strong style="font-size: 14px">비공개 밴드</Strong><br/>
											<span style="font-size: 13px"> 밴드와 게시글이 공개되지 않습니다. <br/>초대를 통해서만 가입할 수 있습니다. </span>
										</label>
									</div>
								</div>
							</div>
						</div>
						<div class="col">
							<div class="d-flex flex-column">
								<div class= "d-flex justify-content-start gap-3 pt-4" style="cursor: pointer;">
									<div>
										<input type="radio" value="open" name="type" id="open" /> 
									</div>
									<div>
										<label for="open" style="cursor: pointer;"> 
											<strong style="font-size: 14px">공개 밴드</strong> <br/>
											<span style="font-size: 13px"> 누구나 밴드를 검색해 찾을 수 있고,<br/> 밴드 소개와 게시글을 볼 수 있습니다. </span>
										</label>
									</div>
								</div>
							</div>                    
						</div>
					</div>
				</div>
				<div class="d-flex justify-content-center gap-4">
					<div>
						<button onclick="location.href='${pageContext.servletContext.contextPath }/home'" type="button" style="width: 150px; height: 42px; border: 1px solid #E2E2E2" class="rounded-1">
							취소
						</button>
					</div>
					<div>
						<button id="submitbutton" type="submit" class="btn btn-secondary " style="width: 150px; height: 42px" disabled="disabled">
							완료
						</button>
					</div>
				</div>
			
			</form>
		</div>
	</div>

	 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" ></script>

	<script>
	
		//기본이미지 중 택해서 미리보기 
		const images = document.querySelectorAll(".defaultButton");
		images.forEach(function(evt) {
			evt.onclick = function(e) {
				document.querySelector('#imageView').src = e.target.src;

			}
		})

		//파일 직접선택 후 미리보기
		let file;
		document.querySelector("#bandimage").onchange = function(e) {

			file = e.target.files[0];
			if (e.target.files[0]) {
				var fileReader = new FileReader();
				fileReader.readAsDataURL(e.target.files[0]);
				fileReader.onload = function(e) {
					document.querySelector('#imageView').src = e.target.result;
				}
			}

		}
		
		// 밴드이름 미기입시 완료버튼 비활성화
		const target = document.querySelector("#submitbutton");
		
		document.querySelector("#bandRoomName").onchange = function(e) {
			if(!e.target.value){
				target.disabled = true;
			}else{
				target.disabled = false;
				
				// 완료 클릭 時 컨트롤러로 이미지 url 전송
				target.onclick = function(e){
					let imageUrl = document.querySelector('#imageView').src;
					console.log(document.querySelector('#imageView').src);
					document.querySelector('#coverImageUrl').value = imageUrl;
				}
			}
		}
	</script>

</body>
</html>