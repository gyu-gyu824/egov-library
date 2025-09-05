package egovframework.example.sample.library.service.impl;

import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.sample.library.service.DownloadService;


@Service("downloadService")
public class DownloadServiceImpl extends EgovAbstractServiceImpl implements DownloadService{
	
	@Override
	public byte[] createExcelFile(String[] headers, List<Map<String, Object>> dataList, String sheetName) throws Exception{
		
		try(Workbook workbook = new XSSFWorkbook()){
			Sheet sheet = workbook.createSheet(sheetName);
			
			Row headerRow = sheet.createRow(0);
			for (int i = 0; i < headers.length; i++) {
				headerRow.createCell(i).setCellValue(headers[i]);
			}
			
			int rowNum = 1;
			for (int i = 0; i <dataList.size(); i++) {
				Row row = sheet.createRow(rowNum++);
				Map<String, Object> data = dataList.get(i);
				
				for (int j = 0; j < headers.length; j++) {
					String header = headers[j];
					Object value = data.get(header);
					
					Cell cell = row.createCell(j);
					
					if (value != null) {
						cell.setCellValue(value.toString());
					} else {
						cell.setCellValue("");
					}
				}
			}
			
			ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
			workbook.write(outputStream);
			return outputStream.toByteArray();
			
			
		}
	}
}