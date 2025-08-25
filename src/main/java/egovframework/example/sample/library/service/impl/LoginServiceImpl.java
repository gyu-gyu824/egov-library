package egovframework.example.sample.library.service.impl;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import egovframework.example.sample.library.service.LoginService;
import egovframework.example.sample.library.service.LoginVO;

@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {
	
	@Resource(name="loginMapper")
	private LoginMapper loginMapper;
	
	@Override
	public LoginVO selectLoginUser(LoginVO loginVO) throws Exception {
		return loginMapper.selectLoginUser(loginVO);
	}

}
