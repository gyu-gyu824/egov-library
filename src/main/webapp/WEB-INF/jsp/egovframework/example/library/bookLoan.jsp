<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 대여 관리 시스템</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
        function fn_link_page(pageNo){
            document.listForm.pageIndex.value = pageNo;
            document.listForm.action = "<c:url value='/bookLoan.do'/>";
            document.listForm.submit();
        }
        
        
        
        function fn_search() {
        	
        	 const searchKeyword = $("#searchKeyword").val();

            if (searchKeyword.trim().length === 0) {
                alert("검색어를 입력해주세요.");

                $("#searchKeyword").val(""); 
                return; 
            }
            document.listForm.pageIndex.value = 1;
            document.listForm.submit();
        }
        function out() {
            location.href = "<c:url value='/logout.do'/>";
        }
        function checkBookStatus(element) {
            const currentQuantity = element.dataset.quantity;
            if (currentQuantity <= 0) {
                alert('대여 가능한 책이 없습니다.');
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <form:form modelAttribute="bookVO" name="listForm" id="listForm" method="get">
        <div class="container mt-4">
            <h2 class="mb-4">📚 도서 대여 관리 시스템</h2>

			<c:import
				url="/WEB-INF/jsp/egovframework/example/library/layout/header.jsp" />

            <div class="input-group mb-3">
                <form:input path="searchKeyword" cssClass="form-control" placeholder="도서 제목 또는 저자를 입력하세요" />
                <button class="btn btn-outline-primary" type="button" onclick="fn_search()">검색</button>
            </div>

            <div id="content">
                <c:choose>
                    <c:when test="${not empty bookList}">
                        <table class="table table-striped table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>제목</th>
                                    <th>저자</th>
                                    <th>출판사</th>
                                    <th>대여 가능 여부</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${bookList}">
                                    <tr>
                                        <td>
                                            <a href="<c:url value='/bookDetail.do?bookId=${book.bookId}'/>"
                                               data-quantity="${book.currentQuantity}"
                                               onclick="return checkBookStatus(this);">
                                                <c:out value="${book.title}" />
                                            </a>
                                        </td>
                                        <td><c:out value="${book.author}" /></td>
                                        <td><c:out value="${book.publisher}" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${book.currentQuantity > 0}">
                                                    <span class="badge bg-success">대여 가능 (${book.currentQuantity})</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">대여 불가</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning text-center p-5 mt-4">
                             <h4>검색 결과가 없거나 등록된 도서가 없습니다.</h4>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="d-flex justify-content-center">
                <ui:pagination paginationInfo="${paginationInfo}" type="bootstrap" jsFunction="fn_link_page" />
            </div>
            
            <form:hidden path="pageIndex" />
        </div>
    </form:form>
</body>
</html>