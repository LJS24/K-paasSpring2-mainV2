<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
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
<html>
<head>
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#bthmove").on("click", function () {
                let f = document.getElementById("f"); // form 태그

                if (f.password.value === "") {
                    alert("비밀번호를 입력하세요.");
                    f.password.focus();
                    return;
                }
                // Ajax 호출해서 로그인하기
                $.ajax({
                        url: "/title/loginProc3",
                        type: "post",   // 전송방식은 Post
                        dataType: "json", // 전송 결과는 JSON으로 받기
                        data: $("#f").serialize(), // form 태그 내 input 등 객체를 자동으로 전송할 형태로 변경하기
                        success: function (json) { // /notice/noticeUpdate 호출이 성공했다면..

                            if (json.result === 1) {   // 비밀번호 확인 성공
                                alert(json.msg);   // 메시지 띄우기
                                location.href = "/title/profile"; // 회원정보 페이지 이동

                            } else {   // 로그인 실패
                                alert(json.msg); // 메시지 띄우기
                                $("#bthmove").focus() // 항목에 마우스 커서 이동
                            }

                        }
                    }
                )
            })
        })


    </script>
    <title>접근 전 비밀번호 확인</title>
</head>
<body>
    <form id="f" class="user">
        <div class="form-group">
            <input type="password" class="form-control form-control-user" id="password" name="password" placeholder="비밀번호">
        </div>
            <a id="bthmove" class="btn btn-primary btn-user btn-block" style="cursor: pointer">이동</a>
    </form>
</body>
</html>
