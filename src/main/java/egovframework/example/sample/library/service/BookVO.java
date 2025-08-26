package egovframework.example.sample.library.service;


import java.io.Serializable;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class BookVO extends PaginationVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int bookId;
    private String title;
    private String author;
    private String publisher;
    private String status;
    private String searchKeyword; 
    private Date loanDate;
    private Date returnDate;
    private int memberId;
}
