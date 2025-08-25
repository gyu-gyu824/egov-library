package egovframework.example.sample.library.service.impl;



import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.sample.library.service.BookVO;

@Mapper("bookMapper")
public interface BookMapper {
    List<BookVO> selectAllBooks();
    List<BookVO> searchKeyword(BookVO bookVO);
    BookVO selectBookById(int bookId);
    int insertBook(BookVO book);
    int updateBook(BookVO book);
    int deleteBook(int bookId);
    List<BookVO> selectBooksByMemberId(int memberId);
    int returnBook(@Param("bookId") int bookId, @Param ("memberId") int memberId);
    int insertLoan(@Param("bookId") int bookId, @Param ("memberId") int memberId);
    int modifyStatusBook(@Param("bookId") int bookId, @Param("memberId") int memberId);
    int availableBook(@Param("bookId") int bookId, @Param("memberId") int memberId);
    List<BookVO> loanList(int memberId);
    
}

