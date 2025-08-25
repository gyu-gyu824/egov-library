<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자: 도서 목록 관리</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
	crossorigin="anonymous"></script>
<script type="text/javaScript" language="javascript" defer="defer">
function out() {
	location.href = "<c:url value='/logout.do'/>";
}
</script>
</head>
<body>
	<div class="container mt-4">

		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2>🧑‍💼 관리자: 도서 목록 관리</h2>
			<a href="<c:url value='/bookLoan.do'/>"
				class="btn btn-outline-secondary">사용자 페이지로</a> <a href="#"
				onclick="out()" class="btn btn-outline-secondary">로그아웃</a>
		</div>

		<div class="d-flex justify-content-end mb-3">
			<a href="<c:url value='/admin/addBook.do'/>" class="btn btn-primary">📘
				새 도서 등록</a>
		</div>

		<table class="table table-hover align-middle">
			<thead class="table-dark">
				<tr>
					<th scope="col" class="text-center">ID</th>
					<th scope="col">제목</th>
					<th scope="col">저자</th>
					<th scope="col">출판사</th>
					<th scope="col" class="text-center">상태</th>
					<th scope="col" class="text-center">관리</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="book" items="${bookList}">
					<tr>
						<td class="text-center">${book.bookId}</td>
						<td>${book.title}</td>
						<td>${book.author}</td>
						<td>${book.publisher}</td>
						<td class="text-center"><c:if
								test="${book.status == 'available'}">
								<span class="badge bg-success">대여 가능</span>
							</c:if> <c:if test="${book.status == 'unavailable'}">
								<span class="badge bg-danger">대여 중</span>
							</c:if></td>
						<td class="text-center"><a
							href="<c:url value='/admin/editBook.do?bookId=${book.bookId}'/>"
							class="btn btn-sm btn-outline-primary">수정</a>

							<form action="<c:url value='/admin/deleteBook.do'/>"
								method="post" style="display: inline;"
								onsubmit="return confirm('정말 삭제하시겠습니까?');">
								<input type="hidden" name="bookId" value="${book.bookId}">
								<button type="submit" class="btn btn-sm btn-outline-danger">삭제</button>
							</form></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>