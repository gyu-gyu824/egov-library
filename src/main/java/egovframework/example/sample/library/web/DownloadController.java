package egovframework.example.sample.library.web;

import java.nio.charset.StandardCharsets;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.example.sample.library.service.BookVO;
import egovframework.example.sample.library.service.DownloadService;
import egovframework.example.sample.library.service.LoginService;
import egovframework.example.sample.library.service.LoginVO;

@Controller
public class DownloadController {

	@Resource(name = "downloadService")
	private DownloadService downloadService;
	
	@Resource(name = "loginService")
	private LoginService loginService;

	@RequestMapping(value = "/down-excel.do", method = RequestMethod.POST)
	public ResponseEntity<byte[]> createExcel(BookVO bookVO, HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		int memberId = loginVO.getMemberId();
		
		bookVO.setMemberId(memberId);
		
		byte[] excelFile = downloadService.createExcelFile(bookVO);
		
		System.out.println("엑셀 파일 바이트 크기: " + excelFile.length);

		String fileName = "대여 기록.xlsx";
		String encodedFileName = java.net.URLEncoder.encode(fileName, StandardCharsets.UTF_8).replaceAll("\\+", "%20");

		HttpHeaders headers = new HttpHeaders();

		
		  headers.add("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\""); 
		  headers.add("Content-Type", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		
		return new ResponseEntity<>(excelFile, headers, HttpStatus.OK);
	}
}
