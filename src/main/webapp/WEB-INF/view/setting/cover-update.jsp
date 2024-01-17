<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>BAND</title>
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
			<form action="${pageContext.servletContext.contextPath }/band/${bandRoom.bandRoomId}/setting/cover-update" method="post" enctype="multipart/form-data">
			<input type="hidden" value="" name="coverImageUrl" id="coverImageUrl">
				<div style="width: 100%" class="mb-3">
					<div class="mb-3">
						<span style="font-size: 14px" class="fw-bold">밴드 이름</span>
					</div>
					<div>
						<input type="text" name="bandRoomName" value="${bandRoom.bandRoomName }" id="bandRoomName"
							class="border-bottom"
							style="border: none; width: 100%; outline: none; line-height: 54px; font-size: 30px; font-weight: 400;"
							maxlength="50">
					</div>
				</div>
				<div class="row">
					<div class="col">
						<div style="overflow-x: auto; margin-top: 7px">
							<img
								src="${contextPath}${bandRoom.coverImageUrl}"
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
					<div class="mb-3">
						<span style="font-size: 14px" class="fw-bold">밴드 컬러</span>
					</div>
					<div class="form-check " style="">
						<input type="radio" class="btn-check" name="bandRoomColor" id="option1" autocomplete="off" ${bandRoom.bandRoomColor eq 'c00C737' ? 'checked' : '' } value="c00C737">
						<label class="btn rounded-circle" for="option1" style="width: 30px; height: 30px; background-color: #00C73C; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option2" autocomplete="off" ${bandRoom.bandRoomColor eq 'c00B1A0' ? 'checked' : '' } value="c00B1A0">
						<label class="btn rounded-circle" for="option2" style="width: 30px; height: 30px; background-color: #00B1A0; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option3" autocomplete="off" ${bandRoom.bandRoomColor eq 'c1BA7E9' ? 'checked' : '' } value="c1BA7E9">
						<label class="btn rounded-circle" for="option3" style="width: 30px; height: 30px; background-color: #1BA7E9; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option4" autocomplete="off" ${bandRoom.bandRoomColor eq 'c8367EB' ? 'checked' : '' } value="c8367EB">
						<label class="btn rounded-circle" for="option4" style="width: 30px; height: 30px; background-color: #8367EB; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option5" autocomplete="off" ${bandRoom.bandRoomColor eq 'cFC5460' ? 'checked' : '' } value="cFC5460">
						<label class="btn rounded-circle" for="option5" style="width: 30px; height: 30px; background-color: #FC5460; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option6" autocomplete="off" ${bandRoom.bandRoomColor eq 'cFC6342' ? 'checked' : '' } value="cFC6342">
						<label class="btn rounded-circle" for="option6" style="width: 30px; height: 30px; background-color: #FC6342; border: none; margin-right: 30px"></label>					
						<input type="radio" class="btn-check" name="bandRoomColor" id="option7" autocomplete="off" ${bandRoom.bandRoomColor eq 'cFFA91C' ? 'checked' : '' } value="cFFA91C">
						<label class="btn rounded-circle" for="option7" style="width: 30px; height: 30px; background-color: #FFA91C; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option8" autocomplete="off" ${bandRoom.bandRoomColor eq 'c909090' ? 'checked' : '' } value="c909090">
						<label class="btn rounded-circle" for="option8" style="width: 30px; height: 30px; background-color: #909090; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option9" autocomplete="off" ${bandRoom.bandRoomColor eq 'c5879EA' ? 'checked' : '' } value="c5879EA">
						<label class="btn rounded-circle" for="option9" style="width: 30px; height: 30px; background-color: #5879EA; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option10" autocomplete="off" ${bandRoom.bandRoomColor eq 'c424B52' ? 'checked' : '' } value="c424B52">
						<label class="btn rounded-circle" for="option10" style="width: 30px; height: 30px; background-color: #424B52; border: none; margin-right: 30px"></label>
						<input type="radio" class="btn-check" name="bandRoomColor" id="option11" autocomplete="off" ${bandRoom.bandRoomColor eq 'cF85C8E' ? 'checked' : '' } value="cF85C8E">
						<label class="btn rounded-circle" for="option11" style="width: 30px; height: 30px; background-color: #F85C8E; border: none"></label>
					</div>
				</div>
				<div class="d-flex justify-content-center gap-4">
					<div>
						<button onclick="location.href='${pageContext.servletContext.contextPath }/index'" type="button" style="width: 150px; height: 42px; border: 1px solid #E2E2E2" class="rounded-1">
							취소
						</button>
					</div>
					<div>
						<button id="submitbutton" type="submit" class="btn btn-secondary " style="width: 150px; height: 42px">
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
		

		const target = document.querySelector("#submitbutton");
		
		// 완료 클릭 時 컨트롤러로 이미지 url 전송
		target.onclick = function(e){
			let imageUrl = document.querySelector('#imageView').src;
			console.log(document.querySelector('#imageView').src);
			document.querySelector('#coverImageUrl').value = imageUrl;
		}
		
	</script>

</body>
</html>