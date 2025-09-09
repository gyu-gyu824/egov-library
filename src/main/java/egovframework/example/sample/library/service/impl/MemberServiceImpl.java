package egovframework.example.sample.library.service.impl;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import egovframework.example.sample.library.service.MemberService;
import egovframework.example.sample.library.service.MemberVO;



@Service("memberService")
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService  {
	
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	
	@Resource(name="memberMapper")
	private MemberMapper memberMapper;
	
	
	@Override
	public int checkUsername(String username) throws Exception{
		return memberMapper.checkUsername(username);
	}
	
	@Override
	public void insertMember(MemberVO memberVO) throws Exception{
		
		String rawPassword = memberVO.getPassword();
		
		String encodedPassword = passwordEncoder.encode(rawPassword);
		
		memberVO.setPassword(encodedPassword);
		
		memberMapper.insertMember(memberVO);
	}
}
