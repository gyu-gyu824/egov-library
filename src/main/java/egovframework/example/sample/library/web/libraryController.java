package egovframework.example.sample.library.web;



import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	public String library(ModelMap model, BookVO bookVO) throws Exception {
		
		int totalCount = bookService.countAllBooks(bookVO);
		
		bookVO.setTotalCount(totalCount);
		
		List<BookVO> bookList = bookService.selectBookList(bookVO);
		
		model.addAttribute("pagination", bookVO);
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
	public String myLoans(HttpServletRequest request, ModelMap model, BookVO bookVO) throws Exception{
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		if (loginVO == null) {
			return "redirect:/login.do";
		}
		
		int memberId = loginVO.getMemberId();
		bookVO.setMemberId(memberId);
		
		int totalCount = bookService.countMyLoans(bookVO);
		
		bookVO.setTotalCount(totalCount);
		
		List<BookVO> myLoanList = bookService.selectMyLoans(bookVO);
		
		model.addAttribute("pagination", bookVO);
		model.addAttribute("myLoanList", myLoanList);
		
		return "/library/myLoan";
		
	}
	
	@RequestMapping(value="/returnBook.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> returnBook(HttpServletRequest request, @RequestParam("bookId") int bookId) throws Exception{
		Map<String, Object> result = new HashMap<>();
		
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		try {
			int memberId = loginVO.getMemberId();
			
			bookService.availableBook(bookId, memberId);
			
			bookService.returnBook(bookId, memberId);
			
			result.put("sueccess", true);
			result.put("message", "반납이 완료되었습니다");
		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "반납에 실패하였습니다");
		}
		return result;
	}
	
	@RequestMapping(value="/loanList.do")
	public String loanList(HttpServletRequest request, ModelMap model, BookVO bookVO) throws Exception{
		HttpSession session = request.getSession();
		LoginVO loginVO = (LoginVO) session.getAttribute("loginVO");
		
		int memberId = loginVO.getMemberId();
		bookVO.setMemberId(memberId);
		
		int totalCount = bookService.countLoanList(bookVO);
		
		bookVO.setTotalCount(totalCount);
		
		List<BookVO> loanHistory = bookService.selectLoanList(bookVO);
		
		model.addAttribute("pagination", bookVO);
		model.addAttribute("loanHistory", loanHistory);
		
		return "/library/loanList";
	}
	
}
