package egovframework.example.sample.library.service;

import lombok.Data;

@Data
public class MemberVO {
	private int memberId;
	private String username;
	private String password;
	private String name;
	private String phone;
	private String role;
	private String joinDate;
}
