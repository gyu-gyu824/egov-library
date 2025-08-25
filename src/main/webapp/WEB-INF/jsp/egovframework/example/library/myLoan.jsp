<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 대여 현황</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<div class="container mt-4">
		<h2 class="mb-4">📚 내 대여 현황</h2>

		<nav class="mb-4">
			<a href="<c:url value='/bookLoan.do'/>"
				class="btn btn-outline-primary me-2">도서 목록</a> 
				<a href="<c:url value='/myLoans.do'/>" class="btn btn-outline-secondary">대여 현황</a>
				<a href="<c:url value='/loanList.do'/>" class="btn btn-outline-secondary">대여 기록</a>  
				<a href="<c:url value='/logout.do'/>" class="btn btn-outline-secondary">로그아웃</a>
		</nav>
		<div class="input-group mb-3">
			<input type="text" id="searchKeyword" class="form-control"
				placeholder="도서 제목 또는 저자를 입력하세요">
			<button class="btn btn-outline-primary" type="button"
				onclick="searchBooks()">검색</button>
		</div>

		<c:choose>
			<c:when test="${not empty myLoanList}">
				<table class="table table-striped table-hover">
					<thead class="table-dark">
						<tr>
							<th scope="col">ID</th>
							<th scope="col">제목</th>
							<th scope="col">저자</th>
							<th scope="col">출판사</th>
							<th scope="col">대여일</th>
							<th scope="col">상태</th>
							<th scope="col">반납</th>
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
                <form method="POST" action="<c:url value='/returnBook.do'/>" style="display:inline;">
                    <input type="hidden" name="bookId" value="${book.bookId}" />
                    
                    <button type="submit" class="btn btn-warning btn-sm">반납</button>
                </form>
            </td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</c:when>
			<c:otherwise>
				<div class='alert alert-info text-center'
					style='padding: 2rem; margin-top: 2rem;'>
					<h2>대여한 도서가 없습니다.</h2>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

	<script>
// 반납 기능은 그대로 유지합니다.
function returnBook(bookId) {
    if (confirm("책을 반납하시겠습니까?")) {
        // 1. 숨겨진 input 태그에 bookId 값을 설정합니다.
        document.getElementById('formBookId').value = bookId;

        // 2. form을 전송(submit)합니다.
        document.getElementById('returnForm').submit();
    }
}

function showBookList() {
	location.href = "<c:url value='/bookLoan.do'/>";
}

function out() {
	location.href = "<c:url value='/logout.do'/>";
}

// 검색 함수 추가
function searchBooks() {
	const searchKeyword = document.getElementById('searchKeyword').value;
	location.href = "<c:url value='/bookLoan.do'/>?searchKeyword="
			+ encodeURIComponent(searchKeyword);
}
$(document).ready(function() {

	// 문제가 되었던 코드를 이 안으로 옮깁니다.
	$(".book-title-link").on('click', function(event) {
		const status = $(this).data('status');
		if (status === "unavailable") {
			alert('대여중인 책입니다');
			event.preventDefault();
		}
	});
});
</script>
</body>
</html>