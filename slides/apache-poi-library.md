---
marp: true
theme: default
class: lead
paginate: true
---

# 전자도서 대여 시스템의 Apache POI 적용 사례

- 발표자: [이름]
- 조직: [회사/팀]
- 일시: [YYYY-MM-DD]

---

## Agenda

1. 프로젝트/문제 배경
2. Apache POI 개요 및 선정 이유
3. 다운로드(Export) 구조와 구현
4. 업로드(Import) 구조와 구현
5. 의존성/버전과 보안·성능 고려사항
6. 효과와 성과, 확장 계획

---

## 프로젝트 배경과 목표

- 전자도서 대여 데이터의 대량 조회·공유 필요(보고서/감사/운영)
- 관리자의 전체 도서 목록 Export, 사용자 개인 대여 이력 Export
- 운영 편의를 위한 도서 일괄 업로드(등록·재고 반영)
- 목표: 서버사이드에서 신뢰성 있게 Excel(.xlsx) 생성/파싱

---

## Apache POI 개요 및 선정 이유

- Apache POI: Java에서 MS Office 문서를 생성/파싱하는 표준 라이브러리
- XSSF: .xlsx 포맷 지원(대부분의 최신 Excel 형식)
- SXSSF: 대용량 데이터 스트리밍 처리에 유리(확장 경로)
- 선정 이유: 표준성, 풍부한 API, Spring MVC와 결합 용이, 커뮤니티·레퍼런스 풍부

---

## 아키텍처 개요(다운로드)

- Controller: 조회 + Model 구성(`fileName`, `sheetName`, `headers`, `dataList`)
- View: `AbstractXlsxView` 상속(POI로 Workbook/Sheet/Row 생성)
- 이점: 뷰-로직 분리, 재사용성 높음, 테스트 용이

```java
// Controller → View로 전달 (요약)
model.addAttribute("fileName", "전체_도서_목록");
model.addAttribute("sheetName", "전체 도서 목록");
model.addAttribute("headers", new String[]{"ID","제목","저자","총 수량","현재 수량"});
model.addAttribute("dataList", dataList);
return "excelDownloadView"; // ViewResolver로 AbstractXlsxView 실행
```

---

## 구현: ExcelDownloadView (요약)

- `AbstractXlsxView`의 `buildExcelDocument`에서 POI API 사용
- 한글 파일명 안전하게 인코딩, 헤더/데이터 행 채움

```java
protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, ...){
  String fileName = (String) model.get("fileName");
  String[] headers = (String[]) model.get("headers");
  List<Map<String,Object>> dataList = (List<Map<String,Object>>) model.get("dataList");

  Sheet sheet = workbook.createSheet((String) model.get("sheetName"));
  Row headerRow = sheet.createRow(0);
  for (int i = 0; i < headers.length; i++) headerRow.createCell(i).setCellValue(headers[i]);

  int rowNum = 1;
  for (Map<String,Object> data : dataList) {
    Row row = sheet.createRow(rowNum++);
    for (int j = 0; j < headers.length; j++) {
      Object value = data.get(headers[j]);
      row.createCell(j).setCellValue(value != null ? value.toString() : "");
    }
  }
}
```

---

## 다운로드 사례 1: 나의 대여 기록

- 세션 사용자 기준 대여 이력 조회 → 시트 생성
- 날짜 포맷, 상태(대여 중/반납 완료) 가공 후 View로 전달

```java
model.addAttribute("fileName", "나의_대여_기록");
model.addAttribute("sheetName", "나의 대여 기록");
model.addAttribute("headers", new String[]{"제목","저자","대여일","반납일","상태"});
```

---

## 다운로드 사례 2: 전체 도서 목록

- 페이징 해제(최대치) 후 전체 목록을 Export
- 재사용 가능한 동일 View로 생성

```java
bookVO.setFirstIndex(0);
bookVO.setRecordCountPerPage(999999);
List<BookVO> bookList = bookService.selectBookList(bookVO);
```

---

## 아키텍처 개요(업로드)

- Controller: 파일 수신 → Service로 파싱 위임 → 도메인 매핑/검증 → 저장
- Service: 헤더 유효성 검증, `Row` 수집(POI), 예외 시 사용자 친화 메시지
- 컨트롤러: 성공/실패 건수와 상세 실패 목록을 알림으로 제공

---

## 구현: UploadServiceImpl (요약)

- `.xlsx` 파싱: `XSSFWorkbook`, 첫 시트, 헤더 정합성 검증
- 유효 행만 수집하여 상위 계층에서 매핑/검증 지속

```java
try (Workbook workbook = new XSSFWorkbook(excelFile.getInputStream())) {
  Sheet sheet = workbook.getSheetAt(0);
  Row headerRow = sheet.getRow(0);
  for (int i = 0; i < headers.length; i++) {
    Cell cell = headerRow.getCell(i);
    if (cell == null || !headers[i].equals(cell.getStringCellValue()))
      throw new Exception("엑셀 파일 양식이 올바르지 않습니다");
  }
  for (int i = 1; i <= sheet.getLastRowNum(); i++) {
    Row row = sheet.getRow(i);
    if (row != null) rowList.add(row);
  }
}
```

---

## 업로드 파싱/검증 포인트

- 타입 체크: 숫자 셀(`CellType.NUMERIC`)만 허용, 공란/오류시 행번호 포함 메시지
- 결과 요약: 성공 건수, 실패 건수/사유를 UI에 표기(운영 가시성)

```java
if (row.getCell(3) != null && row.getCell(3).getCellType() == CellType.NUMERIC){
  bookVO.setTotalQuantity((int) row.getCell(3).getNumericCellValue());
} else { result.addFailure(currentRowNum, "총 수량이 숫자가 아니거나 비어있습니다"); }
```

---

## 의존성/버전, 보안·성능 고려사항

- 의존성: `poi`, `poi-ooxml` 5.2.5 (XSSF 사용)
- 보안: 인증/권한 확인 후만 다운로드·업로드 허용, Content-Type/확장자 점검
- 성능: 대량 Export 시 SXSSF 전환 고려, 자동 컬럼폭·스타일은 비용 고려
- 안정성: 헤더 검증, 파일 크기 제한, OOM 방지(스트리밍/청크)
- 국제화: 파일명 UTF-8 인코딩(`URLEncoder`, 공백 `%20` 대체)

---

## 효과와 성과, 확장 계획

- 효과: 데이터 접근성↑, 업무 자동화, 일괄 등록으로 처리시간↓
- 확장: 공통 Excel 유틸/템플릿화, 날짜/숫자 포맷 공통 스타일, SXSSF 전환
- 품질: 업로드 엣지 케이스(빈셀·공백·과다열) 테스트, 통합테스트 보강

---

## Q & A

감사합니다.
- 데모: [다운로드/업로드 화면 시연]
- 연락처: [email / Slack]
