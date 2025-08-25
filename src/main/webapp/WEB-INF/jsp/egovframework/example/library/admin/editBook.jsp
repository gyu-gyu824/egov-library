<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- Spring Form 태그 라이브러리를 사용하기 위해 추가합니다. --%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자: 도서 수정</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">

    <%-- 
        컨트롤러에서 model.addAttribute("bookVO", 조회된BookVO객체) 로 
        데이터를 넘겨준다고 가정합니다.
    --%>
    <h2 class="mb-4">✏️ 도서 수정 (제목: ${bookVO.title})</h2>
    
    <div class="card">
        <div class="card-body">
            <%-- 
                modelAttribute="bookVO"를 통해 VO 객체와 폼을 연결합니다.
                action 경로는 수정을 처리할 컨트롤러의 URL을 가리킵니다.
            --%>
            <form:form modelAttribute="bookVO" action="${pageContext.request.contextPath}/admin/updateBook.do" method="post">
                
                <%-- 어떤 책을 수정할지 서버에 알려주기 위해 id를 숨겨진 필드로 반드시 전송해야 합니다. --%>
                <form:hidden path="bookId" />

                <div class="mb-3">
                    <label for="title" class="form-label">제목</label>
                    <form:input path="title" cssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label for="author" class="form-label">저자</label>
                    <form:input path="author" cssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label for="publisher" class="form-label">출판사</label>
                    <form:input path="publisher" cssClass="form-control" />
                </div>
                <div class="mb-3">
                    <label for="status" class="form-label">상태</label>
                    <form:select path="status" cssClass="form-select">
                        <form:option value="available">대여 가능</form:option>
                        <form:option value="unavailable">대여 중</form:option>
                    </form:select>
                </div>
                
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">수정 완료</button>
                    <a href="<c:url value='/admin/bookList.do'/>" class="btn btn-secondary ms-2">목록으로</a>
                </div>
            </form:form>
        </div>
    </div>
</div>
</body>
</html>