<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>비밀번호 찾기</title>

    <!-- Custom fonts for this template-->
    <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="/css/sb-admin-2.min.css" rel="stylesheet">
    <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">

        // HTML로딩이 완료되고, 실행됨
        $(document).ready(function () {

            // 회원가입으로 이동
            $("#bthregister").on("click",function () { // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
                location.href = "/title/register";
            })
            $("#bthlogin").on("click",function () { // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
                location.href = "/title/login";
            })

            // 비밀번호 찾기
            $("#bthSearchPassword").on("click",function () {
                doSubmit();
            });

            function doSubmit() {

                const f = document.getElementById("f"); // form 태그

                if (f.userId.value === "") {
                    alert("아이디를 입력하세요.");
                    f.userId.focus();
                    return;
                }

                $.ajax({
                        url: "/title/getUserIDExists2",
                        type: "post",   //  전송방식은 Post
                        dataType: "json",   // 전송 결과는 JSON으로 받기

                        data: $("#f").serialize(),  // form 태그 내 input 등 객체를 자동으로 전송할 형태로 변경하기
                        success: function (json) {  // 호출이 성공했다면..

                            // 아이디 중복 확인
                            if (json.existsYn === "Y") {

                                emailAuthNumber = json.authNumber;

                                sessionStorage.setItem('userId', f.userId.value);   //값 저장
                                sessionStorage.setItem('email', json.email2); // 외부 이메일 값 저장
                                sessionStorage.setItem('authNumber', json.authNumber);

                                location.href = "forgotPassword2";    //이동
                            } else {
                                alert("해당 아이디로 가입된 계정이 없습니다.");

                                f.userId.focus();
                            }
                        }
                    }
                )
            }
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
            align-items: center;
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

        .form-control {
            width: 100%;

        }
        .p-5{
            justify-content: center;
            align-items: center;
        }

    </style>

</head>

<body>


    <div class="container">
        <!-- 로고를 카드 외부에 위치 -->
        <div class="logo-container">
            <img src="/img/logo1roatate.png" alt="Logo"> <!-- 로고 이미지 경로 설정 -->
        </div>

        <!-- Outer Row -->
        <div class="row justify-content-center">

            <div class="col-xl-10 col-lg-12 col-md-9">

                <div class="card o-hidden border-0 shadow-lg my-5">
                    <div class="card-body p-0">
                        <!-- Nested Row within Card Body -->
                        <div class="row justify-content-center">
                            <div class="col-lg-6">
                                <div class="p-5">
                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-2">비밀번호 찾기</h1>
                                        <p class="mb-4">계정 이메일 인증 후 비밀번호를 변경합니다.</p>
                                    </div>
                                    <form id="f" class="user">
                                        <div class="form-group">
                                            <input type="text" class="form-control form-control-user"
                                                   name="userId" id="userId" aria-describedby="emailHelp"
                                                   placeholder="계정 아이디 입력">
                                        </div>
                                        <a id="bthSearchPassword" class="btn btn-primary btn-user btn-block">
                                            이메일 전송
                                        </a>
                                    </form>
                                    <hr>
                                    <div class="text-center">
                                        <a class="small" id="bthregister" style="cursor: pointer">회원가입</a>
                                    </div>
                                    <div class="text-center">
                                        <a class="small" id="bthlogin" style="cursor: pointer">로그인</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

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
