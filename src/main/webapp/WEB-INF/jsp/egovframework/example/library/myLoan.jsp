<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 대여 현황</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
    // 페이지 이동을 위한 표준 JavaScript 함수
    function fn_link_page(pageNo){
        document.listForm.pageIndex.value = pageNo;
        document.listForm.action = "<c:url value='/myLoans.do'/>";
        document.listForm.submit();
    }

    // 검색을 위한 표준 JavaScript 함수
    function fn_search() {
        document.listForm.pageIndex.value = 1; // 검색 시에는 항상 1페이지로 이동
        document.listForm.submit();
    }

    // 로그아웃 함수
    function out() {
        location.href = "<c:url value='/logout.do'/>";
    }
    
    // 반납 함수 (AJAX)
    function returnBook(buttonElement, bookId) {
        if (confirm("이 책을 반납하시겠습니까?")) {
            $.ajax({
                url: "<c:url value='/returnBook.do'/>",
                type: "POST",
                data: { bookId: bookId },
                success: function(response) {
                    if (response.success) {
                        alert(response.message);
                        location.reload(); // 성공 시 페이지 새로고침
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
</head>
<body>
    <form:form modelAttribute="bookVO" name="listForm" id="listForm" method="get">
        <div class="container mt-4">
            <h2 class="mb-4">📚 내 대여 현황</h2>

            <nav class="mb-4">
                <a href="<c:url value='/bookLoan.do'/>" class="btn btn-outline-primary me-2">도서 목록</a> 
                <a href="<c:url value='/myLoans.do'/>" class="btn btn-primary">대여 현황</a>
                <a href="<c:url value='/loanList.do'/>" class="btn btn-outline-secondary">대여 기록</a>  
                <a href="#" onclick="out()" class="btn btn-outline-danger">로그아웃</a>
            </nav>
            
            <div class="input-group mb-3">
                <form:input path="searchKeyword" cssClass="form-control" placeholder="빌린 책 제목 또는 저자를 입력하세요" />
                <button class="btn btn-outline-primary" type="button" onclick="fn_search()">검색</button>
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
                        <ui:pagination paginationInfo="${paginationInfo}" type="bootstrap" jsFunction="fn_link_page" />
                    </div>

                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning text-center p-5 mt-4">
                        <c:choose>
                            <c:when test="${not empty bookVO.searchKeyword}">
                                <h4>'<strong><c:out value="${bookVO.searchKeyword}"/></strong>'(으)로 검색된 대여 도서가 없습니다.</h4>
                            </c:when>
                            <c:otherwise>
                                <h4>대여한 도서가 없습니다.</h4>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <form:hidden path="pageIndex" />
        </div>
    </form:form>
</body>
</html>