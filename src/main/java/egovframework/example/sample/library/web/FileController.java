package egovframework.example.sample.library.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.example.sample.library.service.BookService;
import egovframework.example.sample.library.service.BookVO;
import egovframework.example.sample.library.service.LoginVO;
import egovframework.example.sample.library.service.UploadResultVO;
import egovframework.example.sample.library.service.UploadService;


@Controller
public class FileController {
	
	@Resource(name = "uploadService")
    private UploadService uploadService;
	
	@Resource(name = "bookService")
	private BookService bookService;

	
    @RequestMapping(value = "/downloadLoanHistory.do", method = RequestMethod.POST)
    public String downloadLoanHistory(BookVO bookVO, HttpServletRequest request, Model model, RedirectAttributes redirectAttributes) throws Exception {

        // 1. 데이터 준비: '나의 대여 기록' 조회
        HttpSession session = request.getSession();
        LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
        bookVO.setMemberId(loginVO.getMemberId());
        bookVO.setFirstIndex(0);
        bookVO.setRecordCountPerPage(999999);
        List<BookVO> loanHistory = bookService.selectLoanList(bookVO);
        
        if (loanHistory == null || loanHistory.isEmpty()) {
        	 redirectAttributes.addFlashAttribute("errorMessage", "다운로드할 대여 기록이 없습니다.");
             return "redirect:/loanList.do"; 
         }
        

        // 2. View에 전달할 데이터(헤더, 내용 등)를 Model에 담습니다.
        model.addAttribute("fileName", "나의_대여_기록");
        model.addAttribute("sheetName", "나의 대여 기록");
        model.addAttribute("headers", new String[]{"제목", "저자", "대여일", "반납일", "상태"});
        
        // 데이터 가공 (List<BookVO> -> List<Map>)
        List<Map<String, Object>> dataList = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        for (int i = 0; i < loanHistory.size(); i++) {
            BookVO book = loanHistory.get(i);
            Map<String, Object> map = new HashMap<>();
            
            map.put("제목", book.getTitle());
            map.put("저자", book.getAuthor());
            

            if (book.getLoanDate() != null) {
                map.put("대여일", sdf.format(book.getLoanDate()));
            } else {
                map.put("대여일", "");
            }
            
            if (book.getReturnDate() != null) {
                map.put("반납일", sdf.format(book.getReturnDate()));
            } else {
                map.put("반납일", "");
            }
            
            if ("loaned".equals(book.getStatus())) {
                map.put("상태", "대여 중");
            } else {
                map.put("상태", "반납 완료");
            }
            
            dataList.add(map);
        }
        model.addAttribute("dataList", dataList);
        
        return "excelDownloadView";
    }
	
    @RequestMapping(value = "/uploadBookList.do", method = RequestMethod.POST)
    public String uploadBookList(@RequestParam("excelFile") MultipartFile excelFile, RedirectAttributes redirectAttributes) {
        
    	String originalFilename = excelFile.getOriginalFilename();
        if (originalFilename == null || 
           (!originalFilename.endsWith(".xlsx") && !originalFilename.endsWith(".xls"))) {
            
            redirectAttributes.addFlashAttribute("errorMessage", "엑셀 파일(.xlsx)만 업로드할 수 있습니다.");
            return "redirect:/admin/bookList.do";
        }
        

        try {
            String[] bookHeaders = {"제목", "저자", "출판사", "총 수량", "현재 수량"};
            List<Row> rows = uploadService.getExcelRows(excelFile, bookHeaders);
            
            UploadResultVO result = new UploadResultVO();
            
            List<BookVO> bookList = new ArrayList<>();
            for (int i = 0; i < rows.size(); i++) {
                Row row = rows.get(i);
                int currentRowNum = i + 2;
                
                try {
                    BookVO bookVO = new BookVO();
                	
                    if (row.getCell(0) != null) {
                    	bookVO.setTitle(row.getCell(0).getStringCellValue());
                    } else {
                    	result.addFailure(currentRowNum, "제목이 비어있습니다");
                    	continue;
                    }
                    if (row.getCell(1) != null) {
                    	bookVO.setAuthor(row.getCell(1).getStringCellValue());
                    } else {
                    	result.addFailure(currentRowNum, "저자가 비어있습니다");
                    	continue;
                    }
                    if (row.getCell(2) != null) {
                    	bookVO.setPublisher(row.getCell(2).getStringCellValue());
                    } else {
                    	result.addFailure(currentRowNum, "출반사가 비어있습니다");
                    	continue;
                    }
                    
                    if (row.getCell(3) != null && row.getCell(3).getCellType() == CellType.NUMERIC) {
                        bookVO.setTotalQuantity((int) row.getCell(3).getNumericCellValue());
                    } else {
                    	result.addFailure(currentRowNum, "총 수량이 숫자가 아니거나 비어있습니다");
                    	continue;
                    }

                    if (row.getCell(4) != null && row.getCell(4).getCellType() == CellType.NUMERIC) {
                        bookVO.setCurrentQuantity((int) row.getCell(4).getNumericCellValue());
                    } else {
                    	result.addFailure(currentRowNum, "현재 수량이 숫자가 아니거나 비어있습니다");
                    	continue; 
                    }
                    bookList.add(bookVO);
                } catch (Exception e) {
                	result.addFailure(currentRowNum,"알 수 없는 오류 (" + e.getMessage() + ")");
                }

            }
            if (!bookList.isEmpty()) {
                bookService.addBooksFromExcel(bookList);
                result.setSuccessCount(bookList.size());
            }
            
            StringBuilder messages = new StringBuilder();
            messages.append("총" + result.getSuccessCount() + "권이 등록되었습니다.");
                  
            if (result.hasFailures()) {
                messages.append("<br>" + result.getFailureCount()  + "건의 데이터는 실패했습니다<br><strong>실패 목록:</strong><br>");
                messages.append(String.join("<br>", result.getFailureMessages()));
                redirectAttributes.addFlashAttribute("errorMessage", messages.toString());
            } else {
                redirectAttributes.addFlashAttribute("successMessage", messages.toString());
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("에러 메시지: " + e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }  
        
        return "redirect:/admin/bookList.do";
    }
    
    @RequestMapping(value = "/admin/downloadBookList.do", method = RequestMethod.POST)
    public String downloadBookList(BookVO bookVO, Model model) throws Exception {
        
        // 1. 엑셀에 담을 전체 데이터를 조회합니다.
        bookVO.setFirstIndex(0); 
        bookVO.setRecordCountPerPage(999999);
        List<BookVO> bookList = bookService.selectBookList(bookVO);
        
        // 2. View에 전달할 '재료'들을 Model에 담습니다.
        model.addAttribute("fileName", "전체_도서_목록");
        model.addAttribute("sheetName", "전체 도서 목록");
        model.addAttribute("headers", new String[]{"ID", "제목", "저자", "총 수량", "현재 수량"});
        
        // 3. 데이터를 View가 사용할 형태(List<Map>)로 가공하여 Model에 담습니다.
        List<Map<String, Object>> dataList = new ArrayList<>();
        for (int i = 0; i < bookList.size(); i++) {
            BookVO book = bookList.get(i);
            Map<String, Object> map = new HashMap<>();
            map.put("ID", book.getBookId());
            map.put("제목", book.getTitle());
            map.put("저자", book.getAuthor());
            map.put("총 수량", book.getTotalQuantity());
            map.put("현재 수량", book.getCurrentQuantity());
            dataList.add(map);
        }
        model.addAttribute("dataList", dataList);
        
        return "excelDownloadView";
    }
    

		
    
}
