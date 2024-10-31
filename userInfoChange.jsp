<%--
  Created by IntelliJ IDEA.
  User: data8320-35
  Date: 2024-10-31
  Time: 오전 1:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>사용자 정보 변경</title>

    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">

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

        .form-control-user {
            height: calc(1.5em + .75rem + 2px); /* 세로 높이 조정 */
            width: calc(100%); /* 가로 길이 조정, 비율 유지 */
            margin: 0 auto; /* 가운데 정렬 */
        }

        .btn-user {
            width: calc(50%); /* 버튼의 가로 길이를 입력 필드와 동일하게 조정 */
            height: calc(3.0em + .75rem + 2px); /* 세로 높이 조정 */
            margin: 0 auto; /* 가운데 정렬 */
            display: flex; /* flexbox 사용 */
            justify-content: center; /* 수평 중앙 정렬 */
            align-items: center; /* 수직 중앙 정렬 */
        }

        .form-group {
            margin-bottom: 0.75rem; /* 세로 공간 조정 */
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
                                        <h1 class="h4 text-gray-900 mb-4">회원가입</h1>
                                    </div>
                                    <form class="user form-container" id="f">
                                        <div class="form-group">
                                            <input type="text" name="userId" class="form-control form-control-user"
                                                   id="exampleInputID" aria-describedby="IDHelp"
                                                   placeholder="아이디">
                                        </div>
                                        <div class="form-group">
                                            <input type="email" name="email" class="form-control form-control-user" id="exampleInputEmail"
                                                   placeholder="이메일">
                                        </div>
                                        <div class="form-group">
                                            <input type="password" name="password" class="form-control form-control-user"
                                                   id="exampleInputPassword" placeholder="비밀번호">
                                        </div>
                                        <div class="form-group">
                                            <input type="password" name="password2" class="form-control form-control-user"
                                                   id="exampleRepeatPassword" placeholder="비밀번호 재확인">
                                        </div>
                                        <br>
                                        <button id="bthSend" type="button" class="btn btn-primary btn-user btn-block">
                                            회원가입
                                        </button>
                                    </form>
                                    <hr>
                                    <div class="text-center">
                                        <a class="small" id="bthpassword" style="cursor: pointer">비밀번호 찾기</a>
                                    </div>
                                    <div class="text-center">
                                        <a class="small" id="bthLogin" style="cursor: pointer">로그인</a>
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
