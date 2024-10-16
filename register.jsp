<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>회원가입</title>

    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
            href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
            rel="stylesheet">

    <!-- Custom styles for this template-->
    <link rel="stylesheet" href="/css/sb-admin-2.min.css">
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        let userIdCheck = "Y";
        let emailAuthNumber = "";

        $(document).ready(function () {
            $("#bthSend").on("click", function () {
                doSubmit();
            });
            $("#bthpassword").on("click",function () {
                location.href = "/title/forgotPassword";
            })
            $("#bthLogin").on("click",function () {
                location.href = "/title/login";
            })
        });

        function doSubmit() {
            const f = document.getElementById("f");

            if (f.userId.value === "") {
                alert("아이디를 입력하세요.");
                f.userId.focus();
                return;
            }

            if (f.email.value === "") {
                alert("이메일을 입력하세요.");
                f.email.focus();
                return;
            }

            if (f.password.value === "") {
                alert("비밀번호를 입력하세요.");
                f.password.focus();
                return;
            }

            if (f.password2.value === "") {
                alert("비밀번호확인을 입력하세요.");
                f.password2.focus();
                return;
            }
            if (f.password.value !== f.password2.value) {
                alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                f.password.focus();
                return;
            }

            $.ajax({
                url: "/title/getUserIDExists",
                type: "post",
                dataType: "json",
                async: false,
                data: $("#f").serialize(),
                success: function (json) {

                    if (json.existsYn === "Y") {
                        alert("이미 사용 중인 아이디입니다.");
                        f.userId.focus();
                        userIdCheck="Y";
                    } else {
                        userIdCheck ="N";
                    }
                }
            })
            if (userIdCheck === "N") {

                $.ajax({
                    url: "/title/getUserEmailExists",
                    type: "post",
                    dataType: "json",
                    async: false,
                    data: $("#f").serialize(),
                    success: function (json) {
                        if (json.existsYn === "Y") {
                            alert("이미 가입된 이메일 주소가 존재합니다 ");
                            f.email.focus();
                            userIdCheck="Y";
                        } else {
                            emailAuthNumber = json.authNumber;

                            sessionStorage.setItem('userId', f.userId.value);
                            sessionStorage.setItem('email', f.email.value);
                            sessionStorage.setItem('password', f.password.value);
                            sessionStorage.setItem('authNumber', json.authNumber);

                            location.href = "register2";
                        }
                    }
                });
            }
        }

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

        .card-body p-0 {
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
