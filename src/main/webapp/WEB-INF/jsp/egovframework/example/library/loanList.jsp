<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 대여 기록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
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
	max-width: 1000px;
	margin: 40px auto;
	padding: 20px;
}

h2 {
	text-align: center;
	margin-bottom: 25px;
	font-size: 28px;
	color: #5a3825;
}

/* 검색창 */
.search-box {
	display: flex;
	justify-content: center;
	margin-bottom: 30px;
}

.search-box input {
	width: 70%;
	padding: 12px 15px;
	border: 2px solid #d6c3a3;
	border-right: none;
	border-radius: 25px 0 0 25px;
	outline: none;
	font-size: 15px;
	background-color: #fff;
}

.search-box button {
	padding: 12px 20px;
	border: none;
	border-radius: 0 25px 25px 0;
	background-color: #5a3825;
	color: white;
	font-size: 15px;
	cursor: pointer;
	transition: 0.3s;
}

.search-box button:hover {
	background-color: #d97904;
}

/* 테이블 전체 */
.book-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 15px; 
}

/* 테이블 제목(thead)과 내용(td)의 공통 스타일 */
.book-table th, .book-table td {
    padding: 18px;
    vertical-align: middle;
    text-align: left;
}

/* 테이블 제목(thead) 스타일 */
.book-table thead th {
    font-size: 14px;
    font-weight: bold;
    color: #8a6d59;
    border-bottom: 2px solid #e0d9c9;
    padding-top: 12px;
    padding-bottom: 12px;
}

/* 테이블 내용 행(tbody tr) 스타일 */
.book-table tbody tr {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s, box-shadow 0.2s;
}

.book-table tbody tr:hover {
    transform: translateY(-4px);
    box-shadow: 0 5px 12px rgba(0, 0, 0, 0.15);
}

/* 첫 번째 td(제목) 스타일 */
.book-table td:first-child {
    font-weight: bold;
    font-size: 17px;
    color: #5a3825;
}

/* /* 상태 배지 공통 스타일 */
.badge-custom {
    display: inline-block;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: bold;
} */

.badge-custom.danger {
	background-color: #fcdada;
	color: #c0392b;
}

.badge-custom.info {
	background-color: #e8e8e8;
	color: #5d5d5d;
}

/* 경고 및 에러 메시지 박스 */
.alert-custom {
	margin-top: 40px;
	padding: 30px;
	background: #fff4e6;
	border: 2px dashed #e67e22;
	text-align: center;
	border-radius: 12px;
}

.alert-custom-error {
	margin-bottom: 20px;
	padding: 20px;
	background: #fcdada;
	border: 2px dashed #c0392b;
	text-align: center;
	border-radius: 12px;
	color: #c0392b;
	font-weight: bold;
}

/* 하단 액션 버튼 영역 */
.action-area {
	text-align: right;
	margin-top: 25px;
}

.btn-excel {
	padding: 10px 20px;
	border: none;
	border-radius: 25px;
	background-color: #1D6F42;
	color: white;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
}

.btn-excel:hover {
	background-color: #165934;
}
</style>

<script type="text/javascript">
        function fn_link_page(pageNo){
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/loanList.do'/>";
            document.listForm.submit();
        }

        function fn_search() {
            const searchKeyword = $("#searchKeyword").val();
            if (searchKeyword.trim().length === 0) {
                alert("검색어를 입력해주세요.");
                $("#searchKeyword").val("");
                return;
            }
            document.listForm.pageIndex.value = 1;
            document.listForm.submit();
        }

        function out() {
            location.href = "<c:url value='/logout.do'/>";
        }
    </script>
</head>
<body>
	<div class="navbar">
		<h1>📚 도서 대여 시스템</h1>
		<div class="nav-buttons">
			<a href="<c:url value='/bookLoan.do'/>" class="secondary">도서 목록</a> <a
				href="<c:url value='/myLoans.do'/>" class="secondary">대여 현황</a> <a
				href="<c:url value='/loanList.do'/>" class="primary">대여 기록</a>
			<c:if
				test="${not empty sessionScope.loginVO && sessionScope.loginVO.role eq 'admin'}">
				<a href="<c:url value='/admin/bookList.do'/>" class="secondary">관리자</a>
			</c:if>
			<a href="#" onclick="out()" class="secondary">로그아웃</a>
		</div>
	</div>

	<div class="wrapper">
		<h2 class="mb-4">📜 나의 대여 기록</h2>

		<c:if test="${not empty errorMessage}">
			<div class="alert-custom-error">${errorMessage}</div>
		</c:if>

		<form:form modelAttribute="bookVO" name="listForm" id="listForm"
			method="get">
			<div class="search-box">
				<form:input path="searchKeyword" id="searchKeyword"
					placeholder="기록에서 책 제목 또는 저자 검색" />
				<button type="button" onclick="fn_search()">검색</button>
			</div>

			<div id="content">
				<c:choose>
					<c:when test="${not empty loanHistory}">
						<table class="book-table">
							<thead>
								<tr>
									<th>제목</th>
									<th>저자</th>
									<th>대여일</th>
									<th>반납일</th>
									<th>상태</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="book" items="${loanHistory}">
									<tr>
										<td><c:out value="${book.title}" /></td>
										<td><c:out value="${book.author}" /></td>

										<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm"
												value="${book.loanDate}" /></td>

										<td><c:if test="${not empty book.returnDate}">
												<fmt:formatDate pattern="yyyy-MM-dd HH:mm"
													value="${book.returnDate}" />
											</c:if></td>

										<td><c:choose>
												<c:when test="${book.status eq 'loaned'}">
													<span class="badge-custom danger">대여 중</span>
												</c:when>
												<c:otherwise>
													<span class="badge-custom info">반납 완료</span>
												</c:otherwise>
											</c:choose></td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</c:when>
					<c:otherwise>
						<div class="alert-custom">
							<c:choose>
								<c:when test="${not empty bookVO.searchKeyword}">
									<h4>
										'<strong><c:out value="${bookVO.searchKeyword}" /></strong>'(으)로
										검색된 대여 기록이 없습니다.
									</h4>
								</c:when>
								<c:otherwise>
									<h4>대여 기록이 없습니다.</h4>
								</c:otherwise>
							</c:choose>
						</div>
					</c:otherwise>
				</c:choose>
			</div>

			<div class="d-flex justify-content-center mt-5">
				<ui:pagination paginationInfo="${paginationInfo}" type="bootstrap"
					jsFunction="fn_link_page" />
			</div>

			<form:hidden path="pageIndex" />
		</form:form>

		<div class="action-area">
			<form id="excelForm"
				action="<c:url value='/downloadLoanHistory.do'/>" method="post"
				target="_blank">
				<input type="hidden" name="searchKeyword"
					value="${bookVO.searchKeyword}" />
				<input type="hidden" name="pageIndex" value="${bookVO.pageIndex}" />
				<button type="submit" class="btn-excel">대여 기록 출력</button>
			</form>
		</div>
	</div>
</body>
</html>