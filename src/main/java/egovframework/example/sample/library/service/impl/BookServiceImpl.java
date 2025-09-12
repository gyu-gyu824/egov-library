package egovframework.example.sample.library.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.example.sample.library.service.BookService;
import egovframework.example.sample.library.service.BookVO;

@Service("bookService")
public class BookServiceImpl extends EgovAbstractServiceImpl implements BookService {
	@Resource(name="bookMapper")
	private BookMapper bookMapper;
	
	
	@Override
	public int countAllBooks(BookVO bookVO) throws Exception{
		return bookMapper.countAllBooks(bookVO);
	}
	
	@Override
	public List<BookVO> selectBookList(BookVO bookVO) throws Exception{
		return bookMapper.selectBookList(bookVO);
	}
	
	@Override 
	public BookVO selectBookById(int bookId) throws Exception{
		return bookMapper.selectBookById(bookId);
	}
	
	@Override
	public int countMyLoans(BookVO bookVO) throws Exception{
		return bookMapper.countMyLoans(bookVO);
	}
	
	@Override
	public List<BookVO> selectMyLoans(BookVO bookVO) throws Exception{
		return bookMapper.selectMyLoans(bookVO);
	}
	
	@Override
	public int countLoanList(BookVO bookVO) throws Exception{
		return bookMapper.countLoanList(bookVO);
	}
	
	@Override
	public List<BookVO> selectLoanList(BookVO bookVO) throws Exception{
		return bookMapper.selectLoanList(bookVO);
	}
	
	@Override
	@Transactional
	public int insertBook(BookVO bookVO) throws Exception{
	    
		BookVO existingBook = bookMapper.findBookByTitleAndAuthor(bookVO);
		
		if (existingBook != null) {
			bookVO.setBookId(existingBook.getBookId());
			
			return bookMapper.increaseBookStock(bookVO);
		} else {
			bookVO.setCurrentQuantity(bookVO.getTotalQuantity());
			return bookMapper.insertBook(bookVO);
		}
	}
	
	@Override
	public int updateBook(BookVO bookVO) throws Exception{
		return bookMapper.updateBook(bookVO);
	}
	
	@Override
	public int deleteBook(int bookId) throws Exception{
		return bookMapper.deleteBook(bookId);
	}
	
	@Override
	@Transactional
	public int returnBook(int bookId, int memberId) throws Exception {
	      
	    bookMapper.increaseBookQuantity(bookId);
	    
	    return bookMapper.returnBook(bookId, memberId);
	}
	
	@Override
	@Transactional
	public int insertLoan(int bookId, int memberId) throws Exception{
		
		int updateCount = bookMapper.decreaseBookQuantity(bookId);
		
		if (updateCount ==  0) {
			throw new Exception("대여 가능한 책의 재고가 없습니다");
		}
		
		return bookMapper.insertLoan(bookId, memberId);
	}
	
	@Override
	public int decreaseBookQuantity(int bookId) throws Exception{
		return bookMapper.decreaseBookQuantity(bookId);
	}
	
	@Override
	public int increaseBookQuantity(int bookId) throws Exception{
		return bookMapper.increaseBookQuantity(bookId);
	}
	
	@Override
	public BookVO findBookByTitleAndAuthor(BookVO bookVO) throws Exception {
	    return bookMapper.findBookByTitleAndAuthor(bookVO);
	}

	@Override
	public int increaseBookStock(BookVO bookVO) throws Exception {
	    return bookMapper.increaseBookStock(bookVO);
	}
	
    @Override
    @Transactional
    public void addBooksFromExcel(List<BookVO> bookList) throws Exception {
        if (bookList == null) {
            return;
        }
        for (int i = 0; i < bookList.size(); i++) {
            BookVO bookVO = bookList.get(i);

            this.insertBook(bookVO);
        }
    }
    
    @Override
    @Transactional
    public void selectOverdueLoans() throws Exception {
        
        List<BookVO> overdueList = bookMapper.selectOverdueLoans();

        
        for (int i = 0; i < overdueList.size(); i++) {
            BookVO overdueLoan = overdueList.get(i);
            
            this.returnBook(overdueLoan.getBookId(), overdueLoan.getMemberId());
        }

    }
    
    @Override
    @Transactional
    public List<BookVO> checkNotification(int memberId) throws Exception{
    	
    	List<BookVO> notificationList = bookMapper.selectNotification(memberId);
    	
    	if (notificationList != null && !notificationList.isEmpty()) {
    		bookMapper.returnNotification(memberId);
    	}
    	
    	return notificationList;
    }
}

