package egovframework.example.sample.library.service;

import java.util.List;

import org.apache.poi.ss.usermodel.Row;
import org.springframework.web.multipart.MultipartFile;

public interface UploadService {
    List<Row> getExcelRows(MultipartFile excelFile, String[] headers) throws Exception;
}
