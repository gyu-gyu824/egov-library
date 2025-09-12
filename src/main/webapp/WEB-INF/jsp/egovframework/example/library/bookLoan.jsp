 Gemini와의 대화
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>



<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>도서 대여 관리 시스템</title>

<!-- 페이지네이션은 부트스트랩 스타일 사용 -->

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

/* 도서 목록 */
.book-table {
	width: 100%;
	border-spacing: 0 15px;
}

.book-table tr {
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
	transition: transform 0.2s, box-shadow 0.2s;
}

.book-table tr:hover {
	transform: translateY(-4px);
	box-shadow: 0 5px 12px rgba(0, 0, 0, 0.15);
}

.book-table td {
	padding: 18px;
	font-size: 15px;
}

.book-table td:first-child {
	font-weight: bold;
	font-size: 17px;
	color: #5a3825;
}

.book-table a {
	text-decoration: none;
	color: inherit;
}

.book-table a:hover {
	text-decoration: underline;
	color: #d97904;
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

/* 경고 박스 */
.alert-custom {
	margin-top: 40px;
	padding: 30px;
	background: #fff4e6;
	border: 2px dashed #e67e22;
	text-align: center;
	border-radius: 12px;
}

.book-table thead th {
	padding: 12px 18px;
	font-size: 14px;
	font-weight: bold;
	color: #8a6d59;
	text-align: left;
	border-bottom: 2px solid #e0d9c9;
}

/* 각 컬럼의 정렬을 맞추기 위한 추가 스타일 */
.book-table tbody td, .book-table thead th {
	box-sizing: border-box;
}
</style>



<script type="text/javascript">
	function fn_link_page(pageNo) {

		document.listForm.pageIndex.value = pageNo;

		document.listForm.action = "<c:url value='/bookLoan.do'/>";

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

	function checkBookStatus(element) {

		const currentQuantity = element.dataset.quantity;

		if (currentQuantity <= 0) {

			alert('대여 가능한 책이 없습니다.');

			return false;

		}

		return true;

	}
</script>

</head>

<body>

	<!-- 상단 네비게이션 -->

	<div class="navbar">

		<h1>📚 도서 대여 시스템</h1>

		<div class="nav-buttons">

			<a href="<c:url value='/bookLoan.do'/>" class="primary">도서 목록</a> <a
				href="<c:url value='/myLoans.do'/>" class="secondary">대여 현황</a> <a
				href="<c:url value='/loanList.do'/>" class="secondary">대여 기록</a>

			<c:if
				test="${not empty sessionScope.loginVO && sessionScope.loginVO.role eq 'admin'}">

				<a href="<c:url value='/admin/bookList.do'/>" class="secondary">관리자</a>

			</c:if>

			<a href="#" onclick="out()" class="secondary">로그아웃</a>

		</div>

	</div>



	<form:form modelAttribute="bookVO" name="listForm" id="listForm"
		method="get">

		<div class="wrapper">

			<h2>도서 검색</h2>

			<div class="search-box">

				<form:input path="searchKeyword" id="searchKeyword"
					placeholder="도서 제목 또는 저자를 입력하세요" />

				<button type="button" onclick="fn_search()">검색</button>

			</div>



			<div id="content">

				<c:choose>

					<c:when test="${not empty bookList}">

						<table class="book-table">
							<thead>
								<tr>
									<th>제목</th>
									<th>저자</th>
									<th>출판사</th>
									<th>상태</th>
								</tr>
							</thead>

							<tbody>

								<c:forEach var="book" items="${bookList}">

									<tr>

										<td><a
											href="<c:url value='/bookDetail.do?bookId=${book.bookId}'/>"
											data-quantity="${book.currentQuantity}"
											onclick="return checkBookStatus(this);"> <c:out
													value="${book.title}" />

										</a></td>

										<td><c:out value="${book.author}" /></td>

										<td><c:out value="${book.publisher}" /></td>

										<td><c:choose>

												<c:when test="${book.currentQuantity > 0}">

													<span class="badge-custom success">대여 가능
														(${book.currentQuantity})</span>

												</c:when>

												<c:otherwise>

													<span class="badge-custom danger">대여 불가</span>

												</c:otherwise>

											</c:choose></td>

									</tr>

								</c:forEach>

							</tbody>

						</table>

					</c:when>

					<c:otherwise>

						<div class="alert-custom">

							<h4>검색 결과가 없거나 등록된 도서가 없습니다.</h4>

						</div>

					</c:otherwise>

				</c:choose>

			</div>



			<!-- 페이지네이션 (기존 Bootstrap 스타일 유지) -->

			<div class="d-flex justify-content-center">

				<ui:pagination paginationInfo="${paginationInfo}" type="bootstrap"
					jsFunction="fn_link_page" />

			</div>



			<form:hidden path="pageIndex" />

		</div>

	</form:form>

</body>

</html>