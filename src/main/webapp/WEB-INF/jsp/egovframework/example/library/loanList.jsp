<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 대여 기록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<div class="container mt-4">
		<h2 class="mb-4">📜 나의 대여 기록</h2>

		<nav class="mb-4">
			<a href="<c:url value='/bookLoan.do'/>"
				class="btn btn-outline-primary me-2">도서 목록</a> <a
				href="<c:url value='/myLoans.do'/>"
				class="btn btn-outline-secondary">대여 현황</a> <a
				href="<c:url value='/loanList.do'/>" class="btn btn-primary">대여
				기록</a> <a href="<c:url value='/logout.do'/>"
				class="btn btn-outline-danger">로그아웃</a>
		</nav>
		<div class="input-group mb-3">
			<input type="text" id="searchKeyword" class="form-control"
				placeholder="도서 제목 또는 저자로 기록 검색">
			<button class="btn btn-outline-primary" type="button"
				onclick="searchHistory()">검색</button>
		</div>

		<c:choose>
			<c:when test="${not empty loanHistory}">
				<table class="table table-striped table-hover">
					<thead class="table-dark">
						<tr>
							<th scope="col">ID</th>
							<th scope="col">제목</th>
							<th scope="col">저자</th>
							<th scope="col">출판사</th>
							<th scope="col">대여일</th>
							<th scope="col">반납일</th>
							<th scope="col">상태</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="book" items="${loanHistory}">
							<tr>
								<td><c:out value="${book.bookId}" /></td>
								<td><c:out value="${book.title}" /></td>
								<td><c:out value="${book.author}" /></td>
								<td><c:out value="${book.publisher}" /></td>
								<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm"
										value="${book.loanDate}" /></td>
								<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm"
										value="${book.returnDate}" /></td>
								<td><c:if test="${book.status == 'loaned'}">
										<span class="badge bg-danger">대여중</span>
									</c:if> <c:if test="${book.status == 'returned'}">
										<span class="badge bg-success">반납 완료</span>
									</c:if></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:when>
			<c:otherwise>
				<div class='alert alert-info text-center'
					style='padding: 2rem; margin-top: 2rem;'>
					<h2>대여 기록이 없습니다.</h2>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<script>
		// 대여 기록 내에서 검색하는 함수
		function searchHistory() {
			const searchKeyword = document.getElementById('searchKeyword').value;
			// 현재 페이지(대여 기록)에서 검색하도록 URL 변경
			location.href = "<c:url value='/loanList.do'/>?searchKeyword="
					+ encodeURIComponent(searchKeyword);
		}
	</script>
</body>
</html>