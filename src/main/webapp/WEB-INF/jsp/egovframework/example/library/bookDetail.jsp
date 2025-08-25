<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 상세 정보</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
	<div class="container mt-5">
		<h2 class="mb-4 text-center">📖 도서 상세 정보</h2>
		<div class="card p-4">
			<dl class="row">
				<dt class="col-sm-3">ID</dt>
				<dd class="col-sm-9">
					<c:out value="${book.bookId}" />
				</dd>

				<dt class="col-sm-3">제목</dt>
				<dd class="col-sm-9">
					<c:out value="${book.title}" />
				</dd>

				<dt class="col-sm-3">저자</dt>
				<dd class="col-sm-9">
					<c:out value="${book.author}" />
				</dd>

				<dt class="col-sm-3">출판사</dt>
				<dd class="col-sm-9">
					<c:out value="${book.publisher}" />
				</dd>

				<dt class="col-sm-3">상태</dt>
				<dd class="col-sm-9">
					<c:choose>
						<c:when test="${book.status eq 'available'}">
							<span id="bookStatus" class="badge bg-success">대여 가능</span>
							<button id="loanButton" class="btn btn-primary btn-sm ms-2"
								onclick="loanBook(${book.bookId})">대여하기</button>
						</c:when>
						<c:otherwise>
							<span id="bookStatus" class="badge bg-danger">대여 중</span>
						</c:otherwise>
					</c:choose>
				</dd>
			</dl>
			<div class="text-end mt-4">
				<a href="<c:url value='/bookLoan.do'/>" class="btn btn-secondary">목록으로</a>
			</div>
		</div>
	</div>

	<script>
	function loanBook(bookId) {
	    if (confirm("대여하시겠습니까?")) {
	        $.ajax({
	            url: '<c:url value="/loanBook.do"/>',
	            type: 'POST',
	            data: { bookId: bookId },
	            // 성공 시 컨트롤러에서 반환한 BookVO 객체가 'bookVO' 파라미터로 들어옵니다.
	            success: function(bookVO) {
	                // 서버에서 유효한 bookVO 객체를 반환했는지 간단히 확인합니다.
	                if (bookVO && bookVO.bookId) {
	                    const statusSpan = $('#bookStatus');
	                    
	                    // '대여 중' 상태로 변경
	                    statusSpan.removeClass('bg-success').addClass('bg-danger');
	                    statusSpan.text('대여 중'); // 또는 서버에서 받은 상태값 사용: statusSpan.text(bookVO.status);
	                    
	                    // 대여 버튼 비활성화
	                    $('#loanButton').prop('disabled', true);
	                    
	                    alert("대여가 완료되었습니다.");
	                } else {
	                    // bookVO 객체를 제대로 받지 못한 경우
	                    alert("대여 처리 후 응답 데이터를 받지 못했습니다.");
	                }
	            },
	            error: function() {
	                alert("서버 통신 중 오류가 발생했습니다.");
	            }
	        });
	    } else {
	        alert("대여가 취소되었습니다.");
	    }
	}
	</script>
</body>
</html>
