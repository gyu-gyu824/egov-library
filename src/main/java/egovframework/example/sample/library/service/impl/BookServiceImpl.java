package egovframework.example.sample.library.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

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
	public int insertBook(BookVO bookVO) throws Exception{
		return bookMapper.insertBook(bookVO);
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
    public int returnBook(int bookId, int memberId) throws Exception{
        return bookMapper.returnBook(bookId, memberId);
    }
	
	@Override
	public int insertLoan(int bookId, int memberId) throws Exception{
		return bookMapper.insertLoan(bookId, memberId);
	}
	
	@Override
	public int modifyStatusBook(int bookId, int memberId) throws Exception{
		return bookMapper.modifyStatusBook(bookId, memberId);
	}
	
	@Override
	public int availableBook(int bookId, int memberId) throws Exception{
		return bookMapper.availableBook(bookId, memberId);
	}
	
	

}
