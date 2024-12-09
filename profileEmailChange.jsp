<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%@ page import="kopo.poly.dto.UserDTO" %>
<%
    String userId = CmmUtil.nvl((String) session.getAttribute("SS_USER_ID"));
    String msg = "";

    if (userId == null || userId.length() == 0) {
        msg = "비정상적인 접근입니다. 화면에 접근할 수 없습니다.";
%>
<script>
    alert("<%= msg %>");
    window.location.href = "/title/login";
</script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>이메일 변경</title>

    <!-- 이 템플릿의 사용자 지정 글꼴 -->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">

    <!-- 이 템플릿의 사용자 지정 스타일 -->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">

    <!-- 자바스크립트 라이브러리 -->
    <script src="/vendor/jquery/jquery.min.js"></script>
    <script src="/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/vendor/jquery-easing/jquery.easing.min.js"></script>
    <script src="/js/sb-admin-2.min.js"></script>

    <style>
        body {
            background: url('/static/img/non-5.png') no-repeat bottom center/cover;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            margin-top: 70px;
        }

        .container {
            max-width: 900px;
            width: 100%;
            padding: 20px;
        }

        .card {
            background-color: rgba(255, 255, 255, 0.8) !important;
            position: relative;
            z-index: 1;
            border-radius: 1rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .btn-user {
            border-radius: 30px !important;
            padding: 0.75rem 1.25rem;
            font-size: 1rem;
            font-weight: 600;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-xl-8 col-lg-10 col-md-9">
            <div class="card o-hidden border-0 shadow-lg my-5">
                <div class="card-body p-0">
                    <div class="p-5">
                        <div class="text-center">
                            <h1 class="h4 text-gray-900 mb-4">이메일 변경</h1>
                        </div>
                        <!-- 이메일 입력 필드 -->
                        <div class="form-group">
                            <input type="email" id="newEmail" name="newEmail"
                                   class="form-control form-control-user"
                                   placeholder="새 Email 입력을 입력하세요." required>
                        </div>
                        <!-- 변경 버튼 -->
                        <button id="changeEmailBtn" class="btn btn-primary btn-user btn-block">
                            Email 바꾸기
                        </button>
                        <!-- 메시지 출력 영역 -->
                        <div class="text-center mt-3">
                            <span id="msg" class="text-danger"></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- JavaScript -->
<script>
    $(document).ready(function () {
        // 이메일 변경 버튼 클릭 이벤트
        $("#changeEmailBtn").click(function () {
            const newEmail = $("#newEmail").val(); // 입력된 이메일 값 가져오기

            if (newEmail === "") {
                $("#msg").text("새로운 이메일을 입력하세요."); // 이메일이 비어 있을 경우 메시지 표시
                return;
            }

            // AJAX 요청
            $.ajax({
                url: "/title/updateEmail", // 이메일 변경 처리 URL
                type: "POST", // HTTP POST 요청
                data: { newEmail: newEmail }, // 서버에 보낼 데이터
                success: function (response) {
                    if (response.msg.includes("성공")) { // 성공 메시지가 포함된 경우
                        alert("이메일이 변경되었습니다."); // 성공 알림 표시
                        window.location.href = "/title/profile"; // 회원정보 페이지로 이동
                    } else {
                        $("#msg").text(response.msg); // 실패 메시지 출력
                    }
                },
                error: function () {
                    $("#msg").text("서버와의 통신 중 오류가 발생했습니다. 다시 시도해주세요."); // 통신 오류 메시지
                }
            });
        });
    });
</script>
</body>

</html>
