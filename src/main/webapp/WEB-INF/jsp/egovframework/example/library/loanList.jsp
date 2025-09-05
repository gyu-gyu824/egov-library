<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 대여 기록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
    function fn_link_page(pageNo){
        document.listForm.pageIndex.value = pageNo;
        document.listForm.action = "<c:url value='/loanList.do'/>";
        document.listForm.submit();
    }
    function fn_search() {
        document.listForm.pageIndex.value = 1;
        document.listForm.submit();
    }
    function out() {
        location.href = "<c:url value='/logout.do'/>";
    }
</script>
</head>
<body>
	<form:form modelAttribute="bookVO" name="listForm" id="listForm"
		method="get">
		<div class="container mt-4">
			<h2 class="mb-4">📜 나의 대여 기록</h2>

			<nav class="mb-4">
				<a href="<c:url value='/bookLoan.do'/>"
					class="btn btn-outline-secondary me-2">도서 목록</a> <a
					href="<c:url value='/myLoans.do'/>"
					class="btn btn-outline-secondary">대여 현황</a> <a
					href="<c:url value='/loanList.do'/>" class="btn btn-primary">대여
					기록</a> <a href="#" onclick="out()" class="btn btn-outline-danger">로그아웃</a>
			</nav>

			<div class="input-group mb-3">
				<form:input path="searchKeyword" cssClass="form-control"
					placeholder="기록에서 책 제목 또는 저자 검색" />
				<button class="btn btn-outline-primary" type="button"
					onclick="fn_search()">검색</button>
			</div>

			<c:choose>
				<c:when test="${not empty loanHistory}">
					<table class="table table-striped table-hover">
						<thead class="table-dark">
							<tr>
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
									<td><c:out value="${book.title}" /></td>
									<td><c:out value="${book.author}" /></td>
									<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm"
											value="${book.loanDate}" /></td>
									<td><c:if test="${not empty book.returnDate}">
											<fmt:formatDate pattern="yyyy-MM-dd HH:mm"
												value="${book.returnDate}" />
										</c:if></td>
									<td><c:choose>
											<c:when test="${book.status eq 'loaned'}">
												<span class="badge bg-danger">대여 중</span>
											</c:when>
											<c:otherwise>
												<span class="badge bg-secondary">반납 완료</span>
											</c:otherwise>
										</c:choose></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="d-flex justify-content-center">
						<ui:pagination paginationInfo="${paginationInfo}" type="bootstrap"
							jsFunction="fn_link_page" />
					</div>
				</c:when>
				<c:otherwise>
					<div class="alert alert-warning text-center p-5 mt-4">
						<c:choose>
							<c:when test="${not empty bookVO.searchKeyword}">
								<h4>
									'<strong><c:out value="${bookVO.searchKeyword}" /></strong>'(으)로
									검색된 대여 기록이 없습니다.
								</h4>
							</c:when>
							<c:otherwise>
								<h4>대여 기록이 없습니다.</h4>
							</c:otherwise>
						</c:choose>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</form:form>
	<form id="excelForm" action="<c:url value='/downloadLoanHistory.do'/>" method="post" target="_blank">
    <input type="hidden" name="searchKeyword" value="${bookVO.searchKeyword}" />
    <input type="hidden" name="pageIndex" value="${bookVO.pageIndex}" />
    <!-- 필요한 다른 필드도 넣기 -->
    <button type="submit" class="btn btn-outline-secondary">대여 기록 출력</button>
</form>
	
</body>
</html>