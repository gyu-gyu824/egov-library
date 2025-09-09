package egovframework.example.sample.library.web;

import javax.annotation.Resource;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.example.sample.library.service.BookService;

@Component
public class LibraryScheduler {
	
    @Resource(name = "bookService")
    private BookService bookService;


    @Scheduled(cron = "0 0 0 * * ?") // 초 분 시 일 월 요일
    public void checkOverdueBooks() {
        System.out.println("스케줄러: 연체 도서 강제 반납 처리를 시작합니다...");
        try {
            bookService.selectOverdueLoans();
            System.out.println("스케줄러: 연체 도서 처리가 완료되었습니다.");
        } catch (Exception e) {
            System.err.println("스케줄러: 연체 도서 처리 중 오류가 발생했습니다.");
            e.printStackTrace();
        }
    }
}
