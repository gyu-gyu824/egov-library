package egovframework.example.sample.library.service.impl;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.sample.library.service.BookVO;
import egovframework.example.sample.library.service.DownloadService;


@Service("downloadService")
public class DownloadServiceImpl extends EgovAbstractServiceImpl implements DownloadService{
	
	@Resource(name="bookMapper")
	BookMapper bookMapper;
	
	@Override
	public byte[] createExcelFile(BookVO bookVO) throws Exception{
		
		bookVO.setFirstIndex(0);
		bookVO.setRecordCountPerPage(999999);
		
		List<BookVO> loanHistoryList = bookMapper.selectLoanList(bookVO);
		
		System.out.println("대여 기록 수: " + loanHistoryList.size());
		
		try (Workbook workBook = new XSSFWorkbook();
			 ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
			
			Sheet sheet  = workBook.createSheet("대여 기록");
			
			String[] headers = {"제목", "저자", "출판사", "대여일", "반납일", "상태"};
			
			Row headerRow = sheet.createRow(0);
			
			for (int i = 0; i < headers.length; i++) {
				Cell cell = headerRow.createCell(i);
				cell.setCellValue(headers[i]);
			}
			
			int rowNum = 1;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			
			for (BookVO book : loanHistoryList) {
				Row row = sheet.createRow(rowNum++);
				row.createCell(0).setCellValue(book.getTitle());
				row.createCell(1).setCellValue(book.getAuthor());
				row.createCell(2).setCellValue(book.getPublisher());
				
				if (book.getLoanDate() != null) {
					row.createCell(3).setCellValue(sdf.format(book.getLoanDate()));
				}
				
				if (book.getReturnDate() != null) {
					row.createCell(4).setCellValue(sdf.format(book.getReturnDate()));
				}
				
				String statusText;
				if ("loaned".equals(book.getStatus())) {
					statusText = "대여중";
				} else {
					statusText = "반납 완료";
				}
				row.createCell(5).setCellValue(statusText);
			}
			
			workBook.write(outputStream);
			
			return outputStream.toByteArray();

		} catch (Exception e) {
			throw new Exception("엑셀 파일 생성 중 오류가 발생했습니다.", e);
		} 
	}	
}