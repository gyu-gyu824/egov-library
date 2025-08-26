<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 대여 기록</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<div class="container mt-4">
		<h2 class="mb-4">📜 나의 대여 기록</h2>

		<nav class="mb-4">
			<a href="<c:url value='/bookLoan.do'/>" class="btn btn-outline-primary me-2">도서 목록</a> 
			<a href="<c:url value='/myLoans.do'/>" class="btn btn-outline-secondary">대여 현황</a>
			<a href="<c:url value='/loanList.do'/>" class="btn btn-primary">대여 기록</a>  
			<a href="#" onclick="out(); return false;" class="btn btn-outline-danger">로그아웃</a>
		</nav>
		
		<div class="input-group mb-3">
			<input type="text" id="searchKeyword" class="form-control" placeholder="기록에서 책 제목 또는 저자 검색" value="${pagination.searchKeyword}">
			<button class="btn btn-outline-primary" type="button" onclick="searchBooks()">검색</button>
		</div>

		<c:choose>
			<c:when test="${not empty loanHistory}">
				<table class="table table-striped table-hover">
					<thead class="table-dark">
						<tr>
							<th>ID</th>
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
								<td><c:out value="${book.bookId}" /></td>
								<td><c:out value="${book.title}" /></td>
								<td><c:out value="${book.author}" /></td>
								<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${book.loanDate}" /></td>
								<td>
									<c:if test="${not empty book.returnDate}">
										<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${book.returnDate}" />
									</c:if>
								</td>
								<td>
									<c:choose>
										<c:when test="${book.status eq 'loaned'}">
											<span class="badge bg-danger">대여 중</span>
										</c:when>
										<c:otherwise>
											<span class="badge bg-secondary">반납 완료</span>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<div class="d-flex justify-content-center">
					<ul class="pagination">
						<c:if test="${pagination.prev}">
							<li class="page-item"><a class="page-link" href="<c:url value='/loanList.do?page=${pagination.startPage - 1}&searchKeyword=${pagination.searchKeyword}'/>">&laquo;</a></li>
						</c:if>
						<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="pageNum">
							<li class="page-item <c:if test="${pagination.page == pageNum}">active</c:if>"><a class="page-link" href="<c:url value='/loanList.do?page=${pageNum}&searchKeyword=${pagination.searchKeyword}'/>">${pageNum}</a></li>
						</c:forEach>
						<c:if test="${pagination.next}">
							<li class="page-item"><a class="page-link" href="<c:url value='/loanList.do?page=${pagination.endPage + 1}&searchKeyword=${pagination.searchKeyword}'/>">&raquo;</a></li>
						</c:if>
					</ul>
				</div>

			</c:when>
			<c:otherwise>
				<div class="alert alert-warning text-center p-5 mt-4">
					<c:choose>
						<c:when test="${not empty pagination.searchKeyword}">
							<h4>'<strong><c:out value="${pagination.searchKeyword}"/></strong>'(으)로 검색된 대여 기록이 없습니다.</h4>
						</c:when>
						<c:otherwise>
							<h4>대여 기록이 없습니다.</h4>
						</c:otherwise>
					</c:choose>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<script>
		function showBookList() {
			location.href = "<c:url value='/bookLoan.do'/>";
		}

		function out() {
			location.href = "<c:url value='/logout.do'/>";
		}
		
		// 함수 이름을 다른 페이지와 통일 (searchHistory -> searchBooks)
		function searchBooks() {
			const searchKeyword = document.getElementById('searchKeyword').value;
			location.href = "<c:url value='/loanList.do'/>?searchKeyword=" + encodeURIComponent(searchKeyword);
		}
	</script>
</body>
</html>