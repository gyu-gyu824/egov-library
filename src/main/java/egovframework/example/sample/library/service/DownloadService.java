package egovframework.example.sample.library.service;

import java.util.List;
import java.util.Map;

public interface DownloadService {
	
    byte[] createExcelFile(String[] headers, List<Map<String, Object>> dataList, String sheetName) throws Exception;
}
