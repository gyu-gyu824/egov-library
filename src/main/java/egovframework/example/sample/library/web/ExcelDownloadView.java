package egovframework.example.sample.library.web;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

@Component("excelDownloadView") // 이 View를 호출할 때 사용할 이름(ID)
public class ExcelDownloadView extends AbstractXlsxView {

    @Override
    protected void buildExcelDocument(Map<String, Object> model, 
                                      Workbook workbook, 
                                      HttpServletRequest request,
                                      HttpServletResponse response) throws Exception {

        String fileName = (String) model.get("fileName");
        String sheetName = (String) model.get("sheetName");
        String[] headers = (String[]) model.get("headers");
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> dataList = (List<Map<String, Object>>) model.get("dataList");
        
        String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + ".xlsx\"");

        Sheet sheet = workbook.createSheet(sheetName);
        
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            headerRow.createCell(i).setCellValue(headers[i]);
        }
        
        int rowNum = 1; 
        for (int i = 0; i < dataList.size(); i++) {
            Map<String, Object> data = dataList.get(i);
            Row row = sheet.createRow(rowNum++);
            
            for (int j = 0; j < headers.length; j++) {
                String header = headers[j];
                Object value = data.get(header);
                
                if (value != null) {
                    row.createCell(j).setCellValue(value.toString());
                } else {
                    row.createCell(j).setCellValue("");
                }
            }
        }
    }
}