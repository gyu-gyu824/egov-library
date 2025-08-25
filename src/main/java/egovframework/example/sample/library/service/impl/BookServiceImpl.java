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
	public List<BookVO> selectAllBooks() throws Exception{
		return bookMapper.selectAllBooks();
	}
	
	@Override 
	public BookVO selectBookById(int bookId) throws Exception{
		return bookMapper.selectBookById(bookId);
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
	public List<BookVO> searchKeyword(BookVO bookVO) throws Exception{
		return bookMapper.searchKeyword(bookVO);
	}
	
	@Override
	public List<BookVO> selectBooksByMemberId(int memberId) throws Exception{
		return bookMapper.selectBooksByMemberId(memberId);
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
	
	@Override
	public List<BookVO> loanList(int memberId) throws Exception{
		return bookMapper.loanList(memberId);
	}
	

}
