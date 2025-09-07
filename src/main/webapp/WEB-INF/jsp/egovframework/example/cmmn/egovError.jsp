<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오류 발생</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="alert alert-danger text-center p-5">
            <h2 class="alert-heading">죄송합니다. 요청 처리 중 오류가 발생했습니다.</h2>
            <p>${message}</p>
            <hr>
            <p class="mb-0">문제가 지속될 경우 관리자에게 문의해주세요.</p>
            <div class="mt-4">
                <a href="<c:url value='/bookLoan.do'/>" class="btn btn-danger">메인으로 돌아가기</a>
            </div>
        </div>
        
        <%-- 개발 중에만 원인 파악을 위해 에러 내용을 표시 (실제 서비스에서는 이 부분을 삭제하거나 주석 처리) --%>
        <div class="card mt-4">
            <div class="card-header">
                <strong>[개발자 확인용] 오류 상세 정보</strong>
            </div>
            <div class="card-body" style="font-size:0.8em; white-space:pre-wrap; word-break:break-all;">
                ${exception}
            </div>
        </div>
        
    </div>
</body>
</html>