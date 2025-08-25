<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<!-- Bootstrap CSS 링크 -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

	<div class="container d-flex justify-content-center align-items-center"
		style="height: 100vh;">
		<div class="p-4 border rounded shadow-sm"
			style="width: 100%; max-width: 400px;">
			<main class="form-signin">
				<h1 class="h3 mb-3 fw-normal text-center">로그인</h1>
				<%-- 로그인 폼 --%>
				<form action="<c:url value='/login.do'/>" method="post">
					<div class="form-floating mb-3">
						<input type="text" class="form-control" id="username"
							name="username" placeholder="아이디" required> <label
							for="username">아이디</label>
					</div>
					<div class="form-floating mb-3">
						<input type="password" class="form-control" id="password"
							name="password" placeholder="비밀번호" required> <label
							for="password">비밀번호</label>
					</div>
					<button class="w-100 btn btn-lg btn-primary" type="submit">로그인</button>
				</form>
				<div class="mt-3">
					<a href="<c:url value='/register.do'/>" class="d-block">
						<button class="w-100 btn btn-lg btn-secondary" type="button">회원가입</button>
					</a>
				</div>
			</main>
		</div>
	</div>
</body>
</html>