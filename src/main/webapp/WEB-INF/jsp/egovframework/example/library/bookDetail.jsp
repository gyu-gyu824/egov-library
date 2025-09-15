<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 상세 정보</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background: #f5f2ed;
            color: #2c2c2c;
        }

        /* 상단 네비게이션 */
        .navbar {
            background-color: #5a3825;
            color: #fff;
            display: flex;
            justify-content: space-between;
            padding: 14px 40px;
            align-items: center;
        }
        .navbar h1 {
            font-size: 20px;
            margin: 0;
            font-weight: bold;
        }
        .navbar .nav-buttons a {
            margin-left: 12px;
            text-decoration: none;
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 14px;
            color: #fff;
            transition: 0.3s;
        }
        .navbar .nav-buttons a.primary {
            background: #d97904;
        }
        .navbar .nav-buttons a.secondary {
            background: transparent;
            border: 1px solid #fff;
        }
        .navbar .nav-buttons a:hover {
            background: #f39c12;
        }

        /* 페이지 래퍼 */
        .wrapper {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 28px;
            color: #5a3825;
        }

        /* 상세 정보 카드 */
        .detail-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 40px 50px;
        }
        
        .detail-card dl {
            display: grid;
            grid-template-columns: 120px 1fr;
            gap: 18px 20px; 
            font-size: 16px;
        }
        
        .detail-card dt {
            font-weight: bold;
            color: #5a3825;
            text-align: right;
            padding-right: 20px;
            border-right: 2px solid #f5f2ed;
        }
        
        .detail-card dd {
            margin: 0;
            display: flex;
            align-items: center;
        }

        /* 상태 배지 */
        .badge-custom {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }
        .badge-custom.success {
            background-color: #d8f8d8;
            color: #2f8f2f;
        }
        .badge-custom.danger {
            background-color: #fcdada;
            color: #c0392b;
        }
        
        /* 버튼 그룹 */
        .button-group {
            text-align: center;
            margin-top: 40px;
        }
        
        .btn-action, .btn-secondary-custom {
            text-decoration: none;
            padding: 10px 22px;
            border: none;
            border-radius: 25px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            margin: 0 8px;
        }

        .btn-action {
            background-color: #d97904;
            color: white;
        }
        .btn-action:hover {
            background-color: #e67e22;
        }
        
        .btn-secondary-custom {
            background-color: #e0e0e0;
            color: #555;
        }
        .btn-secondary-custom:hover {
            background-color: #c7c7c7;
        }

    </style>
    
    <script>
        function loanBook(bookId) {
            if (confirm("이 책을 대여하시겠습니까?")) {
                $.ajax({
                    url: '<c:url value="/loanBook.do"/>',
                    type: 'POST',
                    data: { bookId: bookId },
                    success: function(response) {
                        alert(response.message || "대여가 완료되었습니다.");
                        location.reload();
                    },
                    error: function(xhr) {
                        alert(xhr.responseJSON.message || "대여 처리 중 오류가 발생했습니다.");
                    }
                });
            }
        }
        
        // 로그아웃 함수 추가
        function out() {
            location.href = "<c:url value='/logout.do'/>";
        }
    </script>
</head>
<body>
    <div class="navbar">
        <h1>📚 도서 대여 시스템</h1>
        <div class="nav-buttons">
            <a href="<c:url value='/bookLoan.do'/>" class="primary">도서 목록</a>
            <a href="<c:url value='/myLoans.do'/>" class="secondary">대여 현황</a>
            <a href="<c:url value='/loanList.do'/>" class="secondary">대여 기록</a>
            <c:if test="${not empty sessionScope.loginVO && sessionScope.loginVO.role eq 'admin'}">
                <a href="<c:url value='/admin/bookList.do'/>" class="secondary">관리자</a>
            </c:if>
            <a href="#" onclick="out()" class="secondary">로그아웃</a>
        </div>
    </div>

    <div class="wrapper">
        <h2 class="mb-4">📖 도서 상세 정보</h2>
        <div class="detail-card">
            <dl>
                <dt>제목</dt>
                <dd><c:out value="${book.title}" /></dd>

                <dt>저자</dt>
                <dd><c:out value="${book.author}" /></dd>

                <dt>출판사</dt>
                <dd><c:out value="${book.publisher}" /></dd>

                <dt>대여 상태</dt>
                <dd>
                    <c:choose>
                        <c:when test="${book.currentQuantity > 0}">
                            <span class="badge-custom success">대여 가능 (${book.currentQuantity}권)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-custom danger">대여 불가</span>
                        </c:otherwise>
                    </c:choose>
                </dd>
            </dl>
            
            <div class="button-group">
                <c:if test="${book.currentQuantity > 0}">
                    <button class="btn-action" onclick="loanBook(${book.bookId})">대여하기</button>
                </c:if>
                <a href="<c:url value='/bookLoan.do'/>" class="btn-secondary-custom">목록으로</a>
            </div>
        </div>
    </div>
</body>
</html>