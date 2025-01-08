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
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>접근 전 비밀번호 확인</title>

    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#bthIndex").on("click", function (){
                location.href="/title/index";
            })

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


    <style>
        body {
            background: url('/img/non-5.png') no-repeat bottom center/cover !important;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            margin-top: 70px;
        }

        .card {
            background-color: rgba(255, 255, 255, 0.8) !important;
            position: relative;
            z-index: 1;
        }

        .logo-container {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            width: 90px;
            height: 90px;
            border-radius: 50%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            background-color: #28343f;
            z-index: 2;
            align-items: center;
            justify-content: center;
        }

        .logo-container img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }

        .card-body {
            padding-top: 60px;

        }

        .container {
            max-width: 900px;
            width: 150%;
            padding: 20px;
        }

        .form-control-user {
            height: calc(1.5em + .75rem + 2px);
            width: calc(100%);
            margin: 0 auto;
            text-align: left; /* placeholder를 왼쪽 정렬 */
            align-content: center;
        }

        .btn-user {
            width: calc(50%);
            height: calc(3.0em + .75rem + 2px);
            margin: 0 auto;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-group {
            margin-bottom: 0.75rem;

        }

        .form-container {
            width: 100%;

        }

    </style>
</head>
<body>
<div class="container">

    <div class="logo-container">
        <img src="/img/logo1roatate.png" alt="Logo">
    </div>

    <div class="row justify-content-center">

        <div class="col-xl-10 col-lg-12 col-md-9">

            <div class="card o-hidden border-0 shadow-lg my-5">
                <div class="card-body p-0">
                    <div class="row">
                        <div class="col-lg-12 d-flex justify-content-center align-items-center">
                            <div class="w-100 d-flex flex-column justify-content-center" style="max-width: 90%; padding: 5rem;">
                                <div class="p-5">
                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-4">비밀번호 인증이 필요합니다.</h1>
                                    </div>
                                    <form class="user form-container" id="f">
                                        <div class="form-group">
                                            <input type="password" class="form-control form-control-user" id="password" name="password" placeholder="비밀번호">
                                        </div>
                                        <br>
                                        <a id="bthmove" class="btn btn-primary btn-user btn-block" style="cursor: pointer">인증</a>
                                    </form>
                                    <hr>
                                    <div class="text-center">
                                        <a class="small" id="bthIndex" style="cursor: pointer">돌아가기</a>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>

</div>

<script src="/vendor/jquery/jquery.min.js"></script>
<script src="/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<script src="/vendor/jquery-easing/jquery.easing.min.js"></script>

<script src="/js/sb-admin-2.min.js"></script>


</body>
</html>
