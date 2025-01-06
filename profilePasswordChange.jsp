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

  <title>비밀번호 변경</title>

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

      // 로그인 화면으로 이동
      $("#bthlogin").on("click",function () { // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
        location.href = "/title/login";
      })

      $("#bthProfile").on("click",function () {  // 버튼 클릭했을때, 발생되는 이벤트 생성함(onclick 이벤트와 동일함)
        location.href = "/title/profile";
      })

      // 비밀번호 찾기
      $("#bthSearchPassword").on("click",function (event) {

        event.preventDefault(); // 기본 폼 제출을 막음
        let f = document.getElementById("f"); // form 태그

        if (f.password.value === "") {
          alert("새로운 비밀번호를 입력하세요.");
          f.password.focus();
          return;
        }

        if (f.password2.value === "") {
          alert("검증을 위한 새로운 비밀번호를 입력하세요.");
          f.password2.focus();
          return;
        }

        if (f.password.value !== f.password2.value) {
          alert("입력한 비밀번호가 일치하지 않습니다.");
          f.password.focus();
          return;
        }

        $.ajax({
          url: "/title/newPasswordProc2",
          type: "post",   // 전송 방식
          dataType: "json", // JSON 응답 기대
          data: $("#f").serialize(), // form 데이터를 직렬화하여 전송
          success: function (json) { // 성공 시 처리
            if (json.result === 1) {   // 비밀번호 변경 성공
              alert(json.msg); // 메시지 표시
              location.href = "/title/profile"; // 프로필 페이지로 이동
            } else { // 비밀번호 변경 실패
              alert(json.msg); // 실패 메시지 표시
              f.password.focus(); // 비밀번호 입력 필드로 포커스 이동
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
      max-width: 900px; /* 최대 너비 설정 */
      width: 100%; /* 반응형 너비 설정 */
      padding: 20px;
    }

    .form-control-user {
      height: calc(1.5em + .75rem + 2px); /* 세로 높이 조정 */
      width: calc(100%); /* 가로 길이 조정, 비율 유지 */
      margin: 0 auto; /* 가운데 정렬 */
      justify-content: center; /* 수평 중앙 정렬 */
      align-items: center; /* 수직 중앙 정렬 */
    }

    .btn-user {
      width: calc(80%); /* 버튼의 가로 길이를 입력 필드와 동일하게 조정 */
      height: calc(3.0em + .75rem + 2px); /* 세로 높이 조정 */
      margin: 0 auto; /* 가운데 정렬 */
      display: flex; /* flexbox 사용 */
      justify-content: center; /* 수평 중앙 정렬 */
      align-items: center; /* 수직 중앙 정렬 */
    }

    .form-group {
      margin-bottom: 0.75rem; /* 세로 공간 조정 */
      justify-content: center; /* 수평 중앙 정렬 */
      align-items: center; /* 수직 중앙 정렬 */
    }

  </style>

</head>

<body>

<div class="container">

  <!-- 로고를 카드 외부에 위치 -->
  <div class="logo-container">
    <img src="/img/logo1roatate.png" alt="Logo"> <!-- 로고 이미지 경로 설정 -->
  </div>


  <div class="row justify-content-center">

    <div class="col-xl-8 col-lg-10 col-md-9">

      <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-0">
          <div class="row">
            <div class="col-lg-12 d-flex justify-content-center align-items-center">
              <div class="w-100 d-flex flex-column justify-content-center" style="max-width: 90%; padding: 5rem;">

              <div class="p-5">

                <div class="text-center">
                  <h1 class="h4 text-gray-900 mb-4">비밀번호 변경</h1>
                </div>
                <form id="f" class="user">
                  <div class="form-group">
                    <input type="password" name="password" id="password" class="form-control form-control-user"
                            placeholder="새로운 비밀번호 입력">
                  </div>
                  <div class="form-group">
                    <input type="password" name="password2" id="password2" class="form-control form-control-user"
                            placeholder="비밀번호 재입력">
                  </div>
                  <a id="bthSearchPassword" class="btn btn-primary btn-user btn-block">
                    비밀번호 변경(초기화)
                  </a>
                  <hr>
                  <div class="text-center">
                    <a id="bthProfile" type="button" class="btn btn-primary btn-user btn-block" style="cursor: pointer">
                      돌아가기</a>
                  </div>
                </form>

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

<script>
  // Optional: Add form validation or password reset logic here
</script>

</body>

</html>