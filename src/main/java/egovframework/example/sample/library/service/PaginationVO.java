package egovframework.example.sample.library.service;

import lombok.Getter;
import lombok.ToString;

@Getter // 모든 필드에 대한 Getter를 자동으로 생성합니다.
@ToString // toString() 메서드를 자동으로 생성합니다.
public class PaginationVO {

    private int page; // 현재 페이지 번호
    private int perPageNum; // 한 페이지당 보여줄 게시글의 개수
    private int totalCount; // 전체 게시글 수

    private int startPage; // 시작 페이지 번호
    private int endPage; // 끝 페이지 번호
    private boolean prev; // 이전 버튼 유무
    private boolean next; // 다음 버튼 유무

    private final int displayPageNum = 10; // 화면 하단에 보여줄 페이지 번호의 개수

    public PaginationVO() {
        this.page = 1;
        this.perPageNum = 10;
    }

    // MyBatis SQL에서 사용할 시작 인덱스 계산 (계산 로직이 있으므로 직접 작성)
    public int getPageStart() {
        return (this.page - 1) * perPageNum;
    }

    // --- Custom Setters (유효성 검사 등 로직이 포함된 Setter는 직접 작성합니다) ---

    public void setPage(int page) {
        if (page <= 0) {
            this.page = 1;
            return;
        }
        this.page = page;
    }

    public void setPerPageNum(int perPageNum) {
        if (perPageNum <= 0 || perPageNum > 100) {
            this.perPageNum = 10;
            return;
        }
        this.perPageNum = perPageNum;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
        calcData(); // 전체 게시글 수가 정해지면 모든 값을 계산
    }

    private void calcData() {
        endPage = (int) (Math.ceil(page / (double) displayPageNum) * displayPageNum);
        startPage = (endPage - displayPageNum) + 1;

        int tempEndPage = (int) (Math.ceil(totalCount / (double) perPageNum));

        if (endPage > tempEndPage) {
            endPage = tempEndPage;
        }

        prev = startPage != 1;
        next = endPage * perPageNum < totalCount;
    }
}