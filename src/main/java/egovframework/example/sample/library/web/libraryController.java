package egovframework.example.sample.library.web;



import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.library.service.BookService;
import egovframework.example.sample.library.service.BookVO;
import egovframework.example.sample.library.service.LoginService;
import egovframework.example.sample.library.service.LoginVO;

@Controller
public class libraryController {

	@Resource(name = "bookService")
	private BookService bookService;

	@Resource(name = "loginService")
	private LoginService loginService;


	@RequestMapping(value = "/bookLoan.do")
	public String library(ModelMap model, @RequestParam(value="searchKeyword", required=false) String searchKeyword) throws Exception {
		List<BookVO> bookList;
		if (searchKeyword != null && !searchKeyword.isEmpty()) {
			BookVO searchVO = new BookVO();
			searchVO.setSearchKeyword(searchKeyword);
			bookList = bookService.searchKeyword(searchVO);
		}
		else {
			bookList = bookService.selectAllBooks();
		}
		model.addAttribute("bookList", bookList);
		return "/library/bookLoan";
	}

	@RequestMapping(value="/bookDetail.do")
	public String bookDetail(@RequestParam(value="bookId") int bookId, ModelMap model) throws Exception{
		BookVO book = bookService.selectBookById(bookId);

		model.addAttribute("book", book);
		return "/library/bookDetail";
	}

	@RequestMapping(value="/loanBook.do")
	@ResponseBody
	public BookVO loanBook(HttpServletRequest request, @RequestParam(value="bookId") int bookId) throws Exception{
		
		
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		int memberId = loginVO.getMemberId();
		
		bookService.modifyStatusBook(bookId, memberId);
		
		bookService.insertLoan(bookId, memberId);
		
		BookVO bookVO = bookService.selectBookById(bookId);
		
		return bookVO;

	}
		


	@RequestMapping(value= "/myLoans.do", method=RequestMethod.GET)
	public String myLoans(HttpServletRequest request, ModelMap model) throws Exception{
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		if (loginVO == null) {
			return "redirect:/login.do";
		}
		
		int memberId = loginVO.getMemberId();
		List<BookVO> myLoanList = bookService.selectBooksByMemberId(memberId);
		model.addAttribute("myLoanList", myLoanList);
		
		return "/library/myLoan";
		
	}
	
	@RequestMapping(value="/returnBook.do",method=RequestMethod.POST)
	public String returnBook(HttpServletRequest request, ModelMap model, @RequestParam("bookId") int bookId) throws Exception{
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		int memberId = loginVO.getMemberId();
		
		bookService.availableBook(bookId, memberId);
		
		bookService.returnBook(bookId, memberId);
		
		List<BookVO> myLoanList = bookService.selectBooksByMemberId(memberId);
		
		model.addAttribute("myLoanList", myLoanList);
		
		System.out.println(myLoanList);
		
		return "/library/myLoan";

	}
	
	@RequestMapping(value="/loanList.do")
	public String loanList(HttpServletRequest request, ModelMap model) throws Exception{
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		int memberId = loginVO.getMemberId();
		
		List<BookVO> loanHistory = bookService.loanList(memberId);
		
		model.addAttribute("loanHistory", loanHistory);
		
		return "/library/loanList";
	}
	
}
