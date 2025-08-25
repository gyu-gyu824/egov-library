<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<!-- Bootstrap CSS 링크 -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<!-- jQuery 링크 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
/* CSS 스타일을 추가하여 메시지 표시 */
.message {
    font-size: 0.875em;
}
.text-success {
    color: #198754 !important;
}
.text-danger {
    color: #dc3545 !important;
}
</style>
</head>
<body>

	<div class="container d-flex justify-content-center align-items-center"
		style="height: 100vh;">
		<div class="p-4 border rounded shadow-sm"
			style="width: 100%; max-width: 450px;">
			<main class="form-signin">
				<h1 class="h3 mb-3 fw-normal text-center">회원가입</h1>
				
				<%-- 회원가입 폼 --%>
				<form action="<c:url value='/register.do'/>" method="post" onsubmit="return validateForm()">
					
					<!-- 아이디 입력 필드와 중복 확인 버튼 -->
					<div class="mb-3">
						<label for="username" class="form-label">아이디</label>
						<div class="input-group">
							<input type="text" class="form-control" id="username"
								name="username" placeholder="아이디" required>
							<button class="btn btn-outline-secondary" type="button" onclick="checkUsername()">중복 확인</button>
						</div>
						<span id="username-message" class="message"></span>
					</div>

					<!-- 비밀번호 입력 필드 -->
					<div class="mb-3">
						<label for="password" class="form-label">비밀번호</label>
						<input type="password" class="form-control" id="password"
							name="password" placeholder="비밀번호" required>
					</div>

					<!-- 비밀번호 확인 입력 필드 -->
					<div class="mb-3">
						<label for="password2" class="form-label">비밀번호 확인</label>
						<input type="password" class="form-control" id="password2"
							name="password2" placeholder="비밀번호 확인" required>
						<span id="password-match-message" class="message"></span>
					</div>
					
					<!-- 이름 입력 필드 -->
					<div class="mb-3">
						<label for="name" class="form-label">이름</label>
						<input type="text" class="form-control" id="name"
							name="name" placeholder="이름" required>
					</div>

					<!-- 전화번호 입력 필드 -->
					<div class="mb-3">
						<label for="phone" class="form-label">전화번호</label>
						<input type="text" class="form-control" id="phone"
							name="phone" placeholder="전화번호" required>
					</div>
					
					<!-- 회원가입 버튼 -->
					<button class="w-100 btn btn-lg btn-primary" type="submit">가입하기</button>
				</form>

				<!-- 로그인 페이지로 돌아가기 버튼 -->
				<div class="mt-3 text-center">
					<a href="<c:url value='/login.do'/>" class="btn btn-link" type="button">로그인 페이지로 돌아가기</a>
				</div>
			</main>
		</div>
	</div>

	<script>
		// 아이디 중복 확인 여부를 저장하는 변수
		let isUsernameChecked = false;
		let isUsernameDuplicated = true;

		// 아이디 중복 확인 함수 (AJAX 호출)
		function checkUsername() {
			const username = $('#username').val();

			// 아이디가 비어있는지 확인
			if (username.trim() === '') {
				alert('아이디를 입력해주세요');
				isUsernameChecked = false;
				isUsernameDuplicated = true;
				return;
			}
			$.ajax({
				url:'<c:url value="/checkUsername.do"/>',
				type: 'POST',
				data: {username: username},
				success:function(data){
					if (data.isDuplicate){
						alert('이미 사용중인 아이디입니다');
						isUsernameChecked = true;
						isUsernameDuplicated = true;
					}else {
						alert('사용 가능한 아이디입니다');
						isUsernameChecked = true; // 중복 확인 완료 상태로 변경
						isUsernameDuplicated = false; // 중복되지 않음
					}	
				},
				error: function(xhr, status, error) {
					// AJAX 요청이 실패했을 때 실행되는 코드
					console.error("AJAX Error:", status, error);
					alert("AJAX 요청 실패: 서버에서 오류가 발생했습니다. 콘솔을 확인해주세요.");
					isUsernameChecked = false;
					isUsernameDuplicated = true;
				}
			});
		}
		
		function validateForm(){
			const password = $("#password").val();
			const password2 = $("#password2").val();
			
			if (password != password2){
				alert('비밀번호가 일치하지 않습니다');
				return false;
			}
			
			if (!isUsernameChecked){
				alert('아이디 중복확인을 해주세요');
				return false;
			}
			
			if (isUsernameDuplicated){
				alert('중복된 아이디입니다');
				return false;
			}
			
			alert('회원가입이 완료되었습니다');
			return true;
		}
	</script>
</body>
</html>
