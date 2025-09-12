package egovframework.example.sample.library.service;



public interface LoginService {
	LoginVO selectLoginUser (LoginVO loginVO) throws Exception;
	
	
	LoginVO selectByUsername(LoginVO loginVO) throws Exception;
}

