<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
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
    window.location.href = "/title/profile";
</script>
<%
        return; // 이후 코드 실행 방지
    }
%>
<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>이메일 주소 변경</title>

    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>

    <script src="/vendor/jquery/jquery.min.js"></script>
    <script src="/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <script src="/vendor/jquery-easing/jquery.easing.min.js"></script>

    <script src="/js/sb-admin-2.min.js"></script>

    <script type="text/javascript">

        // HTML로딩이 완료되고, 실행됨
        $(document).ready(function () {

            // // 로그인 화면으로 이동
            // $("#bthlogin").on("click",function () { // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
            //     location.href = "/title/login";
            // })

            // 이메일 찾기
            $("#bthSearchEmail").on("click",function (event) {

                event.preventDefault(); // 기본 폼 제출을 막음
                let f = document.getElementById("f"); // form 태그

                if (f.email.value === "") {
                    alert("새로운 이메일 주소를 입력하세요.");
                    f.email.focus();
                    return;
                }

                if (f.email2.value === "") {
                    alert("검증을 위한 새로운 이메일 주소를 입력하세요.");
                    f.email2.focus();
                    return;
                }

                if (f.email.value !== f.email2.value) {
                    alert("입력한 주소가 일치하지 않습니다.");
                    f.email.focus();
                    return;
                }

                $.ajax({
                    url: "/title/newEmailProc2",
                    type: "post",   // 전송 방식
                    dataType: "json", // JSON 응답 기대
                    data: $("#f").serialize(), // form 데이터를 직렬화하여 전송
                    success: function (json) { // 성공 시 처리
                        if (json.result === 1) {   // 이메일 변경 성공
                            alert(json.msg); // 메시지 표시
                            location.href = "/title/profile"; // 프로필 페이지로 이동
                        } else { // 이메일 변경 실패
                            alert(json.msg); // 실패 메시지 표시
                            f.email.focus(); // 이메일 입력 필드로 포커스 이동
                        }
                    },
                    error: function () { // 통신 실패 시 처리
                        alert("서버와의 통신 중 오류가 발생했습니다. 다시 시도해주세요.");
                    }
                });
            });
        });
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
                                        <h1 class="h4 text-gray-900 mb-4">이메일 주소 변경</h1>
                                    </div>
                                    <form class="user form-container" id="f">
                                        <div class="form-group">
                                            <input type="email" name="email" class="form-control form-control-user"
                                                   id="exampleInputEmail" aria-describedby="IDHelp"
                                                   placeholder="새 이메일 주소">
                                        </div>
                                        <div class="form-group">
                                            <input type="email" name="email2" class="form-control form-control-user" id="exampleInputEmail2"
                                                   placeholder="이메일 주소 재입력">
                                        </div>
                                        <hr>
                                        <button id="bthSearchEmail" type="button" class="btn btn-primary btn-user btn-block">
                                            변경하기
                                        </button>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>

</div>

</body>
</html>
