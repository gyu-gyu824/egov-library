package egovframework.example.sample.library.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class CommonExceptionHandler {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonExceptionHandler.class);

    @ExceptionHandler(Exception.class)
    public ModelAndView handleError(Exception e) {
        
        // 서버 콘솔에 전체 에러 로그를 출력합니다 (개발자 확인용).
        LOGGER.error("Exception 발생", e);
        
        // 사용자에게 보여줄 화면과 전달할 정보를 ModelAndView 객체에 담습니다.
        ModelAndView mav = new ModelAndView();
        
        // 1. 사용자에게 보여줄 에러 페이지의 경로를 지정합니다.
        mav.setViewName("cmmn/egovError");         
        // 2. 에러 페이지에 전달할 에러 메시지를 담습니다.
        mav.addObject("message", "서비스 이용에 불편을 드려 죄송합니다.");
        // (선택) 어떤 종류의 에러인지 담아서 페이지에서 활용할 수도 있습니다.
        mav.addObject("exception", e);
        
        return mav;
    }
}