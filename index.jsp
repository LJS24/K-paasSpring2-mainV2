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
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">


    <title>FARMCARE⁺</title>

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

            $("#profile").on("click",function () {  // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
                location.href = "/title/profile1";
            })

            $("#bthTest").on("click",function () {
                location.href = "/map/polygon";
            })

            $("#bthRecord").on("click",function () {
                location.href = "/map/SolList";
            })

            $("#btnIndex").on("click", function () {
                location.href = "/title/index";
            });


            $("#bthLogout").on("click", function () {


                $.ajax({
                    url: "/title/logout",
                    type: "post",   // 전송방식은 Post
                    dataType: "json", // 전송 결과는 JSON으로 받기
                    success: function (json) { // 호출이 성공했다면..
                        if (json.result === 1) {   // 로그아웃 성공
                            alert(json.msg);   // 메시지 띄우기
                            location.href = "login"; // 로그아웃 후 로그인 페이지로 이동
                        } else {   // 로그아웃 실패
                            alert(json.msg); // 메시지 띄우기
                        }
                    },
                    error: function () {  // 예외 처리 (네트워크 오류나 서버 응답 실패 등)
                        alert("로그아웃 처리에 실패했습니다.");
                    }
                });
            })
        })
    </script>

    <style>

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

        .container-fluid{
            display: flex;
            min-height: 720px;
        }


        .image-link {
            position: relative;

        }

        .default-img, .hover-img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            transition: opacity 0.3s ease;

        }

        .hover-img {
            opacity: 0; /* 기본 상태에서 보이지 않음 */
        }

        .image-link:hover .hover-img {
            opacity: 1; /* 호버 시 나타나게 설정 */
        }

        .image-link:hover .default-img {
            opacity: 0; /* 기본 이미지를 숨김 */
        }

        .container-fluid{
            background: url('/img/non-4.png') no-repeat bottom center/cover ;
            display:flex;
            align-items: center;

            margin: 0;
            padding: 0;
            height: max-content;
        }
        .navbar{
            display: flex;
            align-items: center;
        }



        /* Topbar Navbar Styling */
        .navbar {
            background-color: #f7f6ee; /* 밝은 자연색 배경 */
            border-bottom: 2px solid #68f6c4; /* 농업과 관련된 녹색 테두리 */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* 부드러운 그림자 */
        }

        .navbar-nav .nav-item {
            margin: 0 10px; /* 아이템 간격 추가 */
        }

        .navbar-nav .nav-link {
            color:#68f6c4; /* 중간 회색 텍스트 색상 */
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .navbar-nav .nav-link:hover {
            color: #8bc34a; /* 호버 시 녹색 강조 */
            text-decoration: none; /* 밑줄 제거 */
        }

        .dropdown-menu {
            background-color: #ffffff; /* 흰색 배경 */
            border: 1px solid #8bc34a; /* 녹색 테두리 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 그림자 추가 */
        }

        .dropdown-item {
            color: #6c757d; /* 기본 회색 텍스트 */
            padding: 10px 20px; /* 넉넉한 패딩 */
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .dropdown-item:hover {
            background-color: #8bc34a; /* 녹색 배경 */
            color: #ffffff; /* 흰색 텍스트 */
        }

        .mr-2:hover{
            transform: scale(1.1); /* 확대 효과 */
            color: #8bc34a; /* 녹색 */
        }

        .navbar .text-center a {
            font-size: 24px;
            font-weight: bold;
            color: #68f6c4; /* 로고 색상 */
            text-decoration: none;
        }

        .navbar .text-center a:hover {
            transform: scale(1.1); /* 확대 효과 */
            color: #8bc34a; /* 로고 색상 */
        }

        .img-profile {
            display: inherit;
            border: 2px solid #68f6c4; /* 이미지에 녹색 테두리 */
            padding: 2px;
            transition: transform 0.3s ease;

        }

        @media (min-width: 576px) {
            .img-profile  {
                display: none;


            }
        }
        .img-profile:hover {
            transform: scale(1.2); /* 확대 효과 */
            border: 2px solid #68f6c4; /* 이미지에 녹색 테두리 */
            padding: 2px;


        }



        .navbar-toggler {
            border-color: #8bc34a; /* 토글 버튼 테두리 */
        }

        .navbar-toggler-icon {
            background-color: #8bc34a; /* 토글 아이콘 색상 */
        }



    </style>


</head>

<body id="page-top">

<!-- Page Wrapper -->
<div id="wrapper">

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

        <!-- Main Content -->
        <div id="content">

            <!-- Topbar -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
                <div class="text-center">
                    <a id="btnIndex">FARMCARE⁺</a>
                </div>


                <!-- Topbar Navbar -->
                <ul class="navbar-nav ml-auto" style="">

                    <!-- Nav Item - Search Dropdown (Visible Only XS) -->
                    <li class="nav-item dropdown no-arrow d-sm-none">

                    </li>



                    <!-- Nav Item - User Information -->
                    <li class="nav-item dropdown no-arrow">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="mr-2 d-none d-lg-inline">${SS_USER_ID}의 메뉴</span>
                            <img class="img-profile rounded-circle toggle-img"
                                 src="/img/logo1roatate.png" alt="User Profile" style="background-color: #1F2739">
                        </a>
                        <!-- Dropdown - User Information -->
                        <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                             aria-labelledby="userDropdown">
                            <a class="dropdown-item" id="profile">
                                <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400" ></i>
                                사용자 설정 변경
                            </a>
                            <a class="dropdown-item" id="bthRecord">
                                <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i>
                                추천 기록
                            </a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" data-toggle="modal" data-target="#logoutModal">
                                <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400" ></i>
                                로그아웃
                            </a>
                        </div>
                    </li>

                </ul>

            </nav>
            <!-- End of Topbar -->

            <!-- Begin Page Content -->
            <div class="container-fluid" style="height: 859px;">




                        <!-- Page Heading -->
                        <div class="d-flex justify-content-center align-items-center" style="
                        height: 300px; margin-left: 800px; margin-bottom: 300px;">
                            <a id="bthTest" class="image-link">
                                <img src="/img/logo1roatate.png" alt="Clickable Image"
                                     class="default-img" style="width:300px; height:300px;">
                                <img src="/img/createSol.png" alt="Hover Image"
                                     class="hover-img" style=" width:300px; height:300px;">
                            </a>
                        </div>


                    <!-- End of Main Content -->







        </div>
        <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->

    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
        <i class="fas fa-angle-up"></i>
    </a>

    <!-- Logout Modal-->
    <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
         aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel text-center">로그아웃 하시겠습니까?</h5>
                    <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" type="button" data-dismiss="modal">취소</button>
                    <a class="btn btn-primary" id="bthLogout">확인</a>
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

<!-- Page level plugins -->
<script src="/vendor/chart.js/Chart.min.js"></script>

<!-- Page level custom scripts -->
<script src="/js/demo/chart-area-demo.js"></script>
<script src="/js/demo/chart-pie-demo.js"></script>


</body>

</html>