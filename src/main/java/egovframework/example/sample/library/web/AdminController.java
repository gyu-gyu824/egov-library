package egovframework.example.sample.library.web;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.example.sample.library.service.BookService;
import egovframework.example.sample.library.service.BookVO;
import egovframework.example.sample.library.service.LoginService;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Resource(name = "bookService")
	private BookService bookService;

	@Resource(name = "loginService")
	private LoginService loginService;
	
	
	@RequestMapping(value="/bookList.do")
	public String admin(ModelMap model, BookVO bookVO) throws Exception{
		
		int totalCount = bookService.countAllBooks(bookVO);
		
		bookVO.setTotalCount(totalCount);
		
		List<BookVO> bookList = bookService.selectBookList(bookVO);
		
		model.addAttribute("pagination", bookVO);
		model.addAttribute("bookList", bookList);
		
		return "/library/admin/bookList";
	}
	
	
	@RequestMapping(value="/editBook.do")
	public String editBook(ModelMap model, @RequestParam("bookId") int bookId) throws Exception{
		
		BookVO bookVO = bookService.selectBookById(bookId);
		
		model.addAttribute("bookVO", bookVO);
		
		return "/library/admin/editBook";
	}
	
	@RequestMapping(value="/updateBook.do", method = RequestMethod.POST)
	public String updateBook(@ModelAttribute BookVO bookVO) throws Exception {
		
		bookService.updateBook(bookVO);
		
		return "redirect:/admin/bookList.do";
	}
	
	@RequestMapping(value="/deleteBook.do", method = RequestMethod.POST)
	public String deleteBook(@RequestParam("bookId") int bookId) throws Exception {
		
		bookService.deleteBook(bookId);
		
		return "redirect:/admin/bookList.do";
	}
	

	

	
	@RequestMapping(value="/addBook.do", method=RequestMethod.GET)
	public String addBook() throws Exception {
		return "/library/admin/addBook";
	}
	
	@RequestMapping(value="/addBook.do", method=RequestMethod.POST)
	public String addBookForm(@ModelAttribute BookVO bookVO) throws Exception {
		
		bookVO.setStatus("available");
		
		bookService.insertBook(bookVO);
		
		return "redirect:/admin/bookList.do";
	}
	
	
}
