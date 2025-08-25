package egovframework.example.sample.library.service;

import java.util.List;

public interface BookService {
	
	List<BookVO> selectAllBooks() throws Exception;
	
	BookVO selectBookById(int bookId) throws Exception;
	
	int insertBook(BookVO bookVO) throws Exception;
	
	int updateBook(BookVO bookVO) throws Exception;
	
	int deleteBook(int bookId) throws Exception;
	
	List<BookVO> searchKeyword(BookVO bookVO) throws Exception;
	
	List<BookVO> selectBooksByMemberId(int memberId) throws Exception;
	
	int returnBook(int bookId, int memberId) throws Exception;
	
	int insertLoan(int bookId, int memberId) throws Exception;	
	
	int modifyStatusBook(int bookId, int memberId) throws Exception;
	
	int availableBook(int bookId, int memberId) throws Exception;
	
	List<BookVO> loanList(int memberId) throws Exception;
	

}
