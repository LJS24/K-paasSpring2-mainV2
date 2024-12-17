package kopo.poly.service;

import kopo.poly.dto.UserDTO;
import org.apache.ibatis.annotations.Mapper;


public interface IUserService {

    // 아이디
    UserDTO getUserIDExists(UserDTO pDTO) throws Exception;

    // 비번 찾기용 아이디
    UserDTO getUserIDExists2(UserDTO pDTO) throws Exception;

    // 이메일
    UserDTO getUserEmailExists(UserDTO pDTO) throws Exception;

    // 이메일 재발송
    UserDTO resendEmail(UserDTO pDTO) throws Exception;

    // 이메일 재발송 복호화후
    UserDTO resendEmail2(UserDTO pDTO) throws Exception;


    //회원가입
    int insertUserInfo(UserDTO pDTO) throws Exception;


    // 비밀번호 변경
    int newPasswordProc(UserDTO pDTO) throws Exception;

    int newEmailProc(UserDTO pDTO) throws Exception;

    //비밀번호 아이디 찾기 허용
    UserDTO searchUserIdOrPasswordProc2(UserDTO pDTO) throws Exception;

    // 로그인
    UserDTO getLogin(UserDTO pDTO) throws Exception;

    UserDTO getLoginProfile(UserDTO pDTO) throws Exception;

    int deleteUserInfo(UserDTO pDTO) throws Exception;
}
