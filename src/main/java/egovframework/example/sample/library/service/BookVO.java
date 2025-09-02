package egovframework.example.sample.library.service;


import java.io.Serializable;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class BookVO extends SampleDefaultVO implements Serializable {
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
    
    private int totalQuantity;
    
    private int currentQuantity;
    
}
