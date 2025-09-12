package egovframework.example.sample.library.service;

import java.util.ArrayList;
import java.util.List;
import lombok.Data;

@Data 
public class UploadResultVO {

    private int successCount = 0;
    private List<String> failureMessages = new ArrayList<>();


    public void addSuccess() {
        this.successCount++;
    }


    public void addFailure(int rowNum, String reason) {
        this.failureMessages.add(rowNum + "번째 행 처리 실패: " + reason);
    }
    
    public int getFailureCount() {
        return this.failureMessages.size();
    }
    
    public boolean hasFailures() { 
        return !this.failureMessages.isEmpty();
    }
}