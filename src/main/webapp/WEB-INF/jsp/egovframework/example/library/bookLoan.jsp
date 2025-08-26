<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 대여 관리 시스템</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript">
        function showBookList() {
            location.href = "<c:url value='/bookLoan.do'/>";
        }

        function out() {
            location.href = "<c:url value='/logout.do'/>";
        }

        function searchBooks() {
            const searchKeyword = document.getElementById('searchKeyword').value;
            location.href = "<c:url value='/bookLoan.do'/>?searchKeyword=" + encodeURIComponent(searchKeyword);
        }

        function checkBookStatus(element) {
            const status = element.dataset.status;
            if (status === "unavailable") {
                alert('대여중인 책입니다.');
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container mt-4">
        <h2 class="mb-4">📚 도서 대여 관리 시스템</h2>

        <nav class="mb-4">
            <a href="#" onclick="showBookList();" class="btn btn-outline-primary me-2">도서 목록</a> 
            <a href="<c:url value='/myLoans.do'/>" class="btn btn-outline-secondary">대여 현황</a> 
            <a href="<c:url value='/loanList.do'/>" class="btn btn-outline-secondary">대여 기록</a> 
            <a href="#" onclick="out()" class="btn btn-outline-secondary">로그아웃</a>
            <c:if test="${not empty sessionScope.loginVO && sessionScope.loginVO.role eq 'admin'}">
                <a href="<c:url value='/admin/bookList.do'/>" class="btn btn-outline-danger">도서 관리</a>
            </c:if>
        </nav>

        <div class="input-group mb-3">
            <input type="text" id="searchKeyword" class="form-control" placeholder="도서 제목 또는 저자를 입력하세요" value="${pagination.searchKeyword}">
            <button class="btn btn-outline-primary" type="button" onclick="searchBooks()">검색</button>
        </div>

        <div id="content">
            <c:choose>
                <c:when test="${not empty bookList}">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>제목</th>
                                <th>저자</th>
                                <th>출판사</th>
                                <th>대여 가능 여부</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${bookList}">
                                <tr>
                                    <td><c:out value="${book.bookId}" /></td>
                                    <td>
                                        <a href="<c:url value='/bookDetail.do?bookId=${book.bookId}'/>"
                                           data-status="${book.status}"
                                           onclick="return checkBookStatus(this);">
                                            <c:out value="${book.title}" />
                                        </a>
                                    </td>
                                    <td><c:out value="${book.author}" /></td>
                                    <td><c:out value="${book.publisher}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${book.status eq 'available'}">
                                                <span class="badge bg-success">대여 가능</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">대여 중</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="d-flex justify-content-center">
                        <ul class="pagination">
                            <c:if test="${pagination.prev}">
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/bookLoan.do?page=${pagination.startPage - 1}&searchKeyword=${pagination.searchKeyword}'/>">&laquo;</a>
                                </li>
                            </c:if>

                            <c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="pageNum">
                                <li class="page-item <c:if test="${pagination.page == pageNum}">active</c:if>">
                                    <a class="page-link" href="<c:url value='/bookLoan.do?page=${pageNum}&searchKeyword=${pagination.searchKeyword}'/>">${pageNum}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${pagination.next}">
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/bookLoan.do?page=${pagination.endPage + 1}&searchKeyword=${pagination.searchKeyword}'/>">&raquo;</a>
                                </li>
                            </c:if>
                        </ul>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-warning text-center p-5 mt-4">
                        <c:choose>
                            <c:when test="${not empty pagination.searchKeyword}">
                                <h4>'<strong><c:out value="${pagination.searchKeyword}"/></strong>'에 대한 검색 결과가 없습니다.</h4>
                            </c:when>
                            <c:otherwise>
                                <h4>등록된 도서가 없습니다.</h4>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>