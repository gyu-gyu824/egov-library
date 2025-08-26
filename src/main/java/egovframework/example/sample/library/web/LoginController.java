package egovframework.example.sample.library.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.example.sample.library.service.LoginService;
import egovframework.example.sample.library.service.LoginVO;
import egovframework.example.sample.library.service.MemberService;
import egovframework.example.sample.library.service.MemberVO;

@Controller
public class LoginController {


	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="memberService")
	private MemberService memberService;
	
	
	@RequestMapping(value = "/login.do", method = RequestMethod.GET)
	public String loginPage() {
		return "/library/login";
	}

	@RequestMapping(value = "/login.do")
	public String login(HttpServletRequest request, LoginVO loginVO) throws Exception {
		LoginVO resultVO = loginService.selectLoginUser(loginVO);

		if (resultVO != null) {
			HttpSession session = request.getSession();
			session.setAttribute("loginVO", resultVO);
			return "redirect:/bookLoan.do";
		}
		else {
			return "redirect:/login.do";
		}
	}
	@RequestMapping(value = "/logout.do")
	public String logout(ModelMap model, HttpServletRequest request) throws Exception {
		return "redirect:/login.do";
	}
	
	@RequestMapping(value="/register.do", method=RequestMethod.GET)
	public String register(ModelMap model) throws Exception{
		return "/library/register";
	}
	
	@RequestMapping(value="/register.do", method=RequestMethod.POST)
	public String resgisterMember(@ModelAttribute("memberVO") MemberVO memberVO, ModelMap model) throws Exception{
		memberService.insertMember(memberVO);
		return "redirect:/login.do";
	}
	
	@RequestMapping(value="/checkUsername.do", method=RequestMethod.POST)
	@ResponseBody
	public Map<String ,Object> checkUsername(@RequestParam("username") String username) throws Exception{
		Map<String, Object> response = new HashMap<>();
		int count = memberService.checkUsername(username);
		
		if (count > 0) {
			response.put("isDuplicate", true);
		} else {
			response.put("isDuplicate", false);
		}
		
		return response;
	}
	
}
