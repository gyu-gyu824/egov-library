package egovframework.example.sample.library.web;

import java.nio.charset.StandardCharsets;
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
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.example.sample.library.service.BookService;
import egovframework.example.sample.library.service.BookVO;
import egovframework.example.sample.library.service.DownloadService;
import egovframework.example.sample.library.service.LoginVO;
import egovframework.example.sample.library.service.UploadService;


@Controller
public class FileController {
	@Resource(name = "downloadService")
	private DownloadService downloadService;
	
	@Resource(name = "uploadService")
    private UploadService uploadService;
	
	@Resource(name = "bookService")
	private BookService bookService;

	
	@RequestMapping(value = "/downloadLoanHistory.do", method = RequestMethod.POST)
	public ResponseEntity<byte[]> createExcel(BookVO bookVO, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");		
		int memberId = loginVO.getMemberId();
		bookVO.setMemberId(memberId);
		
		bookVO.setFirstIndex(0); 
		bookVO.setRecordCountPerPage(999999);
		List<BookVO> loanHistory = bookService.selectLoanList(bookVO);
		
		String[] headers = {"제목", "저자", "출판사", "대여일", "반납일", "상태"};
		
		List<Map<String, Object>> dataList = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        for (int i = 0; i < loanHistory.size(); i++) {
            BookVO record = loanHistory.get(i);
            
            Map<String, Object> map = new HashMap<>();
            map.put("제목", record.getTitle());
            map.put("저자", record.getAuthor());
            map.put("출판사", record.getPublisher());
            
            if (record.getLoanDate() != null) {
                map.put("대여일", sdf.format(record.getLoanDate()));
            } else {
                map.put("대여일", "");
            }
            
            if (record.getReturnDate() != null) { 
                map.put("반납일", sdf.format(record.getReturnDate()));
            } else {
                map.put("반납일", "");
            }
            
            if ("loaned".equals(record.getStatus())) {
                map.put("상태", "대여 중");
            } else {
                map.put("상태", "반납 완료");
            }
            
            dataList.add(map);
        }
		
        byte[] excelBytes = downloadService.createExcelFile(headers, dataList, "대여 기록");
        

		String fileName = "대여 기록.xlsx";
		String encodedFileName = java.net.URLEncoder.encode(fileName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

		HttpHeaders httpHeaders = new HttpHeaders();

		
		httpHeaders.add("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\""); 
		httpHeaders.add("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		
		return new ResponseEntity<>(excelBytes, httpHeaders, HttpStatus.OK);
	}
	
    @RequestMapping(value = "/uploadBookList.do", method = RequestMethod.POST)
    public String uploadBookList(@RequestParam("excelFile") MultipartFile excelFile, RedirectAttributes redirectAttributes) {
        
        if (excelFile.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "업로드할 엑셀 파일을 선택해주세요.");
            return "redirect:/admin/bookList.do";
        }
        
        try {
            String[] bookHeaders = {"제목", "저자", "출판사", "총 수량", "현재 수량"};
            List<Row> rows = uploadService.getExcelRows(excelFile, bookHeaders);
            
            List<BookVO> bookList = new ArrayList<>();
            for (int i = 0; i < rows.size(); i++) {
                Row row = rows.get(i);
                BookVO bookVO = new BookVO();

                if (row.getCell(0) != null) bookVO.setTitle(row.getCell(0).getStringCellValue());
                if (row.getCell(1) != null) bookVO.setAuthor(row.getCell(1).getStringCellValue());
                if (row.getCell(2) != null) bookVO.setPublisher(row.getCell(2).getStringCellValue());
                
                if (row.getCell(3) != null && row.getCell(3).getCellType() == CellType.NUMERIC) {
                    bookVO.setTotalQuantity((int) row.getCell(3).getNumericCellValue());
                } else { continue; }

                if (row.getCell(4) != null && row.getCell(4).getCellType() == CellType.NUMERIC) {
                    bookVO.setCurrentQuantity((int) row.getCell(4).getNumericCellValue());
                } else { continue; }
                
                bookList.add(bookVO);
            }
            
            bookService.addBooksFromExcel(bookList);
            
            redirectAttributes.addFlashAttribute("successMessage", bookList.size() + "개의 도서가 성공적으로 처리되었습니다.");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "업로드 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return "redirect:/admin/bookList.do";
    }
    
    @RequestMapping(value = "/admin/downloadBookList.do", method = RequestMethod.POST)
	public ResponseEntity<byte[]> downloadBookList(BookVO bookVO, HttpServletRequest request) throws Exception {
		
		bookVO.setFirstIndex(0); 
		bookVO.setRecordCountPerPage(999999);
		List<BookVO> bookList = bookService.selectBookList(bookVO);
		
		String[] headers = {"책 아이디", "제목", "저자", "출판사", "상태", "현재 수량", "총 수량"};
		
		List<Map<String, Object>> dataList = new ArrayList<>();
		for (int i = 0; i < bookList.size(); i++) {
			BookVO record = bookList.get(i);
			
			Map<String, Object> map = new HashMap<>();
			map.put("책 아이디", record.getBookId());
			map.put("제목", record.getTitle());
			map.put("저자",  record.getAuthor());
			map.put("출판사",  record.getPublisher());
			
			String statusText;
			if (record.getCurrentQuantity() > 0) {
				statusText = "대여 가능";
			} else {
				statusText = "대여 불가";
			}
			map.put("상태", statusText);
			
			map.put("현재 수량",  record.getCurrentQuantity());
			map.put("총 수량",  record.getTotalQuantity());

			dataList.add(map);
		}
		
		byte[] excelBytes = downloadService.createExcelFile(headers, dataList, "챙 정보");
		
		String fileName = "책 정보.xlsx";
		String encodedFileName = java.net.URLEncoder.encode(fileName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

		HttpHeaders httpHeaders = new HttpHeaders();

		
		httpHeaders.add("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\""); 
		httpHeaders.add("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		
		return new ResponseEntity<>(excelBytes, httpHeaders, HttpStatus.OK);
	}
		
    
}
