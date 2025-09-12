<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    body {
        margin: 0; padding: 0; font-family: 'Noto Sans KR', sans-serif;
        background: #f5f2ed; color: #2c2c2c;
        display: flex; /* a a 수직/수평 중앙 정렬을 위해 추가 */
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    /* a a 로그인 폼을 감싸는 카드 */
    .login-card {
        background: #fff;
        border-radius: 12px;
        padding: 40px 50px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        width: 100%;
        max-width: 420px;
    }

    .login-card h1 {
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

    /* a a 버튼 */
    .btn-custom {
        width: 100%; 
        text-decoration: none; padding: 12px 22px; border: none;
        border-radius: 25px; font-size: 16px; font-weight: bold;
        cursor: pointer; transition: 0.3s;
        display: block; 
        text-align: center;
    }
    .btn-primary-custom { background-color: #5a3825; color: white; margin-bottom: 10px; }
    .btn-primary-custom:hover { background-color: #d97904; }
    .btn-secondary-custom { background-color: #e0e0e0; color: #555; }
    .btn-secondary-custom:hover { background-color: #c7c7c7; }
    
    /* a a 에러 메시지 */
    .alert-custom-danger {
        margin-bottom: 20px; padding: 15px; border-radius: 25px; text-align: center;
        border: 2px dashed #c0392b;
        background: #fcdada; color: #c0392b;
        font-size: 14px;
    }
</style>
</head>
<body>

    <div class="login-card">
        <h1>로그인</h1>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert-custom-danger">
                ${errorMessage}
            </div>
        </c:if>

        <form action="<c:url value='/login.do'/>" method="post">
            <div class="form-group">
                <label for="username" class="form-label">아이디</label>
                <input type="text" class="form-control-custom" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password" class="form-label">비밀번호</label>
                <input type="password" class="form-control-custom" id="password" name="password" required>
            </div>
            
            <button class="btn-custom btn-primary-custom" type="submit">로그인</button>
        </form>
        
        <a href="<c:url value='/register.do'/>" class="btn-custom btn-secondary-custom">
            회원가입
        </a>
    </div>

</body>
</html>