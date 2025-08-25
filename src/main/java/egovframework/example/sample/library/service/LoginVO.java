package egovframework.example.sample.library.service;

import lombok.Data;

@Data
public class LoginVO {
    private String username; 
    private String password;
    private String name;    
    private String role;    
    private int memberId;
}
