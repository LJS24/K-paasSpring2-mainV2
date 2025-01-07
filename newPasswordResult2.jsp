<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%
    String msg = CmmUtil.nvl((String) request.getAttribute("msg"));
%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>

    <title>비밀번호 찾기 결과</title>

    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">
    <script type="text/javascript">

        // HTML로딩이 완료되고, 실행됨
        $(document).ready(function () {
            // 로그인 화면으로 이동
            $("#bthLogin").on("click",function () {  // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
                location.href = "/title/login";
            })
        })
    </script>

    <!-- 중앙 정렬을 위한 CSS 스타일 -->
    <style>
        body {
            background: url('/img/non-5.png')no-repeat bottom center/cover; !important;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            margin-top: 70px;
        }


        .card {
            background-color: rgba(255, 255, 255, 0.8) !important; /* 반투명 효과 */
            position: relative;
            z-index: 1; /* 카드가 로고 뒤에 오도록 설정 */
        }

        .logo-container {
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            width: 90px; /* 로고 크기 */
            height: 90px;
            border-radius: 50%;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            background-color: #28343f; /* 로고 배경 */
            z-index: 2; /* 로고가 카드 위에 오도록 설정 */
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
            padding-top: 60px; /* 카드 내용이 로고와 겹치지 않도록 패딩 추가 */
        }

        .container {
            max-width: 600px; /* 최대 너비 설정 */
            width: 100%; /* 반응형 너비 설정 */
            padding: 20px;
        }


    </style>
</head>

<body>

<div class="container">
    <div class="logo-container">
        <img src="/img/logo1roatate.png" alt="Logo"> <!-- 로고 이미지 경로 설정 -->
    </div>
    <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-5">
            <div class="text-center">
                <h1 class="h4 text-gray-900 mb-4">비밀번호 재설정 결과</h1>
                <p class="mb-4"><%=msg%></p>
            </div>
            <a id="bthLogin" style="cursor: pointer" class="btn btn-primary btn-user btn-block">
                로그인 화면으로 이동
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap core JavaScript-->
<script src="/vendor/jquery/jquery.min.js"></script>
<script src="/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- Core plugin JavaScript-->
<script src="/vendor/jquery-easing/jquery.easing.min.js"></script>

<!-- Custom scripts for all pages-->
<script src="/js/sb-admin-2.min.js"></script>

</body>

</html>