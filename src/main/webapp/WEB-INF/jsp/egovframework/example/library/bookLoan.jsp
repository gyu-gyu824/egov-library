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

            <nav class="mb-4">
                <a href="<c:url value='/bookLoan.do'/>" class="btn btn-primary me-2">도서 목록</a> 
                <a href="<c:url value='/myLoans.do'/>" class="btn btn-outline-secondary">대여 현황</a> 
                <a href="<c:url value='/loanList.do'/>" class="btn btn-outline-secondary">대여 기록</a> 
                <a href="#" onclick="out()" class="btn btn-outline-danger">로그아웃</a>
           	<c:if test="${not empty sessionScope.loginVO && sessionScope.loginVO.role eq 'admin'}">
   				<a href="<c:url value='/admin/bookList.do'/>" class="btn btn-outline-danger ms-2">도서 관리</a>
			</c:if>
            </nav>

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
<script type="module">
    import Chatbot from "https://cdn.jsdelivr.net/npm/flowise-embed/dist/web.js"
    Chatbot.init({
        chatflowid: "d9d2103b-305e-4404-a122-abc70a596d35",
        apiHost: "http://localhost:3000",
        chatflowConfig: {
            /* Chatflow Config */
        },
        observersConfig: {
            /* Observers Config */
        },
        theme: {
            button: {
                backgroundColor: '#3B81F6',
                right: 20,
                bottom: 20,
                size: 48,
                dragAndDrop: true,
                iconColor: 'white',
                customIconSrc: 'https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/google-messages.svg',
                autoWindowOpen: {
                    autoOpen: true,
                    openDelay: 2,
                    autoOpenOnMobile: false
                }
            },
            tooltip: {
                showTooltip: true,
                tooltipMessage: 'Hi There 👋!',
                tooltipBackgroundColor: 'black',
                tooltipTextColor: 'white',
                tooltipFontSize: 16
            },
            disclaimer: {
                title: 'Disclaimer',
                message: "By using this chatbot, you agree to the <a target=\"_blank\" href=\"https://flowiseai.com/terms\">Terms & Condition</a>",
                textColor: 'black',
                buttonColor: '#3b82f6',
                buttonText: 'Start Chatting',
                buttonTextColor: 'white',
                blurredBackgroundColor: 'rgba(0, 0, 0, 0.4)',
                backgroundColor: 'white'
            },
            customCSS: ``,
            chatWindow: {
                showTitle: true,
                showAgentMessages: true,
                title: 'Flowise Bot',
                titleAvatarSrc: 'https://raw.githubusercontent.com/walkxcode/dashboard-icons/main/svg/google-messages.svg',
                welcomeMessage: 'Hello! This is custom welcome message',
                errorMessage: 'This is a custom error message',
                backgroundColor: '#ffffff',
                backgroundImage: 'enter image path or link',
                height: 700,
                width: 400,
                fontSize: 16,
                starterPrompts: [
                    "What is a bot?",
                    "Who are you?"
                ],
                starterPromptFontSize: 15,
                clearChatOnReload: false,
                sourceDocsTitle: 'Sources:',
                renderHTML: true,
                botMessage: {
                    backgroundColor: '#f7f8ff',
                    textColor: '#303235',
                    showAvatar: true,
                    avatarSrc: 'https://raw.githubusercontent.com/zahidkhawaja/langchain-chat-nextjs/main/public/parroticon.png'
                },
                userMessage: {
                    backgroundColor: '#3B81F6',
                    textColor: '#ffffff',
                    showAvatar: true,
                    avatarSrc: 'https://raw.githubusercontent.com/zahidkhawaja/langchain-chat-nextjs/main/public/usericon.png'
                },
                textInput: {
                    placeholder: 'Type your question',
                    backgroundColor: '#ffffff',
                    textColor: '#303235',
                    sendButtonColor: '#3B81F6',
                    maxChars: 50,
                    maxCharsWarningMessage: 'You exceeded the characters limit. Please input less than 50 characters.',
                    autoFocus: true,
                    sendMessageSound: true,
                    sendSoundLocation: 'send_message.mp3',
                    receiveMessageSound: true,
                    receiveSoundLocation: 'receive_message.mp3'
                },
                feedback: {
                    color: '#303235'
                },
                dateTimeToggle: {
                    date: true,
                    time: true
                },
                footer: {
                    textColor: '#303235',
                    text: 'Powered by',
                    company: 'Flowise',
                    companyLink: 'https://flowiseai.com'
                }
            }
        }
    })
</script>
</html>