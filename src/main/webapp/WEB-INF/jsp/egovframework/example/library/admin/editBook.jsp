<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자: 도서 수정</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    /* ================================================================
       공통 스타일
       ================================================================ */
    body {
        margin: 0; padding: 0; font-family: 'Noto Sans KR', sans-serif;
        background: #f5f2ed; color: #2c2c2c;
    }
    .wrapper { max-width: 800px; margin: 40px auto; padding: 20px; } /* 수정폼은 너비를 조금 줄임 */
    h2 { text-align: center; margin-bottom: 25px; font-size: 28px; color: #5a3825; }

    /* ================================================================
       관리자 페이지 전용 헤더
       ================================================================ */
    .admin-header {
        background-color: #3e2723; color: #fff; display: flex;
        justify-content: space-between; padding: 14px 40px; align-items: center;
    }
    .admin-header h1 { font-size: 20px; margin: 0; font-weight: bold; }
    .admin-header .nav-buttons a {
        margin-left: 12px; text-decoration: none; padding: 8px 14px;
        border-radius: 20px; font-size: 14px; color: #fff; transition: 0.3s;
        border: 1px solid #fff;
    }
    .admin-header .nav-buttons a:hover { background: #d97904; border-color: #d97904; }

    /* ================================================================
       폼 스타일
       ================================================================ */
    /* a a 폼을 감싸는 카드 */
    .form-card {
        background: #fff; border-radius: 12px;
        padding: 40px 50px; box-shadow: 0 5px 15px rgba(0,0,0,0.1);
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
    }
    .form-control-custom:focus {
        border-color: #5a3825;
        box-shadow: 0 0 8px rgba(90, 56, 37, 0.2);
    }
    
    /* a a 버튼 영역 */
    .button-group {
        display: flex; justify-content: flex-end;
        gap: 10px; margin-top: 30px;
    }

    /* 버튼 스타일 */
    .btn-custom {
        text-decoration: none; padding: 10px 22px; border: none;
        border-radius: 25px; font-size: 15px; font-weight: bold;
        cursor: pointer; transition: 0.3s;
    }
    .btn-primary-custom { background-color: #5a3825; color: white; }
    .btn-primary-custom:hover { background-color: #d97904; }
    .btn-secondary-custom { background-color: #e0e0e0; color: #555; }
    .btn-secondary-custom:hover { background-color: #c7c7c7; }
</style>

<script type="text/javascript">
    function out() {
        location.href = "<c:url value='/logout.do'/>";
    }
</script>
</head>
<body>

    <div class="admin-header">
        <h1>🧑‍💼 관리자 페이지</h1>
        <div class="nav-buttons">
            <a href="#" onclick="out()">로그아웃</a>
        </div>
    </div>
    
    <div class="wrapper">
        <h2 class="mb-4">✏️ 도서 수정: ${bookVO.title}</h2>
    
        <div class="form-card">
            <form:form modelAttribute="bookVO" action="${pageContext.request.contextPath}/admin/updateBook.do" method="post">
                
                <form:hidden path="bookId" />

                <div class="form-group">
                    <label for="title" class="form-label">제목</label>
                    <form:input path="title" cssClass="form-control-custom" />
                </div>
                <div class="form-group">
                    <label for="author" class="form-label">저자</label>
                    <form:input path="author" cssClass="form-control-custom" />
                </div>
                <div class="form-group">
                    <label for="publisher" class="form-label">출판사</label>
                    <form:input path="publisher" cssClass="form-control-custom" />
                </div>
                
                <div class="form-group">
                    <label for="totalQuantity" class="form-label">총 수량</label>
                    <form:input path="totalQuantity" cssClass="form-control-custom" type="number" />
                </div>
                 <div class="form-group">
                    <label for="currentQuantity" class="form-label">현재 수량 (대여 가능 수량)</label>
                    <form:input path="currentQuantity" cssClass="form-control-custom" type="number" />
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn-custom btn-primary-custom">수정 완료</button>
                    <a href="<c:url value='/admin/bookList.do'/>" class="btn-custom btn-secondary-custom">목록으로</a>
                </div>
            </form:form>
        </div>
    </div>
</body>
</html>