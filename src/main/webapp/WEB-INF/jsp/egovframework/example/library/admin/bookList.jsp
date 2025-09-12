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
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<style>
/* ================================================================
       공통 스타일
       ================================================================ */
body {
	margin: 0;
	padding: 0;
	font-family: 'Noto Sans KR', sans-serif;
	background: #f5f2ed;
	color: #2c2c2c;
}

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

/* ================================================================
       a a 관리자 페이지 전용 헤더
       ================================================================ */
.admin-header {
	background-color: #3e2723; 
	color: #fff;
	display: flex;
	justify-content: space-between;
	padding: 14px 40px;
	align-items: center;
}

.admin-header h1 {
	font-size: 20px;
	margin: 0;
	font-weight: bold;
}

.admin-header .nav-buttons a {
	margin-left: 12px;
	text-decoration: none;
	padding: 8px 14px;
	border-radius: 20px;
	font-size: 14px;
	color: #fff;
	transition: 0.3s;
	border: 1px solid #fff;
}

.admin-header .nav-buttons a:hover {
	background: #d97904;
	border-color: #d97904;
}

/* ================================================================
       테이블 및 컨텐츠 스타일
       ================================================================ */
/* 테이블 */
.book-table {
	width: 100%;
	border-collapse: separate;
	border-spacing: 0;
}

.book-table thead th {
	padding: 12px 18px;
	font-size: 14px;
	font-weight: bold;
	color: #8a6d59;
	text-align: left;
	border-bottom: 2px solid #e0d9c9;
	vertical-align: middle;
}

.book-table tbody tr {
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
	margin-top: 15px;
	display: table-row;
}

.book-table tbody tr:hover {
	background-color: #fffaf0;
}

.book-table td {
	padding: 18px;
	font-size: 15px;
	vertical-align: middle;
}

.book-table td:first-child {
	border-radius: 12px 0 0 12px;
}

.book-table td:last-child {
	display: flex;
	flex-direction: column; 
	justify-content: center;
	align-items: center;
	gap: 6px; 
	border-radius: 0 12px 12px 0;
}

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

/* a a 폼 카드 (엑셀 업로드 영역) */
.form-card {
	background: #fff;
	border-radius: 12px;
	padding: 25px 30px;
	margin-bottom: 30px;
	box-shadow: 0 3px 8px rgba(0, 0, 0, 0.05);
}

.form-card h5 {
	font-weight: bold;
	color: #5a3825;
	margin-bottom: 15px;
}

/* a a 커스텀 입력 그룹 (파일 업로드) */
.input-group-custom {
	display: flex;
}

.input-group-custom input[type="file"] {
	flex-grow: 1;
	padding: 10px 15px;
	border: 2px solid #d6c3a3;
	border-right: none;
	border-radius: 25px 0 0 25px;
	outline: none;
	font-size: 15px;
	background-color: #fff;
}

.input-group-custom button {
	padding: 10px 20px;
	border: none;
	border-radius: 0 25px 25px 0;
	background-color: #5a3825;
	color: white;
	font-size: 15px;
	cursor: pointer;
	transition: 0.3s;
}

.input-group-custom button:hover {
	background-color: #d97904;
}

/* 액션 버튼 영역 */
.action-area {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

/* 버튼 스타일 */
.btn-custom {
	text-decoration: none;
	padding: 10px 22px;
	border: none;
	border-radius: 25px;
	font-size: 15px;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
}

.btn-primary-custom {
	background-color: #5a3825;
	color: white;
}

.btn-primary-custom:hover {
	background-color: #d97904;
}

.btn-success-custom {
	background-color: #1D6F42;
	color: white;
}

.btn-success-custom:hover {
	background-color: #165934;
}

/* a a 테이블 내 수정/삭제 버튼 */
.btn-edit, .btn-delete {
	text-decoration: none;
	padding: 5px 12px;
	border: 1px solid;
	border-radius: 20px;
	font-size: 13px;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
	background-color: #fff;
}

.btn-edit {
	border-color: #5a3825;
	color: #5a3825;
}

.btn-edit:hover {
	background-color: #5a3825;
	color: #fff;
}

.btn-delete {
	border-color: #c0392b;
	color: #c0392b;
	margin-left: 5px;
}

.btn-delete:hover {
	background-color: #c0392b;
	color: #fff;
}

/* 알림 메시지 */
.alert-custom {
	margin-bottom: 20px;
	padding: 20px;
	border-radius: 12px;
	text-align: center;
	border: 2px dashed;
}

.alert-custom.success {
	background: #d8f8d8;
	border-color: #2f8f2f;
	color: #2f8f2f;
}

.alert-custom.danger {
	background: #fcdada;
	border-color: #c0392b;
	color: #c0392b;
}

.alert-custom.warning {
	background: #fff4e6;
	border-color: #e67e22;
}
</style>

<script type="text/javascript">
    // a a 기존 스크립트 로직은 그대로 유지
    function fn_link_page(pageNo){
        document.listForm.pageIndex.value = pageNo;
        document.listForm.action = "<c:url value='/admin/bookList.do'/>";
        document.listForm.submit();
    }
    function fn_delete_book(bookId) {
        if (confirm("정말 이 도서를 목록에서 삭제하시겠습니까?")) {
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

	<div class="admin-header">
		<h1>🧑‍💼 관리자 페이지</h1>
		<div class="nav-buttons">
			<a href="<c:url value='/bookLoan.do'/>">사용자 페이지로</a> <a href="#"
				onclick="out()">로그아웃</a>
		</div>
	</div>

	<div class="wrapper">
		<h2>도서 목록 관리</h2>

		<c:if test="${not empty successMessage}">
			<div class="alert-custom success">${successMessage}</div>
		</c:if>
		<c:if test="${not empty errorMessage}">
			<div class="alert-custom danger">${errorMessage}</div>
		</c:if>

		<div class="form-card">
			<h5>엑셀로 일괄 등록/추가</h5>
			<form action="<c:url value='/uploadBookList.do'/>" method="post"
				enctype="multipart/form-data">
				<div class="input-group-custom">
					<input type="file" name="excelFile" required="required"
						accept=".xlsx, .xls" />
					<button type="submit">업로드</button>
				</div>
			</form>
		</div>

		<div class="action-area">
			<a href="<c:url value='/admin/addBook.do'/>"
				class="btn-custom btn-primary-custom">📘 새 도서 등록</a>
			<form id="excelForm"
				action="<c:url value='/admin/downloadBookList.do'/>" method="post"
				target="_blank">
				<input type="hidden" name="searchKeyword"
					value="${bookVO.searchKeyword}" />
				<input type="hidden" name="pageIndex" value="${bookVO.pageIndex}" />
				<button type="submit" class="btn-custom btn-success-custom">책
					정보 출력</button>
			</form>
		</div>

		<form:form modelAttribute="bookVO" name="listForm" id="listForm"
			method="get">
			<c:choose>
				<c:when test="${not empty bookList}">
					<table class="book-table">
						<thead>
							<tr>
								<th style="width: 8%; text-align: center;">ID</th>
								<th style="width: 32%;">제목</th>
								<th style="width: 15%;">저자</th>
								<th style="width: 15%;">출판사</th>
								<th style="width: 15%; text-align: center;">상태 (현재/총)</th>
								<th style="width: 15%; text-align: center;">관리</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="book" items="${bookList}">
								<tr>
									<td class="text-center">${book.bookId}</td>
									<td>${book.title}</td>
									<td>${book.author}</td>
									<td>${book.publisher}</td>
									<td class="text-center"><c:choose>
											<c:when test="${book.currentQuantity > 0}">
												<span class="badge-custom success">대여 가능
													(${book.currentQuantity}/${book.totalQuantity})</span>
											</c:when>
											<c:otherwise>
												<span class="badge-custom danger">대여 불가
													(${book.currentQuantity}/${book.totalQuantity})</span>
											</c:otherwise>
										</c:choose></td>
									<td class="text-center"><a
										href="<c:url value='/admin/editBook.do?bookId=${book.bookId}'/>"
										class="btn-edit">수정</a>
										<button type="button" class="btn-delete"
											onclick="fn_delete_book(${book.bookId})">삭제</button></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:when>
				<c:otherwise>
					<div class="alert-custom warning">
						<h4>등록된 도서가 없습니다.</h4>
					</div>
				</c:otherwise>
			</c:choose>

			<div class="d-flex justify-content-center mt-4">
				<ui:pagination paginationInfo="${paginationInfo}" type="bootstrap"
					jsFunction="fn_link_page" />
			</div>

			<form:hidden path="pageIndex" />
		</form:form>

		<form name="deleteForm" action="<c:url value='/admin/deleteBook.do'/>"
			method="post" style="display: none;">
			<input type="hidden" name="bookId" />
		</form>
	</div>

</body>
</html>