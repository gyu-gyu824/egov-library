<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 상세 정보</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
	function loanBook(bookId) {
	    if (confirm("이 책을 대여하시겠습니까?")) {
	        $.ajax({
	            url: '<c:url value="/loanBook.do"/>',
	            type: 'POST',
	            data: { bookId: bookId },
	            success: function(response) {
	                alert("대여가 완료되었습니다.");
	                location.reload(); // 페이지를 새로고침하여 상태를 갱신합니다.
	            },
	            error: function(xhr) {
					// Controller에서 보낸 에러 메시지가 있다면 보여주고, 없으면 기본 메시지를 보여줍니다.
	                alert(xhr.responseJSON.message || "대여 처리 중 오류가 발생했습니다.");
	            }
	        });
	    }
	}
</script>
</head>
<body>
	<div class="container mt-5">
		<h2 class="mb-4 text-center">📖 도서 상세 정보</h2>
		<div class="card p-4">
			<dl class="row">

				<dt class="col-sm-3">제목</dt>
				<dd class="col-sm-9"><c:out value="${book.title}" /></dd>

				<dt class="col-sm-3">저자</dt>
				<dd class="col-sm-9"><c:out value="${book.author}" /></dd>

				<dt class="col-sm-3">출판사</dt>
				<dd class="col-sm-9"><c:out value="${book.publisher}" /></dd>

				<dt class="col-sm-3">상태</dt>
				<dd class="col-sm-9">
					<c:choose>
						<c:when test="${book.currentQuantity > 0}">
							<span class="badge bg-success">대여 가능 (${book.currentQuantity})</span>
							<button class="btn btn-primary btn-sm ms-2" onclick="loanBook(${book.bookId})">대여하기</button>
						</c:when>
						<c:otherwise>
							<span class="badge bg-danger">대여 불가</span>
						</c:otherwise>
					</c:choose>
				</dd>
			</dl>
			<div class="text-end mt-4">
				<a href="<c:url value='/bookLoan.do'/>" class="btn btn-secondary">목록으로</a>
			</div>
		</div>
	</div>
</body>
</html>