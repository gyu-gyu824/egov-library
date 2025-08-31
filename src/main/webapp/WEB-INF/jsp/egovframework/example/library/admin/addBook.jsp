<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자: 새 도서 등록</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h2 class="mb-4">📘 새 도서 등록</h2>
    
    <div class="card">
        <div class="card-body">
            <form action="<c:url value='/admin/addBook.do'/>" method="post">
                <div class="mb-3">
                    <label for="title" class="form-label">제목</label>
                    <input type="text" name="title" id="title" class="form-control" required placeholder="책 제목을 입력하세요">
                </div>
                <div class="mb-3">
                    <label for="author" class="form-label">저자</label>
                    <input type="text" name="author" id="author" class="form-control" required placeholder="저자 이름을 입력하세요">
                </div>
                <div class="mb-3">
                    <label for="publisher" class="form-label">출판사</label>
                    <input type="text" name="publisher" id="publisher" class="form-control" required placeholder="출판사 이름을 입력하세요">
                </div>
                <div class="mb-3">
    				<label for="totalQuantity" class="form-label">총 보유 수량</label>
   				    <input type="number" name="totalQuantity" id="totalQuantity" class="form-control" required value="1" min="1">
				</div>
				<div class="mb-3">
    				<label for="currentQuantity" class="form-label">현재 대여 가능 수량</label>
   					<input type="number" name="currentQuantity" id="currentQuantity" class="form-control" required value="1" min="0">
				</div>
                
                
                <div class="d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">등록하기</button>
                    <a href="<c:url value='/admin/bookList.do'/>" class="btn btn-secondary ms-2">목록으로</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>