package egovframework.example.sample.library.service.impl;
import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import egovframework.example.sample.library.service.LoginService;
import egovframework.example.sample.library.service.LoginVO;

@Service("loginService")
public class LoginServiceImpl extends EgovAbstractServiceImpl implements LoginService {
	
    private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	
	@Resource(name="loginMapper")
	private LoginMapper loginMapper;
	
	@Override
	public LoginVO selectLoginUser(LoginVO loginVO) throws Exception {
		
		LoginVO userVO = loginMapper.selectUserByUsername(loginVO.getUsername());
		
		if (userVO != null) {
			if(passwordEncoder.matches(loginVO.getPassword(), userVO.getPassword())) {
				return userVO;
			}
		}

		
		return null;
	}

}
