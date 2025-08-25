package egovframework.example.sample.library.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.sample.library.service.MemberVO;

@Mapper("memberMapper")
public interface MemberMapper {
	int checkUsername(String username);
	void insertMember (MemberVO memberVO);
}
