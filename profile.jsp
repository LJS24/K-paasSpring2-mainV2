<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%@ page import="kopo.poly.dto.UserDTO" %>
<%
    // 세션에서 SS_USER_ID 속성을 가져옴 (로그인 여부 확인)
    String userId = CmmUtil.nvl((String) session.getAttribute("SS_USER_ID"));
    String msg = "";

    // 비정상적인 접근 체크: SS_USER_ID가 세션에 없거나 빈 값인 경우
    if (userId == null || userId.length() == 0) {
        // 경고 메시지 설정
        msg = "비정상적인 접근입니다. 화면에 접근할 수 없습니다.";

        // 경고 메시지를 alert로 출력하고 로그인 페이지로 리다이렉트
%>
<script>
    alert("<%= msg %>");
    window.location.href = "/title/login";
</script>
<%
        return; // 이후 코드 실행 방지
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#bthemail").on("click",function () {  // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
                location.href = "/title/profile1";
            })

            $("#bthpassword").on("click",function () {  // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
                location.href = "title/profilePasswordChange";
            })
        })

    </script>
    <title>회원 정보</title>
</head>
<body>
    <span>${SS_USER_ID}</span>
    <span>${SS_DECRYPTED_EMAIL}</span>
    <span>${SS_REG_DATE}</span>
    <form id="f" class="user">
        <a id="bthemail" class="btn btn-primary btn-user btn-block" style="cursor: pointer">이메일 변경</a>
        <a id="bthpassword" class="btn btn-primary btn-user btn-block" style="cursor: pointer">비밀번호 변경</a>
    </form>
</body>
</html>
