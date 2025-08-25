<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 대여 관리 시스템</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
	// '도서 목록' 페이지로 이동
	function showBookList() {
		location.href = "<c:url value='/bookLoan.do'/>";
	}

	// 로그아웃
	function out() {
		location.href = "<c:url value='/logout.do'/>";
	}

	// 도서 검색
	function searchBooks() {
		const searchKeyword = document.getElementById('searchKeyword').value;
		location.href = "<c:url value='/bookLoan.do'/>?searchKeyword=" + encodeURIComponent(searchKeyword);
	}

	// ✨ [변경] '대여 중'인 도서 클릭 시 페이지 이동을 막는 함수
	function checkBookStatus(element) {
		const status = element.dataset.status; // data-status 속성 값 가져오기
		if (status === "unavailable") {
			alert('대여중인 책입니다.');
			return false; // a태그의 링크 이동(기본 동작)을 막음
		}
		return true; // 링크 이동을 허용
	}
</script>
</head>
<body>
	<div class="container mt-4">
		<h2 class="mb-4">📚 도서 대여 관리 시스템</h2>

		<nav class="mb-4">
			<a href="#" onclick="showBookList(); return false;" class="btn btn-outline-primary me-2">도서 목록</a> 
			<a href="<c:url value='/myLoans.do'/>" class="btn btn-outline-secondary">대여 현황</a> 
			<a href="<c:url value='/loanList.do'/>" class="btn btn-outline-secondary">대여 기록</a> 
			<a href="#" onclick="out()" class="btn btn-outline-secondary">로그아웃</a>
			<c:if test="${not empty sessionScope.loginVO && sessionScope.loginVO.role eq 'admin'}">
				<a href="<c:url value='/admin/bookList.do'/>" class="btn btn-outline-danger">도서 관리</a>
			</c:if>
		</nav>

		<div class="input-group mb-3">
			<input type="text" id="searchKeyword" class="form-control" placeholder="도서 제목 또는 저자를 입력하세요">
			<button class="btn btn-outline-primary" type="button" onclick="searchBooks()">검색</button>
		</div>

		<div id="content">
			<c:if test="${not empty bookList}">
				<table class="table table-striped table-hover">
					<thead class="table-dark">
						<tr>
							<th>ID</th>
							<th>제목</th>
							<th>저자</th>
							<th>출판사</th>
							<th>대여 가능 여부</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="book" items="${bookList}">
							<tr>
								<td><c:out value="${book.bookId}" /></td>
								<td>
									<a href="<c:url value='/bookDetail.do?bookId=${book.bookId}'/>"
									   data-status="${book.status}"
									   onclick="return checkBookStatus(this);">
										<c:out value="${book.title}" />
									</a>
								</td>
								<td><c:out value="${book.author}" /></td>
								<td><c:out value="${book.publisher}" /></td>
								<td>
									<c:choose>
										<c:when test="${book.status eq 'available'}">
											<span class="badge bg-success">대여 가능</span>
										</c:when>
										<c:otherwise>
											<span class="badge bg-danger">대여 중</span>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:if>
		</div>
	</div>
</body>
</html>