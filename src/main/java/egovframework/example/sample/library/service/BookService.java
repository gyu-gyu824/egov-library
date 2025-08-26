package egovframework.example.sample.library.service;

import java.util.List;

public interface BookService {
	
	int countAllBooks(BookVO bookVO) throws Exception;
	
	List<BookVO> selectBookList(BookVO bookVO) throws Exception;
	
	BookVO selectBookById(int bookId) throws Exception;
	
	int countMyLoans(BookVO bookVO) throws Exception;
	
	List<BookVO> selectMyLoans(BookVO bookVO) throws Exception;
	
	int countLoanList(BookVO bookVO) throws Exception;
	
	List<BookVO> selectLoanList(BookVO bookVO) throws Exception;
	
	int insertBook(BookVO bookVO) throws Exception;
	
	int updateBook(BookVO bookVO) throws Exception;
	
	int deleteBook(int bookId) throws Exception;
	
	int returnBook(int bookId, int memberId) throws Exception;
	
	int insertLoan(int bookId, int memberId) throws Exception;	
	
	int modifyStatusBook(int bookId, int memberId) throws Exception;
	
	int availableBook(int bookId, int memberId) throws Exception;
	
	

}
