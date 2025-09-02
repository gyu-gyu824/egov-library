package egovframework.example.sample.library.service;

public interface DownloadService {
	
	byte[] createExcelFile(BookVO bookVO) throws Exception;
	
}
