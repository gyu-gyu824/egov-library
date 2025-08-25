package egovframework.example.sample.library.service.impl;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.sample.library.service.MemberService;
import egovframework.example.sample.library.service.MemberVO;



@Service("memberService")
public class MemberServiceImpl extends EgovAbstractServiceImpl implements MemberService  {
	
	@Resource(name="memberMapper")
	private MemberMapper memberMapper;
	
	
	@Override
	public int checkUsername(String username) throws Exception{
		return memberMapper.checkUsername(username);
	}
	
	@Override
	public void insertMember(MemberVO memberVO) throws Exception{
		memberMapper.insertMember(memberVO);
	}
}
