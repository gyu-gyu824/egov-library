package egovframework.example.sample.library.service;



public interface MemberService {
	int checkUsername (String username) throws Exception;
	
	void insertMember (MemberVO memberVO) throws Exception;
}
