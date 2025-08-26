<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 대여 현황</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<div class="container mt-4">
		<h2 class="mb-4">📚 내 대여 현황</h2>

		<nav class="mb-4">
			<a href="<c:url value='/bookLoan.do'/>" class="btn btn-outline-primary me-2">도서 목록</a> 
			<a href="<c:url value='/myLoans.do'/>" class="btn btn-outline-secondary">대여 현황</a>
			<a href="<c:url value='/loanList.do'/>" class="btn btn-outline-secondary">대여 기록</a>  
			<a href="#" onclick="out()" class="btn btn-outline-secondary">로그아웃</a>
		</nav>
		
		<div class="input-group mb-3">
			<input type="text" id="searchKeyword" class="form-control" placeholder="빌린 책 제목 또는 저자를 입력하세요" value="${pagination.searchKeyword}">
			<button class="btn btn-outline-primary" type="button" onclick="searchBooks()">검색</button>
		</div>

		<c:choose>
			<c:when test="${not empty myLoanList}">
				<table class="table table-striped table-hover">
					<thead class="table-dark">
						<tr>
							<th>ID</th>
							<th>제목</th>
							<th>저자</th>
							<th>출판사</th>
							<th>대여일</th>
							<th>상태</th>
							<th>반납</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="book" items="${myLoanList}">
							<tr>
								<td><c:out value="${book.bookId}" /></td>
								<td><c:out value="${book.title}" /></td>
								<td><c:out value="${book.author}" /></td>
								<td><c:out value="${book.publisher}" /></td>
								<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${book.loanDate}" /></td>
								<td><span class="badge bg-danger">대여 중</span></td>
								<td>
									<button type="button" class="btn btn-warning btn-sm" onclick="returnBook(this, ${book.bookId})">반납</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<div class="d-flex justify-content-center">
					<ul class="pagination">
						<c:if test="${pagination.prev}">
							<li class="page-item"><a class="page-link" href="<c:url value='/myLoans.do?page=${pagination.startPage - 1}&searchKeyword=${pagination.searchKeyword}'/>">&laquo;</a></li>
						</c:if>
						<c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="pageNum">
							<li class="page-item <c:if test="${pagination.page == pageNum}">active</c:if>"><a class="page-link" href="<c:url value='/myLoans.do?page=${pageNum}&searchKeyword=${pagination.searchKeyword}'/>">${pageNum}</a></li>
						</c:forEach>
						<c:if test="${pagination.next}">
							<li class="page-item"><a class="page-link" href="<c:url value='/myLoans.do?page=${pagination.endPage + 1}&searchKeyword=${pagination.searchKeyword}'/>">&raquo;</a></li>
						</c:if>
					</ul>
				</div>

			</c:when>
			<c:otherwise>
				<div class="alert alert-warning text-center p-5 mt-4">
					<c:choose>
						<c:when test="${not empty pagination.searchKeyword}">
							<h4>'<strong><c:out value="${pagination.searchKeyword}"/></strong>'(으)로 검색된 대여 도서가 없습니다.</h4>
						</c:when>
						<c:otherwise>
							<h4>대여한 도서가 없습니다.</h4>
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

		function searchBooks() {
			const searchKeyword = document.getElementById('searchKeyword').value;
			location.href = "<c:url value='/myLoans.do'/>?searchKeyword=" + encodeURIComponent(searchKeyword);
		}
		
		function returnBook(buttonElement, bookId) {
			if (confirm("이 책을 반납하시겠습니까?")) {
				$.ajax({
					url: "<c:url value='/returnBook.do'/>",
					type: "POST",
					data: { bookId: bookId },
					success: function(response) {
						if (response.success) {
							alert(response.message);
							// 현재 페이지를 새로고침하여 목록을 갱신합니다.
							// 또는 특정 행만 지울 수도 있습니다: $(buttonElement).closest('tr').remove();
							location.reload(); 
						} else {
							alert(response.message);
						}
					},
					error: function() {
						alert("반납 처리 중 오류가 발생했습니다.");
					}
				});
			}
		}
	</script>
</body>
</html>