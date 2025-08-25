package egovframework.example.sample.library.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.example.sample.library.service.LoginVO;

@Mapper("loginMapper")
public interface LoginMapper {
	LoginVO selectLoginUser (LoginVO loginVO);
}
