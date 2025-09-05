package egovframework.example.sample.library.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.example.sample.library.service.BookService;
import egovframework.example.sample.library.service.BookVO;
import egovframework.example.sample.library.service.UploadService;

@Service("uploadService")
public class UploadServiceImpl extends EgovAbstractServiceImpl implements UploadService{
	
	@Resource(name="bookService")
	private BookService bookService;
	
	@Override
	@Transactional
	public List<Row> getExcelRows(MultipartFile excelFile, String[] headers) throws Exception{
		
		
		List<Row> rowList = new ArrayList<>();
		
		try(Workbook workbook = new XSSFWorkbook(excelFile.getInputStream())){
			Sheet sheet = workbook.getSheetAt(0);
			
			Row headerRow = sheet.getRow(0);
			if (headerRow == null) {
				throw new Exception("헤더가 없는 엑셀파일입니다");
			}
			
			for (int i = 0; i < headers.length; i++) {
				Cell cell = headerRow.getCell(i);
				if (cell == null || !headers[i].equals(cell.getStringCellValue())) {
					throw new Exception("엑셀 파일 양식이 올바르지 않습니다");
				}
			}
			
			for (int i = 1; i <= sheet.getLastRowNum(); i++) {
				Row row = sheet.getRow(i);
				if (row != null) {
					rowList.add(row);
				}
			}
		}
		return rowList;
	}
}

