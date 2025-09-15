<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    /* ================================================================
       회원가입 페이지 전용 스타일
       ================================================================ */
    body {
        margin: 0; padding: 0; font-family: 'Noto Sans KR', sans-serif;
        background: #f5f2ed; color: #2c2c2c;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh; /* a a 내용이 길어져도 중앙 정렬 유지 */
        padding: 40px 0; /* a a 화면이 작을 때 상하 여백 추가 */
    }

    /* a a 폼을 감싸는 카드 */
    .register-card {
        background: #fff;
        border-radius: 12px;
        padding: 40px 50px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        width: 100%;
        max-width: 480px; /* 로그인 폼보다 너비를 약간 넓게 */
    }

    .register-card h1 {
        text-align: center;
        margin-bottom: 30px;
        font-size: 28px;
        font-weight: bold;
        color: #5a3825;
    }

    /* a a 각 입력 필드 그룹 */
    .form-group {
        margin-bottom: 20px;
    }
    .form-label {
        display: block; font-weight: bold; color: #5a3825;
        margin-bottom: 8px; font-size: 15px;
    }
    .form-control-custom {
        width: 100%; padding: 12px 15px; border: 2px solid #d6c3a3;
        border-radius: 25px; outline: none; font-size: 15px;
        background-color: #fff; transition: border-color 0.3s, box-shadow 0.3s;
        box-sizing: border-box;
    }
    .form-control-custom:focus {
        border-color: #5a3825;
        box-shadow: 0 0 8px rgba(90, 56, 37, 0.2);
    }

    /* a a 아이디 + 중복확인 버튼 그룹 */
    .input-group-custom {
        display: flex;
    }
    .input-group-custom input {
        flex-grow: 1;
        border-right: none;
        border-radius: 25px 0 0 25px;
    }
    .input-group-custom button {
    padding: 12px 20px; 
    border: 2px solid #d6c3a3;
    border-left: none; 
    border-radius: 0 25px 25px 0;
    background-color: #f5f2ed;
    color: #5a3825;
    font-size: 15px; 
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
    box-sizing: border-box; 
}
    .input-group-custom button:hover {
        background-color: #e0d9c9;
    }

    /* a a 유효성 검사 메시지 */
    .validation-message {
        font-size: 13px;
        padding-left: 15px;
        margin-top: 5px;
    }

    /* a a 버튼 */
    .btn-custom {
        width: 100%;
        text-decoration: none; padding: 12px 22px; border: none;
        border-radius: 25px; font-size: 16px; font-weight: bold;
        cursor: pointer; transition: 0.3s;
        display: block;
        text-align: center;
    }
    .btn-primary-custom { background-color: #5a3825; color: white; margin-top: 10px; }
    .btn-primary-custom:hover { background-color: #d97904; }
    
    .login-link {
        display: block;
        text-align: center;
        margin-top: 20px;
        font-size: 14px;
        color: #8a6d59;
        text-decoration: none;
    }
    .login-link:hover {
        text-decoration: underline;
    }
</style>
</head>
<body>

    <div class="register-card">
        <h1>회원가입</h1>
        
        <form action="<c:url value='/register.do'/>" method="post" onsubmit="return validateForm()">
            
            <div class="form-group">
                <label for="username" class="form-label">아이디</label>
                <div class="input-group-custom">
                    <input type="text" class="form-control-custom" id="username" name="username" required>
                    <button type="button" onclick="checkUsername()">중복 확인</button>
                </div>
                <div id="username-message" class="validation-message"></div>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control-custom" id="password" name="password" required>
            </div>

            <div class="form-group">
                <label for="passwordConfirm" class="form-label">비밀번호 확인</label>
                <input type="password" class="form-control-custom" id="passwordConfirm" name="passwordConfirm" required>
                <div id="password-message" class="validation-message"></div>
            </div>
            
            <div class="form-group">
                <label for="name" class="form-label">이름</label>
                <input type="text" class="form-control-custom" id="name" name="name" required>
            </div>

            <div class="form-group">
                <label for="phone" class="form-label">전화번호</label>
                <input type="text" class="form-control-custom" id="phone" name="phone" required>
            </div>
            
            <button id="submitBtn" class="btn-custom btn-primary-custom" type="submit">가입하기</button>
        </form>

        <a href="<c:url value='/login.do'/>" class="login-link">로그인 페이지로 돌아가기</a>
    </div>

    <%-- a a 기존 자바스크립트 로직은 그대로 유지합니다 --%>
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