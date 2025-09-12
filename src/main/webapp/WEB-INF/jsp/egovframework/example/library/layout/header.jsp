<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 대여 관리 시스템</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<%-- ✨ [추가] 페이지 로드 시 알림을 확인하는 스크립트 --%>
<script>
 $(document).ready(function() {
        checkNotifications();
    });

    function checkNotifications() {
        // 로그인 상태일 때만 AJAX 요청을 보냅니다.
        <c:if test="${not empty sessionScope.loginVO}">
            $.ajax({
                url: '<c:url value="/getNotifications.do"/>',
                type: 'POST',
                success: function(notificationList) {
                    if (notificationList && notificationList.length > 0) {
                        
                        let alertMessage = "다음 도서가 대여 기간이 지나 반납 처리되었습니다:\n";
                        for (let i = 0; i < notificationList.length; i++) {
                            alertMessage += "- " + notificationList[i].title + "\n";
                        }
                        
                        // ✨ [변경] Bootstrap 알림창 대신 alert() 사용
                        alert(alertMessage);
                        location.reload(); // 페이지를 새로고침하여 변경사항 반영
                    }
                }
            });
        </c:if>
    }
    
    // 로그아웃 함수
    function out() {
        location.href = "<c:url value='/logout.do'/>";
    }
</script>

</head>
<body>
    <div class="container mt-4">
        <%-- 모든 페이지에 공통적으로 들어갈 메뉴 바 --%>
        <nav class="mb-4">
            <a href="<c:url value='/bookLoan.do'/>" class="btn btn-outline-primary me-2">도서 목록</a> 
            <a href="<c:url value='/myLoans.do'/>" class="btn btn-outline-secondary">대여 현황</a>
            <a href="<c:url value='/loanList.do'/>" class="btn btn-outline-secondary">대여 기록</a>  
            <a href="#" onclick="out()" class="btn btn-outline-danger">로그아웃</a>
            
            <c:if test="${not empty sessionScope.loginVO && sessionScope.loginVO.role eq 'admin'}">
                <a href="<c:url value='/admin/bookList.do'/>" class="btn btn-outline-danger ms-2">도서 관리</a>
            </c:if>
        </nav>
       