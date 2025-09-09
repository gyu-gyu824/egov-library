<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자: 도서 목록 관리</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
    function fn_link_page(pageNo){
        document.listForm.pageIndex.value = pageNo;
        document.listForm.action = "<c:url value='/admin/bookList.do'/>";
        document.listForm.submit();
    }
    
    function fn_delete_book(bookId) {
        if (confirm("정말 삭제하시겠습니까?")) {
            const form = document.deleteForm;
            form.bookId.value = bookId;
            form.submit();
        }
    }
    
    function out() {
        location.href = "<c:url value='/logout.do'/>";
    }
</script>
</head>
<body>
	<div class="container mt-4">
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h2>🧑‍💼 관리자: 도서 목록 관리</h2>
			<div>
				<a href="<c:url value='/bookLoan.do'/>" class="btn btn-outline-secondary">사용자 페이지로</a> 
				<a href="#" onclick="out()" class="btn btn-outline-danger">로그아웃</a>
			</div>
		</div>

		<c:if test="${not empty successMessage}">
			<div class="alert alert-success alert-dismissible fade show" role="alert">
				${successMessage}
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		</c:if>
		<c:if test="${not empty errorMessage}">
			<div class="alert alert-danger alert-dismissible fade show" role="alert">
				${errorMessage}
				<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
			</div>
		</c:if>
		<div class="d-flex justify-content-end mb-3">
			<a href="<c:url value='/admin/addBook.do'/>" class="btn btn-primary">📘 새 도서 등록</a>
		</div>

		<div class="card mb-4">
			<div class="card-body">
				<h5 class="card-title">엑셀로 일괄 등록</h5>
				<form action="<c:url value='/uploadBookList.do'/>" method="post" enctype="multipart/form-data">
					<div class="input-group">
						<input type="file" name="excelFile" class="form-control" required="required" accept=".xlsx, .xls" />
						<button type="submit" class="btn btn-outline-primary">업로드</button>
					</div>
					<div class="form-text">양식: 제목 | 저자 | 출판사 | 총 수량 | 현재 수량 | (* 띄어쓰기 주의 *)</div>
				</form>
			</div>
		</div>

		<form:form modelAttribute="bookVO" name="listForm" id="listForm" method="get">
			<c:choose>
				<c:when test="${not empty bookList}">
					<table class="table table-hover align-middle">
						<thead class="table-dark">
							<tr>
								<th scope="col" class="text-center">ID</th>
								<th scope="col">제목</th>
								<th scope="col">저자</th>
								<th scope="col">출판사</th>
								<th scope="col" class="text-center">상태 (현재/총)</th>
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
									<td class="text-center">
										<c:choose>
											<c:when test="${book.currentQuantity > 0}">
												<span class="badge bg-success">대여 가능 (${book.currentQuantity}/${book.totalQuantity})</span>
											</c:when>
											<c:otherwise>
												<span class="badge bg-danger">대여 불가 (${book.currentQuantity}/${book.totalQuantity})</span>
											</c:otherwise>
										</c:choose>
									</td>
									<td class="text-center">
										<a href="<c:url value='/admin/editBook.do?bookId=${book.bookId}'/>" class="btn btn-sm btn-outline-primary">수정</a>
										<button type="button" class="btn btn-sm btn-outline-danger" onclick="fn_delete_book(${book.bookId})">삭제</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:when>
				<c:otherwise>
					<div class="alert alert-warning text-center p-5 mt-4">
						<h4>등록된 도서가 없습니다.</h4>
					</div>
				</c:otherwise>
			</c:choose>

			<div class="d-flex justify-content-center">
				<ui:pagination paginationInfo="${paginationInfo}" type="bootstrap" jsFunction="fn_link_page" />
			</div>

			<form:hidden path="pageIndex" />
		</form:form> <div class="text-end my-3">
			<form id="excelForm" action="<c:url value='/admin/downloadBookList.do'/>" method="post" target="_blank">
				<input type="hidden" name="searchKeyword" value="${bookVO.searchKeyword}" />
				<input type="hidden" name="pageIndex" value="${bookVO.pageIndex}" />
				<button type="submit" class="btn btn-success">책 정보 출력</button>
			</form>
		</div>
		</div> <form name="deleteForm" action="<c:url value='/admin/deleteBook.do'/>" method="post" style="display: none;">
		<input type="hidden" name="bookId" />
	</form>

</body>
</html>
