<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kopo.poly.util.CmmUtil" %>
<%@ page import="kopo.poly.dto.UserDTO" %>
<%
  UserDTO rDTO = (UserDTO) request.getAttribute("rDTO");
  // 비밀번호 재설정 접속 가능한지 체크
  String newPassword = CmmUtil.nvl((String) session.getAttribute("NEW_PASSWORD"));

  String msg = "";

  // 아이디와 이메일 체크
  String userId = CmmUtil.nvl(rDTO.getUserId());
  String email = CmmUtil.nvl(rDTO.getEmail());

  if (userId.length() > 0 && email.length() > 0) { // 아이디와 이메일 모두 존재
    if (newPassword.length() == 0) { // 비정상적인 접근
      msg = "비정상적인 접근입니다. \n비밀번호 재설정 화면에 접근할 수 없습니다.";
    }
  } else {
    if (userId.length() == 0) {
      msg = "아이디가 존재하지 않습니다.";
    }
    if (email.length() == 0) {
      msg = "이메일이 존재하지 않습니다.";
    }
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

  <title>SB Admin 2 - Reset Password</title>

  <!-- Custom fonts for this template-->
  <link href="/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link
          href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
          rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="/css/sb-admin-2.min.css" rel="stylesheet">
  <script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
  <script type="text/javascript">

    <%
        //  비정상적인 접근 및 회원정보가 없는 경우 뒤로 가기
        if (msg.length()>0){
        %>
    alert("<%=msg%>")
    history.back();
    <%
    }
    %>

  </script>

  <style>
    body {
      background-color: #68f6c4 !important;
      margin-top: 50px;
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
      background-color: white; /* 로고 배경 */
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
  </style>

</head>

<body>

<div class="container">

  <!-- 로고를 카드 외부에 위치 -->
  <div class="logo-container">
    <img src="../../../../../../../K-Pass-master/img/logo1.png" alt="Logo"> <!-- 로고 이미지 경로 설정 -->
  </div>


  <div class="row justify-content-center">

    <div class="col-xl-10 col-lg-12 col-md-9">

      <div class="card o-hidden border-0 shadow-lg my-5">
        <div class="card-body p-0">
          <!-- Nested Row within Card Body -->
          <div class="row">
            <div class="col-lg-6 d-none d-lg-block bg-login-image"></div>
            <div class="col-lg-6">
              <div class="p-5">
                <div class="text-center">
                  <h1 class="h4 text-gray-900 mb-4">~~~~~</h1>
                </div>
                <form class="user">
                  <div class="form-group">
                    <input type="password" class="form-control form-control-user"
                           id="exampleInputNewPassword" placeholder="새로운 비밀번호 입력">
                  </div>
                  <div class="form-group">
                    <input type="password" class="form-control form-control-user"
                           id="exampleInputConfirmPassword" placeholder="비밀번호 재입력">
                  </div>
                  <a href="../../../../../../../K-Pass-master/index.html" class="btn btn-primary btn-user btn-block">
                    비밀번호 변경(초기화)
                  </a>
                </form>
                <hr>
                <div class="text-center">
                  <a class="small" href="../../../../../../../K-Pass-master/login.html">로그인</a>
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
<script src="../../../../../../../K-Pass-master/vendor/jquery/jquery.min.js"></script>
<script src="../../../../../../../K-Pass-master/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- Core plugin JavaScript-->
<script src="../../../../../../../K-Pass-master/vendor/jquery-easing/jquery.easing.min.js"></script>

<!-- Custom scripts for all pages-->
<script src="../../../../../../../K-Pass-master/js/sb-admin-2.min.js"></script>

<script>
  // Optional: Add form validation or password reset logic here
</script>

</body>

</html>