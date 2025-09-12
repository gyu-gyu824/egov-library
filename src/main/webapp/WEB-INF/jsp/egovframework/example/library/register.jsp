<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<div class="container d-flex justify-content-center align-items-center" style="height: 100vh;">
		<div class="p-4 border rounded shadow-sm" style="width: 100%; max-width: 450px;">
			<main class="form-signin">
				<h1 class="h3 mb-3 fw-normal text-center">회원가입</h1>
				
				<form action="<c:url value='/register.do'/>" method="post" onsubmit="return validateForm()">
					
					<div class="mb-3">
						<label for="username" class="form-label">아이디</label>
						<div class="input-group">
							<input type="text" class="form-control" id="username" name="username" placeholder="아이디" required>
							<button class="btn btn-outline-secondary" type="button" onclick="checkUsername()">중복 확인</button>
						</div>
						<div id="username-message" class="form-text"></div>
					</div>

					<div class="mb-3">
						<label for="password" class="form-label">비밀번호</label>
						<input type="password" class="form-control" id="password" name="password" placeholder="비밀번호" required>
					</div>

					<div class="mb-3">
						<label for="passwordConfirm" class="form-label">비밀번호 확인</label>
						<input type="password" class="form-control" id="passwordConfirm" name="passwordConfirm" placeholder="비밀번호 확인" required>
						<div id="password-message" class="form-text"></div>
					</div>
					
					<div class="mb-3">
						<label for="name" class="form-label">이름</label>
						<input type="text" class="form-control" id="name" name="name" placeholder="이름" required>
					</div>

					<div class="mb-3">
						<label for="phone" class="form-label">전화번호</label>
						<input type="text" class="form-control" id="phone" name="phone" placeholder="전화번호" required>
					</div>
					
					<button id="submitBtn" class="w-100 btn btn-lg btn-primary" type="submit">가입하기</button>
				</form>

				<div class="mt-3 text-center">
					<a href="<c:url value='/login.do'/>" class="btn btn-link">로그인 페이지로 돌아가기</a>
				</div>
			</main>
		</div>
	</div>

	<script>
		// 아이디 중복 확인 여부를 저장하는 변수
		let isUsernameChecked = false;
		let isUsernameAvailable = false;
		
		// 아이디 입력창에 변경이 생기면, 중복 확인 상태를 초기화
		$('#username').on('keyup', function() {
			isUsernameChecked = false;
			isUsernameAvailable = false;
			$('#username-message').text('');
		});

		// 아이디 중복 확인 함수 (AJAX 호출)
		function checkUsername() {
			const username = $('#username').val();

			if (username.trim() === '') {
				alert('아이디를 입력해주세요.');
				return;
			}
			$.ajax({
				url:'<c:url value="/checkUsername.do"/>',
				type: 'POST',
				data: {username: username},
				success: function(data){
					isUsernameChecked = true; // 중복 확인을 시도했음
					if (data.isDuplicate){
						$('#username-message').text('이미 사용중인 아이디입니다.').css('color', 'red');
						isUsernameAvailable = false;
					} else {
						$('#username-message').text('사용 가능한 아이디입니다.').css('color', 'green');
						isUsernameAvailable = true;
					}	
				},
				error: function() {
					alert("아이디 중복 확인 중 오류가 발생했습니다.");
				}
			});
		}
		
		// 비밀번호 일치 여부를 실시간으로 확인하는 함수
		function checkPasswordMatch() {
			const password = $("#password").val();
			const passwordConfirm = $("#passwordConfirm").val();
			const message = $("#password-message");

			if (password || passwordConfirm) {
				if (password === passwordConfirm) {
					message.text('비밀번호가 일치합니다.').css('color', 'green');
				} else {
					message.text('비밀번호가 일치하지 않습니다.').css('color', 'red');
				}
			} else {
				message.text('');
			}
		}

		// 비밀번호와 비밀번호 확인 입력창에 keyup 이벤트 핸들러 연결
		$("#password, #passwordConfirm").on("keyup", checkPasswordMatch);
		
		// 최종 폼 유효성 검사 함수
		function validateForm() {
			const password = $("#password").val();
			const passwordConfirm = $("#passwordConfirm").val();
			
			if (!isUsernameChecked) {
				alert('아이디 중복 확인을 해주세요.');
				return false;
			}
			
			if (!isUsernameAvailable) {
				alert('사용할 수 없는 아이디입니다. 다른 아이디를 입력해주세요.');
				return false;
			}
			
			if (password !== passwordConfirm) {
				alert('비밀번호가 일치하지 않습니다.');
				return false;
			}
			
			// 모든 검사를 통과하면 폼 제출
			return true;
		}
	</script>
</body>
</html>